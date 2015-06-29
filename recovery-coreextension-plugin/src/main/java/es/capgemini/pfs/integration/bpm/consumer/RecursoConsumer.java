package es.capgemini.pfs.integration.bpm.consumer;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.integration.AsuntoPayload;
import es.capgemini.pfs.integration.ConsumerAction;
import es.capgemini.pfs.integration.IntegrationDataException;
import es.capgemini.pfs.integration.Rule;
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

public class RecursoConsumer extends ConsumerAction<AsuntoPayload> {
	
	public RecursoConsumer(Rule<AsuntoPayload> rules) {
		super(rules);
	}
	
	public RecursoConsumer(List<Rule<AsuntoPayload>> rules) {
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

	private String getMEJRecursoGuid(AsuntoPayload payload) {
		return String.format("%s-EXT", payload.getIdOrigen().get("rec")); //payload.getGuid().get("rec");
	}

	private String getMEJProcedimientoGuid(AsuntoPayload payload) {
		return String.format("%s-EXT", payload.getIdOrigen().get(AsuntoPayload.KEY_PROCEDIMIENTO)); //payload.getGuid().get(Payload.KEY_PROCEDIMIENTO);
	}
	
	
	private MEJRecurso load(AsuntoPayload payload) {
		String valor;

		String recursoGuid = getMEJRecursoGuid(payload);
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
		valor = getMEJProcedimientoGuid(payload);
		MEJProcedimiento prc = extProcedimientoManager.getProcedimientoByGuid(valor);
		if (prc==null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El procedimiento con guid %s asociado al recurso s no existe", valor)); 
		}
		recurso.setProcedimiento(prc);

		//
		valor = (String)payload.getCodigo().get("actor");
		if (!Checks.esNulo(valor)) {
			DDActor actor = (DDActor)diccionarioApi.dameValorDiccionarioByCod(DDActor.class, valor);
			recurso.setActor(actor);
		}
		
		//
		valor = (String)payload.getCodigo().get("tipoRecurso");
		if (!Checks.esNulo(valor)) {
			DDTipoRecurso tipoRecurso = (DDTipoRecurso)diccionarioApi.dameValorDiccionarioByCod(DDTipoRecurso.class, valor);
			recurso.setTipoRecurso(tipoRecurso);
		}

		//
		valor = (String)payload.getCodigo().get("causaRecurso");
		if (!Checks.esNulo(valor)) {
			DDCausaRecurso causaRecurso = (DDCausaRecurso)diccionarioApi.dameValorDiccionarioByCod(DDCausaRecurso.class, valor);
			recurso.setCausaRecurso(causaRecurso);
		}
		
		//
		valor = (String)payload.getCodigo().get("resultadoResolucion");
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
		
		recurso.setFechaImpugnacion(payload.getFecha().get("fechaImpugnacion"));
		recurso.setFechaRecurso(payload.getFecha().get("fechaRecurso"));
		recurso.setFechaVista(payload.getFecha().get("fechaVista"));
		recurso.setFechaResolucion(payload.getFecha().get("fechaResolucion"));
		recurso.setObservaciones(payload.getExtraInfo().get("observaciones"));

		recurso.setConfirmarVista(payload.getFlag().get("confirmarVista"));
		recurso.setConfirmarImpugnacion(payload.getFlag().get("confirmarImpugnacion"));
		recurso.setSuspensivo(payload.getFlag().get("suspensivo"));
		
		return recurso;
	}	
	
	@Override
	protected void doAction(AsuntoPayload payLoad) {
		MEJDtoRecurso dtoRecurso = new MEJDtoRecurso();
		
		// Info de usuario
		boolean esGestor = (payLoad.getFlag().containsKey("esGestor")) ? payLoad.getFlag().get("esGestor") : false;
		boolean esSupervisor =(payLoad.getFlag().containsKey("esSupervisor")) ? payLoad.getFlag().get("esSupervisor") : false;

		// Datos del recurso.
		MEJRecurso mejRecurso = load(payLoad);
		dtoRecurso.setRecurso(mejRecurso);
		
		// BO negocio
		mejRecursoManager.createOrUpdateUserInfo(dtoRecurso, esGestor, esSupervisor);
	}

}
