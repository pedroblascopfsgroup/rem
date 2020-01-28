package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.model.dd.*;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.message.MessageService;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoHistoricoPatrimonioDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoPropagacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.DtoActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;

@Component
public class TabActivoPatrimonio implements TabActivoService {
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoPatrimonioDao activoPatrimonioDao;

	@Autowired
	private ActivoHistoricoPatrimonioDao activoHistoricoPatrimonioDao;

	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private ActivoAdapter activoAdapterApi;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private ActivoPropagacionApi activoPropagacionApi;
	
	@Autowired
	private ActivoApi activoApi;	
	
	@Autowired
	private UpdaterStateApi updaterState;

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_PATRIMONIO};
	}
	public DtoActivoPatrimonio getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {
		DtoActivoPatrimonio activoPatrimonioDto = new DtoActivoPatrimonio();

		ActivoPatrimonio activoP = activoPatrimonioDao.getActivoPatrimonioByActivo(activo.getId());
		if(!Checks.esNulo(activoP)) {
			BeanUtils.copyProperties(activoPatrimonioDto, activoP);
			if(!Checks.esNulo(activoP.getCheckHPM())) {
				activoPatrimonioDto.setChkPerimetroAlquiler(activoP.getCheckHPM());
			}
			if(!Checks.esNulo(activoP.getComboRentaAntigua())){
				activoPatrimonioDto.setComboRentaAntigua(activoP.getComboRentaAntigua());
			}
			if(!Checks.esNulo(activoP.getCheckSubrogado())){
				activoPatrimonioDto.setChkSubrogado(activoP.getCheckSubrogado());
			}
			if(!Checks.esNulo(activoP.getAdecuacionAlquiler())) {
				activoPatrimonioDto.setCodigoAdecuacion(activoP.getAdecuacionAlquiler().getCodigo());
				activoPatrimonioDto.setDescripcionAdecuacion(activoP.getAdecuacionAlquiler().getDescripcion());
				activoPatrimonioDto.setDescripcionAdecuacionLarga(activoP.getAdecuacionAlquiler().getDescripcionLarga());
			}

			if(!Checks.esNulo(activoP.getTipoEstadoAlquiler())) {
				activoPatrimonioDto.setEstadoAlquiler(activoP.getTipoEstadoAlquiler().getCodigo());
			}

			if(!Checks.esNulo(activoP.getTipoInquilino())) {
				activoPatrimonioDto.setTipoInquilino(activoP.getTipoInquilino().getCodigo());
			}
			
			if(activoDao.isActivoMatriz(activo.getId())) {
				activoPatrimonioDto.setActivosPropagables(activoPropagacionApi.getAllActivosAgrupacionPorActivo(activo));
				activoPatrimonioDto.setCamposPropagablesUas(TabActivoService.TAB_PATRIMONIO);
			}
		}

		if(!Checks.esNulo(activo.getTipoAlquiler())) {
			activoPatrimonioDto.setTipoAlquilerCodigo(activo.getTipoAlquiler().getCodigo());
		}

		return activoPatrimonioDto;
	}

	@Transactional()
	@Override
	public Activo saveTabActivo(Activo activo, WebDto dto) {
		
		List<ActivoHistoricoPatrimonio> listHistPatrimonio = activoHistoricoPatrimonioDao.getHistoricoAdecuacionesAlquilerByActivo(activo.getId());
		ArrayList<Long> idActivoActualizarPublicacion = new ArrayList<Long>();
		DtoActivoPatrimonio activoPatrimonioDto = (DtoActivoPatrimonio) dto;
		ActivoPatrimonio activoPatrimonio = genericDao.get(ActivoPatrimonio.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
		ActivoSituacionPosesoria activoSituacionPosesoria;
	 
		activoDao.validateAgrupacion(activo.getId());
		if(Checks.esNulo(activoPatrimonio)) {
			activoPatrimonio = new ActivoPatrimonio();
			activoPatrimonio.setActivo(activo);
			
			
			if(!Checks.esNulo(activoPatrimonioDto.getChkPerimetroAlquiler())) {
				activoPatrimonio.setCheckHPM(activoPatrimonioDto.getChkPerimetroAlquiler());
			}

			if (!Checks.esNulo(activoPatrimonioDto.getComboRentaAntigua())){
				activoPatrimonio.setComboRentaAntigua(activoPatrimonioDto.getComboRentaAntigua());
			}

			if (!Checks.esNulo(activoPatrimonioDto.getChkSubrogado())){
				activoPatrimonio.setCheckSubrogado(activoPatrimonioDto.getChkSubrogado());
			}

			if (!Checks.esNulo(activoPatrimonioDto.getEstadoAlquiler())){

				DDTipoEstadoAlquiler tipoEstadoAlquiler = genericDao.get(DDTipoEstadoAlquiler.class, genericDao.createFilter(FilterType.EQUALS, "codigo", activoPatrimonioDto.getEstadoAlquiler()));

				if (!Checks.esNulo(tipoEstadoAlquiler)) {
					activoPatrimonio.setTipoEstadoAlquiler(tipoEstadoAlquiler);
				}

			}

			if(!Checks.esNulo(activoPatrimonioDto.getCodigoAdecuacion())) {
				activoPatrimonio.setAdecuacionAlquilerAnterior(activoPatrimonio.getAdecuacionAlquiler());
				
				if(!DDAdecuacionAlquiler.CODIGO_ADA_NULO.equals(activoPatrimonioDto.getCodigoAdecuacion())) {
					DDAdecuacionAlquiler adecuacionAlquiler = genericDao.get(DDAdecuacionAlquiler.class, genericDao.createFilter(FilterType.EQUALS, "codigo",activoPatrimonioDto.getCodigoAdecuacion()));
					activoPatrimonio.setAdecuacionAlquiler(adecuacionAlquiler);

				} else {
					activoPatrimonio.setAdecuacionAlquiler(null);
				}
			}

		} else {
			ActivoHistoricoPatrimonio activoHistPatrimonio = new ActivoHistoricoPatrimonio();
			if(!Checks.esNulo(activoPatrimonioDto.getCodigoAdecuacion())) {
				if(!Checks.esNulo(activoPatrimonio.getAdecuacionAlquiler())) {
					activoHistPatrimonio.setAdecuacionAlquiler(activoPatrimonio.getAdecuacionAlquiler());
				}

				if(!Checks.esNulo(activoPatrimonioDto.getCodigoAdecuacion())) {
					activoPatrimonio.setAdecuacionAlquilerAnterior(activoPatrimonio.getAdecuacionAlquiler());
					
					if(!DDAdecuacionAlquiler.CODIGO_ADA_NULO.equals(activoPatrimonioDto.getCodigoAdecuacion())) {
						DDAdecuacionAlquiler adecuacionAlquiler = genericDao.get(DDAdecuacionAlquiler.class, genericDao.createFilter(FilterType.EQUALS, "codigo",activoPatrimonioDto.getCodigoAdecuacion()));
						activoPatrimonio.setAdecuacionAlquiler(adecuacionAlquiler);

					} else {
						activoPatrimonio.setAdecuacionAlquiler(null);
					}
				}
			}

			if (!Checks.estaVacio(listHistPatrimonio)) {
				activoHistPatrimonio.setFechaInicioAdecuacionAlquiler(listHistPatrimonio.get(0).getFechaFinAdecuacionAlquiler());
				activoHistPatrimonio.setFechaInicioHPM(listHistPatrimonio.get(0).getFechaFinHPM());
			} else {
				activoHistPatrimonio.setFechaInicioAdecuacionAlquiler(activoPatrimonio.getAuditoria().getFechaCrear());
				activoHistPatrimonio.setFechaInicioHPM(activoPatrimonio.getAuditoria().getFechaCrear());
			}

			activoHistPatrimonio.setFechaFinAdecuacionAlquiler(new Date());
			activoHistPatrimonio.setFechaFinHPM(new Date());
			activoHistPatrimonio.setActivo(activo);
			activoHistPatrimonio.setCheckHPM(activoPatrimonio.getCheckHPM());
			activoHistPatrimonio.setComboRentaAntigua(activoPatrimonio.getComboRentaAntigua());
			activoHistPatrimonio.setCheckSubrogado(activoPatrimonio.getCheckSubrogado());
			activoHistPatrimonio.setTipoEstadoAlquiler(activoPatrimonio.getTipoEstadoAlquiler());
			activoHistPatrimonio.setTipoInquilino(activoPatrimonio.getTipoInquilino());


			if(!Checks.esNulo(activoPatrimonioDto.getChkPerimetroAlquiler())) {
				activoPatrimonio.setCheckHPM(activoPatrimonioDto.getChkPerimetroAlquiler());
			}

			if (!Checks.esNulo(activoPatrimonioDto.getComboRentaAntigua())){
				activoPatrimonio.setComboRentaAntigua(activoPatrimonioDto.getComboRentaAntigua());
			}

			if (!Checks.esNulo(activoPatrimonioDto.getChkSubrogado())){
				activoPatrimonio.setCheckSubrogado(activoPatrimonioDto.getChkSubrogado());
			}

			if (!Checks.esNulo(activoPatrimonioDto.getEstadoAlquiler())){

				DDTipoEstadoAlquiler tipoEstadoAlquiler = genericDao.get(DDTipoEstadoAlquiler.class, genericDao.createFilter(FilterType.EQUALS, "codigo", activoPatrimonioDto.getEstadoAlquiler()));

				activoPatrimonio.setTipoEstadoAlquiler(tipoEstadoAlquiler);
				
				if(DDTipoEstadoAlquiler.ESTADO_ALQUILER_LIBRE.equals(tipoEstadoAlquiler.getCodigo())){
					if (!Checks.estaVacio(activo.getOfertas())) {
						for (ActivoOferta activoOferta : activo.getOfertas()) {
							Filter filtro = genericDao.createFilter(FilterType.EQUALS, "oferta.id",
									activoOferta.getPrimaryKey().getOferta().getId());
							ExpedienteComercial expediente = genericDao.get(ExpedienteComercial.class, filtro);
							if (!Checks.esNulo(expediente) && Checks.esNulo(expediente.getFechaFinAlquiler())) {
								expediente.setFechaFinAlquiler(new Date());
							}
						}
					}
				}

			}

			if (!Checks.esNulo(activoPatrimonioDto.getTipoInquilino())){

				DDTipoInquilino tipoInquilino = genericDao.get(DDTipoInquilino.class, genericDao.createFilter(FilterType.EQUALS, "codigo", activoPatrimonioDto.getTipoInquilino()));

				if (!Checks.esNulo(tipoInquilino)) {
					activoPatrimonio.setTipoInquilino(tipoInquilino);
				}

			}

			activoHistoricoPatrimonioDao.save(activoHistPatrimonio);
		}

		if(!Checks.esNulo(activoPatrimonioDto.getTipoAlquilerCodigo())){

			DDTipoAlquiler tipoAlquiler = genericDao.get(DDTipoAlquiler.class, genericDao.createFilter(FilterType.EQUALS, "codigo", activoPatrimonioDto.getTipoAlquilerCodigo()));
			if(!Checks.esNulo(tipoAlquiler) && DDTipoAlquiler.CODIGO_PAZ_SOCIAL.equals(tipoAlquiler.getCodigo())) {
				activoApi.crearRegistroFaseHistorico(activo);
			}
			activo.setTipoAlquiler(tipoAlquiler);
			activoDao.save(activo);
		}		
		
		//comprobamos si hay que modificar el tipo de comercializacion del activo
		if(!Checks.esNulo(activoPatrimonioDto) 
				&& (!Checks.esNulo(activoPatrimonioDto.getChkPerimetroAlquiler())
				&& (!activoPatrimonioDto.getChkPerimetroAlquiler()))){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoComercializacion.CODIGO_VENTA);
			DDTipoComercializacion comercializacionVenta= genericDao.get(DDTipoComercializacion.class, filtro);
			Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSituacionComercial.CODIGO_DISPONIBLE_VENTA);
			DDSituacionComercial scm= genericDao.get(DDSituacionComercial.class, filtro2);
			if(!Checks.esNulo(activo.getTipoComercializacion())) {
				if(DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(activo.getTipoComercializacion().getCodigo())){
					activo.setTipoComercializacion(comercializacionVenta);
					ActivoPublicacion activoPubli = activo.getActivoPublicacion();
					activoPubli.setTipoComercializacion(comercializacionVenta);
					activo.setSituacionComercial(scm);
					activo.setActivoPublicacion(activoPubli);
					activoDao.save(activo);
				}
			}
		}
		//-----------------------------------------------------


		if(!Checks.esNulo(activoPatrimonioDto.getEstadoAlquiler())) {
			Filter filtroActivoId = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "borrado", false);
			activoSituacionPosesoria = genericDao.get(ActivoSituacionPosesoria.class, filtroActivoId, filtroBorrado);

			if (!Checks.esNulo(activoSituacionPosesoria)) {
				if(DDTipoEstadoAlquiler.ESTADO_ALQUILER_ALQUILADO.equals(activoPatrimonioDto.getEstadoAlquiler())
						|| DDTipoEstadoAlquiler.ESTADO_ALQUILER_CON_DEMANDAS.equals(activoPatrimonioDto.getEstadoAlquiler())) {
	
	
					if (Checks.esNulo(activoSituacionPosesoria)) {
						activoSituacionPosesoria = new ActivoSituacionPosesoria();
						activoSituacionPosesoria.setActivo(activo);
					}
	
					activoSituacionPosesoria.setOcupado(1);
					DDTipoTituloActivoTPA tipoTituloActivoTPA = (DDTipoTituloActivoTPA) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoTituloActivoTPA.class, DDTipoTituloActivoTPA.tipoTituloSi);
					activoSituacionPosesoria.setConTitulo(tipoTituloActivoTPA);
					activoSituacionPosesoria.setFechaUltCambioTit(new Date());
				} else if(DDTipoEstadoAlquiler.ESTADO_ALQUILER_LIBRE.equals(activoPatrimonioDto.getEstadoAlquiler())) {
	
					if (Checks.esNulo(activoSituacionPosesoria)) {
						activoSituacionPosesoria = new ActivoSituacionPosesoria();
						activoSituacionPosesoria.setActivo(activo);
					}
	
					activoSituacionPosesoria.setOcupado(0);
					activoSituacionPosesoria.setConTitulo(null);
					activoSituacionPosesoria.setFechaUltCambioTit(new Date());
					activoPatrimonio.setTipoInquilino(null);
				}
				
				genericDao.save(ActivoSituacionPosesoria.class, activoSituacionPosesoria);
			}
		}

		activoPatrimonioDao.save(activoPatrimonio);

		activoAdapterApi.updateGestoresTabActivoTransactional(activoPatrimonioDto,activo.getId());

		// Actualizar estado publicación activo a través del procedure.
		idActivoActualizarPublicacion.add(activo.getId());
		//activoAdapterApi.actualizarEstadoPublicacionActivo(activo.getId());
		activoAdapterApi.actualizarEstadoPublicacionActivo(idActivoActualizarPublicacion,false);
		
		//updaterState.updaterStateDisponibilidadComercialAndSave(activo, false);
		if (activoDao.isUnidadAlquilable(activo.getId())) {
			activoApi.cambiarSituacionComercialActivoMatriz(activo.getId());
		}

		return activo;
	}
}
