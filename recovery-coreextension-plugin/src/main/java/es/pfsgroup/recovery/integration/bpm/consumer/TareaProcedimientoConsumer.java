package es.pfsgroup.recovery.integration.bpm.consumer;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.core.api.procesosJudiciales.dto.EXTDtoCrearTareaExterna;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaValorDao;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.tareaNotificacion.EXTTareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.api.TareaProcedimientoApi;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;
import es.pfsgroup.recovery.integration.ConsumerAction;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.Rule;
import es.pfsgroup.recovery.integration.bpm.DiccionarioDeCodigos;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;
import es.pfsgroup.recovery.integration.bpm.TareaExternaPayload;
import es.pfsgroup.recovery.integration.bpm.UsuarioPayload;

/**
 * 
 * Inicia el procedimiento si no existe sincronizado según el padre (que debe existir).
 * 
 * Tareas asociadas según el tipo de mensaje:
 * 
 * 	- Da de alta una tarea en la bd (PRC_PROCEDIMIENTO) e inicia el procedimiento que se pasa.
 *  - Cancela una tarea
 *  - Finaliza una tarea.
 * 
 * @author gonzalo
 *
 */
public class TareaProcedimientoConsumer extends ConsumerAction<DataContainerPayload> {

	protected final Log logger = LogFactory.getLog(getClass());
	
	private final DiccionarioDeCodigos diccionarioCodigos;
	
	@Autowired
	private EXTTareaNotificacionManager extTareaNotifificacionManager;

	@Autowired
	private ProcedimientoManager procedimientoManager;
	
	@Autowired
	private EXTProcedimientoManager extProcedimientoManager;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private TareaExternaValorDao tareaExternaValorDao;
	
    @Autowired
    protected TareaExternaManager tareaExternaManager;
    	
	@Autowired
	private Executor executor;

	public TareaProcedimientoConsumer(Rule<DataContainerPayload> rule, DiccionarioDeCodigos diccionarioCodigos) {
		super(rule);
		this.diccionarioCodigos = diccionarioCodigos; 
	}
	
	public TareaProcedimientoConsumer(List<Rule<DataContainerPayload>> rules, DiccionarioDeCodigos diccionarioCodigos) {
		super(rules);
		this.diccionarioCodigos = diccionarioCodigos; 
	}

	private String getGuidProcedimiento(TareaExternaPayload tareaExtenaPayload) {
		return String.format("%d-EXT", tareaExtenaPayload.getProcedimiento().getIdOrigen()); //message.getGuidProcedimiento();
	}

	private String getGuidTareaNotificacion(TareaExternaPayload tareaExtenaPayload) {
		return String.format("%d-EXT", tareaExtenaPayload.getIdTARTarea()); // message.getGuidTARTarea();
	}
	
	@Transactional(readOnly = false)
	private MEJProcedimiento getProcedimiento(TareaExternaPayload tareaExtenaPayload) {
		String prcUUID = getGuidProcedimiento(tareaExtenaPayload);
		logger.debug(String.format("[INTEGRACION] PRC [%s] Configurando procedimiento", prcUUID));
		MEJProcedimiento prc = extProcedimientoManager.getProcedimientoByGuid(prcUUID);
		if (prc==null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El procedimiento con guid %s no existe.", prcUUID));
		}
		return prc;
	}
	
	private String getSubTipoTarea(TareaProcedimiento tareaProcedimiento) {
		String subtipoTarea = SubtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_GESTOR;

		// Si está marcada como supervisor se cambia el subtipo tarea
		if (tareaProcedimiento.getSupervisor()) {
			subtipoTarea = SubtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_SUPERVISOR;
		}

		if (tareaProcedimiento instanceof EXTTareaProcedimiento) {
			EXTTareaProcedimiento tp = (EXTTareaProcedimiento) tareaProcedimiento;

			if (!Checks.esNulo(tp.getSubtipoTareaNotificacion())) {
				subtipoTarea = tp.getSubtipoTareaNotificacion().getCodigoSubtarea();
			} else {

				if (!Checks.esNulo(tp.getTipoGestor())) {
					if ((tp.getTipoGestor().getCodigo().equals(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_CONF_EXP))) {
						subtipoTarea = EXTSubtipoTarea.CODIGO_TAREA_GESTOR_CONFECCION_EXPTE;
					}
					if ((tp.getTipoGestor().getCodigo().equals(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR_CONF_EXP))) {
						subtipoTarea = EXTSubtipoTarea.CODIGO_TAREA_SUPERVISOR_CONFECCION_EXPTE;
					}

				}
			}
		}
		return subtipoTarea;
	}
	
	@Transactional(readOnly = false)
	private EXTTareaNotificacion crearTarea(TareaExternaPayload tareaExtenaPayload, Procedimiento procedimiento, String tarUUID) {
		logger.debug(String.format("[INTEGRACION] TAR [%s] Configurando datos", tarUUID));
		String codTAPTarea = tareaExtenaPayload.getCodigoTAPTarea();
		
		TareaProcedimiento tareaProcedimiento = proxyFactory.proxy(TareaProcedimientoApi.class)
				.getByCodigoTareaIdTipoProcedimiento(procedimiento.getTipoProcedimiento().getId(), codTAPTarea);
		if (tareaProcedimiento==null) {
			throw new IntegrationDataException(
					String.format("[INTEGRACION] TAP [%s] La tarea procedimiento no existe para el procedimiento %s, NO SE INICIA LA TAREA."
							, codTAPTarea
							, procedimiento.getTipoProcedimiento().getCodigo()));
		}
		logger.debug(String.format("[INTEGRACION] TAP [%s] Tarea procedimiento encontrada", tareaProcedimiento.getCodigo()));
		
		String subtipoTarea = getSubTipoTarea(tareaProcedimiento);
		HashMap<String, Object> valores = new HashMap<String, Object>();
		valores.put("codigoSubtipoTarea", subtipoTarea);
		valores.put("plazo", 1);					// Luego se modificará con los valores que llegan
		valores.put("descripcion", tareaExtenaPayload.getDescripcion());
		valores.put("idProcedimiento", procedimiento.getId());
		valores.put("idTareaProcedimiento", tareaProcedimiento.getId());
		valores.put("tokenIdBpm", null);

		logger.debug(String.format("[INTEGRACION] TAR [%s] Persistiendo datos", tarUUID));
		EXTDtoCrearTareaExterna dto = DynamicDtoUtils.create(EXTDtoCrearTareaExterna.class, valores);
		Long idTarea = proxyFactory.proxy(TareaExternaApi.class).crearTareaExternaDto(dto);
		logger.debug(String.format("[INTEGRACION] TAR [%s] Tarea creada", tarUUID));

		TareaExterna tex = tareaExternaManager.get(idTarea);
		EXTTareaNotificacion tareaNotif = (EXTTareaNotificacion)tex.getTareaPadre(); 
		postCrearTarea(tareaExtenaPayload, tareaNotif);
		return tareaNotif;
	}
	
	private void suplantarUsuario(UsuarioPayload usuarioPayload, Auditable auditable) {
		Auditoria auditoria = auditable.getAuditoria();
		if (auditoria==null) {
			auditoria = Auditoria.getNewInstance();
		}
		auditoria.setSuplantarUsuario(usuarioPayload.getNombre());
		auditoria.setUsuarioCrear(usuarioPayload.getNombre());
	}
	
	private void postCrearTarea(TareaExternaPayload tareaExtenaPayload, EXTTareaNotificacion tareaNotif) {
		
		// TODO: QUITAR ESTA LINEA (lo hace la línea anterior)
		tareaNotif.setGuid(this.getGuidTareaNotificacion(tareaExtenaPayload));
		//tareaNotif.setGuid(tareaExtenaPayload.getGuidTARTarea());
		tareaNotif.setFechaInicio(tareaExtenaPayload.getFechaInicio());
		tareaNotif.setFechaFin(tareaExtenaPayload.getFechaFin());
		tareaNotif.setFechaVenc(tareaExtenaPayload.getFechaVencimiento());
		tareaNotif.setFechaVencReal(tareaExtenaPayload.getFechaVencimientoReal());
		suplantarUsuario(tareaExtenaPayload.getUsuario(), tareaNotif);
		
		executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE,
				tareaNotif);
		logger.debug(String.format("[INTEGRACION] TAR [%s] Actualizando post crear tarea finalizado", tareaNotif.getGuid()));
	}
	
	@Transactional(readOnly = false)
	private void inicioTarea(TareaExternaPayload tareaExtenaPayload, Procedimiento procedimiento) {
		String refAsunto = tareaExtenaPayload.getProcedimiento().getAsunto().getGuid();
		String prcUUID = getGuidProcedimiento(tareaExtenaPayload);
		String tarUUID = getGuidTareaNotificacion(tareaExtenaPayload);
		logger.debug(String.format("[INTEGRACION] TAR [%s] Creando tarea para el procedimiento %s asunto %s.", tarUUID, prcUUID, refAsunto));

		EXTTareaNotificacion tareaNotif = extTareaNotifificacionManager.getTareaNoficiacionByGuid(tarUUID);
		if (tareaNotif==null) {
			logger.debug(String.format("[INTEGRACION] TAR [%s] Creando tarea para el procedimiento %d.", tarUUID, procedimiento.getId()));
			tareaNotif = crearTarea(tareaExtenaPayload, procedimiento, tarUUID);
			logger.debug(String.format("[INTEGRACION] TAR [%s] Tarea creada", tarUUID));
		}
	}

	
	
	@Transactional(readOnly = false)
	protected void finTarea(TareaExternaPayload tareaExtenaPayload) {
		String refAsunto = tareaExtenaPayload.getProcedimiento().getAsunto().getGuid();
		String prcUUID = getGuidProcedimiento(tareaExtenaPayload);
		String tarUUID = getGuidTareaNotificacion(tareaExtenaPayload);
		logger.debug(String.format("[INTEGRACION] TAR [%s] Finalizando para el procedimiento %s asunto %s.", tarUUID, prcUUID, refAsunto));

		EXTTareaNotificacion tareaNotif = extTareaNotifificacionManager.getTareaNoficiacionByGuid(tarUUID);
		if (tareaNotif==null) {
			throw new IntegrationDataException(
					String.format("[INTEGRACION] La tarea procedimiento %s no existe para el procedimiento %s, NO SE FINALIZA LA TAREA."
							, tarUUID
							, prcUUID));
		}
		
		TareaExterna tex = tareaNotif.getTareaExterna();
		suplantarUsuario(tareaExtenaPayload.getUsuario(), tex);
		suplantarUsuario(tareaExtenaPayload.getUsuario(), tex.getTareaPadre());
		tex.setDetenida(false);
		logger.debug(String.format("[INTEGRACION] TEX [%d] Finalizando tarea.", tex.getId()));
		proxyFactory.proxy(TareaExternaApi.class).borrar(tex);
		logger.debug(String.format("[INTEGRACION] TEX [%d] Tarea finalizada.", tex.getId()));
		
		saveFormValues(tareaExtenaPayload, tex);
	}

	@Transactional(readOnly = false)
	protected void cancelarTarea(TareaExternaPayload tareaExtenaPayload) {
		String refAsunto = tareaExtenaPayload.getProcedimiento().getAsunto().getGuid();
		String prcUUID = getGuidProcedimiento(tareaExtenaPayload);
		String tarUUID = getGuidTareaNotificacion(tareaExtenaPayload);
		logger.debug(String.format("[INTEGRACION] TAR [%s] Cancelando para el procedimiento %s asunto %s.", tarUUID, prcUUID, refAsunto));

		EXTTareaNotificacion tareaNotif = extTareaNotifificacionManager.getTareaNoficiacionByGuid(tarUUID);
		if (tareaNotif==null) {
			throw new IntegrationDataException(
					String.format("[INTEGRACION] La tarea procedimiento %s no existe para el procedimiento %s, NO SE CANCELA LA TAREA."
							, tarUUID
							, prcUUID));
		}
		
		TareaExterna tex = tareaNotif.getTareaExterna();
        tex.setCancelada(true);
        tex.setDetenida(false);
		suplantarUsuario(tareaExtenaPayload.getUsuario(), tex);
		suplantarUsuario(tareaExtenaPayload.getUsuario(), tex.getTareaPadre());
		logger.debug(String.format("[INTEGRACION] TEX [%d] Cancelando tarea.", tex.getId()));
		proxyFactory.proxy(TareaExternaApi.class).borrar(tex);
		logger.debug(String.format("[INTEGRACION] TEX [%d] Tarea cancelada.", tex.getId()));
	}
	
	@Transactional(readOnly = false)
	private void activarTarea(TareaExternaPayload tareaExtenaPayload) {
		String refAsunto = tareaExtenaPayload.getProcedimiento().getAsunto().getGuid();
		String prcUUID = getGuidProcedimiento(tareaExtenaPayload);
		String tarUUID = getGuidTareaNotificacion(tareaExtenaPayload);
		logger.debug(String.format("[INTEGRACION] TAR [%s] Activando para el procedimiento %s asunto %s.", tarUUID, prcUUID, refAsunto));

		EXTTareaNotificacion tareaNotif = extTareaNotifificacionManager.getTareaNoficiacionByGuid(tarUUID);
		if (tareaNotif==null) {
			throw new IntegrationDataException(
					String.format("[INTEGRACION] La tarea procedimiento %s no existe para el procedimiento %s, NO SE ACTIVA LA TAREA."
							, tarUUID
							, prcUUID));
		}
		MEJProcedimiento prc = (MEJProcedimiento)tareaNotif.getProcedimiento();
		TareaExterna tex = tareaNotif.getTareaExterna();
		suplantarUsuario(tareaExtenaPayload.getUsuario(), tex);
		logger.debug(String.format("[INTEGRACION] TEX [%d] Activando tarea.", tex.getId()));
        tareaExternaManager.activar(tex);
        //
		logger.debug(String.format("[INTEGRACION] PRC [%d] ACtivando procedimiento.", prc.getId()));
		prc.setEstaParalizado(false);
		suplantarUsuario(tareaExtenaPayload.getUsuario(), prc);
		procedimientoManager.saveProcedimiento(prc);
		logger.debug(String.format("[INTEGRACION] TEX [%d] Tarea y procedimientos activados.", tex.getId()));
			
	}

	@Transactional(readOnly = false)
	private void paralizarTarea(TareaExternaPayload tareaExtenaPayload) {
		String refAsunto = tareaExtenaPayload.getProcedimiento().getAsunto().getGuid();
		String prcUUID = getGuidProcedimiento(tareaExtenaPayload);
		String tarUUID = getGuidTareaNotificacion(tareaExtenaPayload);
		logger.debug(String.format("[INTEGRACION] TAR [%s] Deteniendo para el procedimiento %s asunto %s.", tarUUID, prcUUID, refAsunto));

		EXTTareaNotificacion tareaNotif = extTareaNotifificacionManager.getTareaNoficiacionByGuid(tarUUID);
		if (tareaNotif==null) {
			throw new IntegrationDataException(
					String.format("[INTEGRACION] La tarea procedimiento %s no existe para el procedimiento %s, NO SE ACTIVA LA TAREA."
							, tarUUID
							, prcUUID));
		}
		MEJProcedimiento prc = (MEJProcedimiento)tareaNotif.getProcedimiento();
		TareaExterna tex = tareaNotif.getTareaExterna();
		suplantarUsuario(tareaExtenaPayload.getUsuario(), tex);
		logger.debug(String.format("[INTEGRACION] TEX [%d] Deteniendo tarea.", tex.getId()));
        tareaExternaManager.detener(tex);
        //
		logger.debug(String.format("[INTEGRACION] PRC [%d] Deteniendo procedimiento.", prc.getId()));
		prc.setEstaParalizado(true);
		prc.setFechaUltimaParalizacion(new Date());
		suplantarUsuario(tareaExtenaPayload.getUsuario(), prc);
		procedimientoManager.saveProcedimiento(prc);
		logger.debug(String.format("[INTEGRACION] TEX [%d] Tarea y procedimientos activados.", tex.getId()));
			
			
	}

	@Transactional(readOnly = false)
	private void saveFormValues(TareaExternaPayload tareaExtenaPayload, TareaExterna tarea) {
		String tapCodigo = tarea.getTareaProcedimiento().getCodigo();
		logger.debug(String.format("[INTEGRACION] TAP [%s] Guardando campos formulario en tarea.", tapCodigo));
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tareaProcedimiento.id", tarea.getTareaProcedimiento().getId()); 
		List<GenericFormItem> items = genericDao.getList(GenericFormItem.class, filtro);

		logger.debug(String.format("[INTEGRACION] TAP [%s] Num de items para encontrados en tarea: %d", tapCodigo, items.size()));
		
		for (GenericFormItem item : items) {
			if (!tareaExtenaPayload.contieneValorParaCampo(item.getNombre())) {
				logger.warn(String.format("[INTEGRACION] TAP [%s] TFI [%s] Campo no existe en la definición de recovery. ", tapCodigo, item.getNombre()));
				continue;
			}
			String valor = tareaExtenaPayload.getValorCampoFormulario(item.getNombre());

			EXTTareaExternaValor tevValor = new EXTTareaExternaValor();
			tevValor.setTareaExterna(tarea);
			tevValor.setNombre(item.getNombre());
			tevValor.setValor(valor);
			suplantarUsuario(tareaExtenaPayload.getUsuario(), tevValor);

			// listaValores.add(valor);
			tareaExternaValorDao.saveOrUpdate(tevValor);
		}
		logger.debug(String.format("[INTEGRACION] TAP [%s] Fin campos guardados formulario.", tapCodigo));
	}

	@Override
	protected void doAction(DataContainerPayload payload) {
		TareaExternaPayload tareaExtenaPayload = new TareaExternaPayload(payload);
		MEJProcedimiento procedimiento = getProcedimiento(tareaExtenaPayload);
		if (payload.getTipo().equals(IntegracionBpmService.TIPO_INICIO_TAREA)) {
			inicioTarea(tareaExtenaPayload, procedimiento);
		} else if (payload.getTipo().equals(IntegracionBpmService.TIPO_FINALIZACION_TAREA)) {
			finTarea(tareaExtenaPayload);
		} else if (payload.getTipo().equals(IntegracionBpmService.TIPO_CANCELACION_TAREA)) {
			cancelarTarea(tareaExtenaPayload);
		} else if (payload.getTipo().equals(IntegracionBpmService.TIPO_PARALIZAR_TAREA)) {
			paralizarTarea(tareaExtenaPayload);
		} else if (payload.getTipo().equals(IntegracionBpmService.TIPO_ACTIVAR_TAREA)) {
			activarTarea(tareaExtenaPayload);
		}

	}
	
}
