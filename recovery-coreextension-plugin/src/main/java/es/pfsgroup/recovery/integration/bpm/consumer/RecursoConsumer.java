package es.pfsgroup.recovery.integration.bpm.consumer;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.procesosJudiciales.model.DDResultadoResolucion;
import es.capgemini.pfs.recurso.model.DDActor;
import es.capgemini.pfs.recurso.model.DDCausaRecurso;
import es.capgemini.pfs.recurso.model.DDTipoRecurso;
import es.capgemini.pfs.tareaNotificacion.EXTTareaNotificacionManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.recurso.MEJRecursoManager;
import es.pfsgroup.plugin.recovery.mejoras.recurso.dto.MEJDtoRecurso;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;
import es.pfsgroup.recovery.integration.ConsumerAction;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.Rule;
import es.pfsgroup.recovery.integration.bpm.payload.RecursoPayload;

public class RecursoConsumer extends ConsumerAction<DataContainerPayload> {
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	public RecursoConsumer(Rule<DataContainerPayload> rules) {
		super(rules);
	}
	
	public RecursoConsumer(List<Rule<DataContainerPayload>> rules) {
		super(rules);
	}

	@Autowired
	private MEJRecursoManager mejRecursoManager;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private EXTProcedimientoManager extProcedimientoManager;
	
	@Autowired
	private EXTTareaNotificacionManager extTareaNotificacionManager;

	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	private String getMEJRecursoGuid(RecursoPayload recurso) {
		return recurso.getGuid(); // String.format("%s-EXT", recurso.getIdOrigen()); 
	}

	private String getMEJProcedimientoGuid(RecursoPayload recurso) {
		return recurso.getProcedimiento().getGuid(); // String.format("%s-EXT", recurso.getProcedimiento().getIdOrigen()); 
	}
	
	
	private MEJRecurso load(RecursoPayload recursoPayload) {
		String valor;

		String recursoGuid = getMEJRecursoGuid(recursoPayload);
		if (Checks.esNulo(recursoGuid)) {
			throw new IntegrationDataException("[INTEGRACION] No se puede procesar recurso, no tiene guid");
		}

		// comprobamos si existe antes de crear uno nuevo...
		MEJRecurso recurso = mejRecursoManager.getRecursoByGuid(recursoGuid);
		if (recurso == null) {
			recurso = new MEJRecurso();
			recurso.setGuid(recursoGuid);
		}
		
		//
		valor = getMEJProcedimientoGuid(recursoPayload);
		MEJProcedimiento prc = extProcedimientoManager.getProcedimientoByGuid(valor);
		if (prc==null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El procedimiento con guid %s asociado al recurso s no existe", valor)); 
		}
		recurso.setProcedimiento(prc);

		//
		valor = recursoPayload.getActor();
		if (!Checks.esNulo(valor)) {
			DDActor actor = (DDActor)diccionarioApi.dameValorDiccionarioByCod(DDActor.class, valor);
			recurso.setActor(actor);
		}
		
		//
		valor = recursoPayload.getTipoRecurso();
		if (!Checks.esNulo(valor)) {
			DDTipoRecurso tipoRecurso = (DDTipoRecurso)diccionarioApi.dameValorDiccionarioByCod(DDTipoRecurso.class, valor);
			recurso.setTipoRecurso(tipoRecurso);
		}

		//
		valor = recursoPayload.getCausaRecurso();
		if (!Checks.esNulo(valor)) {
			DDCausaRecurso causaRecurso = (DDCausaRecurso)diccionarioApi.dameValorDiccionarioByCod(DDCausaRecurso.class, valor);
			recurso.setCausaRecurso(causaRecurso);
		}
		
		//
		valor = recursoPayload.getResuladoResolucion();
		if (!Checks.esNulo(valor)) {
			DDResultadoResolucion resultadoResolucion = (DDResultadoResolucion)diccionarioApi.dameValorDiccionarioByCod(DDResultadoResolucion.class, valor);
			recurso.setResultadoResolucion(resultadoResolucion);
		}

		/*
		valor = payload.getGuid().get(Payload.KEY_TAR_TAREA);
		EXTTareaNotificacion tareaNotificacion = extTareaNotificacionManager.getTareaNoficiacionByGuid(valor);
		if (tareaNotificacion==null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] La tarea con guid %s asociada al recurso no existe", valor)); 
		}
		recurso.setTareaNotificacion(tareaNotificacion);
		*/
		
		recurso.setFechaImpugnacion(recursoPayload.getFechaImpugnacion());
		recurso.setFechaRecurso(recursoPayload.getFechaRecurso());
		recurso.setFechaVista(recursoPayload.getFechaVista());
		recurso.setFechaResolucion(recursoPayload.getFechaResolucion());
		recurso.setObservaciones(recursoPayload.getObservaciones());

		recurso.setConfirmarVista(recursoPayload.getConfirmarVista());
		recurso.setConfirmarImpugnacion(recursoPayload.getConfirmarImpugnacion());
		recurso.setSuspensivo(recursoPayload.isSuspensivo());
		
		return recurso;
	}	
	
	@Override
	protected void doAction(DataContainerPayload payLoad) {
		RecursoPayload recurso = new RecursoPayload(payLoad);
		String recursoUID = getMEJRecursoGuid(recurso);
		String prcUID = getMEJProcedimientoGuid(recurso);
		
		logger.info(String.format("[INTEGRACION] PRC[%s] REC[%s] Guardando recurso...", prcUID, recursoUID));
		
		MEJDtoRecurso dtoRecurso = new MEJDtoRecurso();
		
		// Info de usuario
		boolean esGestor = recurso.esGestor();
		boolean esSupervisor =recurso.esSupervisor();

		// Datos del recurso.
		MEJRecurso mejRecurso = load(recurso);
		dtoRecurso.setRecurso(mejRecurso);
		
		// BO negocio
		mejRecursoManager.createOrUpdateUserInfo(dtoRecurso, esGestor, esSupervisor);
		logger.info(String.format("[INTEGRACION] PRC[%s] REC[%s] Recurso guardado!!", prcUID, recursoUID));
	}

}
