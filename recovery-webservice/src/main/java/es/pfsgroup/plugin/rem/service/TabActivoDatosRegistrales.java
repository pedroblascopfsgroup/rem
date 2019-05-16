package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.BooleanUtils;
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
import es.capgemini.pfs.procesosJudiciales.model.DDFavorable;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.users.domain.Perfil;
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
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceDesbloqExpCambioSitJuridica;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionJudicial;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionNoJudicial;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoBancario;
import es.pfsgroup.plugin.rem.model.ActivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPlanDinVentas;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTitulo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoActivoDatosRegistrales;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadEjecutante;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdjudicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDivHorizontal;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoMotivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoObraNueva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.dd.DDResponsableSubsanar;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;

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
	private ActivoDao activoDao;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private UsuarioApi usuarioApi;
	
	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;
	
	@Resource
	private MessageService messageServices;
	
	private final String PERFIL_HAYASUPER = "HAYASUPER";
	private final String PERFIL_HAYAGESTADM = "HAYAGESTADM";
	private final String PERFIL_HAYASUPADM = "HAYASUPADM";
	private final String PERFIL_GESTOADM = "GESTOADM";
	private static final String MENSAJE_ERROR_SUPERFICIE_CONSTRUIDA  = "msg.error.superficie.construida.UAs";
	private static final String MENSAJE_ERROR_SUPERFICIE_UTIL        = "msg.error.superficie.util.UAs";
	private static final String MENSAJE_ERROR_SUPERFICIE_REPERCUSION = "msg.error.superficie.repercusion.UAs";
	private static final String MENSAJE_ERROR_SUPERFICIE_PARCELA     = "msg.error.superficie.parcela.UAs";
	
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
		boolean esUA = activoDao.isUnidadAlquilable(activo.getId());
				
		BeanUtils.copyProperties(activoDto, activo);

		if (activo.getInfoRegistral() != null || esUA) {
			if (!esUA) {
				BeanUtils.copyProperties(activoDto, activo.getInfoRegistral());
			}else {
				ActivoAgrupacion agr = activoDao.getAgrupacionPAByIdActivoConFechaBaja(activo.getId());
				Activo activoMatriz = null;
				if (!Checks.esNulo(agr)) {
					activoMatriz = activoAgrupacionActivoDao.getActivoMatrizByIdAgrupacion(agr.getId());
				}
				if (!Checks.esNulo(activoMatriz) && !Checks.esNulo(activoMatriz.getAdjJudicial())) {
					BeanUtils.copyProperty(activoDto,"tipoTituloActivoMatriz", DDTipoTituloActivo.tipoTituloJudicial);
					BeanUtils.copyProperties(activoDto, activoMatriz.getInfoRegistral());
				}
			}
			
		}
		
		if (activo.getAdjNoJudicial() != null || esUA) {
			
			if (!esUA) {
				BeanUtils.copyProperties(activoDto, activo.getAdjNoJudicial());
			}else {
				ActivoAgrupacion agr = activoDao.getAgrupacionPAByIdActivoConFechaBaja(activo.getId());
				Activo activoMatriz = null;
				if (!Checks.esNulo(agr)) {
					activoMatriz = activoAgrupacionActivoDao.getActivoMatrizByIdAgrupacion(agr.getId());
				}
				if (!Checks.esNulo(activoMatriz) && !Checks.esNulo(activoMatriz.getAdjNoJudicial())) {
					BeanUtils.copyProperty(activoDto,"tipoTituloActivoMatriz", DDTipoTituloActivo.tipoTituloNoJudicial);
					BeanUtils.copyProperties(activoDto, activoMatriz.getAdjNoJudicial());
				}
			}
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
		
			if (!Checks.esNulo(activo.getInfoRegistral())) {
				BeanUtils.copyProperties(activoDto, activo.getInfoRegistral().getInfoRegistralBien());
				
				if (!Checks.esNulo(activo.getInfoRegistral().getEstadoDivHorizontal())) {
					BeanUtils.copyProperty(activoDto, "estadoDivHorizontalCodigo", activo.getInfoRegistral().getEstadoDivHorizontal().getCodigo());
				}
				
				if(Checks.esNulo(activo.getInfoRegistral().getDivHorInscrito())) {
					activoDto.setDivHorInscrito(null);
				}
				
				if (!Checks.esNulo(activo.getInfoRegistral().getEstadoObraNueva())) {
					BeanUtils.copyProperty(activoDto, "estadoObraNuevaCodigo", activo.getInfoRegistral().getEstadoObraNueva().getCodigo());
				}
				
				if (!Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien()) && !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien().getLocalidad())) {
					BeanUtils.copyProperty(activoDto, "poblacionRegistro", activo.getInfoRegistral().getInfoRegistralBien().getLocalidad().getCodigo());
				}
	
				if (!Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien()) && !Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien().getProvincia())) {
					BeanUtils.copyProperty(activoDto, "provinciaRegistro", activo.getInfoRegistral().getInfoRegistralBien().getProvincia().getCodigo());
				}
				
				if (!Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien()) && !Checks.esNulo(activo.getInfoRegistral().getLocalidadAnterior())) {
					BeanUtils.copyProperty(activoDto, "localidadAnteriorCodigo", activo.getInfoRegistral().getLocalidadAnterior().getCodigo());
				}
				if (!Checks.esNulo(activo.getInfoRegistral().getInfoRegistralBien()) && !Checks.esNulo(activo.getInfoRegistral().getSuperficieUtil())) {
					BeanUtils.copyProperty(activoDto, "superficieUtil", activo.getInfoRegistral().getSuperficieUtil());
				}
				
				if (!Checks.esNulo(activo.getTipoTitulo())) {
					BeanUtils.copyProperty(activoDto, "tipoTituloCodigo", activo.getTipoTitulo().getCodigo());
				}
				if (!Checks.esNulo(activo.getSubtipoTitulo())) {
					BeanUtils.copyProperty(activoDto, "subtipoTituloCodigo", activo.getSubtipoTitulo().getCodigo());
				}
				if (!Checks.esNulo(activo.getCartera())) {
					BeanUtils.copyProperty(activoDto, "entidadPropietariaCodigo", activo.getCartera().getCodigo());
				}
				
			}
		
			if (!Checks.esNulo(activo.getAdjJudicial())) {
				
				BeanUtils.copyProperties(activoDto, activo.getAdjJudicial());
				
				if (!Checks.esNulo(activo.getAdjJudicial().getAdjudicacionBien())) {
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
	
				if (!Checks.esNulo(activo.getAdjJudicial().getAdjudicacionBien().getEntidadAdjudicataria())) {
					BeanUtils.copyProperty(activoDto, "entidadAdjudicatariaCodigo", activo.getAdjJudicial().getAdjudicacionBien().getEntidadAdjudicataria().getCodigo());
				}
					
				if(!Checks.esNulo(activo.getAdjJudicial().getAdjudicacionBien().getResolucionMoratoria())){
					BeanUtils.copyProperty(activoDto, "resolucionMoratoriaCodigo", activo.getAdjJudicial().getAdjudicacionBien().getResolucionMoratoria().getCodigo());
				}
				
			}
			
			if (!Checks.esNulo(activo.getAdjJudicial().getEntidadEjecutante())) {
				BeanUtils.copyProperty(activoDto, "entidadEjecutanteCodigo", activo.getAdjJudicial().getEntidadEjecutante().getCodigo());
			}

			if (!Checks.esNulo(activo.getAdjJudicial().getJuzgado())) {
				BeanUtils.copyProperty(activoDto, "tipoJuzgadoCodigo", activo.getAdjJudicial().getJuzgado().getCodigo());
			}
			
			if (!Checks.esNulo(activo.getAdjJudicial().getPlazaJuzgado())) {
				BeanUtils.copyProperty(activoDto, "tipoPlazaCodigo", activo.getAdjJudicial().getPlazaJuzgado().getCodigo());
			}
			
			if (!Checks.esNulo(activo.getAdjJudicial().getEstadoAdjudicacion())) {
				BeanUtils.copyProperty(activoDto, "estadoAdjudicacionCodigo", activo.getAdjJudicial().getEstadoAdjudicacion().getCodigo());

			}
				
		}
		
		ActivoBancario activoBancario = activoApi.getActivoBancarioByIdActivo(activo.getId());
		
		if(!Checks.esNulo(activoBancario)) {
			BeanUtils.copyProperty(activoDto, "acreedorNumExp", activoBancario.getNumExpRiesgo());
		}
		
		Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		
		List<ActivoCalificacionNegativa> motivosCalificacionNegativa = genericDao.getList(ActivoCalificacionNegativa.class, filterActivo);
		List<ActivoCalificacionNegativa> motivosVigentes = new ArrayList<ActivoCalificacionNegativa>();
		for (ActivoCalificacionNegativa activoCN : motivosCalificacionNegativa){
			if (!activoCN.getAuditoria().isBorrado()){
				motivosVigentes.add(activoCN);
			}
		}	
			if (!Checks.estaVacio(motivosVigentes) && motivosVigentes.get(0).getCalificacionNegativa() != null) {
				BeanUtils.copyProperty(activoDto, "calificacionNegativa", motivosVigentes.get(0).getCalificacionNegativa().getCodigo());
				
				if (!Checks.esNulo(motivosVigentes.get(0).getEstadoMotivoCalificacionNegativa()) && !Checks.esNulo(motivosVigentes.get(0).getEstadoMotivoCalificacionNegativa().getCodigo()) && !Checks.esNulo(motivosVigentes.get(0).getResponsableSubsanar()) && !Checks.esNulo(motivosVigentes.get(0).getResponsableSubsanar().getCodigo())) {
					BeanUtils.copyProperty(activoDto, "estadoMotivoCalificacionNegativa", motivosVigentes.get(0).getEstadoMotivoCalificacionNegativa().getCodigo());
					BeanUtils.copyProperty(activoDto, "responsableSubsanar", motivosVigentes.get(0).getResponsableSubsanar().getCodigo());
				}else {
					BeanUtils.copyProperty(activoDto, "estadoMotivoCalificacionNegativa", null);
					BeanUtils.copyProperty(activoDto, "responsableSubsanar", null);
				}
				
				StringBuffer codigos = new StringBuffer();
				for(ActivoCalificacionNegativa act : motivosVigentes) {
					if(!Checks.esNulo(act.getMotivoCalificacionNegativa())) {
						codigos.append(act.getMotivoCalificacionNegativa().getCodigo()).append(",");
						if (DDMotivoCalificacionNegativa.CODIGO_OTROS.equals(act.getMotivoCalificacionNegativa().getCodigo())){
							beanUtilNotNull.copyProperty(activoDto, "descripcionCalificacionNegativa", act.getDescripcion());
						}
					}
				}
				beanUtilNotNull.copyProperty(activoDto, "motivoCalificacionNegativa", codigos.substring(0, (codigos.length()-1)));

			} else {
				BeanUtils.copyProperty(activoDto, "calificacionNegativa", DDCalificacionNegativa.CODIGO_NO);
			}


		// HREOS-2761: Buscamos los campos que pueden ser propagados para esta pestaña
			if(!Checks.esNulo(activo) && activoDao.isActivoMatriz(activo.getId())) {	
				activoDto.setCamposPropagablesUas(TabActivoService.TAB_DATOS_REGISTRALES);
			}else {
				// Buscamos los campos que pueden ser propagados para esta pestaña
				activoDto.setCamposPropagables(TabActivoService.TAB_DATOS_REGISTRALES);
			}
		
		List<ActivoCalificacionNegativa> activoCNList = activoDao.getListActivoCalificacionNegativaByIdActivo(activo.getId());
		Boolean puedeEditar = false, campoMarcado = false;
		
		for(ActivoCalificacionNegativa acn : activoCNList) {
			if(!Checks.esNulo(acn.getEstadoMotivoCalificacionNegativa()) 
					&&DDEstadoMotivoCalificacionNegativa.DD_PENDIENTE_CODIGO.equals(acn.getEstadoMotivoCalificacionNegativa().getCodigo())) {
				puedeEditar = true;
				campoMarcado = true;
				break;
			}
		}

		activoDto.setPuedeEditarCalificacionNegativa(campoMarcado);
		activoDto.setIsCalificacionNegativaEnabled(puedeEditar);
		Usuario usuario = usuarioApi.getUsuarioLogado();
		List<Perfil> perfiles = usuario.getPerfiles();
		Boolean tienePerfil = false;
		for (Perfil perfil : perfiles) {
			if(PERFIL_HAYASUPER.equalsIgnoreCase(perfil.getCodigo())
					|| PERFIL_GESTOADM.equalsIgnoreCase(perfil.getCodigo())
					|| PERFIL_HAYAGESTADM.equalsIgnoreCase(perfil.getCodigo())
					|| PERFIL_HAYASUPADM.equalsIgnoreCase(perfil.getCodigo())){
				tienePerfil = true;
				break;
			}
		}
		
		if(!Checks.esNulo(activo.getTitulo()) 
				&& !Checks.esNulo(activo.getTitulo().getEstado()) 
				&& !DDEstadoTitulo.ESTADO_INSCRITO.equals(activo.getTitulo().getEstado().getCodigo())
				&& tienePerfil){
			activoDto.setNoEstaInscrito(true);
		}else{
			activoDto.setNoEstaInscrito(false);
		}
		
		if(activoDao.isUnidadAlquilable(activo.getId())) {
			activoDto.setUnidadAlquilable(true);
		}else {
			activoDto.setUnidadAlquilable(false);
		}
		
		
		return activoDto;
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {

		DtoActivoDatosRegistrales dto = (DtoActivoDatosRegistrales) webDto;
		boolean esUA = activoDao.isUnidadAlquilable(activo.getId());
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
			if (esUA){
				this.comprobacionSuperficieUAs(dto, activo.getId());
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
				Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getProvinciaRegistro());
				DDProvincia provincia = genericDao.get(DDProvincia.class, filtro2);
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
	
	public void updateActivoCalificacionNegativa(String motivo, String codigo, String descripcion, Long idActivo){
		Filter filterActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filterCodigo = genericDao.createFilter(FilterType.EQUALS, "motivoCalificacionNegativa.codigo", motivo);
		Filter filterBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", true);
		ActivoCalificacionNegativa acn = genericDao.get(ActivoCalificacionNegativa.class, filterActivo, filterCodigo, filterBorrado);
		acn.getAuditoria().setBorrado(false);
		if (DDMotivoCalificacionNegativa.CODIGO_OTROS.equals(motivo)){
			acn.setDescripcion(descripcion);
		}
		if (acn.getCalificacionNegativa().getCodigo().equals(codigo)){
			genericDao.update(ActivoCalificacionNegativa.class, acn);
		}else {
			genericDao.save(ActivoCalificacionNegativa.class, acn);
		}
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
	
	public void comprobacionSuperficieUAs(DtoActivoDatosRegistrales activoDto, Long id) {
		Activo activoActual = activoApi.get(id);
		ActivoAgrupacion agr = activoDao.getAgrupacionPAByIdActivoConFechaBaja(id);
		Activo activoMatriz = null;
		if (!Checks.esNulo(agr)) {
			activoMatriz = activoAgrupacionActivoDao.getActivoMatrizByIdAgrupacion(agr.getId());
		}
		List<Activo> listaUAs = activoAgrupacionActivoDao.getListUAsByIdAgrupacion(agr.getId());
		float superficie_construida = 0;
		float superficie_util = 0;
		float superficie_repercusion = 0;
		float superficie_parcela = 0;
		
		float superficieConstruidaActivoMatriz = 0;
		float superficieUtilActivoMatriz = 0;
		float superficieElementosComunesActivoMatriz = 0;
		float superficieParcelaActivoMatriz = 0;
		
		for (Activo ua : listaUAs) {
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
