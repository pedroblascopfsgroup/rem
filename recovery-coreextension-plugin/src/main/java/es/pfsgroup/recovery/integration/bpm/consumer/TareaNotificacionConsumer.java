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
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaValorDao;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.tareaNotificacion.EXTTareaNotificacionManager;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
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
import es.pfsgroup.recovery.integration.bpm.TareaNotificacionPayload;
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
public class TareaNotificacionConsumer extends ConsumerAction<DataContainerPayload> {

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

	public TareaNotificacionConsumer(Rule<DataContainerPayload> rule, DiccionarioDeCodigos diccionarioCodigos) {
		super(rule);
		this.diccionarioCodigos = diccionarioCodigos; 
	}
	
	public TareaNotificacionConsumer(List<Rule<DataContainerPayload>> rules, DiccionarioDeCodigos diccionarioCodigos) {
		super(rules);
		this.diccionarioCodigos = diccionarioCodigos; 
	}

	private String getGuidTareaNotificacion(TareaNotificacionPayload tareaPayload) {
		return String.format("%d-EXT", tareaPayload.getId()); // message.getGuid();
	}

	private void suplantarUsuario(UsuarioPayload usuarioPayload, Auditable auditable) {
		Auditoria auditoria = auditable.getAuditoria();
		if (auditoria==null) {
			auditoria = Auditoria.getNewInstance();
		}
		auditoria.setSuplantarUsuario(usuarioPayload.getNombre());
		auditoria.setUsuarioCrear(usuarioPayload.getNombre());
	}
	
	private void postCrearTarea(TareaNotificacionPayload tareaPayload, EXTTareaNotificacion tareaNotif) {
		
		// TODO: QUITAR ESTA LINEA (lo hace la línea anterior)
		tareaNotif.setGuid(this.getGuidTareaNotificacion(tareaPayload));
		//tareaNotif.setGuid(tareaExtenaPayload.getGuidTARTarea());
		tareaNotif.setFechaInicio(tareaPayload.getFechaInicio());
		tareaNotif.setFechaFin(tareaPayload.getFechaFin());
		tareaNotif.setFechaVenc(tareaPayload.getFechaVencimiento());
		tareaNotif.setFechaVencReal(tareaPayload.getFechaVencimientoReal());
		suplantarUsuario(tareaPayload.getUsuario(), tareaNotif);
		
		executor.execute(ComunBusinessOperation.BO_TAREA_MGR_SAVE_OR_UPDATE,
				tareaNotif);
		logger.debug(String.format("[INTEGRACION] TAR [%s] Actualizando post crear tarea finalizado", tareaNotif.getGuid()));
	}
	
	@Override
	protected void doAction(DataContainerPayload payload) {
		TareaNotificacionPayload tareaPayload = new TareaNotificacionPayload(payload);
		String guid = getGuidTareaNotificacion(tareaPayload);
		EXTTareaNotificacion tarNotif = extTareaNotifificacionManager.getTareaNoficiacionByGuid(guid);
		if (tarNotif==null) {
			Long idEntidad = tareaPayload.getIdEntidadInformacion();
			String codigoTipoEntidad = tareaPayload.getTipoEntidad();
			String sta = tareaPayload.getCodigoSTA();
			String descripcion = tareaPayload.getDescripcion();
			Long plazo = tareaPayload.getPlazo();
			Boolean enEspera = false;
			DtoGenerarTarea dto = new DtoGenerarTarea(idEntidad, codigoTipoEntidad, sta, enEspera, false, plazo, descripcion);
			tareaPayload.getCodigoSTA();
			Long idTarea = proxyFactory.proxy(TareaNotificacionApi.class).crearTarea(dto);
			TareaNotificacion tareaN = extTareaNotifificacionManager.get(idTarea); 
			tarNotif = EXTTareaNotificacion.instanceOf(tareaN);
		}
		postCrearTarea(tareaPayload, tarNotif);
	}
	
}
