package es.pfsgroup.plugin.rem.jbpm.handler;

import java.io.IOException;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.prorroga.model.Prorroga;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.adapter.AgendaAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterServiceFactoryApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

public class ActivoGenericLeaveActionHandler extends ActivoGenericActionHandler {

	private static final long serialVersionUID = -5256087821622834764L;
	
    @Autowired
    private ActivoTareaExternaApi activoTareaExternaManagerApi;
    
    @Autowired
    private UpdaterServiceFactoryApi updaterServiceFactory;

    @Autowired
    private UpdaterStateApi updaterState;
    
	@Autowired
	private AgendaAdapter agendaAdapter;
	
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    public static final String COD_TAP_TAREA_AUTORIZACION_PROPIEDAD = "T017_ResolucionPROManzana";
	public static final String COD_TAP_TAREA_ADVISORY_NOTE = "T017_AdvisoryNote";
	public static final String COD_TAP_TAREA_RECOM_ADVISORY= "T017_RecomendCES";

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) {
		printInfoNode("Sale nodo", executionContext);
		
		// Llamamos al nodo genérico de transición
		if (delegateTransitionClass instanceof ActivoJBPMLeaveEventHandler) {
			((ActivoJBPMLeaveEventHandler) delegateTransitionClass).onLeave(executionContext);
		}

		// Llamamos al nodo específico
		if (delegateSpecificClass instanceof ActivoJBPMLeaveEventHandler) {
			((ActivoJBPMLeaveEventHandler) delegateSpecificClass).onLeave(executionContext);
		}

		if (!BPMContants.TRANSICION_VUELTA_ATRAS.equals(delegateTransitionClass)) {
			if (debeDestruirTareaProcedimiento(executionContext)) {
				if (isDecisionNode(executionContext)) {
					String nombreDecision = getNombreNodo(executionContext) + "Decision";
					setVariable(nombreDecision, getDecision(executionContext), executionContext);
					logger.error("\tDecisión de la tarea: " + getVariable(nombreDecision, executionContext));
				}
				
				this.borraTimersTarea(getTareaExterna(executionContext).getId());

				finalizarTarea(executionContext);
				finalizarOperacionesAsociadas(executionContext);
			}
		}

		// Borramos las posibles variables de listado de tareas del nodo
		executionContext.getContextInstance().deleteVariable(BPMContants.BPM_LISTADO_TAREAS_VUELTA_ATRAS + "_" + getNombreNodo(executionContext));

		// Añadimos el nombre del nodo actual al contexto para poder detectar
		// una reentrada en el PROGenericEnterActionHandler
		setVariable(ConstantesBPMPFS.NOMBRE_NODO_SALIENTE, getNombreNodo(executionContext), executionContext);
		
		//HREOS-3393
		if(!SALTO_T013_RESOLUCION_EXPEDIENTE.equals(getTransitionName(executionContext))) {
			// Guardado adicional de datos de la tarea
			guardadoAdicionalTarea(executionContext);
			
			// Actualizamos los check de admisión y gestión
			actualizarEstados(executionContext);
		}
	}

	/**
	 * Finaliza las operaciones asociadas a la tarea (prorrogas, ...).
	 */
	protected void finalizarOperacionesAsociadas(ExecutionContext executionContext) {
		// Buscamos si tiene prorroga activa
		Prorroga prorroga = getTareaExterna(executionContext).getTareaPadre().getProrrogaAsociada();

		// Borramos (finalizamos) la prorroga si es que tiene
		if (prorroga != null) {
			proxyFactory.proxy(TareaNotificacionApi.class).borrarNotificacionTarea(prorroga.getTarea().getId());
			// tareaNotificacionManager.borrarNotificacionTarea(prorroga.getTarea().getId());
		}
	}

	/**
	 * Finaliza la tarea activa del BPM del procedimiento.
	 */
	protected void finalizarTarea(ExecutionContext executionContext) {
		TareaExterna tareaExterna = getTareaExterna(executionContext);
		// TareaNotificacion tarea = tareaExterna.getTareaPadre();
		TareaProcedimiento tareaProcedimiento = tareaExterna.getTareaProcedimiento();

		String scriptValidacion = tareaProcedimiento.getScriptValidacionJBPM();
		// String scriptAmpliado =
		// context.get(BPMContants.FUNCIONES_GLOBALES_SCRIPT) +
		// scriptValidacion;

		/**
		 * Comprobamos que la transicion que se está ejecutando es la de vuelta
		 * atras. En tal caso, no debe ejecutar el script de validacion, dado
		 * que está volviendo hacia atrás
		 */
		String transicion = executionContext.getTransition().getName();
		boolean transicionSalto = transicion.startsWith("salto") || ActivoBaseActionHandler.SALTO_CIERRE_ECONOMICO.equals(transicion) || ActivoBaseActionHandler.SALTO_RESOLUCION_EXPEDIENTE.equals(transicion);
		if (!BPMContants.TRANSICION_VUELTA_ATRAS.equals(transicion) && !StringUtils.isBlank(scriptValidacion) && !transicionSalto && !transicion.toLowerCase().equals("fin") && !transicion.toLowerCase().equals("saltofin")) {
			try {

				avanzaTramiteNormal(executionContext, tareaExterna, scriptValidacion);
			} catch (UserException e) {
				logger.info("No se ha podido validar el formulario correctamente. Trámite [" + getActivoTramite(executionContext).getId() + "], tarea [" + tareaExterna.getId() + "]. Mensaje ["
						+ e.getMessage() + "]", e);
				// Relanzamos la userException para que le aparezca al usuario
				// en pantalla
				throw (e);
			} catch (Exception e) {
				logger.error("No se ha podido validar el formulario correctamente. Trámite [" + getActivoTramite(executionContext).getId() + "], tarea [" + tareaExterna.getId() + "]", e);
				throw new UserException("bpm.error.script");
			}
		}

		// La seteamos por si acaso avanza sin haber despertado el BPM
		tareaExterna.setDetenida(false);
		proxyFactory.proxy(TareaExternaApi.class).borrar(tareaExterna);

		logger.debug("\tCaducamos la tarea: " + getNombreNodo(executionContext));
	}

	private void avanzaTramiteNormal(ExecutionContext executionContext, TareaExterna tareaExterna,
			String scriptValidacion) throws Exception {
		
		String validacionPrevia = agendaAdapter.getValidacionPrevia(tareaExterna.getTareaPadre().getId());

		if (!Checks.esNulo(validacionPrevia)){
			throw new UserException((String) validacionPrevia);
		}
		
		Long activoTramite = getActivoTramite(executionContext).getId();
		Object result = jbpmMActivoScriptExecutorApi.evaluaScript(activoTramite, tareaExterna.getId(), tareaExterna.getTareaProcedimiento().getId(),
				null, scriptValidacion);

		if (result instanceof Boolean && !(Boolean) result) {
			throw new UserException("bpm.error.script");
		}

		if (result instanceof String && ((String) result).length() > 0 && !"null".equalsIgnoreCase((String) result)) {
			throw new UserException((String) result);
		}
	}

	/**
	 * PONER JAVADOC FO.
	 * 
	 * @return boolean
	 */
	protected boolean isDecisionNode(ExecutionContext executionContext) {
		TareaExterna tareaExterna = getTareaExterna(executionContext);
		String script = "";
		if(!Checks.esNulo(tareaExterna.getTareaProcedimiento())) {
			if(!Checks.esNulo(tareaExterna.getTareaProcedimiento().getAuditoria())) {
				if(!tareaExterna.getTareaProcedimiento().getAuditoria().isBorrado()) {
					script = tareaExterna.getTareaProcedimiento().getScriptDecision();
				}
			}
		}
		return (!StringUtils.isBlank(script));
	}

	/**
	 * PONER JAVADOC FO.
	 * 
	 * @return string
	 */
	protected String getDecision(ExecutionContext executionContext) {
		TareaExterna tareaExterna = getTareaExterna(executionContext);
		String script = tareaExterna.getTareaProcedimiento().getScriptDecision();
		String result;
		try {
			result = jbpmMActivoScriptExecutorApi.evaluaScript(getActivoTramite(executionContext).getId(), tareaExterna.getId(), tareaExterna.getTareaProcedimiento().getId(), null, script).toString();
		} catch (Exception e) {
			logger.error("Error en el script de decisión [" + script + "]. Trámite [" + getActivoTramite(executionContext).getId() + "], tarea [" + tareaExterna.getId() + "].", e);
			throw new UserException("bpm.error.script");
		}
		return result;
	}

	
	/**
	 * Guarda los datos adicionales de las tareas
	 */
	protected void guardadoAdicionalTarea(ExecutionContext executionContext) {
		TareaExterna tareaExterna = getTareaExterna(executionContext);
		ActivoTramite tramite = getActivoTramite(executionContext); 
		TareaProcedimiento tareaProcedimiento = tareaExterna.getTareaProcedimiento();
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		Activo activo = null;
		Trabajo trabajo = null;
		ExpedienteComercial expediente = null;
		Oferta oferta = null;
		
		if(tareaActivo != null) {
			activo = tareaActivo.getActivo();
			trabajo = tareaActivo.getTramite().getTrabajo();
			if(trabajo != null) {
				expediente = expedienteComercialApi.findOneByTrabajo(trabajo);
				if(expediente != null) {
					oferta = expediente.getOferta();
				}
			}
		}
		
		List<TareaExternaValor> valores = activoTareaExternaManagerApi.obtenerValoresTarea(tareaExterna.getId());
				
		UpdaterService dataUpdater = updaterServiceFactory.getService(tareaProcedimiento.getCodigo());
		
		if(!Checks.estaVacio(valores) || 
				(activo != null && DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo())
				&& oferta != null && oferta.getOfertaExpress())){
			dataUpdater.saveValues(tramite, tareaExterna, valores);
			enviaNotificacionFinTareaConValores(tareaExterna.getId(),valores);
		}
			
		logger.debug("\tGuardamos los datos de la tarea: " + getNombreNodo(executionContext));
	}

	/**
	 * Actualiza los estados de gestión y admisión del activo
	 */
	protected void actualizarEstados(ExecutionContext executionContext){
		Activo activo = getActivoTramite(executionContext).getActivo();
		updaterState.updaterStates(activo);
	}
	
	private void writeObject(java.io.ObjectOutputStream out) throws IOException {
		//empty
	}

	private void readObject(java.io.ObjectInputStream in) throws IOException, ClassNotFoundException {
		//empty
	}

}
