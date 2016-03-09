package es.capgemini.pfs.asunto;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.adjuntos.api.AdjuntoApi;
import es.capgemini.pfs.asunto.dao.EXTAsuntoDao;
import es.capgemini.pfs.asunto.dto.DtoAsunto;
import es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto;
import es.capgemini.pfs.asunto.dto.DtoProcedimiento;
import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDto;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.DDTiposAsunto;
import es.capgemini.pfs.asunto.model.HistoricoCambiosAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.core.api.asunto.EXTAdjuntoDto;
import es.capgemini.pfs.core.api.asunto.HistoricoAsuntoInfo;
import es.capgemini.pfs.core.api.asunto.HistoricoAsuntoInfoImpl;
import es.capgemini.pfs.core.api.registro.HistoricoProcedimientoApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.decisionProcedimiento.DecisionProcedimientoManager;
import es.capgemini.pfs.decisionProcedimiento.model.DDCausaDecisionFinalizar;
import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.exceptions.GenericRollbackException;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.iplus.IPLUSUtils;
import es.capgemini.pfs.multigestor.dao.EXTGestorAdicionalAsuntoDao;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.procedimiento.dao.EXTProcedimientoDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.registro.HistoricoAsuntoBuilder;
import es.capgemini.pfs.registro.HistoricoAsuntoDto;
import es.capgemini.pfs.registro.ModificacionAsuntoListener;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.util.HistoricoProcedimientoComparatorV4;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;
import es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext;
import es.pfsgroup.plugin.recovery.coreextension.model.Provisiones;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto.MEJFinalizarAsuntoDto;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.MEJDecisionProcedimientoManager;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTipoFondo;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.ext.api.asunto.EXTAsuntoApi;
import es.pfsgroup.recovery.ext.api.asunto.EXTHistoricoProcedimiento;
import es.pfsgroup.recovery.ext.api.asunto.EXTHistoricoProcedimientoApi;
import es.pfsgroup.recovery.ext.api.asunto.EXTUsuarioRelacionadoInfo;
import es.pfsgroup.recovery.ext.api.multigestor.EXTGestorInfo;
import es.pfsgroup.recovery.ext.api.multigestor.EXTGrupoUsuariosApi;
import es.pfsgroup.recovery.ext.api.multigestor.EXTMultigestorApi;
import es.pfsgroup.recovery.ext.api.multigestor.dao.EXTGrupoUsuariosDao;
import es.pfsgroup.recovery.ext.api.procedimiento.EXTProcedimientoApi;
import es.pfsgroup.recovery.ext.impl.asunto.dto.EXTDtoAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.dto.EXTDtoBusquedaAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;
import es.pfsgroup.recovery.ext.impl.zona.dao.EXTZonaDao;
import es.pfsgroup.recovery.integration.Guid;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;

@Component
public class EXTAsuntoManager extends BusinessOperationOverrider<AsuntoApi> implements es.pfsgroup.recovery.api.AsuntoApi, AsuntoApi, EXTAsuntoApi {

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private Executor executor;

	@Autowired
	private EXTAsuntoDao asuntoDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private EXTProcedimientoDao procedimientoDao;

	@Autowired
	private GenericABMDao genericdDao;

	@Autowired
	private EXTGestorAdicionalAsuntoDao gestorAdicionalAsuntoDao;

	@Autowired(required = false)
	private List<ModificacionAsuntoListener> listeners;

	private Boolean modeloMultiGestor = null;

	@Autowired(required = false)
	private List<HistoricoAsuntoBuilder> builders;
	
	@Resource
    private MessageService messageService;
	
	@Autowired(required = false)
	private IPLUSUtils iplus;
	
	@Autowired
	private EXTGrupoUsuariosDao extGrupoUsuariosDao;
	
	@Autowired
	private CoreProjectContext coreProjectContext;
	
	@Autowired
    private EXTZonaDao extZonaDao;

	@Autowired
	private JBPMProcessManager jbpmUtil;
	
	@Autowired
	private IntegracionBpmService integrationService;
	
	@Autowired
	private MEJDecisionProcedimientoManager mejDecisionProcedimientoManager;

	@Autowired
	private DecisionProcedimientoManager decisionProcedimientoManager;
	
	@Autowired
	private AdjuntoApi adjuntosApi;
	
	@Override
	public String managerName() {
		return "asuntosManager";
	}

	@Override
	@BusinessOperation(BO_CORE_ASUNTO_GET_HISTORICO_ASUNTO)
	public List<? extends HistoricoAsuntoInfo> getHistoricoAsunto(Long idAsunto) {
		EventFactory.onMethodStart(this.getClass());
		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
		ArrayList<HistoricoAsuntoInfo> historico = obtenerHistoricoTareasProcedimientoAsunto(idAsunto);

		// SACAMOS ESTE BUCLE FUERA, PORQUE ESTO SE REFIERE A HISTORICOS ASUNTOS
		// Y NO A HISTORICOS PROCEDIMIENTOS
		if (builders != null) {
			for (HistoricoAsuntoBuilder b : builders) {
				addHistorico(historico, b.getHistorico(asunto.getId()));
			}
		}

		EventFactory.onMethodStop(this.getClass());
		return ordenaLista(historico);
	}

	@Override
	@BusinessOperation(BO_CORE_ASUNTO_GET_HISTORICO_TAREAS_PROCEDIMIENTO_ASUNTO)
	public List<? extends HistoricoAsuntoInfo> getHistoricoTareasProcedimientoAsunto(Long idAsunto) {
		EventFactory.onMethodStart(this.getClass());

		ArrayList<HistoricoAsuntoInfo> historico = obtenerHistoricoTareasProcedimientoAsunto(idAsunto);
		EventFactory.onMethodStop(this.getClass());
		return ordenaLista(historico);
	}

	private ArrayList<HistoricoAsuntoInfo> obtenerHistoricoTareasProcedimientoAsunto(Long idAsunto) {
		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);

		ArrayList<HistoricoAsuntoInfo> historico = new ArrayList<HistoricoAsuntoInfo>();
		if (!Checks.esNulo(asunto.getProcedimientos())) {
			for (Object o : asunto.getProcedimientos()) {
				Procedimiento p = (Procedimiento) o;
				historico.addAll(getHistoricoProcedimiento(p));
			}
		}
		return historico;
	}

	@Override
	@BusinessOperation(BO_CORE_ASUNTO_GET_EXT_HISTORICO_ASUNTO)
	public List<? extends HistoricoAsuntoInfo> getExtHistoricoAsunto(Long idAsunto) {
		EventFactory.onMethodStart(this.getClass());

		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);

		ArrayList<HistoricoAsuntoInfo> historico = new ArrayList<HistoricoAsuntoInfo>();
		if (!Checks.esNulo(asunto.getProcedimientos())) {
			for (Object o : asunto.getProcedimientos()) {
				Procedimiento p = (Procedimiento) o;
				historico.addAll(getExtHistoricoProcedimiento(p));
			}
		}

		// SACAMOS ESTE BUCLE FUERA, PORQUE ESTO SE REFIERE A HISTORICOS ASUNTOS
		// Y NO A HISTORICOS PROCEDIMIENTOS
		if (builders != null) {
			for (HistoricoAsuntoBuilder b : builders) {
				addHistorico(historico, b.getHistorico(asunto.getId()));
			}
		}

		EventFactory.onMethodStop(this.getClass());
		return ordenaLista(historico);
	}

	private void addHistorico(List<HistoricoAsuntoInfo> lista, List<HistoricoAsuntoDto> historico) {
		for (HistoricoAsuntoDto dto : historico) {
			HistoricoProcedimiento hp = new HistoricoProcedimiento();
			try {
				try{
					BeanUtils.copyProperties(hp, dto);
				} catch (Exception e){
					//ouch!! rellenamos la tarea manualmente e imprimimos error
					hp.setFechaFin(dto.getFechaFin());
					hp.setFechaIni(dto.getFechaIni());
					hp.setFechaRegistro(dto.getFechaRegistro());
					hp.setFechaVencimiento(dto.getFechaVencimiento());
					hp.setIdEntidad(dto.getIdEntidad());
					hp.setIdProcedimiento(dto.getIdProcedimiento());
					hp.setNombreTarea(dto.getNombreTarea());
					hp.setNombreUsuario(dto.getNombreUsuario());
					hp.setRespuesta(dto.getRespuesta());
					hp.setTipoEntidad(dto.getTipoEntidad());
					logger.error(e.toString());	
				}

				HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("tipoActuacion", "Historico asunto");
				map.put("tarea", hp);
				map.put("procedimiento", null);
				
				
				if (dto.getIdTarea() != null) {
					map.put("idTarea", dto.getIdTarea());
					EXTTareaNotificacion tarea = genericdDao.get(EXTTareaNotificacion.class, genericdDao.createFilter(FilterType.EQUALS, "id", dto.getIdTarea()));
					map.put("destinatarioTarea", tarea.getDestinatarioTarea().getApellidoNombre());
				}
				if (dto.getIdTraza() != null) {
					map.put("idTraza", dto.getIdTraza());
				}
				if (dto.getTipoTraza() != null) {
					map.put("tipoTraza", dto.getTipoTraza());
				}
				if (dto.getGroup() != null) {
					map.put("group", dto.getGroup());
				} else {
					map.put("group", "Desconocido");
				}
				try{
					map.put("subtipoTarea", dto.getSubtipoTarea());
				}catch(Throwable e){
					map.put("subtipoTarea", "");
				}
				try{
					map.put("descripcionTarea", dto.getDescripcionTarea());
				}catch(Throwable e){
					map.put("descripcionTarea", "");
				}
				
				try{
					map.put("tipoRegistro", dto.getTipoRegistro());
				}catch(Throwable e){
					map.put("tipoRegistro", "");
				}

				lista.add(DynamicDtoUtils.create(HistoricoAsuntoInfo.class, map));

			} catch (Exception e) {
				BusinessOperationException ex = new BusinessOperationException("plugin.coreextension.error.historicoProcedimiento.getListByProcedimiento.completar");
				ex.initCause(e);
				throw ex;
			}

		}

	}

	@Override
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_ASU_MGR_GET)
	public Asunto get(Long id) {
		EventFactory.onMethodStart(this.getClass());
		return parent().get(id);
	}

	private Collection<? extends HistoricoAsuntoInfo> getHistoricoProcedimiento(Procedimiento p) {

		ArrayList<HistoricoAsuntoInfo> historico = new ArrayList<HistoricoAsuntoInfo>();

		for (HistoricoProcedimiento h : proxyFactory.proxy(HistoricoProcedimientoApi.class).getListByProcedimiento(p.getId())) {
			HistoricoAsuntoInfoImpl haf = new HistoricoAsuntoInfoImpl();
			haf.setProcedimiento(p);
			haf.setTarea(h);
			haf.setTipoActuacion(p.getTipoActuacion().getDescripcion());
			haf.setGroup("A");

			if (HistoricoProcedimiento.TIPO_ENTIDAD_TAREA.equals(h.getTipoEntidad()))
				haf.setTipoTraza(HistoricoProcedimientoApi.TIPO_TAREA_PROCEDIMIENTO);
			if (HistoricoProcedimiento.TIPO_ENTIDAD_PETICION_DECISION.equals(h.getTipoEntidad()) || HistoricoProcedimiento.TIPO_ENTIDAD_RESPUESTA_DECISION.equals(h.getTipoEntidad()))
				haf.setTipoTraza(HistoricoProcedimientoApi.TIPO_PROPUESTA_DECISION);
			historico.add(haf);

		}
		return historico;
	}

	private Collection<? extends HistoricoAsuntoInfo> getExtHistoricoProcedimiento(Procedimiento p) {

		ArrayList<HistoricoAsuntoInfo> historico = new ArrayList<HistoricoAsuntoInfo>();

		for (EXTHistoricoProcedimiento h : proxyFactory.proxy(EXTHistoricoProcedimientoApi.class).getListByProcedimientoEXT(p.getId())) {
			HistoricoAsuntoInfoImpl haf = new HistoricoAsuntoInfoImpl();
			haf.setProcedimiento(p);
			haf.setTarea(h);
			haf.setTipoActuacion(p.getTipoActuacion().getDescripcion());
			haf.setGroup("A");
			haf.setFechaVencReal(h.getFechaVencReal());
			haf.setSubtipoTarea(h.getSubtipoTarea());
			haf.setDescripcionTarea(h.getDescripcionTarea());

			if (HistoricoProcedimiento.TIPO_ENTIDAD_TAREA.equals(h.getTipoEntidad()))
				haf.setTipoTraza(HistoricoProcedimientoApi.TIPO_TAREA_PROCEDIMIENTO);
			if (HistoricoProcedimiento.TIPO_ENTIDAD_PETICION_DECISION.equals(h.getTipoEntidad()) || HistoricoProcedimiento.TIPO_ENTIDAD_RESPUESTA_DECISION.equals(h.getTipoEntidad()))
				haf.setTipoTraza(HistoricoProcedimientoApi.TIPO_PROPUESTA_DECISION);
			historico.add(haf);

		}
		return historico;
	}

	@SuppressWarnings("unchecked")
	private List<? extends HistoricoAsuntoInfo> ordenaLista(ArrayList<HistoricoAsuntoInfo> lista) {
		if (lista != null) {
			Collections.sort(lista, new HistoricoProcedimientoComparatorV4());
		}

		return lista;

	}

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(BO_ASU_UPDATE)
	public Asunto actualizaAsunto(EditAsuntoDtoInfo dto) {
		Asunto asunto = null;
		Map<String, Object> map = new HashMap<String, Object>();
		map.put(ModificacionAsuntoListener.CLAVE_NOMBRE_POSTERIOR, dto.getNombre());
		if (!Checks.esNulo(dto.getId())) {

			asunto = proxyFactory.proxy(AsuntoApi.class).get(dto.getId());
			map.put(ModificacionAsuntoListener.ID_ASUNTO, asunto.getId());

			map.put(ModificacionAsuntoListener.CLAVE_NOMBRE_ANTERIOR, asunto.getNombre());
			asunto.setNombre(dto.getNombre());
			proxyFactory.proxy(AsuntoApi.class).saveOrUpdateAsunto(asunto);

			if (listeners != null) {
				for (ModificacionAsuntoListener l : listeners) {
					l.fireEvent(map);
				}
			}
		}
		return asunto;

	}

	@Override
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_ASU_MGR_SAVE_OR_UDPATE)
	public void saveOrUpdateAsunto(Asunto asunto) {
		parent().saveOrUpdateAsunto(asunto);
	}

	@Override
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_ASU_MGR_OBTENER_ACTUACIONES_ASUNTO)
	public List<Procedimiento> obtenerActuacionesAsunto(Long idAsunto) {

		List<Procedimiento> todosProcedimientosDelAsunto = new ArrayList<Procedimiento>();

		List<Procedimiento> procedimientosOrigen = procedimientoDao.getProcedimientosOrigenOrdenados(idAsunto);

		for (Procedimiento p : procedimientosOrigen) {
			List<Procedimiento> listaHijosPorFecha = dameHijosProcedimiento(p);
			todosProcedimientosDelAsunto.addAll(listaHijosPorFecha);

		}
		return todosProcedimientosDelAsunto;

	}
	
	

	private List<Procedimiento> dameHijosProcedimiento(Procedimiento p) {
		List<Procedimiento> listaDevuelta = new ArrayList<Procedimiento>();
		if (!p.getAuditoria().isBorrado()) {
			listaDevuelta.add(p);
		}
		List<Procedimiento> listaHijosPorFecha = procedimientoDao.buscaHijosProcedimiento(p.getId());
		if (!Checks.esNulo(listaHijosPorFecha) && !Checks.estaVacio(listaHijosPorFecha)) {
			for (Procedimiento proc : listaHijosPorFecha) {
				List<Procedimiento> listaOtroNivel = dameHijosProcedimiento(proc);
				listaDevuelta.addAll(listaOtroNivel);
			}
		}
		return listaDevuelta;

	}

	@Override
	@BusinessOperation(BO_CORE_ASUNTO_ADJUNTOSMAPEADOS)
	public List<? extends EXTAdjuntoDto> getAdjuntosConBorrado(Long id) {
			return adjuntosApi.getAdjuntosConBorrado(id);
	}
	

	private List<? extends EXTAdjuntoDto> ordenaListado(List<EXTAdjuntoDto> adjuntosAsunto) {
		Comparator<EXTAdjuntoDto> comparador = new Comparator<EXTAdjuntoDto>() {
			@Override
			public int compare(EXTAdjuntoDto o1, EXTAdjuntoDto o2) {
				if (Checks.esNulo(o1) && Checks.esNulo(o2)) {
					return 0;
				} else if (Checks.esNulo(o1)) {
					return -1;
				} else if (Checks.esNulo(o2)) {
					return 1;
				} else {
					AdjuntoAsunto a1 = (AdjuntoAsunto) o1.getAdjunto();
					AdjuntoAsunto a2 = (AdjuntoAsunto) o2.getAdjunto();
					if (Checks.esNulo(a1) && Checks.esNulo(a2)) {
						return 0;
					} else if (Checks.esNulo(a1)) {
						return -1;
					} else if (Checks.esNulo(a2)) {
						return 1;
					} else {
						return a2.getAuditoria().getFechaCrear().compareTo(a1.getAuditoria().getFechaCrear());
					}
				}
			}
			
		};
		Collections.sort(adjuntosAsunto, comparador);

		return adjuntosAsunto;
	}

	private Set<EXTAdjuntoDto> creaObjetosEXTAsuntos(final Set<AdjuntoAsunto> adjuntos, final Usuario usuario, final Boolean borrarOtrosUsu) {
		if (adjuntos == null)
			return null;

		HashSet<EXTAdjuntoDto> result = new HashSet<EXTAdjuntoDto>();

		for (final AdjuntoAsunto aa : adjuntos) {
			EXTAdjuntoDto dto = new EXTAdjuntoDto() {
				@Override
				public Boolean getPuedeBorrar() {
					if (borrarOtrosUsu || aa.getAuditoria().getUsuarioCrear().equals(usuario.getUsername())) {
						return true;
					} else {
						return false;
					}
				}

				@Override
				public AdjuntoAsunto getAdjunto() {
					return (AdjuntoAsunto) aa;
				}

				@Override
				public String getTipoDocumento() {
					if (aa instanceof EXTAdjuntoAsunto) {
						if (((EXTAdjuntoAsunto) aa).getTipoFichero() != null)
							return ((EXTAdjuntoAsunto) aa).getTipoFichero().getDescripcion();
						else
							return "";
					} else
						return "";

				}

				@Override
				public Long prcId() {
					if (aa instanceof EXTAdjuntoAsunto) {
						if(((EXTAdjuntoAsunto) aa).getProcedimiento() != null)
							return ((EXTAdjuntoAsunto) aa).getProcedimiento().getId();
						else 
							return null;
					}
					else 
						return null;
				}

				@Override
				public String getRefCentera() {
					return null;
				}

				@Override
				public String getNombreTipoDoc() {
					return null;
				}
			};
			result.add(dto);
		}
		return result;
	}

	
	private boolean tieneFuncion(Usuario usuario, String codigo) {
		List<Perfil> perfiles = usuario.getPerfiles();
		for (Perfil per : perfiles) {
			for (Funcion fun : per.getFunciones()) {
				if (fun.getDescripcion().equals(codigo)) {
					return true;
				}
			}
		}

		return false;
	}

	@Override
	@BusinessOperation(BO_CORE_ASUNTO_ADJUNTOSCONTRATOS)
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratosAsu(Long id) {
		return adjuntosApi.getAdjuntosContratosAsu(id);
	}

	@Override
	@BusinessOperation(BO_CORE_ASUNTO_ADJUNTOSPERSONA)
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonaAsu(Long id) {
		return adjuntosApi.getAdjuntosPersonaAsu(id);
	}

	@Override
	@BusinessOperation(BO_CORE_ASUNTO_ADJUNTOSEXPEDIENTE)
	public List<ExtAdjuntoGenericoDto> getAdjuntosExpedienteAsu(Long id) {
		return adjuntosApi.getAdjuntosExpedienteAsu(id); 
	}

	@Override
	public List<Persona> obtenerPersonasDeUnAsunto(Long idAsunto) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	@BusinessOperation(EXT_MGR_ASUNTO_GET_GESTORES)
	public List<GestorDespacho> getGestoresAsunto(Long idAsunto) {
		List<EXTGestorAdicionalAsunto> gestoresAdicionales = getGestoresAdicionalesAsunto(idAsunto);
		ArrayList<GestorDespacho> gestores = new ArrayList<GestorDespacho>();
		if (!Checks.estaVacio(gestoresAdicionales)) {
			for (EXTGestorAdicionalAsunto gaa : gestoresAdicionales) {
				if (Checks.estaVacio(gaa.getTipoGestor().getSupervisados())) {
					gestores.add(gaa.getGestor());
				}
			}
		}
		return gestores;
	}

	@Override
	@BusinessOperation(EXT_MGR_ASUNTO_GET_SUPERVISORES)
	public List<GestorDespacho> getSupervisoresAsunto(Long idAsunto) {
		List<EXTGestorAdicionalAsunto> gestoresAdicionales = getGestoresAdicionalesAsunto(idAsunto);
		ArrayList<GestorDespacho> supervisores = new ArrayList<GestorDespacho>();
		if (!Checks.estaVacio(gestoresAdicionales)) {
			for (EXTGestorAdicionalAsunto gaa : gestoresAdicionales) {
				if (!Checks.estaVacio(gaa.getTipoGestor().getSupervisados())) {
					supervisores.add(gaa.getGestor());
				}
			}
		}
		return supervisores;
	}

	/**
	 * Indica si el Usuario Logado es el gestor del asunto.
	 * 
	 * @param idAsunto
	 *            el id del asunto
	 * @return true si es el gestor.
	 */
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_ASU_MGR_ES_GESTOR)
	@Override
	public Boolean esGestor(Long idAsunto) {
		try {
			Asunto asunto = get(idAsunto);
			Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			if (tieneValorGestorUnico(asunto)) {
				return asunto.getGestor().getUsuario().getId().equals(usuario.getId());
			} else {
				return averiguaSiEsGestor(asunto, usuario);
			}
		} catch (Exception e) {
			logger.fatal("No se ha podido averiguar si el usuario es gestor del asunto", e);
			throw new BusinessOperationException(e);
		}
	}

	/**
	 * Indica si el Usuario Logado es el supervisor del asunto.
	 * 
	 * @param idAsunto
	 *            el id del asunto
	 * @return true si es el Supervisor.
	 */
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_ASU_MGR_ES_SUPERVISOR)
	@Override
	public Boolean esSupervisor(Long idAsunto) {
		Asunto asunto = get(idAsunto);
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		if (tieneValorGestorUnico(asunto)) {
			return asunto.getSupervisor().getUsuario().getId().equals(usuario.getId());
		} else {
			return buscaUsuario(usuario, proxyFactory.proxy(EXTAsuntoApi.class).getSupervisoresAsunto(asunto.getId()));
		}
	}

	/**
	 * Busca asuntos paginados.
	 * 
	 * @param dto
	 *            los par�metros para la Búsqueda.
	 * @return Asuntos paginados
	 */
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_ASU_MGR_FIND_ASUNTOS_PAGINATED)
	public Page findAsuntosPaginated(DtoBusquedaAsunto dto) {
		dto.setCodigoZonas(getCodigosDeZona(dto));
		dto.setTiposProcedimiento(getTiposProcedimiento(dto));
		
		if (dto instanceof EXTDtoBusquedaAsunto) {
			return asuntoDao.buscarAsuntosPaginated(proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado(), (EXTDtoBusquedaAsunto) dto);
		} else {
			return parent().findAsuntosPaginated(dto);
		}
	}

	/**
	 * Nos dice si el modelo multi-gestor est� activo o no
	 * 
	 * @return
	 */
	@BusinessOperation(EXT_MGR_ASUNTO_MODELO_MULTI_GESTOR)
	@Override
	public boolean modeloMultiGestor() {

		if (this.modeloMultiGestor == null) {
			// workaround, por defecto siempre es multigestor.
			//List<EXTGestorAdicionalAsunto> gestoreAdicionales = genericdDao.getList(EXTGestorAdicionalAsunto.class);
			this.modeloMultiGestor = true;//!Checks.estaVacio(gestoreAdicionales);
		}
		return modeloMultiGestor;
	}

	@BusinessOperation(EXT_MGR_ASUNTO_GET_GESTORES_ADICIONALES_ASUNTO)
	@Override
	public List<EXTGestorAdicionalAsunto> getGestoresAdicionalesAsunto(Long idAsunto) {
		Filter filtroAsunto = genericdDao.createFilter(FilterType.EQUALS, "asunto.id", idAsunto);
		return genericdDao.getList(EXTGestorAdicionalAsunto.class, filtroAsunto);
	}

	private boolean buscaUsuario(Usuario usuario, List<GestorDespacho> lista) {
		if (usuario == null) {
			return false;
		}
		if (!Checks.estaVacio(lista)) {
			List<Long> listaGruposUsuario= proxyFactory.proxy(EXTGrupoUsuariosApi.class).buscaIdsGrupos(usuario);
			for (GestorDespacho gd : lista) {
				if ((usuario.getId().equals(gd.getUsuario().getId()))) {
					return true;
				} else {
					if (!Checks.esNulo(listaGruposUsuario) && !Checks.estaVacio(listaGruposUsuario)){
						if (listaGruposUsuario.contains(gd.getUsuario().getId())){
							return true;
						}
					}
				}
			}
		}
		return false;
	}

	private Set<String> getCodigosDeZona(DtoBusquedaAsunto dtoBusquedaAsuntos) {
		Set<String> zonas;
		if (dtoBusquedaAsuntos.getCodigoZona() != null && dtoBusquedaAsuntos.getCodigoZona().trim().length() > 0) {
			List<String> list = Arrays.asList((dtoBusquedaAsuntos.getCodigoZona().split(",")));
			zonas = new HashSet<String>(list);
		} else {
			// Usuario usuario = (Usuario) executor
			// .execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
			// zonas = usuario.getCodigoZonas();
			zonas = new HashSet<String>();
		}
		return zonas;
	}

	private Set<String> getTiposProcedimiento(DtoBusquedaAsunto dtoBusquedaAsuntos) {
		Set<String> tiposProcedimiento = null;
		if (dtoBusquedaAsuntos.getTipoProcedimiento() != null && dtoBusquedaAsuntos.getTipoProcedimiento().trim().length() > 0) {
			tiposProcedimiento = new HashSet<String>(Arrays.asList((dtoBusquedaAsuntos.getTipoProcedimiento().split(","))));
		}
		return tiposProcedimiento;
	}
	
	private boolean tieneValorGestorUnico(Asunto asunto) {
		if (asunto == null) {
			return false;
		}

		try {
			Field f = Asunto.class.getDeclaredField("gestor");
			f.setAccessible(true);
			Object o = f.get(asunto);
			f.setAccessible(false);
			return o != null;
		} catch (Exception e) {
			logger.fatal("Fallo al obtener el gestor por reflection", e);
			throw new BusinessOperationException("No se ha podido obtener el gesor del Asunto");
		}
	}

	@Override
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_ASU_MGR_CAMBIAR_GESTOR_ASUNTO)
	@Transactional(readOnly = false)
	public void cambiarGestorAsunto(DtoAsunto dtoAsunto) {
		cambiarGestorAsuntoGenerico(dtoAsunto, EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO);
		if (modeloMultiGestor())
			cambiarProcurador(dtoAsunto);
	}

	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(overrides = "asuntosManager.cambiarSupervisor")
	public void cambiarSupervisor(DtoAsunto dto, boolean temporal) {
		cambiarSupervisorGenerico(dto, temporal, EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR);
	}

	private void borrarFavoritosAsunto(Asunto asunto) {
		long idGestor = asunto.getGestor().getUsuario().getId().longValue();
		executor.execute(ComunBusinessOperation.BO_FAVORITOS_MGR_ELIMINAR_FAVORITOS_POR_ENTIDAD, idGestor, asunto.getId(), DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO);
		for (Procedimiento prc : asunto.getProcedimientos()) {

			executor.execute(ComunBusinessOperation.BO_FAVORITOS_MGR_ELIMINAR_FAVORITOS_POR_ENTIDAD, idGestor, prc.getId(), DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO);
		}
	}

	@Override
	public void aceptarAsunto(Long arg0, boolean arg1) {
		// TODO Auto-generated method stub

	}

	@Transactional(readOnly = false)
	public void cambiarGestorCEXPAsunto(DtoAsunto dtoAsunto) {
		cambiarGestorAsuntoGenerico(dtoAsunto, EXTDDTipoGestor.CODIGO_TIPO_GESTOR_CONF_EXP);
		cambiarProcurador(dtoAsunto);
	}

	@Transactional(readOnly = false)
	public void cambiarSupervisorCEXP(DtoAsunto dto, boolean temporal) {
		cambiarSupervisorGenerico(dto, temporal, EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR_CONF_EXP);
	}

	@BusinessOperation(overrides = ExternaBusinessOperation.BO_ASU_MGR_CREAR_ASUNTO_DTO)
	@Override
	@Transactional(readOnly = false)
	public Long crearAsunto(DtoAsunto dtoAsunto) {
		return crearOmodificarAsunto(dtoAsunto);
	}

	/**
	 * Modifica un Asunto.
	 * 
	 * @param dtoAsunto
	 *            el dto con los datos nuevos
	 * @return el id;
	 */
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_ASU_MGR_MODIFICAR_ASUNTO)
	@Override
	@Transactional(readOnly = false)
	public Long modificarAsunto(DtoAsunto dtoAsunto) {
		return crearOmodificarAsunto(dtoAsunto);
	}

	@Transactional(readOnly = false)
	// private Long crearOmodificarAsunto(GestorDespacho gd, GestorDespacho sup,
	// GestorDespacho procurador, String nombreAsunto, Expediente exp,
	// String observaciones, GestorDespacho gdCEXP, GestorDespacho supCEXP) {
	private Long crearOmodificarAsunto(DtoAsunto dtoAsunto) {
		Long id;
		Expediente exp;
		GestorDespacho gd = null;
		GestorDespacho sup = null;

		// if (asuntoDao.isNombreAsuntoDuplicado(nombreAsunto, null)) throw new
		// GenericRollbackException("altaAsunto.error.nombreDuplicado");
		if (asuntoDao.isNombreAsuntoDuplicado(dtoAsunto.getNombreAsunto(), dtoAsunto.getIdAsunto()))
			throw new GenericRollbackException("altaAsunto.error.nombreDuplicado");

		if (dtoAsunto.getIdGestor() != null) {
			Filter f1 = genericdDao.createFilter(FilterType.EQUALS, "id", dtoAsunto.getIdGestor());
			gd = genericdDao.get(GestorDespacho.class, f1);
		}

		if (dtoAsunto.getIdSupervisor() != null) {
			Filter f2 = genericdDao.createFilter(FilterType.EQUALS, "id", dtoAsunto.getIdSupervisor());
			sup = genericdDao.get(GestorDespacho.class, f2);
		}

		GestorDespacho procurador = null;

		if (dtoAsunto.getIdProcurador() != null) {
			Filter f3 = genericdDao.createFilter(FilterType.EQUALS, "id", dtoAsunto.getIdProcurador());
			procurador = genericdDao.get(GestorDespacho.class, f3);
		}

//		GestorDespacho gdCEXP = null;
//		GestorDespacho supCEXP = null;
		if (dtoAsunto instanceof EXTDtoAsunto) {
			dtoAsunto = (EXTDtoAsunto) dtoAsunto;

//			if (((EXTDtoAsunto) dtoAsunto).getIdGestorConfeccionExpediente() != null) {
//				Filter f4 = genericdDao.createFilter(FilterType.EQUALS, "id", ((EXTDtoAsunto) dtoAsunto).getIdGestorConfeccionExpediente());
//				gdCEXP = genericdDao.get(GestorDespacho.class, f4);
//			}
//
//			if (((EXTDtoAsunto) dtoAsunto).getIdSupervisorConfeccionExpediente() != null) {
//				Filter f5 = genericdDao.createFilter(FilterType.EQUALS, "id", ((EXTDtoAsunto) dtoAsunto).getIdSupervisorConfeccionExpediente());
//				supCEXP = genericdDao.get(GestorDespacho.class, f5);
//			}

		}

		if (modeloMultiGestor()) {
			// gestoresAsunto = getListGestoresAsuntos(gd, sup,procurador,
			// gdCEXP, supCEXP);

			gd = null;
			sup = null;
			procurador = null;
		}

		if (Checks.esNulo(dtoAsunto.getIdAsunto())) // CREAR EXTASUNTO
		{
			exp = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, dtoAsunto.getIdExpediente());
			
			DDTiposAsunto tipoDeAsunto = null;
			
			if(!Checks.esNulo(dtoAsunto.getTipoDeAsunto())){
				tipoDeAsunto = genericdDao.get(DDTiposAsunto.class, genericdDao.createFilter(FilterType.EQUALS, "id", dtoAsunto.getTipoDeAsunto()));
			}
			
			id = asuntoDao.crearAsuntoConEstado(gd, sup, procurador, dtoAsunto.getNombreAsunto(), exp, dtoAsunto.getObservaciones(),dtoAsunto.getCodigoEstadoAsunto(),tipoDeAsunto);
			dtoAsunto.setIdAsunto(id);
		} else // MODIFICAR EXTASUNTO
		{
			id = asuntoDao.modificarAsunto(dtoAsunto.getIdAsunto(), gd, sup, procurador, dtoAsunto.getNombreAsunto(), dtoAsunto.getObservaciones());
		}

		if (modeloMultiGestor()) {
			if ( (dtoAsunto instanceof EXTDtoAsunto) &&
					(((EXTDtoAsunto)dtoAsunto).getListaMapGestoresId().size()>0)	) {
				actualizarGestoresAdicionales((EXTDtoAsunto)dtoAsunto);
			} else {
				cambiarGestorAsuntoGenerico(dtoAsunto, EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO);
				cambiarGestorAsuntoGenerico(dtoAsunto, EXTDDTipoGestor.CODIGO_TIPO_GESTOR_CONF_EXP);
				cambiarSupervisorGenerico(dtoAsunto, false, EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR);
				cambiarSupervisorGenerico(dtoAsunto, false, EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR_CONF_EXP);
				cambiarProcuradorMultiGEstor(dtoAsunto);
			}
		}

		logger.debug("CREADO ASUNTO CON ID " + id);
		return id;
	}
	
	@Transactional(readOnly = false)
	private void actualizarGestoresAdicionales(EXTDtoAsunto dtoAsunto) {
		//Primero hay que borrar todos los gestores del asunto y luego los volvemos a insertar los que se han enviado
		List<EXTGestorAdicionalAsunto> gaaActuales = gestorAdicionalAsuntoDao.findGestorAdicionalesByAsunto(dtoAsunto.getIdAsunto());
		for (EXTGestorAdicionalAsunto gaa : gaaActuales) {
			gestorAdicionalAsuntoDao.delete(gaa);	
		}
		
		Asunto asu = proxyFactory.proxy(AsuntoApi.class).get(dtoAsunto.getIdAsunto());
		
		//Ahora insertamos los enviados
		for (Map<String,Long> gestorAdicional : dtoAsunto.getListaMapGestoresId()) {
			EXTGestorAdicionalAsunto gaa = new EXTGestorAdicionalAsunto();
			gaa.setAsunto(asu);
			
			EXTDDTipoGestor tipoGestor = genericdDao.get(EXTDDTipoGestor.class, genericdDao.createFilter(FilterType.EQUALS, "id", gestorAdicional.get("tipoGestor")));
			gaa.setTipoGestor(tipoGestor);
			
			GestorDespacho gestor = genericdDao.get(GestorDespacho.class, genericdDao.createFilter(FilterType.EQUALS, "usuario.id", gestorAdicional.get("usuarioId"))
																		, genericdDao.createFilter(FilterType.EQUALS, "despachoExterno.id", gestorAdicional.get("tipoDespacho")));
			gaa.setGestor(gestor);
			gestorAdicionalAsuntoDao.save(gaa);
		}
		
		
		
	}

	@Transactional(readOnly = false)
	private void cambiarProcuradorMultiGEstor(DtoAsunto dtoAsunto) {
		Asunto asu = proxyFactory.proxy(AsuntoApi.class).get(dtoAsunto.getIdAsunto());
		if (asu instanceof EXTAsunto) {
			Long idGestor = dtoAsunto.getIdProcurador();
			if (!Checks.esNulo(idGestor)) {
				GestorDespacho gestor = genericdDao.get(GestorDespacho.class, genericdDao.createFilter(FilterType.EQUALS, "id", idGestor));
				EXTDDTipoGestor tipoGestor = genericdDao.get(EXTDDTipoGestor.class, genericdDao.createFilter(FilterType.EQUALS, "codigo", EXTDDTipoGestor.CODIGO_TIPO_GESTOR_PROCURADOR));
				Filter filtroAsunto = genericdDao.createFilter(FilterType.EQUALS, "asunto.id", dtoAsunto.getIdAsunto());
				Filter filtroTipoGestor = genericdDao.createFilter(FilterType.EQUALS, "tipoGestor.id", tipoGestor.getId());
				EXTGestorAdicionalAsunto gaa = genericdDao.get(EXTGestorAdicionalAsunto.class, filtroAsunto, filtroTipoGestor);
				if (Checks.esNulo(gaa)) {
					gaa = new EXTGestorAdicionalAsunto();
					gaa.setAsunto(asu);
					gaa.setTipoGestor(tipoGestor);
					gaa.setGestor(gestor);
					genericdDao.save(EXTGestorAdicionalAsunto.class, gaa);
				}else{
					gaa.setGestor(gestor);
					gestorAdicionalAsuntoDao.saveOrUpdate(gaa);
				}
			}
		}
	}

	@Transactional(readOnly = false)
	private void cambiarProcurador(DtoAsunto dtoAsunto) {
		Asunto asu = proxyFactory.proxy(AsuntoApi.class).get(dtoAsunto.getIdAsunto());
		GestorDespacho procuradorAnterior = asu.getProcurador();
		// verifico si se cambio el procurador
		if (dtoAsunto.getIdProcurador() != null) {
			// Valido que el procurador sea uno distinto
			if (procuradorAnterior != null && (procuradorAnterior.getId().equals(dtoAsunto.getIdProcurador()))) {
				if (dtoAsunto.getIdGestor().equals(asu.getGestor().getId()))
					throw new BusinessOperationException("asuntos.procuradordistinto");
			} else {
				GestorDespacho nuevoProcurador = genericdDao.get(GestorDespacho.class, genericdDao.createFilter(FilterType.EQUALS, "id", dtoAsunto.getIdProcurador()));
				asu.setProcurador(nuevoProcurador);
			}
		}
	}

	@Transactional(readOnly = false)
	private void cambiarGestorAsuntoGenerico(DtoAsunto dtoAsunto, String strEXTDDTipoGestor) {
		Asunto asu = proxyFactory.proxy(AsuntoApi.class).get(dtoAsunto.getIdAsunto());
		if (!(asu instanceof EXTAsunto)) {
			parent().cambiarGestorAsunto(dtoAsunto);
		} else {
			Long idGestor = null;
			if (strEXTDDTipoGestor.equals(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO)) {
				idGestor = dtoAsunto.getIdGestor();
			} else if (strEXTDDTipoGestor.equals(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_CONF_EXP)) {
				if (dtoAsunto instanceof EXTDtoAsunto)
					idGestor = ((EXTDtoAsunto) dtoAsunto).getIdGestorConfeccionExpediente();
			}
			// if(!Checks.esNulo(dtoAsunto.getIdGestor())){
			if (!Checks.esNulo(idGestor)) {
				GestorDespacho gestor = genericdDao.get(GestorDespacho.class, genericdDao.createFilter(FilterType.EQUALS, "id", idGestor));
				EXTDDTipoGestor tipoGestor = genericdDao.get(EXTDDTipoGestor.class, genericdDao.createFilter(FilterType.EQUALS, "codigo", strEXTDDTipoGestor));
				Filter filtroAsunto = genericdDao.createFilter(FilterType.EQUALS, "asunto.id", dtoAsunto.getIdAsunto());
				Filter filtroTipoGestor = genericdDao.createFilter(FilterType.EQUALS, "tipoGestor.id", tipoGestor.getId());
				EXTGestorAdicionalAsunto gaa = genericdDao.get(EXTGestorAdicionalAsunto.class, filtroAsunto, filtroTipoGestor);
				if (Checks.esNulo(gaa)) {
					gaa = new EXTGestorAdicionalAsunto();
					gaa.setAsunto(asu);
					gaa.setTipoGestor(tipoGestor);
					gaa.setGestor(gestor);
					genericdDao.save(EXTGestorAdicionalAsunto.class, gaa);
				} else {
					if (!gaa.getGestor().getId().equals(dtoAsunto.getIdGestor())) {
						borrarFavoritosAsunto(asu);
					}
					gaa.setGestor(gestor);
					gestorAdicionalAsuntoDao.saveOrUpdate(gaa);

				}
			}

			/*
			 * GestorDespacho procuradorAnterior = asu.getProcurador();
			 * //verifico si se cambio el procurador if
			 * (dtoAsunto.getIdProcurador() != null) { //Valido que el
			 * procurador sea uno distinto if (procuradorAnterior != null &&
			 * (procuradorAnterior.getId().equals(dtoAsunto.getIdProcurador())))
			 * { if (dtoAsunto.getIdGestor().equals(asu.getGestor().getId()))
			 * throw new
			 * BusinessOperationException("asuntos.procuradordistinto"); } else
			 * { GestorDespacho nuevoProcurador =
			 * genericdDao.get(GestorDespacho.class,
			 * genericdDao.createFilter(FilterType.EQUALS, "id",
			 * dtoAsunto.getIdProcurador()));
			 * asu.setProcurador(nuevoProcurador); }
			 * 
			 * }
			 */
		}
	}

	@Transactional(readOnly = false)
	private void cambiarSupervisorGenerico(DtoAsunto dto, boolean temporal, String strEXTDDTipoGestor) {
		Asunto asu = proxyFactory.proxy(AsuntoApi.class).get(dto.getIdAsunto());
		if (!(asu instanceof EXTAsunto)) {
			parent().cambiarSupervisor(dto, temporal);
		} else {
			Long idSupervisor = null;
			if (strEXTDDTipoGestor.equals(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR)) {
				idSupervisor = dto.getIdSupervisor();
			} else if (strEXTDDTipoGestor.equals(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR_CONF_EXP)) {
				if (dto instanceof EXTDtoAsunto)
					idSupervisor = ((EXTDtoAsunto) dto).getIdSupervisorConfeccionExpediente();
			}

			// if(!Checks.esNulo(dto.getIdSupervisor())){
			if (!Checks.esNulo(idSupervisor)) {
				// GestorDespacho supervisor =
				// genericdDao.get(GestorDespacho.class,
				// genericdDao.createFilter(FilterType.EQUALS, "id",
				// dto.getIdSupervisor()));
				GestorDespacho supervisor = genericdDao.get(GestorDespacho.class, genericdDao.createFilter(FilterType.EQUALS, "id", idSupervisor));
				EXTDDTipoGestor tipoGestor = genericdDao.get(EXTDDTipoGestor.class, genericdDao.createFilter(FilterType.EQUALS, "codigo", strEXTDDTipoGestor));
				Filter filtroAsunto = genericdDao.createFilter(FilterType.EQUALS, "asunto.id", dto.getIdAsunto());
				Filter filtroTipoGestor = genericdDao.createFilter(FilterType.EQUALS, "tipoGestor.id", tipoGestor.getId());
				EXTGestorAdicionalAsunto gaa = genericdDao.get(EXTGestorAdicionalAsunto.class, filtroAsunto, filtroTipoGestor);
				if (Checks.esNulo(gaa)) {
					gaa = new EXTGestorAdicionalAsunto();
					gaa.setAsunto(asu);
					gaa.setTipoGestor(tipoGestor);
					gaa.setGestor(supervisor);
					genericdDao.save(EXTGestorAdicionalAsunto.class, gaa);
				} else {
					HistoricoCambiosAsunto his = new HistoricoCambiosAsunto();
					his.setSupervisorOrigen(gaa.getGestor());
					his.setSupervisorDestino(supervisor);
					his.setAuditoria(Auditoria.getNewInstance());
					his.setTemporal(temporal);
					asu.addHistorico(his);
					asuntoDao.saveOrUpdate(asu);
					gaa.setGestor(supervisor);
					gestorAdicionalAsuntoDao.saveOrUpdate(gaa);

				}
			}
		}
	}

	/*
	 * private EXTGestorAdicionalAsunto
	 * getExtGestorAdicionalAsunto(GestorDespacho gestorGenerico, String
	 * extTipoGestorStr) { EXTGestorAdicionalAsunto extGestorAdicional = new
	 * EXTGestorAdicionalAsunto(); EXTDDTipoGestor extTipoGestor = null;
	 * 
	 * extGestorAdicional.setGestor(gestorGenerico);
	 * 
	 * Filter f1 = genericdDao.createFilter(FilterType.EQUALS, "codigo",
	 * extTipoGestorStr);
	 * extGestorAdicional.setTipoGestor(genericdDao.get(EXTDDTipoGestor.class,
	 * f1));
	 * 
	 * return extGestorAdicional; }
	 * 
	 * 
	 * private List<EXTGestorAdicionalAsunto>
	 * getListGestoresAsuntos(GestorDespacho gd, GestorDespacho sup,
	 * GestorDespacho procurador, GestorDespacho gdCEXP, GestorDespacho supCEXP)
	 * { List<EXTGestorAdicionalAsunto> gestoresAsunto = new
	 * ArrayList<EXTGestorAdicionalAsunto>(0); EXTGestorAdicionalAsunto
	 * extGestorAdicional = null;
	 * 
	 * if(gd != null) { extGestorAdicional = getExtGestorAdicionalAsunto(gd,
	 * EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO);
	 * gestoresAsunto.add(extGestorAdicional); } if(sup != null) {
	 * extGestorAdicional = getExtGestorAdicionalAsunto(sup,
	 * EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR);
	 * gestoresAsunto.add(extGestorAdicional); } if(procurador != null) {
	 * extGestorAdicional = getExtGestorAdicionalAsunto(procurador,
	 * EXTDDTipoGestor.CODIGO_TIPO_GESTOR_PROCURADOR);
	 * gestoresAsunto.add(extGestorAdicional); } if(gdCEXP != null) {
	 * extGestorAdicional = getExtGestorAdicionalAsunto(gdCEXP,
	 * EXTDDTipoGestor.CODIGO_TIPO_GESTOR_CONF_EXP);
	 * gestoresAsunto.add(extGestorAdicional); } if(supCEXP != null) {
	 * extGestorAdicional = getExtGestorAdicionalAsunto(supCEXP,
	 * EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR_CONF_EXP);
	 * gestoresAsunto.add(extGestorAdicional); }
	 * 
	 * return gestoresAsunto; }
	 */
	
	@BusinessOperation(EXT_MGR_ASUNTO_GET_TIPOS_GESTOR_USU_LOGADO)
	@Override
	public List<EXTDDTipoGestor> getListTiposGestorAsuntoUsuarioLogado(Long idAsunto) {
		List<EXTDDTipoGestor> listTiposGestorAsuntoUsuarioLogado = new ArrayList<EXTDDTipoGestor>(0);

		Usuario user = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		List<EXTGestorAdicionalAsunto> lista = new ArrayList<EXTGestorAdicionalAsunto>(0);
		Asunto asu = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
		if (asu instanceof EXTAsunto) {
			lista = ((EXTAsunto) asu).getGestoresAsunto();
		}

		for (EXTGestorAdicionalAsunto gaa : lista) {
			if (gaa.getGestor().getUsuario().getId().equals(user.getId())) {
				listTiposGestorAsuntoUsuarioLogado.add(gaa.getTipoGestor());
			}
		}

		return listTiposGestorAsuntoUsuarioLogado;
	}

	/**
	 * Indica si el usuario puede tomar una acci�n sobre el asunto o si debe
	 * completar la ficha antes.
	 * 
	 * @param idAsunto
	 *            el id del asunto
	 * @return true o false.
	 */
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_ASU_MGR_PUEDE_TOMAR_ACCION_ASUNTO)
	public Boolean puedeTomarAccionAsunto(Long idAsunto) {
		Asunto asunto = asuntoDao.get(idAsunto);
		if (asunto.getFichaAceptacion() == null) {
			return true;
		}

		if (asunto.getFichaAceptacion().getObservaciones() == null || asunto.getFichaAceptacion().getObservaciones().size() == 0) {
			// Es la primera vez. Todav�a nadie grab� nada.
			return true;
		}
		Usuario usuUltimaEdicion = asunto.getFichaAceptacion().getObservaciones().get(0).getUsuario();
		Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		if (usuUltimaEdicion.getId().longValue() == usuarioLogado.getId().longValue()) {
			// El �ltimo que hizo una modificaci�n a la ficha fue este
			// usuario, así que puede tomar acci�n
			return true;
		}
		return false;

	}

	@Override
	@BusinessOperation(EXT_MGR_ASUNTO_GET_USUARIOS_RELACIONADOS)
	public Set<EXTUsuarioRelacionadoInfo> getUsuariosRelacionados(Long idAsunto) {
		HashSet<EXTUsuarioRelacionadoInfo> usuarios = new HashSet<EXTUsuarioRelacionadoInfo>();
		Asunto asu = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);

		if (asu.getGestor() != null) {
			usuarios.add(new EXTUsuarioRelacionadoAsunto(asu.getGestor(), getTipoGestor(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO)));
		}
		if (asu.getSupervisor() != null) {
			usuarios.add(new EXTUsuarioRelacionadoAsunto(asu.getSupervisor(), getTipoGestor(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR)));
		}

		if (asu.getSupervisorComite() != null) {
			usuarios.add(new EXTUsuarioRelacionadoAsunto(asu.getSupervisorComite(), getTipoGestor(EXTDDTipoGestor.DESCONOCIDO)));
		}

		if (asu.getProcurador() != null) {
			usuarios.add(new EXTUsuarioRelacionadoAsunto(asu.getProcurador(), getTipoGestor(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_PROCURADOR)));
		}

		if (asu.getSupervisorOriginal() != null) {
			usuarios.add(new EXTUsuarioRelacionadoAsunto(asu.getSupervisorOriginal(), getTipoGestor(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR)));
		}

		usuarios.addAll(convierteUsuariosRelacionadosAsuntoGAA(this.getGestoresAdicionalesAsunto(idAsunto)));

		usuarios.addAll(convierteUsuariosRelacionadosAsuntoMulti(this.getMultiGestoresMultiEntidad(asu)));

		return usuarios;
	}

	public List<HistoricoAsuntoBuilder> getBuilders() {
		return builders;
	}

	public void setBuilders(List<HistoricoAsuntoBuilder> builders) {
		this.builders = builders;
	}

	private boolean averiguaSiEsGestor(Asunto asunto, Usuario usuario) {
		boolean gestor = false;

		// Buscamos entre los Multi Gestores Multi Entidad
		gestor = buscaMultiGestorMultiEntidad(usuario, asunto);

		// Buscamos entre los gestores adicionales del asunto
		if (!gestor) {
			gestor = buscaUsuario(usuario, proxyFactory.proxy(EXTAsuntoApi.class).getGestoresAsunto(asunto.getId()));
		}

		return gestor;
	}

	private boolean buscaMultiGestorMultiEntidad(Usuario usuario, Asunto asunto) {
		if (Checks.esNulo(usuario) || Checks.esNulo(asunto)) {
			return false;
		}
		List<EXTGestorInfo> gestores = getMultiGestoresMultiEntidad(asunto);

		if (!Checks.estaVacio(gestores)) {
			for (EXTGestorInfo gestor : gestores) {
				List<Long> listaGruposUsuario = proxyFactory.proxy(EXTGrupoUsuariosApi.class).buscaIdsGrupos(usuario);
				if (usuario.getId().equals(gestor.getUsuario().getId())) {
					// FIXME Hay que hacer esto bas�ndonos en propiedades del
					// tipo de gestor
					if (gestor.getTipoGestor().getCodigo().equals(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO)) {
						return true;
					}
				} else {
					if (!Checks.esNulo(listaGruposUsuario) && !Checks.estaVacio(listaGruposUsuario)){
						if (listaGruposUsuario.contains(gestor.getUsuario().getId())){
							if (gestor.getTipoGestor().getCodigo().equals(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO)) {
								return true;
							}
						}
					}
				}
			}
		}
		return false;
	}
	
	private boolean buscaMultiGestorMultiEntidad(Usuario usuario, Asunto asunto, List<String> listaCodigoGestores) {
		
		//Si algún argumento es nulo, devolvemos false
		if (Checks.esNulo(usuario) || Checks.esNulo(asunto) || Checks.esNulo(listaCodigoGestores)) {
			return false;
		}
		
		// Si la lista de gestores está vacía, añadimos el Gestor Externo
		if(listaCodigoGestores.isEmpty()){
			listaCodigoGestores.add(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_EXTERNO);
		}
		
		//Obtenemos los gestores del asunto
		//List<EXTGestorInfo> gestores = getMultiGestoresMultiEntidad(asunto);
		List<EXTGestorAdicionalAsunto> gestores = getGestoresAdicionalesAsunto(asunto.getId());
		
		if (!Checks.estaVacio(gestores)) {
			for (EXTGestorAdicionalAsunto gestor : gestores) {
				List<Long> listaGruposUsuario = proxyFactory.proxy(EXTGrupoUsuariosApi.class).buscaIdsGrupos(usuario);
				
				//Miramos si el usuario es el gestor del asunto
				if (usuario.getId().equals(gestor.getGestor().getUsuario().getId())) {
					// FIXME Hay que hacer esto bas�ndonos en propiedades del
					// tipo de gestor
						//Comprobamos si es de los tipos permitidos
						if (listaCodigoGestores.contains(gestor.getTipoGestor().getCodigo())) {
							return true;
						}
				//Miramos si el usuario pertenece a algún grupo que sea gestor del asunto
				} else {
					if (!Checks.esNulo(listaGruposUsuario) && !Checks.estaVacio(listaGruposUsuario)){
						if (listaGruposUsuario.contains(gestor.getGestor().getUsuario().getId())){
							//Comprobamos si es de los tipos permitidos
							if (listaCodigoGestores.contains(gestor.getTipoGestor().getCodigo())) {
								return true;
							}
						}
					}
				}
			}
		}
		return false;
	}

	private List<EXTGestorInfo> getMultiGestoresMultiEntidad(Asunto asunto) {
		List<EXTGestorInfo> gestores = proxyFactory.proxy(EXTMultigestorApi.class).dameGestores(EXTMultigestorApi.COD_UG_ASUNTO, asunto.getId());
		return gestores;
	}

	private EXTDDTipoGestor getTipoGestor(String codigo) {
		if (Checks.esNulo(codigo)) {
			return null;
		} else {
			return genericdDao.get(EXTDDTipoGestor.class, genericdDao.createFilter(FilterType.EQUALS, "codigo", codigo));
		}
	}

	private Collection<? extends EXTUsuarioRelacionadoInfo> convierteUsuariosRelacionadosAsuntoGAA(List<EXTGestorAdicionalAsunto> list) {
		ArrayList<EXTUsuarioRelacionadoInfo> usuarios = new ArrayList<EXTUsuarioRelacionadoInfo>();

		if (!Checks.estaVacio(list)) {
			for (EXTGestorAdicionalAsunto ga : list) {
				usuarios.add(new EXTUsuarioRelacionadoAsunto(ga.getGestor(), ga.getTipoGestor()));
			}
		}
		return usuarios;
	}

	private Collection<? extends EXTUsuarioRelacionadoInfo> convierteUsuariosRelacionadosAsuntoMulti(List<EXTGestorInfo> multiGestores) {
		ArrayList<EXTUsuarioRelacionadoInfo> usuarios = new ArrayList<EXTUsuarioRelacionadoInfo>();

		if (!Checks.estaVacio(multiGestores)) {
			for (EXTGestorInfo gi : multiGestores) {
				usuarios.add(new EXTUsuarioRelacionadoAsunto(gi));
			}
		}
		return usuarios;
	}

	@Override
	@BusinessOperation(EXTAsuntoApi.EXT_BO_ASU_MGR_FIND_ASUNTOS_PAGINATED_DINAMICO)
	public Page findAsuntosPaginatedDinamico(EXTDtoBusquedaAsunto dto, String params) {
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		
		dto.setCodigoZonas(getCodigosDeZona(dto));
		dto.setTiposProcedimiento(getTiposProcedimiento(dto));
		if (usuarioLogado.getUsuarioExterno()) {
			List<Long> idGrpsUsuario = extGrupoUsuariosDao.buscaGruposUsuario(usuarioLogado);
			dto.setIdsUsuariosGrupos(idGrpsUsuario);
		}
		
		return asuntoDao.buscarAsuntosPaginatedDinamico(usuarioLogado, dto, params);
	}
	
    /**
     * upload.
     * @param uploadForm upload
     * @return String
     */
	@BusinessOperation(overrides = ExternaBusinessOperation.BO_ASU_MGR_UPLOAD)
    @Transactional(readOnly = false)
    public String upload(WebFileItem uploadForm) {
		String comboTipoFichero = uploadForm.getParameter("comboTipoFichero");
		
		FileItem fileItem = uploadForm.getFileItem();

        //En caso de que el fichero est� vacio, no subimos nada
        if (fileItem == null || fileItem.getLength() <= 0) { return null; }
        
        logger.info(fileItem.getFileName() + ": " + fileItem.getContentType());
        
        Integer max = getLimiteFichero();

        if (fileItem.getLength() > max) {
            AbstractMessageSource ms = MessageUtils.getMessageSource();
            return ms.getMessage("fichero.limite.tamanyo", new Object[] { (int) ((float) max / 1024f) }, MessageUtils.DEFAULT_LOCALE);
        }

        Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(Long.parseLong(uploadForm.getParameter("id")));
        
        EXTAdjuntoAsunto adjuntoAsunto = new EXTAdjuntoAsunto(fileItem);
        
        if (comboTipoFichero != null) {
			DDTipoFicheroAdjunto tipoFicheroAdjunto = genericdDao.get(DDTipoFicheroAdjunto.class, genericdDao.createFilter(FilterType.EQUALS, "codigo", comboTipoFichero));
			adjuntoAsunto.setTipoFichero(tipoFicheroAdjunto);
		}
		
        adjuntoAsunto.setAsunto(asunto);
		
		//En caso de que estemos añadiendo un adjunto desde el propio procedimiento
        if (!Checks.esNulo(uploadForm.getParameter("prcId"))) {
			Procedimiento procedimiento = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(Long.parseLong(uploadForm.getParameter("prcId")));
	        if(!Checks.esNulo(procedimiento)){
				adjuntoAsunto.setProcedimiento(procedimiento);
			}
        }
        
        Auditoria.save(adjuntoAsunto);
		asunto.getAdjuntos().add(adjuntoAsunto);

		// asunto.addAdjunto(fileItem);
		proxyFactory.proxy(AsuntoApi.class).saveOrUpdateAsunto(asunto);
        
        
//        Asunto asunto = asuntoDao.get(Long.parseLong(uploadForm.getParameter("id")));        
//        asunto.addAdjunto(fileItem);
//        asuntoDao.save(asunto);

		//Integracion con IPLUS, si está configurado el flag correspondiente en devon.properties
        if (iplus != null && iplus.instalado()) {
        	iplus.almacenar(asunto, adjuntoAsunto);
        }
        
        return null;
    }
	
    /**
     * Recupera el l�mite de tama�o de un fichero.
     * @return integer
     */
    private Integer getLimiteFichero() {
        try {
            Parametrizacion param = (Parametrizacion) executor.execute(
                    ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE, Parametrizacion.LIMITE_FICHERO_ASUNTO);
            return Integer.valueOf(param.getValor());
        } catch (Exception e) {
            logger.warn("No esta parametrizado el l�mite m�ximo del fichero en bytes para asuntos, se toma un valor por defecto (2Mb)");
            return new Integer(2 * 1024 * 1024);
        }
    }

	@Override
	public List<Expediente> getExpedienteAsList(Long asuntoId) {
		// TODO Auto-generated method stub
		return null;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	@BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_GET_BIENES_AS_LIST)
	public List<Bien> getBienesDeUnAsunto(Long idAsunto) {
		List<Procedimiento> procedimientos = this.obtenerActuacionesAsunto(idAsunto);
		List<Bien> bienes = new ArrayList<Bien>();
		
		for (Procedimiento procedimiento : procedimientos) {
			bienes.addAll((List<Bien>) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO, procedimiento.getId()));
			//bienes.addAll(proxyFactory.proxy(ProcedimientoManager.class).getBienesDeUnProcedimiento(procedimiento.getId()));
		}
		
		return bienes;
		
	}

	@Override
	@BusinessOperation(BO_CORE_ASUNTO_ADJUNTOSMAPEADOS_BY_PRC_ID)
	public List<? extends AdjuntoDto> getAdjuntosConBorradoByPrcId(Long prcId) {
		final Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

		final Boolean borrarOtrosUsu = tieneFuncion(usuario, "BORRAR_ADJ_OTROS_USU");

		Procedimiento procedimiento = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(prcId);
		List<EXTAdjuntoDto> adjuntosAsunto = new ArrayList<EXTAdjuntoDto>();

		adjuntosAsunto.addAll(creaObjetosEXTAsuntos(procedimiento.getAdjuntos(), usuario, borrarOtrosUsu));

		return ordenaListado(adjuntosAsunto);
	}

	//TODO cambiar la busqueda de procedimientos por buscar directamente el la tabla de subastas
	@BusinessOperation(BO_CORE_ASUNTO_PUEDER_VER_TAB_SUBASTA)
	public Boolean puedeVerTabSubasta(Long asuId) {
		
		/*Asunto asunto = asuntoDao.get(asuId);
		List<Procedimiento> procedimientos = asunto.getProcedimientos();
		if(!Checks.estaVacio(procedimientos)){
			for(Procedimiento p: procedimientos){
				if(SubastaDao.CODIGO_TIPO_SUBASTA_BANKIA.equals(p.getTipoProcedimiento().getCodigo()) 
						|| SubastaDao.CODIGO_TIPO_SUBASTA_SAREB.equals(p.getTipoProcedimiento().getCodigo())
						|| "H002".equals(p.getTipoProcedimiento().getCodigo()) || "H003".equals(p.getTipoProcedimiento().getCodigo())
						|| "H004".equals(p.getTipoProcedimiento().getCodigo()) || "H036".equals(p.getTipoProcedimiento().getCodigo())){
					return true;
				}
			}
		}
		
		return false;*/
		int numeroSubastas = genericdDao.getList(Subasta.class, genericdDao.createFilter(FilterType.EQUALS, "asunto.id", asuId),genericdDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false)).size();
		if(numeroSubastas > 0){
			return true;
		}
		return false;
	}
	
	@BusinessOperation(BO_CORE_ASUNTO_PUEDER_VER_TAB_ADJUDICADOS)
	public Boolean puedeVerTabAdjudicados(Long asuId) {
		List<String> tiposProcedimientos = coreProjectContext.getTiposProcedimientosAdjudicados();
		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(asuId);
		List<Procedimiento> procedimientos = asunto.getProcedimientos();
		for (Procedimiento p : procedimientos){
			MEJProcedimiento mejp = proxyFactory.proxy(EXTProcedimientoApi.class).getInstanceOf(p);
			if (!Checks.esNulo(mejp) && !mejp.isEstaParalizado()) {				
				if(tiposProcedimientos.contains(p.getTipoProcedimiento().getCodigo())) {
					return true;
				}
			}
		}
		return false;
	}
		
	@Override
	@BusinessOperation(BO_ASU_MGR_OBTENER_ACTUACIONES_ASUNTO_OPTIMIZADO)
	public List<Procedimiento> obtenerActuacionesAsuntoOptimizado(Long asuId) {

		//List<DtoProcedimiento> listado = new ArrayList<DtoProcedimiento>();
		List<Procedimiento> list = genericdDao.getList(Procedimiento.class, 
				genericdDao.createFilter(FilterType.EQUALS, "asunto.id", asuId),
				genericdDao.createFilter(FilterType.EQUALS, "borrado", false));
		for (Procedimiento p : list) {
			p.setActivo(isProcedimientoActivo(p));
		}
		
		list = ordena(list);

		return list;
	}
	
	private List<Procedimiento> ordena(List<Procedimiento> list) {
		if (!Checks.estaVacio(list)) {
			Collections.sort(list, new Comparator<Procedimiento>() {

				@Override
				public int compare(Procedimiento o1, Procedimiento o2) {
					if ((o1 == null) && (o2 == null))
						return compareById(o1, o2);
						//return 0;
					else if ((o1 == null) && (o2 != null))
						return 1;
					else if ((o1 != null) && (o2 == null))
						return -1;
					else {
						Date f1 = o1.getAuditoria().getFechaCrear();
						Date f2 = o2.getAuditoria().getFechaCrear();
						if ((f1 == null) && (f2 == null))
							return 0;
						else if ((f1 == null) && (f2 != null))
							return 1;
						else if ((f1 != null) && (f2 == null))
							return -1;
						else {
							return f1.compareTo(f2) == 0 ? compareById(o1, o2) : f1.compareTo(f2);
						}
					}
				}
			});
		}
		return list;
	}
	
	private int compareById(Object arg1, Object arg2) {
		Long id1 = getId(arg1);
		Long id2 = getId(arg2);	
		if ((id1 == null) && (id2 == null)) {
			return 0;
		} else if (id1 == null) {
			return 1;
		} else if (id2 == null) {
			return -1;
		}

		return id1.compareTo(id2);
	}
	
	private Long getId(Object o) {
		if (o instanceof HistoricoProcedimiento) {
			return ((HistoricoProcedimiento) o).getIdProcedimiento();
		} else if (o instanceof HistoricoAsuntoInfo) {
			return ((HistoricoProcedimiento) o).getIdProcedimiento();
		} else if (o instanceof DtoProcedimiento) {
			return ((DtoProcedimiento) o).getProcedimiento().getId();
		} else {
			return ((Procedimiento) o).getId();
		}
	}
	
	private Boolean isProcedimientoActivo(Procedimiento prc) {

		MEJProcedimiento procedimiento = (MEJProcedimiento) prc;
		
		if(procedimiento.isEstaParalizado()){
			return true;
		}
		
		String estadoProcedimiento = procedimiento.getEstadoProcedimiento().getCodigo();
		
		//Si el procedimiento no está en un estado factible de tener tareas pendientes, nunca se debe marcar como activo
		if ((DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_ACEPTADO.equals(procedimiento.getEstadoProcedimiento().getCodigo()) || (DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO).equals(procedimiento.getEstadoProcedimiento().getCodigo()))) {
			if (!DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO.equals(estadoProcedimiento)
							&& !DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO.equals(estadoProcedimiento)) {
				Set<TareaNotificacion> tareasProc = procedimiento.getTareas();
	
				for (TareaNotificacion tar : tareasProc) {
					TareaExterna tarExterna = tar.getTareaExterna();
					if (!Checks.esNulo(tarExterna)) {
						if (tarExterna.getAuditoria() != null && !tarExterna.getAuditoria().isBorrado()) {
							return true;
						}
					}
				}		
			}		
		}

		return false;

	}

	@Override
	@BusinessOperation(BO_CORE_ASUNTO_CONTIENE_PROVISIONES)
	public Boolean contieneProvisiones(Long asuId) {
		try{
			Provisiones prov = genericdDao.get(Provisiones.class, genericdDao.createFilter(FilterType.EQUALS, "asunto.id", asuId), genericdDao.createFilter(FilterType.EQUALS, "borrado", false));
			if(!Checks.esNulo(prov)){
				if(Checks.esNulo(prov.getFechaBaja())){
					return true;
				}
			}
		}
		catch(Exception e){
			logger.equals("contieneProvisiones: "+e);
		}
		return false;
	}

//	@Override
//	@BusinessOperation(EXT_BO_ASU_MGR_FIND_ASUNTOS_PAGINATED_DINAMICO_COUNT)
//	public Integer findAsuntosPaginatedDinamicoCount(EXTDtoBusquedaAsunto dto, String params) {
//		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
//		
//		dto.setCodigoZonas(getCodigosDeZona(dto));
//		dto.setTiposProcedimiento(getTiposProcedimiento(dto));
//		if (usuarioLogado.getUsuarioExterno())
//			dto.setIdsUsuariosGrupos(extGrupoUsuariosDao.getIdsUsuariosGrupoUsuario(usuarioLogado));
//
//		return asuntoDao.buscarAsuntosPaginatedDinamicoCount(usuarioLogado, dto, params);
//	}
	
	@Override
	@BusinessOperation(EXTAsuntoApi.EXT_BO_ASU_MGR_FIND_ASUNTOS_PAGINATED_DINAMICO_COUNT)
	public Page findAsuntosPaginatedDinamicoCount(EXTDtoBusquedaAsunto dto, String params) {
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		
		dto.setCodigoZonas(getCodigosDeZona(dto));
		dto.setTiposProcedimiento(getTiposProcedimiento(dto));
		
		if (usuarioLogado.getUsuarioExterno()) {
			List<Long> idsGruposUsuario = extGrupoUsuariosDao.buscaGruposUsuario(usuarioLogado);
			dto.setIdsUsuariosGrupos(idsGruposUsuario);
		}
		
		Parametrizacion param = (Parametrizacion) executor.execute(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
                Parametrizacion.LIMITE_EXPORT_EXCEL_BUSCADOR_ASUNTOS);		
		
		Integer limite = Integer.parseInt(param.getValor());

		dto.setLimit(limite+1);
		Page results = asuntoDao.buscarAsuntosPaginatedDinamico(usuarioLogado, dto, params);
				
		if(results.getTotalCount()>limite){
			throw new UserException(messageService.getMessage("plugin.coreextension.asuntos.exportarExcel.limiteSuperado1") +limite+" "+ messageService.getMessage("plugin.coreextension.asuntos.exportarExcel.limiteSuperado2"));
		}
		
		return results;
	}

/*	@Override
	@BusinessOperation(EXTAsuntoApi.EXT_BO_ASU_MGR_FIND_ASUNTOS_PAGINATED_DINAMICO_COUNT)
	public List<Asunto> findAsuntosPaginatedDinamicoCount(EXTDtoBusquedaAsunto dto, String params) {
		Usuario usuarioLogado = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		
		dto.setCodigoZonas(getCodigosDeZona(dto));
		dto.setTiposProcedimiento(getTiposProcedimiento(dto));
		
		if (usuarioLogado.getUsuarioExterno()) {
			List<Long> idsGruposUsuario = extGrupoUsuariosDao.buscaGruposUsuario(usuarioLogado);
			dto.setIdsUsuariosGrupos(idsGruposUsuario);
		}
		
		Parametrizacion param = (Parametrizacion) executor.execute(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
                Parametrizacion.LIMITE_EXPORT_EXCEL_BUSCADOR_ASUNTOS);		
		
		Integer limite = Integer.parseInt(param.getValor());
		List<Asunto> listaRetorno = new ArrayList<Asunto>();
		dto.setLimit(limite+1);
		PageHibernate page = (PageHibernate) asuntoDao.buscarAsuntosPaginatedDinamico(usuarioLogado, dto, params);
	

		if(page.getTotalCount()>limite){
			throw new UserException(messageService.getMessage("plugin.coreextension.asuntos.exportarExcel.limiteSuperado1") +limite+" "+ messageService.getMessage("plugin.coreextension.asuntos.exportarExcel.limiteSuperado2"));
		}
		listaRetorno.addAll((List<Asunto>) page.getResults());
		page.setResults(listaRetorno);
		return (List<Asunto>) page.getResults();
	}
	*/
	/**
	 * Indica si el Usuario Logado es el gestor de Decision del asunto.
	 * 
	 * @return true si es el gestor de Decision
	 */
	@BusinessOperation(ExternaBusinessOperation.BO_ASU_MGR_ES_GESTOR_DECISION)
	@Override
	public Boolean esGestorDecision(Long id) {
		try {
			
			return esUsuarioGestorDecision(id);
			
		} catch (Exception e) {
			logger.error("No se ha podido comprobar si el usuario puede ver el botón de tomar una decisión en el asunto: "+id, e);
			return false;
			//throw new BusinessOperationException(e);
		}
	}		



	
	/**
	 * esUsuarioGestorDecision
	 * 
	 * Nos devuelve si este usuario tiene algún gestor de tipo Decisión
	 * 
	 * @param usu Usuario
	 * @return true / false
	 */
	private Boolean esUsuarioGestorDecision(Long id){
		
		Asunto asunto = procedimientoDao.get(id).getAsunto();
		Usuario usuario = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		
		Set<String> staC = coreProjectContext.getCategoriasSubTareas().get(CoreProjectContext.CATEGORIA_SUBTAREA_TOMA_DECISION);
		
		List<String> listaCodigosGestor = new ArrayList<String>();
		
		//Obtenemos los TGE de las subtareas indicadas en el XML
		for (String st : staC) {
			
			EXTSubtipoTarea extSubtipoTarea = genericdDao.get(EXTSubtipoTarea.class, genericdDao.createFilter(FilterType.EQUALS, "codigoSubtarea", st));
			if (extSubtipoTarea!=null) {
				listaCodigosGestor.add(extSubtipoTarea.getTipoGestor().getCodigo());
			}
		}
		
		boolean gestor = false;

		// Buscamos entre los Multi Gestores Multi Entidad
		gestor = buscaMultiGestorMultiEntidad(usuario, asunto, listaCodigosGestor);

		/**
		// Buscamos entre los gestores adicionales del asunto
		if (!gestor) {
			gestor = buscaUsuario(usuario, proxyFactory.proxy(EXTAsuntoApi.class).getGestoresAsunto(asunto.getId()));
		}*/

		return gestor;
	}

	@Override
	@BusinessOperation(EXT_BO_ES_TITULIZADA)
	public String esTitulizada(Long idAsunto) {
		
		List<DDTipoFondo> listREsultado = asuntoDao.esTitulizada(idAsunto);
		if(listREsultado.isEmpty()){
			return "NO";
		}
		else{
			return "SI";
		}
		
	}

	@Override
	@BusinessOperation(EXT_BO_ES_GET_FONDO)
	public String getFondo(Long idAsunto) {
		
		List<DDTipoFondo> listREsultado = asuntoDao.esTitulizada(idAsunto);
		if(listREsultado.isEmpty()){
			return null;
		}
		else{
			return listREsultado.get(0).getDescripcion();
		}
		
	}
	

	public EXTAsunto getAsuntoByGuid(String guid) {
		Filter filter = genericdDao.createFilter(FilterType.EQUALS, "guid", guid);
		EXTAsunto extAsunto = genericdDao.get(EXTAsunto.class, filter);
		return extAsunto;
	}

	public EXTAsunto getAsuntoById(Long id) {
		Filter filter = genericdDao.createFilter(FilterType.EQUALS, "id", id);
		EXTAsunto extAsunto = genericdDao.get(EXTAsunto.class, filter);
		return extAsunto;
	}

	@BusinessOperation(EXT_BO_ES_TIPO_GESTOR_ASIGNADO)
	public Boolean esTipoGestorAsignado(Long idAsunto, String codigoTipoGestor){
		List<EXTGestorAdicionalAsunto> gestores = getGestoresAdicionalesAsunto(idAsunto);
		if(!gestores.isEmpty()){
			for(EXTGestorAdicionalAsunto gestor : gestores){
				if(gestor != null && gestor.getTipoGestor() != null && codigoTipoGestor.equals(gestor.getTipoGestor().getCodigo())){
					return true;
				}
			}
		}
		return false;
	}

    /**
     * Obtiene las zonas del nivel.
     * @param idNivel id nivel
     * @return zonas
     */
	@Override
    @BusinessOperation(BO_ZONA_MGR_GET_ZONAS_POR_NIVEL_BY_CODIGO)
    public List<DDZona> getZonasPorNivel(Integer codigoNivel) {
        if (codigoNivel == null || codigoNivel.longValue() == 0) { return new ArrayList<DDZona>(); }
        Set<String> codigoZonasUsuario = ((Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO))
                .getCodigoZonas();
        return extZonaDao.buscarZonasPorCodigoNivel(codigoNivel, codigoZonasUsuario);
    }
        
	@Override
	@BusinessOperation(EXT_BO_MSG_ERROR_ENVIO_CDD)
	public String getMsgErrorEnvioCDD(Long idAsunto) {
		
            return asuntoDao.getMsgErrorEnvioCDD(idAsunto);
		
	}
        
	@Override
	@BusinessOperation(EXT_BO_MSG_ERROR_ENVIO_CDD_NUSE)
	public String getMsgErrorEnvioCDDNuse(Long idAsunto) {
		
            return asuntoDao.getMsgErrorEnvioCDDNuse(idAsunto);
		
	}
	
    @Override
	@BusinessOperation(EXT_BO_MSG_ERROR_ENVIO_CDD_ASUNTO)
	public String getMsgErrorEnvioCDDCabecera(Long idAsunto) {
	
            if (Checks.esNulo(asuntoDao.getMsgErrorEnvioCDDCabecera(idAsunto))){
                return "NoCDDError";
            }else{
                return asuntoDao.getMsgErrorEnvioCDDCabecera(idAsunto);
            }

	}
        
	@Override
	@Transactional(readOnly = false)
	public void finalizarAsunto(MEJFinalizarAsuntoDto dto) {
		this.finalizarAsunto(dto, true);
	}
        
	@Override
	@Transactional(readOnly = false)
	public void finalizarAsunto(MEJFinalizarAsuntoDto dto, boolean sincronizar) {

		Asunto asunto = asuntoDao.get(dto.getIdAsunto());
		
		Provisiones prov = genericDao.get(Provisiones.class, genericDao.createFilter(FilterType.EQUALS, "asunto.id", asunto.getId()), genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		// Buscamos el estado procedimiento cerrado para asignarselo después al
		// procedimiento
		DDEstadoProcedimiento ep = (DDEstadoProcedimiento)diccionarioApi.dameValorDiccionarioByCod(DDEstadoProcedimiento.class, DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO);
		boolean error = false;
		for (Procedimiento proc : asunto.getProcedimientos()) {
			
			if(proc.getEstadoProcedimiento().getCodigo().equals(ep.getCodigo())) {
				continue;
			}

			MEJDtoDecisionProcedimiento dtoDecisionProcedimiento = new MEJDtoDecisionProcedimiento();

			dtoDecisionProcedimiento.setIdProcedimiento(proc.getId());
			dtoDecisionProcedimiento.setFinalizar(true);
			dtoDecisionProcedimiento.setParalizar(false);
			dtoDecisionProcedimiento.setFechaParalizacion(dto
					.getFechaFinalizacion());
			dtoDecisionProcedimiento.setComentarios(dto.getObservaciones());
			
			//dtoDecisionProcedimiento.setCausaDecision(getCodigoCausaDecisionByDescripcion(dto.getMotivoFinalizacion()));
			dtoDecisionProcedimiento.setCausaDecisionFinalizar(getCodigoCausaDecisionByDescripcion(dto.getMotivoFinalizacion()));
			
			dtoDecisionProcedimiento.setStrEstadoDecision("02");

			
			DecisionProcedimiento decisionProcedimiento = decisionProcedimientoManager.getInstance(proc.getId());

			dtoDecisionProcedimiento
					.setDecisionProcedimiento(decisionProcedimiento);
			try {
				mejDecisionProcedimientoManager.aceptarPropuesta(dtoDecisionProcedimiento);
			} catch (Exception e) {
				e.printStackTrace();
				logger.error("Ha habido un error al cerrar los procedimientos. "
						+ e);
				error = true;
			}
		}

		// Cuando haya finalizado todos los procedimientos, ahora ya se puede
		// cambiar el estado del asunto
		// Comprobamos que no haya habido ningún error
		if (!error) {
			//Estado Asunto por defecto = "Cerrado"
			DDEstadoAsunto estado = (DDEstadoAsunto)diccionarioApi.dameValorDiccionarioByCod(DDEstadoAsunto.class, DDEstadoAsunto.ESTADO_ASUNTO_CERRADO);
			
			//Se evalúa si existen provisiones -> Se establece estado = "Gestion finalizada"
			if ( prov != null && (Checks.esNulo(prov.getFechaBaja() )) ){
				estado = (DDEstadoAsunto)diccionarioApi.dameValorDiccionarioByCod(DDEstadoAsunto.class, DDEstadoAsunto.ESTADO_ASUNTO_GESTION_FINALIZADA);
			}

			asunto.setEstadoAsunto(estado);
			try {
				asuntoDao.save(asunto);

				// Ahora vamos a eliminar todas las tareas asociadas al asunto
				Long idAsunto = asunto.getId();

				// Primero borramos las tareas externas del asunto
				Set<TareaNotificacion> listadoN = asunto.getTareas();
				for (TareaNotificacion tn : listadoN) {
					if (!Checks.esNulo(tn.getTareaExterna()))
						genericDao.deleteById(TareaExterna.class, tn
								.getTareaExterna().getId());
				}

				// Borramos todas las notificaciones del asunto
				List<TareaNotificacion> listadoNotificaciones = genericDao
						.getList(TareaNotificacion.class, genericDao
								.createFilter(FilterType.EQUALS, "asunto.id",
										idAsunto));
				for (TareaNotificacion tn : listadoNotificaciones) {
					genericDao.deleteById(TareaNotificacion.class, tn.getId());
				}

				if (sincronizar) {
					integrationService.finalizarAsunto(dto);
				}
				
			} catch (Exception e) {
				e.printStackTrace();
				logger.error(e);
			}
		} else {
			logger.error("El asunto no se ha cerrado correctamente.");
		}

	}
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.mejoras.asunto.api.MEJFinalizarAsuntoApi#paralizaAsunto(es.capgemini.pfs.asunto.model.Asunto, java.util.Date)
	 */
	@Override
	@Transactional(readOnly = false)
	public void paralizaAsunto(Asunto asunto, Date fechaParalizacion) {
		List<Procedimiento> procedimientos = asunto.getProcedimientos();
		for (Procedimiento procedimiento : procedimientos) {
			if ((!DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CANCELADO.equals(procedimiento.getEstadoProcedimiento().getCodigo())) &&
				(!DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO.equals(procedimiento.getEstadoProcedimiento().getCodigo()))) {
				
				MEJProcedimiento mejPrc = genericDao.get(MEJProcedimiento.class, 
						genericDao.createFilter(FilterType.EQUALS, "id", procedimiento.getId()));			
				
				Long idProcessBPM = mejPrc.getProcessBPM();
				if (!Checks.esNulo(idProcessBPM))
					jbpmUtil.aplazarProcesosBPM(idProcessBPM, fechaParalizacion);
                mejPrc.setEstaParalizado(true);
                mejPrc.setFechaUltimaParalizacion(fechaParalizacion);
                genericDao.save(MEJProcedimiento.class, mejPrc);
			}
		}
	}	
	
	/**
	 * M�todo que devuelve el c�digo de causa decisi�n a partir de la descripci�n de la causa
	 * @param descripcion
	 * @return codigo
	 */
	private String getCodigoCausaDecisionByDescripcion(String descripcion){
		if(!Checks.esNulo(descripcion)){
			
			//DDCausaDecision causa = genericDao.get(DDCausaDecision.class, genericDao.createFilter(FilterType.EQUALS, "descripcion", descripcion));
			DDCausaDecisionFinalizar causa = genericDao.get(DDCausaDecisionFinalizar.class, genericDao.createFilter(FilterType.EQUALS, "descripcion", descripcion));
			if(!Checks.esNulo(causa))
				return causa.getCodigo();
			return "";
		}
		return null;
	}
	
	public EXTAsunto prepareGuid(Asunto asunto) {
		
		EXTAsunto extAsu =  EXTAsunto.instanceOf(asunto);
		
		if (Checks.esNulo(extAsu.getGuid())) {
			
			String guid = Guid.getNewInstance().toString();
			while(getAsuntoByGuid(guid) != null) {
				guid = Guid.getNewInstance().toString();
			}

			extAsu.setGuid(guid);
			asuntoDao.save(extAsu);
		}
		
		return extAsu;
	}
	
	public Boolean tieneProcurador(Long idAsunto){
		List<EXTGestorAdicionalAsunto> gestores = getGestoresAdicionalesAsunto(idAsunto);
		if(!gestores.isEmpty()){
			for(EXTGestorAdicionalAsunto gestor : gestores){
				if(gestor != null && gestor.getTipoGestor() != null && coreProjectContext.getTiposGestorProcurador().contains(gestor.getTipoGestor().getCodigo())){
					return true;
				}
			}
		}
		return false;
	}
	

	public boolean tieneActorEnAsunto(Long id, Set<String> listadoGestores) {
		List<EXTGestorAdicionalAsunto> gestores = getGestoresAdicionalesAsunto(id);
		if(!gestores.isEmpty()){
			for(EXTGestorAdicionalAsunto gestor : gestores){
				if(gestor != null && gestor.getTipoGestor() != null && listadoGestores.contains(gestor.getTipoGestor().getCodigo())){
					return true;
				}
			}
		}
		return false;
	}

}

