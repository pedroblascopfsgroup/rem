package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.model.dd.*;
import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoHistoricoPatrimonioDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoPublicacion;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.DtoActivoPatrimonio;

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
		activoPatrimonioDto.setEstadoAlquiler(DDTipoEstadoAlquiler.ESTADO_ALQUILER_LIBRE);

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

				if (!Checks.esNulo(tipoEstadoAlquiler)) {
					activoPatrimonio.setTipoEstadoAlquiler(tipoEstadoAlquiler);
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
			if(DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(activo.getTipoComercializacion().getCodigo())){
				activo.setTipoComercializacion(comercializacionVenta);
				ActivoPublicacion activoPubli = activo.getActivoPublicacion();
				activoPubli.setTipoComercializacion(comercializacionVenta);
				activo.setSituacionComercial(scm);
				activo.setActivoPublicacion(activoPubli);
				activoDao.save(activo);
			}
		}
		//-----------------------------------------------------


		if(!Checks.esNulo(activoPatrimonioDto.getEstadoAlquiler())) {
			Filter filtroActivoId = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "borrado", false);
			activoSituacionPosesoria = genericDao.get(ActivoSituacionPosesoria.class, filtroActivoId, filtroBorrado);

			if(activoPatrimonioDto.getEstadoAlquiler().equals(DDTipoEstadoAlquiler.ESTADO_ALQUILER_ALQUILADO)
					|| activoPatrimonioDto.getEstadoAlquiler().equals(DDTipoEstadoAlquiler.ESTADO_ALQUILER_CON_DEMANDAS)) {


				if (Checks.esNulo(activoSituacionPosesoria)) {
					activoSituacionPosesoria = new ActivoSituacionPosesoria();
					activoSituacionPosesoria.setActivo(activo);
				}

				if(activoSituacionPosesoria.getOcupado() != null && activoSituacionPosesoria.getOcupado() == 0) {
					activoSituacionPosesoria.setOcupado(1);
				}

				DDTipoTituloActivoTPA tipoTituloActivoTPA = (DDTipoTituloActivoTPA) utilDiccionarioApi.dameValorDiccionarioByCod(DDSituacionComercial.class, DDTipoTituloActivoTPA.tipoTituloSi);
				activoSituacionPosesoria.setConTitulo(tipoTituloActivoTPA);

				genericDao.save(ActivoSituacionPosesoria.class, activoSituacionPosesoria);
			} else if(activoPatrimonioDto.getEstadoAlquiler().equals(DDTipoEstadoAlquiler.ESTADO_ALQUILER_LIBRE)) {

				if (Checks.esNulo(activoSituacionPosesoria)) {
					activoSituacionPosesoria = new ActivoSituacionPosesoria();
					activoSituacionPosesoria.setActivo(activo);
				}

				activoSituacionPosesoria.setOcupado(0);
				activoSituacionPosesoria.setConTitulo(null);
				activoPatrimonio.setTipoInquilino(null);

				genericDao.save(ActivoSituacionPosesoria.class, activoSituacionPosesoria);

			}
		}

		activoPatrimonioDao.save(activoPatrimonio);

		activoAdapterApi.updateGestoresTabActivoTransactional(activoPatrimonioDto,activo.getId());

		// Actualizar estado publicación activo a través del procedure.
		idActivoActualizarPublicacion.add(activo.getId());
		//activoAdapterApi.actualizarEstadoPublicacionActivo(activo.getId());
		activoAdapterApi.actualizarEstadoPublicacionActivo(idActivoActualizarPublicacion,false);

		return activo;
	}
}
