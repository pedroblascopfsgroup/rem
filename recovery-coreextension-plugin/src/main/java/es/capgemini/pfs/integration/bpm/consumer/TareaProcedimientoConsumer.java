package es.capgemini.pfs.integration.bpm.consumer;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.core.api.procesosJudiciales.dto.EXTDtoCrearTareaExterna;
import es.capgemini.pfs.integration.AsuntoPayload;
import es.capgemini.pfs.integration.ConsumerAction;
import es.capgemini.pfs.integration.IntegrationDataException;
import es.capgemini.pfs.integration.Rule;
import es.capgemini.pfs.integration.bpm.DiccionarioDeCodigos;
import es.capgemini.pfs.integration.bpm.IntegracionBpmService;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaValorDao;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.tareaNotificacion.EXTTareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.web.dto.dynamic.DynamicDtoUtils;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.api.TareaProcedimientoApi;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

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
public class TareaProcedimientoConsumer extends ConsumerAction<AsuntoPayload> {

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

	public TareaProcedimientoConsumer(Rule<AsuntoPayload> rule, DiccionarioDeCodigos diccionarioCodigos) {
		super(rule);
		this.diccionarioCodigos = diccionarioCodigos; 
	}
	
	public TareaProcedimientoConsumer(List<Rule<AsuntoPayload>> rules, DiccionarioDeCodigos diccionarioCodigos) {
		super(rules);
		this.diccionarioCodigos = diccionarioCodigos; 
	}

	private String getGuidProcedimiento(AsuntoPayload message) {
		return String.format("%d-EXT", message.getIdProcedimiento()); //message.getGuidProcedimiento();
	}

	private String getGuidTareaNotificacion(AsuntoPayload message) {
		return String.format("%d-EXT", message.getIdTARTarea()); // message.getGuidTARTarea();
	}
	
	@Transactional(readOnly = false)
	private MEJProcedimiento getProcedimiento(AsuntoPayload message) {
		String prcUUID = getGuidProcedimiento(message);
		logger.debug(String.format("[INTEGRACION] PRC [%s] Configurando procedimiento", prcUUID));
		MEJProcedimiento prc = extProcedimientoManager.getProcedimientoByGuid(prcUUID);
		if (prc==null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El procedimiento con guid %s no existe.", prcUUID));
		}
		return prc;
	}
	
	@Transactional(readOnly = false)
	private EXTTareaNotificacion crearTarea(AsuntoPayload message, Procedimiento procedimiento, String tarUUID) {
		logger.debug(String.format("[INTEGRACION] TAR [%s] Configurando datos", tarUUID));
		String codTAPTarea = message.getCodigoTAPTarea();
		
		TareaProcedimiento tareaProcedimiento = proxyFactory.proxy(TareaProcedimientoApi.class)
				.getByCodigoTareaIdTipoProcedimiento(procedimiento.getTipoProcedimiento().getId(), codTAPTarea);
		if (tareaProcedimiento==null) {
			throw new IntegrationDataException(
					String.format("[INTEGRACION] TAP [%s] La tarea procedimiento no existe para el procedimiento %s, NO SE INICIA LA TAREA."
							, codTAPTarea
							, procedimiento.getTipoProcedimiento().getCodigo()));
		}
		logger.debug(String.format("[INTEGRACION] TAP [%s] Tarea procedimiento encontrada", tareaProcedimiento.getCodigo()));

		String subtipoTarea = SubtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_GESTOR;;		// ?? Es normal???????? *************************************+
		HashMap<String, Object> valores = new HashMap<String, Object>();
		valores.put("codigoSubtipoTarea", subtipoTarea);
		valores.put("plazo", 1);					// Luego se modificará con los valores que llegan
		valores.put("descripcion", message.getDescripcion());
		valores.put("idProcedimiento", procedimiento.getId());
		valores.put("idTareaProcedimiento", tareaProcedimiento.getId());
		valores.put("tokenIdBpm", null);

		logger.debug(String.format("[INTEGRACION] TAR [%s] Persistiendo datos", tarUUID));
		EXTDtoCrearTareaExterna dto = DynamicDtoUtils.create(EXTDtoCrearTareaExterna.class, valores);
		Long idTarea = proxyFactory.proxy(TareaExternaApi.class).crearTareaExternaDto(dto);
		logger.debug(String.format("[INTEGRACION] TAR [%s] Tarea creada", tarUUID));

		TareaExterna tex = tareaExternaManager.get(idTarea);
		EXTTareaNotificacion tareaNotif = (EXTTareaNotificacion)tex.getTareaPadre(); 
		postCrearTarea(message, tareaNotif);
		return tareaNotif;
	}
	
	private void postCrearTarea(AsuntoPayload message, EXTTareaNotificacion tareaNotif) {
		message.load(tareaNotif);
		
		// TODO: QUITAR ESTA LINEA (lo hace la línea anterior)
		tareaNotif.setGuid(this.getGuidTareaNotificacion(message));
		
		executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE,
				tareaNotif);
		logger.debug(String.format("[INTEGRACION] TAR [%s] Actualizando post crear tarea finalizado", tareaNotif.getGuid()));
	}
	
	@Transactional(readOnly = false)
	private void inicioTarea(AsuntoPayload message, Procedimiento procedimiento) {
		String refAsunto = message.getGuidAsunto();
		String prcUUID = getGuidProcedimiento(message);
		String tarUUID = getGuidTareaNotificacion(message);
		logger.debug(String.format("[INTEGRACION] TAR [%s] Creando tarea para el procedimiento %s asunto %s.", tarUUID, prcUUID, refAsunto));

		EXTTareaNotificacion tareaNotif = extTareaNotifificacionManager.getTareaNoficiacionByGuid(tarUUID);
		if (tareaNotif==null) {
			logger.debug(String.format("[INTEGRACION] TAR [%s] Creando tarea para el procedimiento %d.", tarUUID, procedimiento.getId()));
			tareaNotif = crearTarea(message, procedimiento, tarUUID);
			logger.debug(String.format("[INTEGRACION] TAR [%s] Tarea creada", tarUUID));
		}
	}

	
	
	@Transactional(readOnly = false)
	protected void finTarea(AsuntoPayload message) {
		String refAsunto = message.getGuidAsunto();
		String prcUUID = getGuidProcedimiento(message);
		String tarUUID = getGuidTareaNotificacion(message);
		logger.debug(String.format("[INTEGRACION] TAR [%s] Finalizando para el procedimiento %s asunto %s.", tarUUID, prcUUID, refAsunto));

		EXTTareaNotificacion tareaNotif = extTareaNotifificacionManager.getTareaNoficiacionByGuid(tarUUID);
		if (tareaNotif==null) {
			throw new IntegrationDataException(
					String.format("[INTEGRACION] La tarea procedimiento %s no existe para el procedimiento %s, NO SE FINALIZA LA TAREA."
							, tarUUID
							, prcUUID));
		}
		
		TareaExterna tex = tareaNotif.getTareaExterna();
		tex.setDetenida(false);
		logger.debug(String.format("[INTEGRACION] TEX [%d] Finalizando tarea.", tex.getId()));
		proxyFactory.proxy(TareaExternaApi.class).borrar(tex);
		logger.debug(String.format("[INTEGRACION] TEX [%d] Tarea finalizada.", tex.getId()));
		
		saveFormValues(message, tex);
	}

	@Transactional(readOnly = false)
	protected void cancelarTarea(AsuntoPayload message) {
		String refAsunto = message.getGuidAsunto();
		String prcUUID = getGuidProcedimiento(message);
		String tarUUID = getGuidTareaNotificacion(message);
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
		logger.debug(String.format("[INTEGRACION] TEX [%d] Cancelando tarea.", tex.getId()));
		proxyFactory.proxy(TareaExternaApi.class).borrar(tex);
		logger.debug(String.format("[INTEGRACION] TEX [%d] Tarea cancelada.", tex.getId()));
	}
	
	@Transactional(readOnly = false)
	private void activarTarea(AsuntoPayload message) {
		String refAsunto = message.getGuidAsunto();
		String prcUUID = getGuidProcedimiento(message);
		String tarUUID = getGuidTareaNotificacion(message);
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
		logger.debug(String.format("[INTEGRACION] TEX [%d] Activando tarea.", tex.getId()));
        tareaExternaManager.activar(tex);
		logger.debug(String.format("[INTEGRACION] PRC [%d] ACtivando procedimiento.", prc.getId()));
		prc.setEstaParalizado(false);
		procedimientoManager.saveProcedimiento(prc);
		logger.debug(String.format("[INTEGRACION] TEX [%d] Tarea y procedimientos activados.", tex.getId()));
			
	}

	@Transactional(readOnly = false)
	private void paralizarTarea(AsuntoPayload message) {
		String refAsunto = message.getGuidAsunto();
		String prcUUID = getGuidProcedimiento(message);
		String tarUUID = getGuidTareaNotificacion(message);
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
		logger.debug(String.format("[INTEGRACION] TEX [%d] Deteniendo tarea.", tex.getId()));
        tareaExternaManager.detener(tex);
		logger.debug(String.format("[INTEGRACION] PRC [%d] Deteniendo procedimiento.", prc.getId()));
		prc.setEstaParalizado(true);
		prc.setFechaUltimaParalizacion(new Date());
		procedimientoManager.saveProcedimiento(prc);
		logger.debug(String.format("[INTEGRACION] TEX [%d] Tarea y procedimientos activados.", tex.getId()));
			
			
	}

	@Transactional(readOnly = false)
	private void saveFormValues(AsuntoPayload message, TareaExterna tarea) {
		String tapCodigo = tarea.getTareaProcedimiento().getCodigo();
		logger.debug(String.format("[INTEGRACION] TAP [%s] Guardando campos formulario en tarea.", tapCodigo));
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "tareaProcedimiento.id", tarea.getTareaProcedimiento().getId()); 
		List<GenericFormItem> items = genericDao.getList(GenericFormItem.class, filtro);

		logger.debug(String.format("[INTEGRACION] TAP [%s] Num de items para encontrados en tarea: %d", tapCodigo, items.size()));
		
		Map<String, String> extraInfo = message.getExtraInfo();
		for (GenericFormItem item : items) {
			if (!extraInfo.containsKey(item.getNombre())) {
				logger.warn(String.format("[INTEGRACION] TAP [%s] TFI [%s] Campo no existe en la definición de recovery. ", tapCodigo, item.getNombre()));
				continue;
			}
			String valor = extraInfo.get(String.format("%s.%s", AsuntoPayload.KEY_TFI_FORM_ITEM, item.getNombre()));

			EXTTareaExternaValor tevValor = new EXTTareaExternaValor();
			tevValor.setTareaExterna(tarea);
			tevValor.setNombre(item.getNombre());
			tevValor.setValor(valor);
			
			// listaValores.add(valor);
			tareaExternaValorDao.saveOrUpdate(tevValor);
		}
		logger.debug(String.format("[INTEGRACION] TAP [%s] Fin campos guardados formulario.", tapCodigo));
	}

	@Override
	protected void doAction(AsuntoPayload message) {
		MEJProcedimiento procedimiento = getProcedimiento(message);
		if (message.getTipo().equals(IntegracionBpmService.TIPO_INICIO_TAREA)) {
			inicioTarea(message, procedimiento);
		} else if (message.getTipo().equals(IntegracionBpmService.TIPO_FINALIZACION_TAREA)) {
			finTarea(message);
		} else if (message.getTipo().equals(IntegracionBpmService.TIPO_CANCELACION_TAREA)) {
			cancelarTarea(message);
		} else if (message.getTipo().equals(IntegracionBpmService.TIPO_PARALIZAR_TAREA)) {
			paralizarTarea(message);
		} else if (message.getTipo().equals(IntegracionBpmService.TIPO_ACTIVAR_TAREA)) {
			activarTarea(message);
		}

	}
	
}
