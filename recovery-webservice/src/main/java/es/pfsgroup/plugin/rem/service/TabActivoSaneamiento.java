package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoCargasApi;
import es.pfsgroup.plugin.rem.gestor.dao.GestorActivoHistoricoDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoInfAdministrativa;
import es.pfsgroup.plugin.rem.model.ActivoTitulo;
import es.pfsgroup.plugin.rem.model.ActivoTituloAdicional;
import es.pfsgroup.plugin.rem.model.DtoActivoSaneamiento;
import es.pfsgroup.plugin.rem.model.HistoricoTramitacionTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPresentacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVpo;

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
	private UsuarioApi usuarioApi;
	
	@Autowired
	private GestorActivoHistoricoDao gestorActivoDao;

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
		}
		
		//por programar TITULO ADICIONAL SANEAMIENTO
		
		Filter filtroTituloAdicional = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoTituloAdicional actTituloAdicional = genericDao.get(ActivoTituloAdicional.class, filtroTituloAdicional);
		
		//BeanUtils.copyProperties(actTituloAdicional, activoDto);
		//if (!"1".equals(activoDto.getTieneTituloAdicional())) {
			//activoDto.setTieneTituloAdicional(activoSaneamiento.getTieneTituloAdicional());
		if (actTituloAdicional.getTituloAdicional() != null) {
			
			activoDto.setTieneTituloAdicional(actTituloAdicional.getTituloAdicional());
			
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
		 
		return activoDto;
	}
	
	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {
		
		DtoActivoSaneamiento activoDto = (DtoActivoSaneamiento) webDto;
		
		if(activoDto != null){

			ActivoTitulo  actTitulo = genericDao.get(ActivoTitulo.class, genericDao.createFilter(FilterType.EQUALS,"activo.id", activo.getId()));
			
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
			
		}

		if (activoDto.getFechaRevisionCarga() != null) {
			activo.setFechaRevisionCarga(activoDto.getFechaRevisionCarga());
		}
		
		
		if (activo.getInfoAdministrativa() == null) {
			activo.setInfoAdministrativa(new ActivoInfAdministrativa());
			activo.getInfoAdministrativa().setActivo(activo);
		}
		
		try {
			beanUtilNotNull.copyProperties(activo.getInfoAdministrativa(), activoDto);
		} catch (IllegalAccessException e) {
			logger.error(e.getMessage());
		} catch (InvocationTargetException e) {
			logger.error(e.getMessage());
		}
	
		activo.setInfoAdministrativa(genericDao.save(ActivoInfAdministrativa.class, activo.getInfoAdministrativa()));
		if (activoDto.getTipoVpoCodigo() != null) {
			DDTipoVpo tipoVpo = (DDTipoVpo) diccionarioApi.dameValorDiccionarioByCod(DDTipoVpo.class, activoDto.getTipoVpoCodigo());
			activo.getInfoAdministrativa().setTipoVpo(tipoVpo);
		}
		
		genericDao.save(Activo.class, activo);
		
		return activo;
	}	

}
