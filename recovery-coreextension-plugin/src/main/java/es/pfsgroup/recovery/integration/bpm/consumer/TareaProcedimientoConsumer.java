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
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.core.api.procesosJudiciales.dto.EXTDtoCrearTareaExterna;
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
import es.pfsgroup.recovery.integration.ConsumerAction;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.Rule;
import es.pfsgroup.recovery.integration.bpm.DiccionarioDeCodigos;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;
import es.pfsgroup.recovery.integration.bpm.payload.TareaExternaPayload;

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
	
	private final String staDefecto;
	
	private ProcedimientoConsumer procedimientoConsumer;

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

	public TareaProcedimientoConsumer(Rule<DataContainerPayload> rule, DiccionarioDeCodigos diccionarioCodigos, String staDefecto) {
		super(rule);
		this.staDefecto = staDefecto;
	}
	
	public TareaProcedimientoConsumer(List<Rule<DataContainerPayload>> rules, DiccionarioDeCodigos diccionarioCodigos, String staDefecto) {
		super(rules);
		this.staDefecto = staDefecto;
	}

	public ProcedimientoConsumer getProcedimientoConsumer() {
		return procedimientoConsumer;
	}

	public void setProcedimientoConsumer(ProcedimientoConsumer procedimientoConsumer) {
		this.procedimientoConsumer = procedimientoConsumer;
	}
	
	private String getGuidProcedimiento(TareaExternaPayload tareaExtenaPayload) {
		return tareaExtenaPayload.getProcedimiento().getGuid(); // String.format("%d-EXT", tareaExtenaPayload.getProcedimiento().getIdOrigen());
	}

	private String getGuidTareaNotificacion(TareaExternaPayload tareaExtenaPayload) {
		return tareaExtenaPayload.getGuidTARTarea(); // String.format("%d-EXT", tareaExtenaPayload.getIdTARTarea());
	}
	
	@Transactional(readOnly = false)
	private MEJProcedimiento getProcedimiento(TareaExternaPayload tareaExtenaPayload) {
		String prcUUID = getGuidProcedimiento(tareaExtenaPayload);
		logger.debug(String.format("[INTEGRACION] PRC[%s] Configurando procedimiento", prcUUID));
		MEJProcedimiento prc = extProcedimientoManager.getProcedimientoByGuid(prcUUID);
		if (prc==null && procedimientoConsumer != null) {
				String errorMsg = String.format("[INTEGRACION] PRC[%s] El procedimiento no existe!, se intenta crear uno nuevo.", prcUUID);
				logger.warn(errorMsg);
				procedimientoConsumer.doAction(tareaExtenaPayload.getData());
				prc = extProcedimientoManager.getProcedimientoByGuid(prcUUID);
		}
		if (prc==null) {
			String errorMsg = String.format("[INTEGRACION] PRC[%s] El procedimiento no existe!!, no podemos continuar!.", prcUUID);
			logger.error(errorMsg);
			throw new IntegrationDataException(errorMsg);
		}
		return prc;
	}
	
	@Transactional(readOnly = false)
	private EXTTareaNotificacion crearTarea(TareaExternaPayload tareaExtenaPayload, Procedimiento procedimiento) {
		String prcUUID = getGuidProcedimiento(tareaExtenaPayload);
		String tarUUID = getGuidTareaNotificacion(tareaExtenaPayload);
		String codTAPTarea = tareaExtenaPayload.getCodigoTAPTarea();
		logger.info(String.format("[INTEGRACION] TAR[%s] Creando tarea...", tarUUID));

		TareaProcedimiento tareaProcedimiento = proxyFactory.proxy(TareaProcedimientoApi.class)
				.getByCodigoTareaIdTipoProcedimiento(procedimiento.getTipoProcedimiento().getId(), codTAPTarea);
		if (tareaProcedimiento==null) {
			String errorMsg = String.format("[INTEGRACION] PRC[%s] TAR[%s] TAP[%s] La tarea procedimiento no existe para el tipo de procedimiento [%s]!!!! NO SE INICIA LA TAREA."
					, prcUUID
					, tarUUID
					, codTAPTarea
					, procedimiento.getTipoProcedimiento().getCodigo());
			logger.error(errorMsg);
			throw new IntegrationDataException(errorMsg);
		}
		logger.debug(String.format("[INTEGRACION] TAR[%s] TAP[%s] Tarea procedimiento encontrada", tarUUID, tareaProcedimiento.getCodigo()));
		
		String subtipoTarea = this.staDefecto; //getSubTipoTarea(tareaProcedimiento);
		HashMap<String, Object> valores = new HashMap<String, Object>();
		valores.put("codigoSubtipoTarea", subtipoTarea);
		valores.put("plazo", 1);					// Luego se modificará con los valores que llegan
		valores.put("descripcion", tareaExtenaPayload.getDescripcion());
		valores.put("idProcedimiento", procedimiento.getId());
		valores.put("idTareaProcedimiento", tareaProcedimiento.getId());
		valores.put("tokenIdBpm", null);

		logger.info(String.format("[INTEGRACION] TAR[%s] Guardando datos de la tarea", tarUUID));
		EXTDtoCrearTareaExterna dto = DynamicDtoUtils.create(EXTDtoCrearTareaExterna.class, valores);
		Long idTarea = proxyFactory.proxy(TareaExternaApi.class).crearTareaExternaDto(dto);

		logger.info(String.format("[INTEGRACION] TAR[%s] Gguardando datos adicionales...", tarUUID));
		TareaExterna tex = tareaExternaManager.get(idTarea);
		EXTTareaNotificacion tareaNotif = (EXTTareaNotificacion)tex.getTareaPadre(); 
		postCrearTarea(tareaExtenaPayload, tareaNotif);
		logger.info(String.format("[INTEGRACION] TAR[%s] Tarea creada correctamente!!!", tarUUID));
		return tareaNotif;
	}

	private void postCrearTarea(TareaExternaPayload tareaExtenaPayload, EXTTareaNotificacion tareaNotif) {
		// TODO: QUITAR ESTA LINEA (lo hace la línea anterior)
		tareaNotif.setGuid(this.getGuidTareaNotificacion(tareaExtenaPayload));
		//tareaNotif.setGuid(tareaExtenaPayload.getGuidTARTarea());
		tareaNotif.setFechaInicio(tareaExtenaPayload.getFechaInicio());
		tareaNotif.setFechaFin(tareaExtenaPayload.getFechaFin());
		tareaNotif.setFechaVenc(tareaExtenaPayload.getFechaVencimiento());
		tareaNotif.setFechaVencReal(tareaExtenaPayload.getFechaVencimientoReal());
		tareaNotif.getAuditoria().setUsuarioBorrar(tareaExtenaPayload.getData().getUsername());
		
		executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tareaNotif);
		logger.debug(String.format("[INTEGRACION] TAR[%s] Actualizando post crear tarea finalizado", tareaNotif.getGuid()));
	}
	
	@Transactional(readOnly = false)
	private EXTTareaNotificacion recuperaYCreaTareaNotificacion(Procedimiento procedimiento, TareaExternaPayload tareaExtenaPayload) {
		String refAsunto = tareaExtenaPayload.getProcedimiento().getAsunto().getGuid();
		String prcUUID = getGuidProcedimiento(tareaExtenaPayload);
		String tarUUID = getGuidTareaNotificacion(tareaExtenaPayload);

		String logMsg = String.format("[INTEGRACION] ASU[%s] PRC[%s] TAR[%s] Recuperando tarea...", refAsunto, prcUUID, tarUUID);
		logger.info(logMsg);

		EXTTareaNotificacion tareaNotif = extTareaNotifificacionManager.getTareaNoficiacionByGuid(tarUUID);
		if (tareaNotif==null) {
			logMsg = String.format("[INTEGRACION] ASU[%s] PRC[%s] TAR[%s] Ups, La tarea no existe!! se intenta crear una nueva...", refAsunto, prcUUID, tarUUID);
			logger.info(logMsg);
			tareaNotif = crearTarea(tareaExtenaPayload, procedimiento);
			tareaNotif = extTareaNotifificacionManager.getTareaNoficiacionByGuid(tarUUID);
/*	Se quita para ser nemos restrictivos...  tarea que no existe se crea...
  			throw new IntegrationDataException(
					String.format("[INTEGRACION] La tarea procedimiento %s no existe para el procedimiento %s, NO SE FINALIZA LA TAREA."
							, tarUUID
							, prcUUID));
*/
		}
		return tareaNotif;
	}

	@Transactional(readOnly = false)
	protected void finTarea(TareaExternaPayload tareaExtenaPayload, EXTTareaNotificacion tareaNotif) {
		TareaExterna tex = tareaExternaManager.getByIdTareaNotificacion(tareaNotif.getId());
		String tarUUID = getGuidTareaNotificacion(tareaExtenaPayload);
		//
		String logMsg = String.format("[INTEGRACION] TAR[%s] TEX[%d] Cerrando tarea externa...", tarUUID, tex.getId());
		logger.debug(logMsg);
		//suplantarUsuario(tareaExtenaPayload.getUsuario(), tex);
		//suplantarUsuario(tareaExtenaPayload.getUsuario(), tex.getTareaPadre());
		tex.setDetenida(false);
		//
		proxyFactory.proxy(TareaExternaApi.class).borrar(tex);
		logMsg = String.format("[INTEGRACION] TEX[%d] Tarea externa cerrada!!", tex.getId());
		logger.debug(logMsg);

		saveFormValues(tareaExtenaPayload, tex);
	}

	@Transactional(readOnly = false)
	protected void cancelarTarea(TareaExternaPayload tareaExtenaPayload, EXTTareaNotificacion tareaNotif) {
		TareaExterna tex = tareaExternaManager.getByIdTareaNotificacion(tareaNotif.getId());
		String tarUUID = getGuidTareaNotificacion(tareaExtenaPayload);
		//
		String logMsg = String.format("[INTEGRACION] TAR[%s] TEX[%d] Cancelando tarea externa...", tarUUID, tex.getId());
		logger.info(logMsg);
        tex.setCancelada(true);
        tex.setDetenida(false);
		//suplantarUsuario(tareaExtenaPayload.getUsuario(), tex);
		//suplantarUsuario(tareaExtenaPayload.getUsuario(), tex.getTareaPadre());
		//
		proxyFactory.proxy(TareaExternaApi.class).borrar(tex);
		logMsg = String.format("[INTEGRACION] TEX [%d] Tarea externa cancelada!!!", tex.getId());
		logger.debug(logMsg);
	}
	
	@Transactional(readOnly = false)
	private void activarTarea(TareaExternaPayload tareaExtenaPayload, EXTTareaNotificacion tareaNotif) {
		MEJProcedimiento prc = MEJProcedimiento.instanceOf(tareaNotif.getProcedimiento());
		TareaExterna tex = tareaExternaManager.getByIdTareaNotificacion(tareaNotif.getId());
		String tarUUID = getGuidTareaNotificacion(tareaExtenaPayload);
		//
		String logMsg = String.format("[INTEGRACION] TAR[%s] TEX[%d] Activando tarea externa...", tarUUID, tex.getId());
		logger.info(logMsg);
		//suplantarUsuario(tareaExtenaPayload.getUsuario(), tex);
        tareaExternaManager.activar(tex);
        //
        logMsg = String.format("[INTEGRACION] PRC[%d] TEX[%d] Activando procedimiento.", prc.getId(), tex.getId());
		logger.info(logMsg);
		prc.setEstaParalizado(false);
		//suplantarUsuario(tareaExtenaPayload.getUsuario(), prc);
		procedimientoManager.saveProcedimiento(prc);
		logMsg = String.format("[INTEGRACION] PRC[%d] TEX[%d] Tarea y procedimientos activados!!", prc.getId(), tex.getId());
		logger.debug(logMsg);
	}

	@Transactional(readOnly = false)
	private void paralizarTarea(TareaExternaPayload tareaExtenaPayload, EXTTareaNotificacion tareaNotif) {
		MEJProcedimiento prc = MEJProcedimiento.instanceOf(tareaNotif.getProcedimiento());
		TareaExterna tex = tareaExternaManager.getByIdTareaNotificacion(tareaNotif.getId());
		//
		String logMsg = String.format("[INTEGRACION] TEX[%d] Paralizando tarea y procedimiento...", tex.getId());
		logger.info(logMsg);
		//suplantarUsuario(tareaExtenaPayload.getUsuario(), tex);
        tareaExternaManager.detener(tex);
        //
        logMsg = String.format("[INTEGRACION] PRC[%d] TEX[%d] Paralizando procedimiento.", prc.getId(), tex.getId());
		logger.info(logMsg);
		prc.setEstaParalizado(true);
		prc.setFechaUltimaParalizacion(new Date());
		//suplantarUsuario(tareaExtenaPayload.getUsuario(), prc);
		//
		procedimientoManager.saveProcedimiento(prc);
		logMsg = String.format("[INTEGRACION] TEX[%d] Tarea y procedimientos paralizados!!!", tex.getId());
		logger.debug(logMsg);
	}

	@Transactional(readOnly = false)
	private void saveFormValues(TareaExternaPayload tareaExtenaPayload, TareaExterna tarea) {
		String tapCodigo = tarea.getTareaProcedimiento().getCodigo();
		logger.info(String.format("[INTEGRACION] TAP [%s] Guardando campos formulario en tarea.", tapCodigo));

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
			//suplantarUsuario(tareaExtenaPayload.getUsuario(), tevValor);

			// listaValores.add(valor);
			tareaExternaValorDao.saveOrUpdate(tevValor);
		}
		logger.debug(String.format("[INTEGRACION] TAP [%s] Fin campos guardados formulario.", tapCodigo));
	}

	@Override
	protected void doAction(DataContainerPayload payload) {

		TareaExternaPayload tareaExtenaPayload = new TareaExternaPayload(payload);
		String asuGUID = tareaExtenaPayload.getProcedimiento().getAsunto().getGuid();
		String prcUUID = getGuidProcedimiento(tareaExtenaPayload);
		String tarUUID = getGuidTareaNotificacion(tareaExtenaPayload);

		logger.info(String.format("[INTEGRACION] ASU[%s] PRC[%s] TAR[%s] Guardando tarea externa...", asuGUID, prcUUID, tarUUID));
		
		SubtipoTarea subtipoTarea = genericDao.get(SubtipoTarea.class, genericDao.createFilter(FilterType.EQUALS, "codigoSubtarea", this.staDefecto));
		if (subtipoTarea==null) {
			String errorMsg = String.format("[INTEGRACION] El código STA [%s] proporcionado no es correcto o no existe!!.", this.staDefecto);
			logger.error(errorMsg);
			throw new IntegrationDataException(errorMsg);
		}
		
		//
		logger.info(String.format("[INTEGRACION] ASU[%s] PRC[%s] TAR[%s] Recuperando procedimiento...", asuGUID, prcUUID, tarUUID));
		MEJProcedimiento procedimiento = getProcedimiento(tareaExtenaPayload);

		logger.info(String.format("[INTEGRACION] ASU[%s] PRC[%s] TAR[%s] Recuperando Tarea...", asuGUID, prcUUID, tarUUID));
		EXTTareaNotificacion tareaNotif = recuperaYCreaTareaNotificacion(procedimiento, tareaExtenaPayload);
		
		//if (payload.getTipo().equals(IntegracionBpmService.TIPO_INICIO_TAREA)) {
		//	inicioTarea(procedimiento, tareaExtenaPayload);
		//} else if (payload.getTipo().equals(IntegracionBpmService.TIPO_FINALIZACION_TAREA)) {
		if (payload.getTipo().equals(IntegracionBpmService.TIPO_FINALIZACION_TAREA)) {
			logger.info(String.format("[INTEGRACION] ASU[%s] PRC[%s] TAR[%s] Finalizando Tarea...", asuGUID, prcUUID, tarUUID));
			finTarea(tareaExtenaPayload, tareaNotif);
		} else if (payload.getTipo().equals(IntegracionBpmService.TIPO_CANCELACION_TAREA)) {
			logger.info(String.format("[INTEGRACION] ASU[%s] PRC[%s] TAR[%s]  Cancelando Tarea...", asuGUID, prcUUID, tarUUID));
			cancelarTarea(tareaExtenaPayload, tareaNotif);
		} else if (payload.getTipo().equals(IntegracionBpmService.TIPO_PARALIZAR_TAREA)) {
			logger.info(String.format("[INTEGRACION] ASU[%s] PRC[%s] TAR[%s]  Paralizando Tarea...", asuGUID, prcUUID, tarUUID));
			paralizarTarea(tareaExtenaPayload, tareaNotif);
		} else if (payload.getTipo().equals(IntegracionBpmService.TIPO_ACTIVAR_TAREA)) {
			logger.info(String.format("[INTEGRACION] ASU[%s] PRC[%s] TAR[%s] Activando tarea paralizada...", asuGUID, prcUUID, tarUUID));
			activarTarea(tareaExtenaPayload, tareaNotif);
		}

	}

}
