package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import es.pfsgroup.plugin.rem.alaskaComunicacion.AlaskaComunicacionManager;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoCargasApi;
import es.pfsgroup.plugin.rem.gestor.dao.GestorActivoHistoricoDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoTituloAdicional;
import es.pfsgroup.plugin.rem.model.ActivoInfAdministrativa;
import es.pfsgroup.plugin.rem.model.ActivoTitulo;
import es.pfsgroup.plugin.rem.model.ActivoTituloAdicional;
import es.pfsgroup.plugin.rem.model.DtoActivoSaneamiento;
import es.pfsgroup.plugin.rem.model.HistoricoTramitacionTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPresentacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoVenta;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloAdicional;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVpo;
import es.pfsgroup.plugin.rem.rest.dto.ReqFaseVentaDto;
import es.pfsgroup.plugin.rem.thread.ConvivenciaAlaska;

import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.ModelMap;

@Component
public class TabActivoSaneamiento implements TabActivoService{
	
	private static final String PERFIL_HAYASUPER = "HAYASUPER";
	private static final String PERFIL_HAYAGESTADM = "HAYAGESTADM";
	private static final String PERFIL_HAYASUPADM = "HAYASUPADM";
	private static final String PERFIL_GESTOADM = "GESTOADM";
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoCargasApi activoCargasApi;
	
	@Autowired
	private ActivoAgrupacionActivoDao activoAgrupacionActivoDao;

	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private UsuarioApi usuarioApi;
	
	@Autowired
	private GestorActivoHistoricoDao gestorActivoDao;

	@Autowired
	private AlaskaComunicacionManager alaskaComunicacionManager;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;

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

		BeanUtils.copyProperties(activoDto, activo);
		
		if(activoDao.isUnidadAlquilable(activo.getId())){
			activoDto.setUnidadAlquilable(true);
		}else {
			activoDto.setUnidadAlquilable(false);
		}
		
		Usuario usuario = usuarioApi.getUsuarioLogado();
		List<Perfil> perfiles = usuario.getPerfiles();
		boolean tienePerfil = false;
		for (Perfil perfil : perfiles) {
			if(PERFIL_HAYASUPER.equalsIgnoreCase(perfil.getCodigo())
					|| PERFIL_GESTOADM.equalsIgnoreCase(perfil.getCodigo())
					|| PERFIL_HAYAGESTADM.equalsIgnoreCase(perfil.getCodigo())
					|| PERFIL_HAYASUPADM.equalsIgnoreCase(perfil.getCodigo())){
				tienePerfil = true;
				break;
			}
		}
		
		Boolean puedeEditar = false;
		Long idMasAlta = 0L;
		int posicionIDmasAlta = 0;
		
		if(!Checks.esNulo(activo.getTitulo())) {
			List <HistoricoTramitacionTitulo> tramitacionTitulo = genericDao.getList(HistoricoTramitacionTitulo.class, genericDao.createFilter(FilterType.EQUALS, "titulo.id", activo.getTitulo().getId()));
			for (int i = 0; i < tramitacionTitulo.size(); i++) {
				if(idMasAlta < tramitacionTitulo.get(i).getId()) {
					idMasAlta = tramitacionTitulo.get(i).getId();
					posicionIDmasAlta = i;
				}					
			}
			
			if(!Checks.estaVacio(tramitacionTitulo) && !Checks.esNulo(tramitacionTitulo.get(posicionIDmasAlta).getEstadoPresentacion())
				&& DDEstadoPresentacion.CALIFICADO_NEGATIVAMENTE.equals(tramitacionTitulo.get(posicionIDmasAlta).getEstadoPresentacion().getCodigo())
				&& !Checks.esNulo(activo.getTitulo().getEstado()) && DDEstadoTitulo.ESTADO_SUBSANAR.equals(activo.getTitulo().getEstado().getCodigo())
			) {
				puedeEditar = true;

			}
		}
		activoDto.setPuedeEditarCalificacionNegativa(puedeEditar);
		
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
		
		if(!Checks.esNulo(activo.getTitulo()) 
				&& !Checks.esNulo(activo.getTitulo().getEstado()) 
				&& !DDEstadoTitulo.ESTADO_INSCRITO.equals(activo.getTitulo().getEstado().getCodigo())
				&& tienePerfil){
			activoDto.setNoEstaInscrito(true);
		}else{
			activoDto.setNoEstaInscrito(false);
		}
		
		ActivoTitulo  actTitulo = genericDao.get(ActivoTitulo.class, genericDao.createFilter(FilterType.EQUALS,"activo.id", activo.getId()));

		if(actTitulo != null) {
			
			if (activo.getTitulo() != null) {
				BeanUtils.copyProperties(activoDto, activo.getTitulo());
				if (activo.getTitulo().getEstado() != null) {
					if (activo.getTitulo().getEstado() != null) {
						BeanUtils.copyProperty(activoDto, "estadoTitulo", activo.getTitulo().getEstado().getCodigo());
						BeanUtils.copyProperty(activoDto, "estadoTituloDescripcion", activo.getTitulo().getEstado().getDescripcion());
					}
				}
			}
			
			if(activoDto.getFechaEntregaGestoria() != null) {
				activoDto.setFechaEntregaGestoria(activoDto.getFechaEntregaGestoria());
			}
			
			if(activoDto.getFechaPresHacienda() != null) {
				activoDto.setFechaPresHacienda(actTitulo.getFechaPresHacienda());
			}
			
			if(activoDto.getFechaPres1Registro() != null) {
				activoDto.setFechaPres1Registro(actTitulo.getFechaPres1Registro());
			}
			
			if(activoDto.getFechaEnvioAuto() != null) {
				activoDto.setFechaEnvioAuto(actTitulo.getFechaEnvioAuto());
			}
			
			if(activoDto.getFechaPres2Registro() != null) {
				activoDto.setFechaPres2Registro(actTitulo.getFechaPres2Registro());
			}
			
			if(activoDto.getFechaInscripcionReg() != null) {
				activoDto.setFechaInscripcionReg(actTitulo.getFechaInscripcionReg());
			}
			
			if(activoDto.getFechaNotaSimple() != null) {
				activoDto.setFechaNotaSimple(actTitulo.getFechaNotaSimple());
			}
			
			if(activoDto.getFechaRetiradaReg() != null) {
				activoDto.setFechaRetiradaReg(actTitulo.getFechaRetiradaReg());
			}
			
		}
		
		boolean esUA = activoDao.isUnidadAlquilable(activo.getId());
		
		if(esUA) {
			activoDto.setUnidadAlquilable(true);
			ActivoAgrupacion agrupacion = activoDao.getAgrupacionPAByIdActivo(activo.getId());
			if(agrupacion != null) {
				if(activoCargasApi.tieneCargasOcultasCargaMasivaEsparta(agrupacion.getId())) {
					if(activoCargasApi.esCargasOcultasCargaMasivaEsparta(agrupacion.getId())) {
						activoDto.setConCargas(1);
					} else {
						activoDto.setConCargas(0);
					}
				} else if(activoCargasApi.esActivoConCargasNoCanceladas(agrupacion.getId())) {
					activoDto.setConCargas(1);
				} else {
					activoDto.setConCargas(0);
				}
				
				Activo activoMatriz = activoAgrupacionActivoDao.getActivoMatrizByIdAgrupacion(agrupacion.getId());
				if (activoMatriz != null) {
					if (activoMatriz.getInfoAdministrativa() != null) {
						BeanUtils.copyProperties(activoDto, activo.getInfoAdministrativa());
						if(activoMatriz.getInfoAdministrativa().getTipoVpo() != null) {
							activoDto.setTipoVpoId(activoMatriz.getInfoAdministrativa().getTipoVpo().getId());
							activoDto.setTipoVpoCodigo(activoMatriz.getInfoAdministrativa().getTipoVpo().getCodigo());
							activoDto.setTipoVpoDescripcion(activoMatriz.getInfoAdministrativa().getTipoVpo().getDescripcion());
						}
					}
					activoDto.setVpo(activoMatriz.getVpo());
				}
			}
		} else {
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

			if (activo.getInfoAdministrativa() != null) {
				BeanUtils.copyProperties(activoDto, activo.getInfoAdministrativa());
				if(activo.getInfoAdministrativa().getTipoVpo() != null) {
					activoDto.setTipoVpoId(activo.getInfoAdministrativa().getTipoVpo().getId());
					activoDto.setTipoVpoCodigo(activo.getInfoAdministrativa().getTipoVpo().getCodigo());
					activoDto.setTipoVpoDescripcion(activo.getInfoAdministrativa().getTipoVpo().getDescripcion());
				}
			}
			activoDto.setVpo(activo.getVpo());		
		}
		
		if (activo.getEstadoCargaActivo() != null) {
			activoDto.setEstadoCargas(activo.getEstadoCargaActivo().getDescripcion());
		}
		
		if (activo.getFechaRevisionCarga() != null) {
			activoDto.setFechaRevisionCarga(activo.getFechaRevisionCarga());
		}
		
		// HREOS-2761: Buscamos los campos que pueden ser propagados para esta pestaña
		if(activoDao.isActivoMatriz(activo.getId())) {	
			activoDto.setCamposPropagablesUas(TabActivoService.TAB_SANEAMIENTO);
		} else {
			// Buscamos los campos que pueden ser propagados para esta pestaña
			activoDto.setCamposPropagables(TabActivoService.TAB_SANEAMIENTO);
		}
		
		if (activo.getInfoAdministrativa() != null) {
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
			activoDto.setFechaSoliCertificado(activo.getInfoAdministrativa().getFechaSolCertificado());
			activoDto.setFechaComAdquisicion(activo.getInfoAdministrativa().getFechaComAdquision());
			activoDto.setFechaComRegDemandantes(activo.getInfoAdministrativa().getFechaComRegDem());
			activoDto.setFechaVencimiento(activo.getInfoAdministrativa().getFechaVencimiento());
			
			if(activo.getInfoAdministrativa().getActualizaPrecioMax() != null) {
				activoDto.setActualizaPrecioMaxId(activo.getInfoAdministrativa().getActualizaPrecioMax().getCodigo().equals(DDSinSiNo.CODIGO_NO) ? 0L : 1L);				
			}
			if(activo.getInfoAdministrativa().getFechaRecepcionRespuestaOrganismo() != null) {
				activoDto.setFechaRecepcionRespuestaOrganismo(activo.getInfoAdministrativa().getFechaRecepcionRespuestaOrganismo());
			}
			if(activo.getInfoAdministrativa().getFechaEnvioComunicacionOrganismo() != null) {
				activoDto.setFechaEnvioComunicacionOrganismo(activo.getInfoAdministrativa().getFechaEnvioComunicacionOrganismo());
			}
			if(activo.getInfoAdministrativa().getEstadoVenta() != null) {
				activoDto.setEstadoVentaCodigo(activo.getInfoAdministrativa().getEstadoVenta().getCodigo());
				activoDto.setEstadoVentaDescripcion(activo.getInfoAdministrativa().getEstadoVenta().getDescripcion());
			}
			try {
				List<ReqFaseVentaDto> requisitosVenta = activoApi.getReqFaseVenta(activo.getId());
						
				if(requisitosVenta != null && !requisitosVenta.isEmpty()) {
					for (int i = 0; i < requisitosVenta.size(); i++) {
						ReqFaseVentaDto req = requisitosVenta.get(i);
						if(req.getFechavencimiento() != null && req.getPreciomaximo() != null) {
							activoDto.setMaxPrecioVenta("" + req.getPreciomaximo());
							String dateStr = req.getFechavencimiento().split(" ")[0];
						    Date date = new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);  
							activoDto.setFechaVencimiento(date);
							break;
						}
					}
				}
			}catch (Exception e) {
				logger.error(e.getMessage());
			}
		}
		
		//TITULO ADICIONAL SANEAMIENTO
		
		Filter filtroTituloAdicional = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoTituloAdicional actTituloAdicional = genericDao.get(ActivoTituloAdicional.class, filtroTituloAdicional);
		

		if (actTituloAdicional != null && actTituloAdicional.getTituloAdicional() != null) {
			
			activoDto.setTieneTituloAdicional(actTituloAdicional.getTituloAdicional());
			
			if (actTituloAdicional.getEstadoTitulo() != null) {
				activoDto.setEstadoTituloAdicional(actTituloAdicional.getEstadoTitulo().getCodigo());
				activoDto.setEstadoTituloAdicionalDescripcion(actTituloAdicional.getEstadoTitulo().getDescripcion());
			}
			if (actTituloAdicional.getTipoTitulo() != null) {
				activoDto.setTipoTituloAdicional(actTituloAdicional.getTipoTitulo().getCodigo());
				activoDto.setTipoTituloAdicionalDescripcion(actTituloAdicional.getTipoTitulo().getDescripcion());
			}
			if (actTituloAdicional.getFechaInscripcionReg() != null) {
				activoDto.setFechaInscriptionRegistroAdicional(actTituloAdicional.getFechaInscripcionReg());
			}
			if (actTituloAdicional.getFechaEntregaTitulo() != null) {
				activoDto.setFechaEntregaTituloGestAdicional(actTituloAdicional.getFechaEntregaTitulo());
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
			
			puedeEditar = false;
			
			Order order = new Order(OrderType.DESC, "id");
			filtro = genericDao.createFilter(FilterType.EQUALS, "tituloAdicional.activo.id", activo.getId());
			List<ActivoHistoricoTituloAdicional> listasTramitacion = genericDao.getListOrdered(ActivoHistoricoTituloAdicional.class, order, filtro);
			
			if(!Checks.estaVacio(listasTramitacion) && !Checks.esNulo(listasTramitacion.get(0).getEstadoPresentacion())
				&& DDEstadoPresentacion.CALIFICADO_NEGATIVAMENTE.equals(listasTramitacion.get(0).getEstadoPresentacion().getCodigo())
				&& !Checks.esNulo(actTituloAdicional.getEstadoTitulo()) && DDEstadoTitulo.ESTADO_SUBSANAR.equals(actTituloAdicional.getEstadoTitulo().getCodigo())
			) {
				puedeEditar = true;

			}
		
			activoDto.setPuedeEditarCalificacionNegativaAdicional(puedeEditar);
			
			
		}else {
			activoDto.setTieneTituloAdicional(0);
		}
			
				
		 
		return activoDto;
	}
	
	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {
		
		DtoActivoSaneamiento activoDto = (DtoActivoSaneamiento) webDto;
		
		if(activoDto != null){

			ActivoTitulo  actTitulo = genericDao.get(ActivoTitulo.class, genericDao.createFilter(FilterType.EQUALS,"activo.id", activo.getId()));

			ActivoTituloAdicional actTituloAdicional = genericDao.get(ActivoTituloAdicional.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));

			if(actTitulo == null) {
				actTitulo = new ActivoTitulo();
				actTitulo.setActivo(activo);
			}
			
			if (activoDto.getEstadoTitulo() != null) {
				DDEstadoTitulo estadoTituloNuevo = (DDEstadoTitulo) diccionarioApi.dameValorDiccionarioByCod(DDEstadoTitulo.class, activoDto.getEstadoTitulo());
				activo.getTitulo().setEstado(estadoTituloNuevo);
			}
			
			if(activoDto.getFechaEntregaGestoria() != null) {
				actTitulo.setFechaEntregaGestoria(activoDto.getFechaEntregaGestoria());
			}
			
			if(activoDto.getFechaPresHacienda() != null) {
				actTitulo.setFechaPresHacienda(activoDto.getFechaPresHacienda());
			}
			
			if(activoDto.getFechaPres1Registro() != null) {
				actTitulo.setFechaPres1Registro(activoDto.getFechaPres1Registro());
			}
			
			if(activoDto.getFechaEnvioAuto() != null) {
				actTitulo.setFechaEnvioAuto(activoDto.getFechaEnvioAuto());
			}
			
			if(activoDto.getFechaPres2Registro() != null) {
				actTitulo.setFechaPres2Registro(activoDto.getFechaPres2Registro());
			}
			
			if(activoDto.getFechaInscripcionReg() != null) {
				actTitulo.setFechaInscripcionReg(activoDto.getFechaInscripcionReg());
			}
			
			if(activoDto.getFechaNotaSimple() != null) {
				actTitulo.setFechaNotaSimple(activoDto.getFechaNotaSimple());
			}
			
			if(activoDto.getFechaRetiradaReg() != null) {
				actTitulo.setFechaRetiradaReg(activoDto.getFechaRetiradaReg());
			}
			
			genericDao.save(ActivoTitulo.class, actTitulo);
			
			
			if (actTituloAdicional == null) {
				actTituloAdicional = new ActivoTituloAdicional();
				actTituloAdicional.setActivo(activo);
				
			}
			if (activoDto.getTipoTituloAdicional() != null) {
				actTituloAdicional.setTipoTitulo( (DDTipoTituloAdicional) diccionarioApi.dameValorDiccionarioByCod(DDTipoTituloAdicional.class, activoDto.getTipoTituloAdicional()));
			}
			if (activoDto.getTieneTituloAdicional() != null) {
				actTituloAdicional.setTituloAdicional(activoDto.getTieneTituloAdicional());
			}
			if (activoDto.getEstadoTituloAdicional() != null) {
				
				actTituloAdicional.setEstadoTitulo((DDEstadoTitulo) diccionarioApi.dameValorDiccionarioByCod(DDEstadoTitulo.class, activoDto.getEstadoTituloAdicional()));
			}
			if (activoDto.getFechaInscriptionRegistroAdicional() != null) {
				actTituloAdicional.setFechaInscripcionReg(activoDto.getFechaInscriptionRegistroAdicional());
				
			}
			if (activoDto.getFechaEntregaTituloGestAdicional() != null) {
				actTituloAdicional.setFechaEntregaTitulo(activoDto.getFechaEntregaTituloGestAdicional());
			}
			if(activoDto.getFechaRetiradaDefinitivaRegAdicional() != null) {
				actTituloAdicional.setFechaRetiradaReg(activoDto.getFechaRetiradaDefinitivaRegAdicional());
			}
			if (activoDto.getFechaPresentacionHaciendaAdicional() != null) {
				actTituloAdicional.setFechaPresentHacienda(activoDto.getFechaPresentacionHaciendaAdicional());
			}
			if (activoDto.getFechaNotaSimpleAdicional() != null) {
				actTituloAdicional.setFechaNotaSimple(activoDto.getFechaNotaSimpleAdicional());
			}
			
			genericDao.save(ActivoTituloAdicional.class, actTituloAdicional);
			
			
			
			
		}

		if (activoDto.getFechaRevisionCarga() != null) {
			activo.setFechaRevisionCarga(activoDto.getFechaRevisionCarga());
		}

		try {
			if (activo.getInfoAdministrativa() == null) {
				activo.setInfoAdministrativa(new ActivoInfAdministrativa());
				activo.getInfoAdministrativa().setActivo(activo);
			}
				
			beanUtilNotNull.copyProperties(activo.getInfoAdministrativa(), activoDto);
	
			activo.setInfoAdministrativa(genericDao.save(ActivoInfAdministrativa.class, activo.getInfoAdministrativa()));
			ActivoInfAdministrativa infoAdministrativa = activo.getInfoAdministrativa();
			
			if (activoDto.getTipoVpoCodigo() != null) {
				DDTipoVpo tipoVpo = (DDTipoVpo) diccionarioApi.dameValorDiccionarioByCod(DDTipoVpo.class, activoDto.getTipoVpoCodigo());
				infoAdministrativa.setTipoVpo(tipoVpo);
			}
			
			if(infoAdministrativa.getTipoVpo() != null) {
				
				if(activoDto.getFechaSoliCertificado() != null) {
					infoAdministrativa.setFechaSolCertificado(activoDto.getFechaSoliCertificado());					
				}
				if(activoDto.getFechaComAdquisicion() != null) {
					infoAdministrativa.setFechaComAdquisicion(activoDto.getFechaComAdquisicion());
				}
				if(activoDto.getFechaComRegDemandantes() != null) {
					infoAdministrativa.setFechaComRegDem(activoDto.getFechaComRegDemandantes());					
				}
				if(activoDto.getActualizaPrecioMaxId() != null) {
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "codigo", (activoDto.getActualizaPrecioMaxId() == 0) ? DDSinSiNo.CODIGO_NO : DDSinSiNo.CODIGO_SI);
					DDSinSiNo mapeadoSinSiNo =genericDao.get(DDSinSiNo.class, filter); 
					infoAdministrativa.setActualizaPrecioMax(mapeadoSinSiNo);					
				}
				if(activoDto.getFechaVencimiento() != null) {
					infoAdministrativa.setFechaVencimiento(activoDto.getFechaVencimiento());					
				}
				if(activoDto.getFechaEnvioComunicacionOrganismo() != null) {
					infoAdministrativa.setFechaEnvioComunicacionOrganismo(activoDto.getFechaEnvioComunicacionOrganismo());
				}
				if(activoDto.getFechaRecepcionRespuestaOrganismo() != null) {
					infoAdministrativa.setFechaRecepcionRespuestaOrganismo(activoDto.getFechaRecepcionRespuestaOrganismo());
				}
				if(activoDto.getEstadoVentaCodigo() != null) {
					Filter filterEstadoVenta = genericDao.createFilter(FilterType.EQUALS, "codigo", activoDto.getEstadoVentaCodigo());
					DDEstadoVenta ddEstadoVenta = genericDao.get(DDEstadoVenta.class, filterEstadoVenta); 
					infoAdministrativa.setEstadoVenta(ddEstadoVenta);	
				}
			}
			
			activo.setInfoAdministrativa(genericDao.save(ActivoInfAdministrativa.class, activo.getInfoAdministrativa()));

			
		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
		}
		
		return activo;
	}	

}
