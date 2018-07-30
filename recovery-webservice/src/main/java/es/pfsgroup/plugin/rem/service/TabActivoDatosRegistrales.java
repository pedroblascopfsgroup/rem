package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.procesosJudiciales.model.DDFavorable;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDEntidadAdjudicataria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBInformacionRegistralBien;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceDesbloqExpCambioSitJuridica;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionJudicial;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionNoJudicial;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPlanDinVentas;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTitulo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoActivoDatosRegistrales;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadEjecutante;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdjudicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDivHorizontal;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoObraNueva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.ENTIDADES;

@Component
public class TabActivoDatosRegistrales implements TabActivoService {
    
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi; 
    
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	private NotificatorServiceDesbloqExpCambioSitJuridica notificatorServiceDesbloqueoExpediente;
	
	@Autowired
	private RestApi restApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	protected static final Log logger = LogFactory.getLog(TabActivoDatosRegistrales.class);
	

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_DATOS_REGISTRALES};
	}
	
	
	public DtoActivoDatosRegistrales getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {

		DtoActivoDatosRegistrales activoDto = new DtoActivoDatosRegistrales();
		
		BeanUtils.copyProperties(activoDto, activo);
		if (activo.getInfoRegistral() != null) {
			BeanUtils.copyProperties(activoDto, activo.getInfoRegistral());
		}
		if (activo.getAdjNoJudicial() != null) {
			BeanUtils.copyProperties(activoDto, activo.getAdjNoJudicial());
		}
		
		if (!Checks.estaVacio(activo.getPdvs())) {
			BeanUtils.copyProperties(activoDto, activo.getPdvs().get(0));
		}
		
		if (activo.getTitulo() != null) {
			BeanUtils.copyProperties(activoDto, activo.getTitulo());
			if (activo.getTitulo().getEstado() != null) {
				if (activo.getTitulo().getEstado() != null) {
					BeanUtils.copyProperty(activoDto, "estadoTitulo", activo.getTitulo().getEstado().getCodigo());
				}
			}
		}
		
		if (activo.getInfoRegistral() != null) {
			BeanUtils.copyProperties(activoDto, activo.getInfoRegistral().getInfoRegistralBien());
			
			if (activo.getInfoRegistral().getEstadoDivHorizontal() != null ) {
				BeanUtils.copyProperty(activoDto, "estadoDivHorizontalCodigo", activo.getInfoRegistral().getEstadoDivHorizontal().getCodigo());
			}
			
			if(activo.getInfoRegistral().getDivHorInscrito() == null) {
				activoDto.setDivHorInscrito(null);
			}
			
			if (activo.getInfoRegistral().getEstadoObraNueva() != null ) {
				BeanUtils.copyProperty(activoDto, "estadoObraNuevaCodigo", activo.getInfoRegistral().getEstadoObraNueva().getCodigo());
			}
			
			if (activo.getInfoRegistral().getInfoRegistralBien() != null && activo.getInfoRegistral().getInfoRegistralBien().getLocalidad() != null) {
				BeanUtils.copyProperty(activoDto, "poblacionRegistro", activo.getInfoRegistral().getInfoRegistralBien().getLocalidad().getCodigo());
			}

			if (activo.getInfoRegistral().getInfoRegistralBien() != null && activo.getInfoRegistral().getInfoRegistralBien().getProvincia() != null) {
				BeanUtils.copyProperty(activoDto, "provinciaRegistro", activo.getInfoRegistral().getInfoRegistralBien().getProvincia().getCodigo());
			}
			
			if (activo.getInfoRegistral().getInfoRegistralBien() != null && activo.getInfoRegistral().getLocalidadAnterior() != null) {
				BeanUtils.copyProperty(activoDto, "localidadAnteriorCodigo", activo.getInfoRegistral().getLocalidadAnterior().getCodigo());
			}
			
			if (activo.getTipoTitulo() != null) {
				BeanUtils.copyProperty(activoDto, "tipoTituloCodigo", activo.getTipoTitulo().getCodigo());
			}
			if (activo.getSubtipoTitulo() != null) {
				BeanUtils.copyProperty(activoDto, "subtipoTituloCodigo", activo.getSubtipoTitulo().getCodigo());
			}
			if (activo.getCartera() != null) {
				BeanUtils.copyProperty(activoDto, "entidadPropietariaCodigo", activo.getCartera().getCodigo());
			}
			
		}
		
		if (activo.getAdjJudicial() != null) {
			
			BeanUtils.copyProperties(activoDto, activo.getAdjJudicial());
			
			if (activo.getAdjJudicial().getAdjudicacionBien() != null) {
				BeanUtils.copyProperties(activoDto, activo.getAdjJudicial().getAdjudicacionBien());
				
				if(Checks.esNulo(activo.getAdjJudicial().getAdjudicacionBien().getLanzamientoNecesario())){
					activoDto.setLanzamientoNecesario(null);
				}else{
					if(activo.getAdjJudicial().getAdjudicacionBien().getLanzamientoNecesario()){
						activoDto.setLanzamientoNecesario(1);
						activoApi.calcularFechaTomaPosesion(activo);
					}
					else{
						activoDto.setLanzamientoNecesario(0);
						activoApi.calcularFechaTomaPosesion(activo);
					}
				}

				if (activo.getAdjJudicial().getAdjudicacionBien().getEntidadAdjudicataria() != null) {
					BeanUtils.copyProperty(activoDto, "entidadAdjudicatariaCodigo", activo.getAdjJudicial().getAdjudicacionBien().getEntidadAdjudicataria().getCodigo());
				}
				
				if(activo.getAdjJudicial().getAdjudicacionBien().getResolucionMoratoria() != null){
					BeanUtils.copyProperty(activoDto, "resolucionMoratoriaCodigo", activo.getAdjJudicial().getAdjudicacionBien().getResolucionMoratoria().getCodigo());
				}
					
			}
			
			if (activo.getAdjJudicial().getEntidadEjecutante() != null) {
				BeanUtils.copyProperty(activoDto, "entidadEjecutanteCodigo", activo.getAdjJudicial().getEntidadEjecutante().getCodigo());
			}

			if (activo.getAdjJudicial().getJuzgado() != null) {
				BeanUtils.copyProperty(activoDto, "tipoJuzgadoCodigo", activo.getAdjJudicial().getJuzgado().getCodigo());
			}
			
			if (activo.getAdjJudicial().getPlazaJuzgado() != null) {
				BeanUtils.copyProperty(activoDto, "tipoPlazaCodigo", activo.getAdjJudicial().getPlazaJuzgado().getCodigo());
			}
			
			if (activo.getAdjJudicial().getEstadoAdjudicacion() != null) {
				BeanUtils.copyProperty(activoDto, "estadoAdjudicacionCodigo", activo.getAdjJudicial().getEstadoAdjudicacion().getCodigo());

			}
			
		}
		
		ActivoBancario activoBancario = activoApi.getActivoBancarioByIdActivo(activo.getId());
		
		if(!Checks.esNulo(activoBancario)) {
			BeanUtils.copyProperty(activoDto, "acreedorNumExp", activoBancario.getNumExpRiesgo());
		}

		// HREOS-2761: Buscamos los campos que pueden ser propagados para esta pestaña
		activoDto.setCamposPropagables(TabActivoService.TAB_DATOS_REGISTRALES);
		
		return activoDto;
		
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {

		DtoActivoDatosRegistrales dto = (DtoActivoDatosRegistrales) webDto;
		
		try {
			
			if (activo.getInfoRegistral() == null) {
				activo.setInfoRegistral(new ActivoInfoRegistral());
				activo.getInfoRegistral().setActivo(activo);

			}
			
			if (activo.getInfoRegistral().getInfoRegistralBien() == null) {
				activo.getInfoRegistral().setInfoRegistralBien(new NMBInformacionRegistralBien());
				activo.getInfoRegistral().getInfoRegistralBien().setBien(activo.getBien());
			}
			
			if (Checks.esNulo(activo.getSituacionPosesoria())) {
				Auditoria auditoria = Auditoria.getNewInstance();

				ActivoSituacionPosesoria actSit = new ActivoSituacionPosesoria();
				actSit.setActivo(activo);
				actSit.setVersion(new Long(0));
				actSit.setAuditoria(auditoria);
				activo.setSituacionPosesoria(actSit);

			}
			
			beanUtilNotNull.copyProperties(activo, dto);
			//beanUtilNotNull.copyProperties(activo.getInfoAdministrativa(), dto);
			beanUtilNotNull.copyProperties(activo.getInfoRegistral(), dto);
			beanUtilNotNull.copyProperties(activo.getInfoRegistral().getInfoRegistralBien(), dto);
		
			if (activo.getTitulo() == null) {
				activo.setTitulo(new ActivoTitulo());
				activo.getTitulo().setActivo(activo);
				activo.getTitulo().setAuditoria(Auditoria.getNewInstance());				
			}
			
			beanUtilNotNull.copyProperties(activo.getTitulo(), dto);
			
			if(Checks.esNulo(dto.getFechaInscripcionReg())) activo.getTitulo().setFechaInscripcionReg(null);
			
			
			if (dto.getEstadoTitulo() != null) {
				
				DDEstadoTitulo estadoTituloNuevo = (DDEstadoTitulo) diccionarioApi.dameValorDiccionarioByCod(DDEstadoTitulo.class, dto.getEstadoTitulo());
		
				activo.getTitulo().setEstado(estadoTituloNuevo);
			
			}
			
			if (!Checks.esNulo(activo.getDivHorizontal()) && activo.getDivHorizontal() != 0) {
				
				DDEstadoDivHorizontal estadoDivHorizontal = null;
				
				if (dto.getEstadoDivHorizontalCodigo() != null) {
					
					estadoDivHorizontal = (DDEstadoDivHorizontal) 
							diccionarioApi.dameValorDiccionarioByCod(DDEstadoDivHorizontal.class,  dto.getEstadoDivHorizontalCodigo());
				}
				
				activo.getInfoRegistral().setEstadoDivHorizontal(estadoDivHorizontal);
			
			} else {
				activo.getInfoRegistral().setEstadoDivHorizontal(null);
				activo.getInfoRegistral().setDivHorInscrito(null);
			}
			
			activo.getInfoRegistral().setInfoRegistralBien((genericDao.save(NMBInformacionRegistralBien.class, activo.getInfoRegistral().getInfoRegistralBien())));
			activo.setInfoRegistral((genericDao.save(ActivoInfoRegistral.class, activo.getInfoRegistral())));
			restApi.marcarRegistroParaEnvio(ENTIDADES.ACTIVO, activo);
			
			if (dto.getEstadoObraNuevaCodigo() != null) {
				
				DDEstadoObraNueva estadoObraNueva = (DDEstadoObraNueva) 
						diccionarioApi.dameValorDiccionarioByCod(DDEstadoObraNueva.class, dto.getEstadoObraNuevaCodigo());
				
				activo.getInfoRegistral().setEstadoObraNueva(estadoObraNueva);
				
			}
			
			if (dto.getLocalidadAnteriorCodigo() != null) {
				
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getLocalidadAnteriorCodigo());
				Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);
				activo.getInfoRegistral().setLocalidadAnterior(municipioNuevo);	
				
			}
			
			if (dto.getPoblacionRegistro() != null) {
				
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getPoblacionRegistro());
				Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);
				activo.getInfoRegistral().getInfoRegistralBien().setLocalidad(municipioNuevo);
				
			}
			
			if (dto.getPoblacionRegistro() != null) {
				
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getPoblacionRegistro());
				Localidad municipioNuevo = (Localidad) genericDao.get(Localidad.class, filtro);
				activo.getInfoRegistral().getInfoRegistralBien().setLocalidad(municipioNuevo);
				DDProvincia provincia = municipioNuevo.getProvincia();
				activo.getInfoRegistral().getInfoRegistralBien().setProvincia(provincia);
				
			}
			
			activo.getInfoRegistral().setInfoRegistralBien((genericDao.save(NMBInformacionRegistralBien.class, activo.getInfoRegistral().getInfoRegistralBien())));
			activo.setInfoRegistral((genericDao.save(ActivoInfoRegistral.class, activo.getInfoRegistral())));
			
			
			if (dto.getTipoTituloCodigo() != null) {
				
				DDTipoTituloActivo tipoTitulo = (DDTipoTituloActivo) 
						diccionarioApi.dameValorDiccionarioByCod(DDTipoTituloActivo.class, dto.getTipoTituloCodigo());
				
				activo.setTipoTitulo(tipoTitulo);
				
			}
			
			if (dto.getSubtipoTituloCodigo() != null) {
				
				DDSubtipoTituloActivo subtipoTitulo = (DDSubtipoTituloActivo) 
						diccionarioApi.dameValorDiccionarioByCod(DDSubtipoTituloActivo.class, dto.getSubtipoTituloCodigo());
				
				activo.setSubtipoTitulo(subtipoTitulo);
				
			}
                     
			if (activo.getTipoTitulo() != null) {
				
				if (activo.getTipoTitulo().getCodigo().equals(DDTipoTituloActivo.tipoTituloNoJudicial)) {
					
					if (activo.getAdjNoJudicial() == null) {
						activo.setAdjNoJudicial(new ActivoAdjudicacionNoJudicial());
						activo.getAdjNoJudicial().setActivo(activo);
					}
					beanUtilNotNull.copyProperties(activo.getAdjNoJudicial(), dto);
					
					activo.setAdjNoJudicial((genericDao.save(ActivoAdjudicacionNoJudicial.class, activo.getAdjNoJudicial())));
					activoApi.calcularFechaTomaPosesion(activo);
					
				} else if (activo.getTipoTitulo().getCodigo().equals(DDTipoTituloActivo.tipoTituloPDV)) {
					ActivoPlanDinVentas pdv = null;
					if (Checks.estaVacio(activo.getPdvs())) {
						 pdv = new ActivoPlanDinVentas();
						 pdv.setActivo(activo);
						 beanUtilNotNull.copyProperties(pdv, dto);
						 genericDao.save(ActivoPlanDinVentas.class, pdv);
						 activo.getPdvs().add(pdv);
					} else {
						pdv = activo.getPdvs().get(0);						
						beanUtilNotNull.copyProperties(pdv, dto);
						genericDao.update(ActivoPlanDinVentas.class, pdv);
					}


				} else if (activo.getTipoTitulo().getCodigo().equals(DDTipoTituloActivo.tipoTituloJudicial)) {
					
					if (activo.getAdjJudicial() == null) {
						activo.setAdjJudicial(new ActivoAdjudicacionJudicial());
						activo.getAdjJudicial().setActivo(activo);
					}
					beanUtilNotNull.copyProperties(activo.getAdjJudicial(), dto);
					
					
					if (activo.getAdjJudicial().getAdjudicacionBien() == null) {
						activo.getAdjJudicial().setAdjudicacionBien(new NMBAdjudicacionBien());
						activo.getAdjJudicial().getAdjudicacionBien().setBien(activo.getBien());
					}
						
					beanUtilNotNull.copyProperties(activo.getAdjJudicial().getAdjudicacionBien(), dto);
					
					activo.getAdjJudicial().setAdjudicacionBien((genericDao.save(NMBAdjudicacionBien.class, activo.getAdjJudicial().getAdjudicacionBien())));


					if(dto.getResolucionMoratoriaCodigo() != null){
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getResolucionMoratoriaCodigo());
						DDFavorable favorableDesfavorable = (DDFavorable) genericDao.get(DDFavorable.class, filtro);
						activo.getAdjJudicial().getAdjudicacionBien().setResolucionMoratoria(favorableDesfavorable);
					}
					
					if (dto.getEntidadAdjudicatariaCodigo() != null) {
						
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEntidadAdjudicatariaCodigo());
						DDEntidadAdjudicataria entidadAdjudicataria = (DDEntidadAdjudicataria) genericDao.get(DDEntidadAdjudicataria.class, filtro);
		
						activo.getAdjJudicial().getAdjudicacionBien().setEntidadAdjudicataria(entidadAdjudicataria);						
						
					}
					
					if (dto.getEntidadEjecutanteCodigo() != null) {
						
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEntidadEjecutanteCodigo());
						DDEntidadEjecutante entidadEjecutante = (DDEntidadEjecutante) genericDao.get(DDEntidadEjecutante.class, filtro);
		
						activo.getAdjJudicial().setEntidadEjecutante(entidadEjecutante);					
						
					}

					if (dto.getTipoJuzgadoCodigo() != null) {
						
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoJuzgadoCodigo());
						TipoJuzgado juzgado = (TipoJuzgado) genericDao.get(TipoJuzgado.class, filtro);
						
						activo.getAdjJudicial().setJuzgado(juzgado);
					}
					
					if (dto.getTipoPlazaCodigo() != null) {
						
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoPlazaCodigo());
						TipoPlaza plazaJuzgado = (TipoPlaza) genericDao.get(TipoPlaza.class, filtro);
						
						activo.getAdjJudicial().setPlazaJuzgado(plazaJuzgado);
					}
					
					if (dto.getEstadoAdjudicacionCodigo() != null) {
						
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEstadoAdjudicacionCodigo());
						DDEstadoAdjudicacion estadoAdjudicacion = (DDEstadoAdjudicacion) genericDao.get(DDEstadoAdjudicacion.class, filtro);
						
						activo.getAdjJudicial().setEstadoAdjudicacion(estadoAdjudicacion);
					}
					
					activo.getAdjJudicial().setAdjudicacionBien((genericDao.save(NMBAdjudicacionBien.class, activo.getAdjJudicial().getAdjudicacionBien())));
					activo.setAdjJudicial((genericDao.save(ActivoAdjudicacionJudicial.class, activo.getAdjJudicial())));
					activoApi.calcularFechaTomaPosesion(activo);

				}
			
			}
			ActivoBancario activoBancario = activoApi.getActivoBancarioByIdActivo(activo.getId());
			
			if (!Checks.esNulo(activoBancario)) {
				if (!Checks.esNulo(dto.getAcreedorNumExp())) {
					activoBancario.setNumExpRiesgo(dto.getAcreedorNumExp().toString());
					genericDao.save(ActivoBancario.class, activoBancario);
				}
			}
			

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return activo;
		
	}
	
	public void afterSaveTabActivo(Activo activo, WebDto dto) {
		
		DtoActivoDatosRegistrales dtoDatReg = (DtoActivoDatosRegistrales) dto;
		//Oferta oferta = ofertaApi.getOfertaAceptadaByActivo(activo);
		List<ActivoOferta> ofertas = activo.getOfertas();
		
		// Si ha cambiado el estado del título registral a inscrito
		if(!Checks.esNulo(dtoDatReg.getEstadoTitulo()) || !Checks.esNulo(dtoDatReg.getFechaTitulo()) || !Checks.esNulo(dtoDatReg.getFechaSenalamientoPosesion())  /*&& DDEstadoTitulo.ESTADO_INSCRITO.equals(dtoDatReg.getEstadoTitulo())*/) {
			
			for(ActivoOferta oferta : ofertas){
				// Si tiene expediente 
				if(!Checks.esNulo(oferta)) {
					ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getPrimaryKey().getOferta().getId());
					
					if(!Checks.esNulo(expediente)){
						// Si esta bloqueado, lo desbloqueamos y notificamos
						if(!Checks.esNulo(expediente.getBloqueado()) && BooleanUtils.toBoolean(expediente.getBloqueado())) {
							
							expediente.setBloqueado(0);					
							genericDao.save(ExpedienteComercial.class, expediente);
							
							List<ActivoTramite> tramites = activoTramiteApi.getTramitesActivoTrabajoList(expediente.getTrabajo().getId());	
							if(!Checks.estaVacio(tramites)) {					
								notificatorServiceDesbloqueoExpediente.notificator(tramites.get(0));
							}
							/// sino, solamente avisamos
						} else {
							
							activoAdapter.enviarAvisosCambioSituacionLegalActivo(activo, expediente);					
						}		
					}
				}
			}
			
		}
	}

}
