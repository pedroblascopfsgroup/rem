package es.pfsgroup.recovery.integration.bpm.consumer;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.pfs.asunto.EXTAsuntoManager;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaValorDao;
import es.capgemini.pfs.prorroga.ProrrogaManager;
import es.capgemini.pfs.prorroga.dto.DtoSolicitarProrroga;
import es.capgemini.pfs.prorroga.model.Prorroga;
import es.capgemini.pfs.tareaNotificacion.EXTTareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;
import es.pfsgroup.recovery.integration.ConsumerAction;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.Rule;
import es.pfsgroup.recovery.integration.bpm.DiccionarioDeCodigos;
import es.pfsgroup.recovery.integration.bpm.payload.TareaNotificacionPayload;

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
public class TareaNotificacionConsumer extends ConsumerAction<DataContainerPayload> {

	protected final Log logger = LogFactory.getLog(getClass());
	
	private final String staDefecto;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	@Autowired
	private EXTTareaNotificacionManager extTareaNotifificacionManager;

	@Autowired
	private ProrrogaManager prorrogaManager;
	
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
	private EXTAsuntoManager extAsuntoManager;
    
	@Autowired
	private Executor executor;

	public TareaNotificacionConsumer(Rule<DataContainerPayload> rule, DiccionarioDeCodigos diccionarioCodigos, String staDefecto) {
		super(rule);
		this.staDefecto = staDefecto;
	}
	
	public TareaNotificacionConsumer(List<Rule<DataContainerPayload>> rules, DiccionarioDeCodigos diccionarioCodigos, String staDefecto) {
		super(rules);
		this.staDefecto = staDefecto; 
	}

	private String getGuidTareaNotificacion(TareaNotificacionPayload tareaPayload) {
		return tareaPayload.getGuid(); // String.format("%d-EXT", tareaPayload.getId());
	}

	private String getGuidEntidad(TareaNotificacionPayload tareaPayload) {
		return tareaPayload.getGuidEntidad(); // String.format("%d-EXT", tareaPayload.getIdEntidadInformacion());
	}

	private String getGuidTareaAsociadaAProrroga(TareaNotificacionPayload tareaPayload) {
		return tareaPayload.getGuidTareaAsociadaProrroga(); // String.format("%d-EXT", tareaPayload.getIdTareaAsociadaProrroga());
	}

	private void postCrearTarea(TareaNotificacionPayload tareaPayload, EXTTareaNotificacion tareaNotif) {

		acualizarProrroga(tareaPayload, tareaNotif);
		
		if (tareaPayload.getBorrada()) {
			proxyFactory.proxy(TareaNotificacionApi.class).borrarNotificacionTarea(tareaNotif.getId());
			logger.debug(String.format("[INTEGRACION] TAR[%s] Post crear tarea, tarea borrada!!", tareaNotif.getGuid()));			
		} else {
			
			// TODO: QUITAR ESTA LINEA (lo hace la línea anterior)
			tareaNotif.setGuid(this.getGuidTareaNotificacion(tareaPayload));
			//tareaNotif.setGuid(tareaExtenaPayload.getGuidTARTarea());
			tareaNotif.setFechaInicio(tareaPayload.getFechaInicio());
			tareaNotif.setFechaFin(tareaPayload.getFechaFin());
			tareaNotif.setFechaVenc(tareaPayload.getFechaVencimiento());
			tareaNotif.setFechaVencReal(tareaPayload.getFechaVencimientoReal());
			tareaNotif.setTarea(tareaPayload.getTarea());

			executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE, tareaNotif);
			logger.debug(String.format("[INTEGRACION] TAR[%s] Post crear tarea, tarea actualizada!!", tareaNotif.getGuid()));
		}
		
	}


	private void acualizarProrroga(TareaNotificacionPayload tareaPayload, EXTTareaNotificacion tareaNotif) {
		String tarUUID = getGuidTareaNotificacion(tareaPayload);

		String logMsg = String.format("[INTEGRACION] TAR[%s] Comprobando la existencia de prórroga...", tarUUID);
		logger.info(logMsg);
		
		if (!tareaPayload.contieneProrroga()) {
			logMsg = String.format("[INTEGRACION] TAR[%s] No se ha encontrado información de prórroga", tarUUID);
			logger.debug(logMsg);
			return;
		}

		logMsg = String.format("[INTEGRACION] TAR[%s] Creando prórroga...", tarUUID);
		logger.info(logMsg);
		
		DtoSolicitarProrroga dtoProrroga = new DtoSolicitarProrroga();
		
		if (tareaNotif.getProrroga()==null) { 

			logger.debug(String.format("[INTEGRACION] TAR[%s] Creando prórroga para tarea...", tarUUID));
			
			dtoProrroga.setFechaPropuesta(tareaPayload.getProrrogaFecha());
			String valor = tareaPayload.getProrrogaCausa();
			if (!Checks.esNulo(valor)) {
				logger.debug(String.format("[INTEGRACION] TAR[%s] CAU[%s] Asignando causa prórroga...", tarUUID, valor));
				dtoProrroga.setCodigoCausa(valor);
			}
			
			String tarNotifAsociadaGuid = getGuidTareaAsociadaAProrroga(tareaPayload);
			EXTTareaNotificacion tarNotifAsociada = extTareaNotifificacionManager.getTareaNoficiacionByGuid(tarNotifAsociadaGuid);
			dtoProrroga.setIdTareaAsociada(tarNotifAsociada.getId());
				
			Prorroga prorroga = prorrogaManager.crearNuevaProrroga(dtoProrroga);
			tareaNotif.setProrroga(prorroga);
			
		} else {
			
			logger.debug(String.format("[INTEGRACION] TAR[%s] Actualizando prórroga para tarea...", tarUUID));
			
			String valor = tareaPayload.getProrrogaRespuesta();
			if (!Checks.esNulo(valor)) {
				logger.debug(String.format("[INTEGRACION] TAR[%s] RES[%s] Asignando respuesta prórroga...", tarUUID, valor));
				dtoProrroga.setCodigoRespuesta(valor);
			}
			
			dtoProrroga.setIdProrroga(tareaNotif.getProrroga().getId());
			prorrogaManager.responderProrroga(dtoProrroga);
		}
		
		logMsg = String.format("[INTEGRACION] TAR[%s] Prórroga creada!", tarUUID);
		logger.info(logMsg);
		
	}

	@Override
	protected void doAction(DataContainerPayload payload) {
		TareaNotificacionPayload tareaPayload = new TareaNotificacionPayload(payload);
		String tarUID = getGuidTareaNotificacion(tareaPayload);

		logger.info(String.format("[INTEGRACION] TAR[%s] Guardando Tarea Notificación...", tarUID));
		
		SubtipoTarea subtipoTarea = genericDao.get(SubtipoTarea.class, genericDao.createFilter(FilterType.EQUALS, "codigoSubtarea", this.staDefecto));
		if (subtipoTarea==null) {
			String errorMsg = String.format("[INTEGRACION] El código STA [%s] proporcionado no es correcto o no existe!!.", this.staDefecto);
			logger.error(errorMsg);
			throw new IntegrationDataException(errorMsg);
		}
		
		String guid = getGuidTareaNotificacion(tareaPayload);
		EXTTareaNotificacion tarNotif = extTareaNotifificacionManager.getTareaNoficiacionByGuid(guid);
		if (tarNotif==null) {
			logger.info(String.format("[INTEGRACION] TAR[%s] Tarea no existe, se crea una nueva...", tarUID));
			String codigoTipoEntidad = tareaPayload.getTipoEntidad();
			String guidEntidad = getGuidEntidad(tareaPayload);

			if (Checks.esNulo(guidEntidad)) {
				String errorMsg = "[INTEGRACION] No se ha proporcionado GUID entidad para realizar la notificación!!";
				logger.error(errorMsg);
				throw new IntegrationDataException(errorMsg);
			}
			
			Long idEntidad = null;
			if (codigoTipoEntidad.equals(DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO)) {
				MEJProcedimiento prc = extProcedimientoManager.getProcedimientoByGuid(guidEntidad);
				if (Checks.esNulo(prc)) {
					String errorMsg = "[INTEGRACION] PRC[%s] El procedimiento no existe!!";
					logger.error(errorMsg);
					throw new IntegrationDataException(errorMsg);
				}
				// Comprueba la existencia
				idEntidad = prc.getId();
			} else if (codigoTipoEntidad.equals(DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO)) {
				EXTAsunto asu = extAsuntoManager.getAsuntoByGuid(guidEntidad);
				if (Checks.esNulo(asu)) {
					String errorMsg = "[INTEGRACION] ASU[%s] El asunto no existe!!";
					logger.error(errorMsg);
					throw new IntegrationDataException(errorMsg);
				}
				// Comprueba la existencia
				idEntidad = asu.getId();
			}
			
			if (Checks.esNulo(idEntidad)) {
				String errorMsg = "[INTEGRACION] ID_ENTIDAD[%s] no se ha encontrado ninguna entidad para este GUID!!";
				logger.error(errorMsg);
				throw new IntegrationDataException(errorMsg);
			}
			
			// STA PARA CREAR LA NOTIFICACION....
			String sta = this.staDefecto; //tareaPayload.getCodigoSTA();

			String descripcion = tareaPayload.getDescripcion();
			Long plazo = tareaPayload.getPlazo();
			Boolean enEspera = false;
			DtoGenerarTarea dto = new DtoGenerarTarea(idEntidad, codigoTipoEntidad, sta, enEspera, false, plazo, descripcion);
			Long idTarea = proxyFactory.proxy(TareaNotificacionApi.class).crearTarea(dto);
			TareaNotificacion tareaN = extTareaNotifificacionManager.get(idTarea); 
			tarNotif = EXTTareaNotificacion.instanceOf(tareaN);
			
			// Suplanta usuario pendiente de realizar la tarea (lo pone en el USAURIOBORRAR)
			// para mostrarlo en el histórico
			tarNotif.getAuditoria().setUsuarioBorrar(SecurityUtils.getCurrentUser().getUsername());			
		}
		
		logger.info(String.format("[INTEGRACION] TAR[%s] Guardando adicionales de Tarea Notificación...", tarUID));
		postCrearTarea(tareaPayload, tarNotif);
		logger.info(String.format("[INTEGRACION] TAR[%s] Tarea Notificación guardada!!", tarUID));
	}	
}
