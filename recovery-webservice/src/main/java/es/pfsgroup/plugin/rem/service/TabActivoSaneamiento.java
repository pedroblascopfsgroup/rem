package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Version;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.DDFavorable;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDEntidadAdjudicataria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBInformacionRegistralBien;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoCargasApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.gestor.dao.GestorActivoHistoricoDao;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceDesbloqExpCambioSitJuridica;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionJudicial;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionNoJudicial;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.ActivoInfAdministrativa;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;
import es.pfsgroup.plugin.rem.model.ActivoJuntaPropietarios;
import es.pfsgroup.plugin.rem.model.ActivoPlanDinVentas;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTitulo;
import es.pfsgroup.plugin.rem.model.ActivoTituloAdicional;
import es.pfsgroup.plugin.rem.model.DtoActivoCargasTab;
import es.pfsgroup.plugin.rem.model.DtoActivoDatosRegistrales;
import es.pfsgroup.plugin.rem.model.DtoActivoInformacionAdministrativa;
import es.pfsgroup.plugin.rem.model.DtoActivoSaneamiento;
import es.pfsgroup.plugin.rem.model.GestorActivoHistorico;
import es.pfsgroup.plugin.rem.model.dd.DDCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadEjecutante;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdjudicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDivHorizontal;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoMotivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoObraNueva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.dd.DDOrigenAnterior;
import es.pfsgroup.plugin.rem.model.dd.DDResponsableSubsanar;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloAdicional;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVpo;

@Component
public class TabActivoSaneamiento implements TabActivoService{
	
	private static final String MENSAJE_ERROR_SUPERFICIE_CONSTRUIDA  = "msg.error.superficie.construida.UAs";
	private static final String MENSAJE_ERROR_SUPERFICIE_UTIL        = "msg.error.superficie.util.UAs";
	private static final String MENSAJE_ERROR_SUPERFICIE_REPERCUSION = "msg.error.superficie.repercusion.UAs";
	private static final String MENSAJE_ERROR_SUPERFICIE_PARCELA     = "msg.error.superficie.parcela.UAs";
	
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
	private ActivoDao activoDao;

	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoCargasApi activoCargasApi;

	@Autowired
	private UsuarioApi usuarioApi;
	
	@Autowired
	private GestorActivoHistoricoDao gestorActivoDao;

	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

	@Resource
	private MessageService messageServices;
	
	protected static final Log logger = LogFactory.getLog(TabActivoSaneamiento.class);
	

	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_SANEAMIENTO};
	}
	

	public DtoActivoSaneamiento getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {
		DtoActivoSaneamiento activoDto = new DtoActivoSaneamiento();
		 
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", "GGADM");
		EXTDDTipoGestor ddTipoGestor = genericDao.get(EXTDDTipoGestor.class, filtro );
		
		List<Usuario> list = gestorActivoDao.getListUsuariosGestoresActivoByTipoYActivo(ddTipoGestor.getId(), activo);
		List<Date> listDate = gestorActivoDao.getFechaDesdeByTipoYActivo(ddTipoGestor.getId(), activo);
		
		if(list != null && !list.isEmpty()) {
			if(list.get(0).getApellidoNombre() != null) {
				activoDto.setGestoriaAsignada(list.get(0).getApellidoNombre());
			}
		}
		if(listDate != null && !listDate.isEmpty()) {
			activoDto.setFechaAsignacion(listDate.get(0));
		}
		
		//Parte de Cargas
		DtoActivoCargasTab activoCarga = new DtoActivoCargasTab();
		BeanUtils.copyProperties(activoCarga, activo);
		boolean esUA = activoDao.isUnidadAlquilable(activo.getId());
		if(activoCarga.getEstadoCargas() != null) {
			activoDto.setEstadoCargas(activoCarga.getEstadoCargas());
		}
		if(activoCarga.getFechaRevisionCarga() != null) {
			activoDto.setFechaRevisionCarga(activoCarga.getFechaRevisionCarga());
		}
		if(esUA) {
			activoDto.setUnidadAlquilable(true);
			ActivoAgrupacion actgagru = activoDao.getAgrupacionPAByIdActivo(activo.getId());
			Activo activoM = activoApi.get(activoDao.getIdActivoMatriz(actgagru.getId()));
			if(activoCargasApi.tieneCargasOcultasCargaMasivaEsparta(activoM.getId())) {
				if(activoCargasApi.esCargasOcultasCargaMasivaEsparta(activoM.getId())) {
					activoDto.setConCargas(1);
				} else {
					activoDto.setConCargas(0);
				}
			} else if(activoCargasApi.esActivoConCargasNoCanceladas(activoM.getId())) {
				activoDto.setConCargas(1);
			} else {
				activoDto.setConCargas(0);
			}
		}else {
			activoDto.setUnidadAlquilable(false);
			if(activoCargasApi.tieneCargasOcultasCargaMasivaEsparta(activo.getId())) {
				if(activoCargasApi.esCargasOcultasCargaMasivaEsparta(activo.getId())) {
					activoDto.setConCargas(1);
				} else {
					activoDto.setConCargas(0);
				}
			} else if(activoCargasApi.esActivoConCargasNoCanceladas(activo.getId())) {
				activoDto.setConCargas(1);
			} else {
				activoDto.setConCargas(0);
			}
		}
		if(!Checks.esNulo(activo.getEstadoCargaActivo())) {
			activoDto.setEstadoCargas(activo.getEstadoCargaActivo().getDescripcion());
		}
		
		
		//Datos Registrales
		DtoActivoDatosRegistrales activoDtoRegistrales = new DtoActivoDatosRegistrales();
		BeanUtils.copyProperties(activoDtoRegistrales, activo);
		
		
		if (activo.getTitulo() != null) {
			BeanUtils.copyProperties(activoDto, activo.getTitulo());
			if (activo.getTitulo().getEstado() != null) {
				if (activo.getTitulo().getEstado() != null) {
					BeanUtils.copyProperty(activoDto, "estadoTitulo", activo.getTitulo().getEstado().getCodigo());
				}
			}
		}
		if(activoDtoRegistrales.getFechaEntregaGestoria() != null) {
			activoDto.setFechaEntregaGestoria(activoDtoRegistrales.getFechaEntregaGestoria());
		}
		
		//por programar TITULO ADICIONAL SANEAMIENTO
		
		Filter filtroTituloAdicional = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoTituloAdicional actTituloAdicional = genericDao.get(ActivoTituloAdicional.class, filtroTituloAdicional);
		
		//BeanUtils.copyProperties(actTituloAdicional, activoDto);
		//if (!"1".equals(activoDto.getTieneTituloAdicional())) {
			//activoDto.setTieneTituloAdicional(activoSaneamiento.getTieneTituloAdicional());
		if (actTituloAdicional.getTituloAdicional() != null) {
			
			if (actTituloAdicional.getEstadoTitulo() != null) {
				activoDto.setEstadoTituloAdicional(actTituloAdicional.getEstadoTitulo().getCodigo());
			}
			if (actTituloAdicional.getTipoTitulo() != null) {
				activoDto.setSituacionTituloAdicional(actTituloAdicional.getTipoTitulo().getCodigo());
			}
			if (actTituloAdicional.getFechaInscripcionReg() != null) {
				activoDto.setFechaInscriptionRegistroAdicional(actTituloAdicional.getFechaInscripcionReg());
			}
			if (actTituloAdicional.getFechaRetiradaReg() != null) {
				activoDto.setFechaRetiradaDefinitivaRegAdicional(actTituloAdicional.getFechaRetiradaReg());
			}
			if (actTituloAdicional.getFechaPresentHacienda() != null) {
				activoDto.setFechaPresentacionHaciendaAdicional(actTituloAdicional.getFechaPresentHacienda());
			}
			if (actTituloAdicional.getFechaNotaSimple() != null) {
				activoDto.setFechaNotaSimpleAdicional(actTituloAdicional.getFechaNotaSimple());
			}
			
		}
			
				
		//}
		
		
		//Parte Proteccion
		DtoActivoInformacionAdministrativa activoDtoPortect = new DtoActivoInformacionAdministrativa();
		
		if(esUA) {
			//Cuando es una UA, cargamos los datos de su AM
			ActivoAgrupacion agrupacion = activoDao.getAgrupacionPAByIdActivo(activo.getId());
			if (!Checks.esNulo(agrupacion)) {
				Activo activoMatriz = activoAgrupacionActivoDao.getActivoMatrizByIdAgrupacion(agrupacion.getId());
				if (!Checks.esNulo(activoMatriz)) {
					if (activoMatriz.getInfoAdministrativa() != null) {
						BeanUtils.copyProperties(activoDto, activoMatriz.getInfoAdministrativa());
						if (activoMatriz.getInfoAdministrativa().getTipoVpo() != null) {
							BeanUtils.copyProperty(activoDto, "tipoVpoCodigo", activoMatriz.getInfoAdministrativa().getTipoVpo().getCodigo());
						}
					}
//					BeanUtils.copyProperty(activoDto, "vpo", activoMatriz.getVpo());
				}
				
			}
			
		}
		else {
			
			if (activo.getInfoAdministrativa() != null) {
				BeanUtils.copyProperties(activoDto, activo.getInfoAdministrativa());
				if (activo.getInfoAdministrativa().getTipoVpo() != null) {
					BeanUtils.copyProperty(activoDto, "tipoVpoCodigo", activo.getInfoAdministrativa().getTipoVpo().getCodigo());
				}
			}		
//			BeanUtils.copyProperty(activoDto, "vpo", activo.getVpo());
		}
		if (!Checks.esNulo(activo.getInfoAdministrativa())) {
			activoDto.setVigencia(activo.getInfoAdministrativa().getVigencia());
			activoDto.setComunicarAdquisicion(activo.getInfoAdministrativa().getComunicarAdquisicion());
			activoDto.setNecesarioInscribirVpo(activo.getInfoAdministrativa().getNecesarioInscribirVpo());
			activoDto.setLibertadCesion(activo.getInfoAdministrativa().getLibertadCesion());
			activoDto.setRenunciaTanteoRetrac(activo.getInfoAdministrativa().getRenunciaTanteoRetrac());
			activoDto.setVisaContratoPriv(activo.getInfoAdministrativa().getVisaContratoPriv());
			activoDto.setVenderPersonaJuridica(activo.getInfoAdministrativa().getVenderPersonaJuridica());
			activoDto.setMinusvalia(activo.getInfoAdministrativa().getMinusvalia());
			activoDto.setInscripcionRegistroDemVpo(activo.getInfoAdministrativa().getInscripcionRegistroDemVpo());
			activoDto.setIngresosInfNivel(activo.getInfoAdministrativa().getIngresosInfNivel());
			activoDto.setResidenciaComAutonoma(activo.getInfoAdministrativa().getResidenciaComAutonoma());
			activoDto.setNoTitularOtraVivienda(activo.getInfoAdministrativa().getNoTitularOtraVivienda());			
		}
		
		return activoDto;
	}
	
	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {
		
		//Datos Proteccion
		DtoActivoInformacionAdministrativa dtoAdministrativo = (DtoActivoInformacionAdministrativa) webDto;
		
		try {			
			if (activo.getInfoAdministrativa() == null) {
				activo.setInfoAdministrativa(new ActivoInfAdministrativa());
				activo.getInfoAdministrativa().setActivo(activo);
			}
				
			beanUtilNotNull.copyProperties(activo.getInfoAdministrativa(), dtoAdministrativo);
			
			activo.setInfoAdministrativa(genericDao.save(ActivoInfAdministrativa.class, activo.getInfoAdministrativa()));
			
			if (dtoAdministrativo.getTipoVpoCodigo() != null) {
			
				DDTipoVpo tipoVpo = (DDTipoVpo) diccionarioApi.dameValorDiccionarioByCod(DDTipoVpo.class, dtoAdministrativo.getTipoVpoCodigo());

				activo.getInfoAdministrativa().setTipoVpo(tipoVpo);
				
			}	
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		
		//Datos registrales
		DtoActivoDatosRegistrales dto = (DtoActivoDatosRegistrales) webDto;
		boolean esPA = activoDao.isIntegradoEnAgrupacionPA(activo.getId());
		
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
			if (esPA){
				this.comprobacionSuperficiePA(dto, activo.getId());
				beanUtilNotNull.copyProperties(activo.getInfoRegistral(), dto);
				beanUtilNotNull.copyProperties(activo.getInfoRegistral().getInfoRegistralBien(), dto);
			} else {
				beanUtilNotNull.copyProperties(activo.getInfoRegistral(), dto);
				beanUtilNotNull.copyProperties(activo.getInfoRegistral().getInfoRegistralBien(), dto);
			}
		
			if (activo.getTitulo() == null) {
				activo.setTitulo(new ActivoTitulo());
				activo.getTitulo().setActivo(activo);
				activo.getTitulo().setAuditoria(Auditoria.getNewInstance());				
			}
			
			beanUtilNotNull.copyProperties(activo.getTitulo(), dto);			
			
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
				
				if(!Checks.esNulo(dto.getProvinciaRegistro())){
					Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaRegistro());
					DDProvincia provincia = genericDao.get(DDProvincia.class, filtro2);
					activo.getInfoRegistral().getInfoRegistralBien().setProvincia(provincia);
				}
				
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
			
			if (dto.getOrigenAnteriorActivoCodigo() != null) {
				DDOrigenAnterior origenAnterior = (DDOrigenAnterior) diccionarioApi.dameValorDiccionarioByCod(DDOrigenAnterior.class, dto.getOrigenAnteriorActivoCodigo());
				activo.setOrigenAnterior(origenAnterior);
			}
			if (dto.getFechaTituloAnterior() != null) {
				activo.setFechaTituloAnterior(dto.getFechaTituloAnterior());
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
			
			Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			
			if (Checks.esNulo(dto.getCalificacionNegativa())){
					Filter filterNoBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
					List<ActivoCalificacionNegativa> acnList = genericDao.getList(ActivoCalificacionNegativa.class, filterActivo, filterNoBorrado);
					if (!Checks.estaVacio(acnList) && !Checks.esNulo(acnList.get(0).getCalificacionNegativa())){
						if (!DDCalificacionNegativa.CODIGO_NO.equals(acnList.get(0).getCalificacionNegativa().getCodigo())){
							if (!Checks.esNulo(dto.getMotivoCalificacionNegativa())){
								List<ActivoCalificacionNegativa> motivosCalificacionNegativa = activoApi.getActivoCalificacionNegativaByIdActivo(activo.getId());
								List<String> motivosVigentes = new ArrayList<String>();
								List<String> motivosBorrados = new ArrayList<String>();
								
								for (ActivoCalificacionNegativa activoCN : motivosCalificacionNegativa){
									if (!activoCN.getAuditoria().isBorrado()){
										motivosVigentes.add(activoCN.getMotivoCalificacionNegativa().getCodigo());
									} else {
										motivosBorrados.add(activoCN.getMotivoCalificacionNegativa().getCodigo());				}
								}
								
								String motivosCalificacion = dto.getMotivoCalificacionNegativa();
								String motivosFormat = motivosCalificacion.replace("[", "");
								motivosFormat = motivosFormat.replace("]", "");
								motivosFormat = motivosFormat.replace("\"", "");
								if (!Checks.esNulo(motivosFormat)){
									List<String> motivosList = Arrays.asList(motivosFormat.split(","));
									
									for (String motivo : motivosList){
										if (!motivosVigentes.contains(motivo) && !motivosBorrados.contains(motivo)) {
											ActivoCalificacionNegativa activoCalificacion = new ActivoCalificacionNegativa();
											activoCalificacion.setActivo(activo);
											Filter filterMotivo = genericDao.createFilter(FilterType.EQUALS, "codigo", motivo);
											activoCalificacion.setMotivoCalificacionNegativa(genericDao.get(DDMotivoCalificacionNegativa.class, filterMotivo));
											if (Checks.esNulo(dto.getCalificacionNegativa()) && Checks.esNulo(motivosCalificacionNegativa.get(0).getCalificacionNegativa())){
												DDCalificacionNegativa calNegativa = genericDao.get(DDCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDCalificacionNegativa.CODIGO_SI));
												activoCalificacion.setCalificacionNegativa(calNegativa);
											} else if (!Checks.esNulo(dto.getCalificacionNegativa())){			
												DDCalificacionNegativa calNegativa = genericDao.get(DDCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCalificacionNegativa()));
												activoCalificacion.setCalificacionNegativa(calNegativa);
											} else {
												DDCalificacionNegativa calNegativa = genericDao.get(DDCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "codigo", motivosCalificacionNegativa.get(0).getCalificacionNegativa().getCodigo()));
												activoCalificacion.setCalificacionNegativa(calNegativa);
											}
												if (DDMotivoCalificacionNegativa.CODIGO_OTROS.equals(motivo)){
													activoCalificacion.setDescripcion(dto.getDescripcionCalificacionNegativa());
												}
												
											if (!Checks.esNulo(dto.getEstadoMotivoCalificacionNegativa()) && !Checks.esNulo(dto.getResponsableSubsanar())) {
												DDEstadoMotivoCalificacionNegativa estMotNegativa = genericDao.get(DDEstadoMotivoCalificacionNegativa.class,genericDao.createFilter(FilterType.EQUALS, "codigo",  dto.getEstadoMotivoCalificacionNegativa()));
												DDResponsableSubsanar responSubsanar = genericDao.get(DDResponsableSubsanar.class, genericDao.createFilter(FilterType.EQUALS, "codigo",  dto.getResponsableSubsanar()));
												activoCalificacion.setEstadoMotivoCalificacionNegativa(estMotNegativa);
												activoCalificacion.setResponsableSubsanar(responSubsanar);
												
											}else if (Checks.esNulo(dto.getEstadoMotivoCalificacionNegativa()) && !Checks.esNulo(dto.getResponsableSubsanar())) {
												DDEstadoMotivoCalificacionNegativa estMotNegativa = genericDao.get(DDEstadoMotivoCalificacionNegativa.class,genericDao.createFilter(FilterType.EQUALS, "codigo",  DDEstadoMotivoCalificacionNegativa.DD_PENDIENTE_CODIGO));
												DDResponsableSubsanar responSubsanar = genericDao.get(DDResponsableSubsanar.class, genericDao.createFilter(FilterType.EQUALS, "codigo",  dto.getResponsableSubsanar()));
												activoCalificacion.setEstadoMotivoCalificacionNegativa(estMotNegativa);
												activoCalificacion.setResponsableSubsanar(responSubsanar);												
											} 
										
											genericDao.save(ActivoCalificacionNegativa.class, activoCalificacion);
										} else if (!motivosVigentes.contains(motivo) && motivosBorrados.contains(motivo)){
											
											Filter filterCodigo = genericDao.createFilter(FilterType.EQUALS, "motivoCalificacionNegativa.codigo", motivo);
											Filter filterBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", true);
											ActivoCalificacionNegativa acn = genericDao.get(ActivoCalificacionNegativa.class, filterActivo, filterCodigo, filterBorrado);
											acn.getAuditoria().setBorrado(false);
											if (DDMotivoCalificacionNegativa.CODIGO_OTROS.equals(motivo)){
												acn.setDescripcion(dto.getDescripcionCalificacionNegativa());
											}
											if (acn.getCalificacionNegativa().getCodigo().equals(acnList.get(0).getCalificacionNegativa().getCodigo())){
												genericDao.update(ActivoCalificacionNegativa.class, acn);
											}else {
												genericDao.save(ActivoCalificacionNegativa.class, acn);
											}
											
										} else {
											for (String codigoVigente : motivosVigentes){
												if (!motivosList.contains(codigoVigente)){
													this.borrarActivoCalificacionNegativaByCodigo(codigoVigente, activo.getId(), acnList.get(0).getCalificacionNegativa().getCodigo());
												}
											}
										}
									}
								}
							} else {
								Filter filterBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
								Filter filterOtros = genericDao.createFilter(FilterType.EQUALS, "motivoCalificacionNegativa.codigo", DDMotivoCalificacionNegativa.CODIGO_OTROS);
								ActivoCalificacionNegativa acn = genericDao.get(ActivoCalificacionNegativa.class, filterActivo, filterBorrado, filterOtros);
								if (!Checks.esNulo(acn)){
									if (!Checks.esNulo(dto.getDescripcionCalificacionNegativa())){
										acn.setDescripcion(dto.getDescripcionCalificacionNegativa());
									}					
										genericDao.save(ActivoCalificacionNegativa.class, acn);
								}	
							}
						}			
				}
			} else if (!Checks.esNulo(dto.getCalificacionNegativa())){
				if (!DDCalificacionNegativa.CODIGO_NO.equals(dto.getCalificacionNegativa())){
					if (!Checks.esNulo(dto.getMotivoCalificacionNegativa())){
						List<ActivoCalificacionNegativa> motivosCalificacionNegativa = genericDao.getList(ActivoCalificacionNegativa.class, filterActivo);
						List<String> motivosVigentes = new ArrayList<String>();
						List<String> motivosBorrados = new ArrayList<String>();
						
						for (ActivoCalificacionNegativa activoCN : motivosCalificacionNegativa){
							if (!activoCN.getAuditoria().isBorrado()){
								motivosVigentes.add(activoCN.getMotivoCalificacionNegativa().getCodigo());
							} else {
								motivosBorrados.add(activoCN.getMotivoCalificacionNegativa().getCodigo());				}
						}
						
						String motivosCalificacion = dto.getMotivoCalificacionNegativa();
						String motivosFormat = motivosCalificacion.replace("[", "");
						motivosFormat = motivosFormat.replace("]", "");
						motivosFormat = motivosFormat.replace("\"", "");
						if (!Checks.esNulo(motivosFormat)){
							List<String> motivosList = Arrays.asList(motivosFormat.split(","));
							
							for (String motivo : motivosList){
								if (!motivosVigentes.contains(motivo) && !motivosBorrados.contains(motivo)) {
									ActivoCalificacionNegativa activoCalificacion = new ActivoCalificacionNegativa();
									activoCalificacion.setActivo(activo);
									activoCalificacion.setMotivoCalificacionNegativa(genericDao.get(DDMotivoCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "codigo", motivo)));
									if (Checks.esNulo(dto.getCalificacionNegativa()) && Checks.esNulo(motivosCalificacionNegativa.get(0).getCalificacionNegativa())){
										DDCalificacionNegativa calNegativa = genericDao.get(DDCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDCalificacionNegativa.CODIGO_SI));
										activoCalificacion.setCalificacionNegativa(calNegativa);
									} else if (!Checks.esNulo(dto.getCalificacionNegativa())){			
										DDCalificacionNegativa calNegativa = genericDao.get(DDCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCalificacionNegativa()));
										activoCalificacion.setCalificacionNegativa(calNegativa);
									} else {
										DDCalificacionNegativa calNegativa = genericDao.get(DDCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "codigo", motivosCalificacionNegativa.get(0).getCalificacionNegativa().getCodigo()));
										activoCalificacion.setCalificacionNegativa(calNegativa);
									}
									if (DDMotivoCalificacionNegativa.CODIGO_OTROS.equals(motivo)){
										activoCalificacion.setDescripcion(dto.getDescripcionCalificacionNegativa());
									}
									
									if (!Checks.esNulo(dto.getEstadoMotivoCalificacionNegativa()) && !Checks.esNulo(dto.getResponsableSubsanar())) {
										DDEstadoMotivoCalificacionNegativa estMotNegativa = genericDao.get(DDEstadoMotivoCalificacionNegativa.class,genericDao.createFilter(FilterType.EQUALS, "codigo",  dto.getEstadoMotivoCalificacionNegativa()));
										DDResponsableSubsanar responSubsanar = genericDao.get(DDResponsableSubsanar.class, genericDao.createFilter(FilterType.EQUALS, "codigo",  dto.getResponsableSubsanar()));
										activoCalificacion.setEstadoMotivoCalificacionNegativa(estMotNegativa);
										activoCalificacion.setResponsableSubsanar(responSubsanar);
										
									}else if (Checks.esNulo(dto.getEstadoMotivoCalificacionNegativa()) && !Checks.esNulo(dto.getResponsableSubsanar())) {
										DDEstadoMotivoCalificacionNegativa estMotNegativa = genericDao.get(DDEstadoMotivoCalificacionNegativa.class,genericDao.createFilter(FilterType.EQUALS, "codigo",  DDEstadoMotivoCalificacionNegativa.DD_PENDIENTE_CODIGO));
										DDResponsableSubsanar responSubsanar = genericDao.get(DDResponsableSubsanar.class, genericDao.createFilter(FilterType.EQUALS, "codigo",  dto.getResponsableSubsanar()));
										activoCalificacion.setEstadoMotivoCalificacionNegativa(estMotNegativa);
										activoCalificacion.setResponsableSubsanar(responSubsanar);												
									}
									if (!Checks.esNulo(activoCalificacion.getEstadoMotivoCalificacionNegativa()) && !Checks.esNulo(activoCalificacion.getResponsableSubsanar())) {
										genericDao.save(ActivoCalificacionNegativa.class, activoCalificacion);
									}
								} else if (!motivosVigentes.contains(motivo) && motivosBorrados.contains(motivo)){
									
									Filter filterCodigo = genericDao.createFilter(FilterType.EQUALS, "motivoCalificacionNegativa.codigo", motivo);
									Filter filterBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", true);
									ActivoCalificacionNegativa acn = genericDao.get(ActivoCalificacionNegativa.class, filterActivo, filterCodigo, filterBorrado);
									acn.getAuditoria().setBorrado(false);
									if (DDMotivoCalificacionNegativa.CODIGO_OTROS.equals(motivo)){
										acn.setDescripcion(dto.getDescripcionCalificacionNegativa());
									}
									if (acn.getCalificacionNegativa().getCodigo().equals(dto.getCalificacionNegativa())){										
										genericDao.update(ActivoCalificacionNegativa.class, acn);
									}else {
										genericDao.save(ActivoCalificacionNegativa.class, acn);
									}
								} else {
									for (String codigoVigente : motivosVigentes){
										if (!motivosList.contains(codigoVigente)){
											this.borrarActivoCalificacionNegativaByCodigo(codigoVigente, activo.getId(), dto.getCalificacionNegativa());
										}
									}
									
								}
							}
						}
					} else {
						Filter filterNoBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
						Filter filterBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", true);
						List<ActivoCalificacionNegativa> acnList = genericDao.getList(ActivoCalificacionNegativa.class, filterActivo, filterNoBorrado);
						List<ActivoCalificacionNegativa> acnListBorrado = genericDao.getList(ActivoCalificacionNegativa.class, filterActivo, filterBorrado);
						Boolean isActualizado = false;
						for (ActivoCalificacionNegativa acn : acnList){
							ActivoCalificacionNegativa activoCN = new ActivoCalificacionNegativa();
							if (!Checks.esNulo(dto.getDescripcionCalificacionNegativa()) && DDMotivoCalificacionNegativa.CODIGO_OTROS.equals(acn.getMotivoCalificacionNegativa().getCodigo())){
								activoCN.setDescripcion(dto.getDescripcionCalificacionNegativa());
							}
							activoCN.setActivo(acn.getActivo());	
							activoCN.setMotivoCalificacionNegativa(acn.getMotivoCalificacionNegativa());
							DDCalificacionNegativa calNegativa = genericDao.get(DDCalificacionNegativa.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCalificacionNegativa()));
							if (!Checks.esNulo(calNegativa)){
								activoCN.setCalificacionNegativa(calNegativa);
							}
							
							for (ActivoCalificacionNegativa acnBorrado : acnListBorrado) {
								if (acnBorrado.getActivo().equals(activoCN.getActivo()) && acnBorrado.getCalificacionNegativa().equals(activoCN.getCalificacionNegativa()) && acnBorrado.getMotivoCalificacionNegativa().equals(activoCN.getMotivoCalificacionNegativa())){
									acnBorrado.getAuditoria().setBorrado(false);
									genericDao.update(ActivoCalificacionNegativa.class, acnBorrado);
									isActualizado = true;
									break;
								}
							}
							
							if (!isActualizado){
								genericDao.save(ActivoCalificacionNegativa.class, activoCN);
							}
							acn.getAuditoria().setBorrado(true);
							genericDao.update(ActivoCalificacionNegativa.class, acn);
							}
						}
					}
				}
			
		} catch (JsonViewerException jvex) {
			throw jvex;
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		//
		DtoActivoSaneamiento actSaneamientoDto = (DtoActivoSaneamiento) webDto;
		ActivoTituloAdicional actTituloAdicional = new ActivoTituloAdicional();
		
		try {
			if (actSaneamientoDto.getTieneTituloAdicional() != null && DDSiNo.SI.equals(actSaneamientoDto.getTieneTituloAdicional())) {
				
				
				actTituloAdicional.setTituloAdicional("1".equals(actSaneamientoDto.getTieneTituloAdicional()));
				
				if (actSaneamientoDto.getEstadoTituloAdicional() != null) {
					//actTituloAdicional.setEstadoTitulo(estadoTitulo); //DD_TTA_ID
					actTituloAdicional.setActivo(activo);
				}
				if (actSaneamientoDto.getSituacionTituloAdicional() != null) {
					//actTituloAdicional.setTipoTitulo(tipoTitulo); //DD_ETI_ID
				}
					
			}
		} catch (JsonViewerException jvex) {
			throw jvex;
		} catch (Exception e) {
			// TODO: handle exception
		}

		return activo;
	}
	
	
	public void borrarActivoCalificacionNegativaByCodigo(String motivo, Long idActivo, String calificacionNegativa){
		Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filterCodigo = genericDao.createFilter(FilterType.EQUALS, "motivoCalificacionNegativa.codigo", motivo);
		Filter filterBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		ActivoCalificacionNegativa acn = genericDao.get(ActivoCalificacionNegativa.class, filterActivo, filterCodigo, filterBorrado);
		acn.getAuditoria().setBorrado(true);
		if (acn.getCalificacionNegativa().getCodigo().equals(calificacionNegativa)){										
			genericDao.update(ActivoCalificacionNegativa.class, acn);
		}
	}
	
	public void comprobacionSuperficiePA(DtoActivoDatosRegistrales activoDto, Long id) {
		Activo activoActual = activoApi.get(id);
		ActivoAgrupacion agr = activoDao.getAgrupacionPAByIdActivoConFechaBaja(id);
		boolean isUA = activoDao.isUnidadAlquilable(id);
		Activo activoMatriz = null;
		List<Activo> listaUAs = new ArrayList<Activo>();
		if (!Checks.esNulo(agr)) {
			if (!isUA) {
				activoMatriz = activoActual;
			}else {
				activoMatriz = activoAgrupacionActivoDao.getActivoMatrizByIdAgrupacion(agr.getId());
			}
			listaUAs = activoAgrupacionActivoDao.getListUAsByIdAgrupacion(agr.getId());
		}
		
		
		float superficie_construida = 0;
		float superficie_util = 0;
		float superficie_repercusion = 0;
		float superficie_parcela = 0;
		
		float superficieConstruidaActivoMatriz = 0;
		float superficieUtilActivoMatriz = 0;
		float superficieElementosComunesActivoMatriz = 0;
		float superficieParcelaActivoMatriz = 0;
		
		for (Activo ua : listaUAs) {
			if (isUA) {
				if (ua.getId() == activoActual.getId()) {
					if(!Checks.esNulo(activoDto.getSuperficieConstruida())) {
						ua.getInfoRegistral().getInfoRegistralBien().setSuperficieConstruida(BigDecimal.valueOf(Long.parseLong(activoDto.getSuperficieConstruida())));
					}
					if(!Checks.esNulo(activoDto.getSuperficieUtil())) {
						ua.getInfoRegistral().setSuperficieUtil(Float.valueOf(activoDto.getSuperficieUtil()));
					}
					if(!Checks.esNulo(activoDto.getSuperficieElementosComunes())) {
						 ua.getInfoRegistral().setSuperficieElementosComunes(Float.valueOf(activoDto.getSuperficieElementosComunes()));
					}
					if(!Checks.esNulo(activoDto.getSuperficieParcela())) {
						ua.getInfoRegistral().setSuperficieParcela(Float.valueOf(activoDto.getSuperficieParcela()));
					}
				}
			}
			if(!Checks.esNulo(ua.getInfoRegistral())) {
				if(!Checks.esNulo(ua.getInfoRegistral().getInfoRegistralBien())) {
					if(!Checks.esNulo(ua.getInfoRegistral().getInfoRegistralBien().getSuperficieConstruida())) {
						superficie_construida += ua.getInfoRegistral().getInfoRegistralBien().getSuperficieConstruida().floatValue();
					}
				}
				if(!Checks.esNulo(ua.getInfoRegistral().getSuperficieUtil())) {
					superficie_util += ua.getInfoRegistral().getSuperficieUtil();
				}
				if(!Checks.esNulo(ua.getInfoRegistral().getSuperficieElementosComunes())) {
					superficie_repercusion += ua.getInfoRegistral().getSuperficieElementosComunes();
				}
				if(!Checks.esNulo(ua.getInfoRegistral().getSuperficieElementosComunes())) {
					superficie_parcela += ua.getInfoRegistral().getSuperficieParcela();
				}
			}
		}
		if(!isUA) {
			if(!Checks.esNulo(activoDto.getSuperficieConstruida())) {
				activoMatriz.getInfoRegistral().getInfoRegistralBien().setSuperficieConstruida(BigDecimal.valueOf(Long.parseLong(activoDto.getSuperficieConstruida())));
			}
			if(!Checks.esNulo(activoDto.getSuperficieUtil())) {
				activoMatriz.getInfoRegistral().setSuperficieUtil(Float.valueOf(activoDto.getSuperficieUtil()));
			}
			if(!Checks.esNulo(activoDto.getSuperficieElementosComunes())) {
				activoMatriz.getInfoRegistral().setSuperficieElementosComunes(Float.valueOf(activoDto.getSuperficieElementosComunes()));
			}
			if(!Checks.esNulo(activoDto.getSuperficieParcela())) {
				activoMatriz.getInfoRegistral().setSuperficieParcela(Float.valueOf(activoDto.getSuperficieParcela()));
			}
		}
		if(!Checks.esNulo(activoMatriz)) {
			if(!Checks.esNulo(activoMatriz.getInfoRegistral()) && !Checks.esNulo(activoMatriz.getInfoRegistral().getInfoRegistralBien())) {
				if(!Checks.esNulo(activoMatriz.getInfoRegistral().getInfoRegistralBien().getSuperficieConstruida())) {
					superficieConstruidaActivoMatriz = activoMatriz.getInfoRegistral().getInfoRegistralBien().getSuperficieConstruida().floatValue();
				}
			}
			if(!Checks.esNulo(activoMatriz.getInfoRegistral().getSuperficieUtil())) {
				superficieUtilActivoMatriz = activoMatriz.getInfoRegistral().getSuperficieUtil();
			}
			if(!Checks.esNulo(activoMatriz.getInfoRegistral().getSuperficieElementosComunes())) {
				superficieElementosComunesActivoMatriz = activoMatriz.getInfoRegistral().getSuperficieElementosComunes();
			}
			if(!Checks.esNulo(activoMatriz.getInfoRegistral().getSuperficieParcela())) {
				superficieParcelaActivoMatriz = activoMatriz.getInfoRegistral().getSuperficieParcela();
			}
			if(superficie_construida > superficieConstruidaActivoMatriz) {
				throw new JsonViewerException(messageServices.getMessage(MENSAJE_ERROR_SUPERFICIE_CONSTRUIDA));
			}else if(superficie_util > superficieUtilActivoMatriz) {
				throw new JsonViewerException(messageServices.getMessage(MENSAJE_ERROR_SUPERFICIE_UTIL));
			}else if(superficie_repercusion > superficieElementosComunesActivoMatriz) {
				throw new JsonViewerException(messageServices.getMessage(MENSAJE_ERROR_SUPERFICIE_REPERCUSION));
			}else if(superficie_parcela > superficieParcelaActivoMatriz) {
				throw new JsonViewerException(messageServices.getMessage(MENSAJE_ERROR_SUPERFICIE_PARCELA));
			}
		}
	}
	
}
