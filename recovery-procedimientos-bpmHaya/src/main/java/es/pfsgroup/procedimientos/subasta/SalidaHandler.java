package es.pfsgroup.procedimientos.subasta;

import org.apache.commons.lang.StringUtils;
import org.jbpm.graph.exe.ExecutionContext;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.bpm.generic.JBPMLeaveEventHandler;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.prorroga.model.Prorroga;
import es.pfsgroup.procedimientos.PROGenericActionHandler;
import es.pfsgroup.procedimientos.PROJBPMLeaveEventHandler;
import es.pfsgroup.procedimientos.recoveryapi.JBPMProcessApi;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;

public class SalidaHandler extends PROGenericActionHandler {

	private static final long serialVersionUID = 4727308329810928607L;
	private String city;

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) {
		printInfoNode("Sale nodo", executionContext);

		// Llamamos al nodo gen�rico de transici�n
		if (delegateTransitionClass instanceof PROJBPMLeaveEventHandler) {
			((PROJBPMLeaveEventHandler) delegateTransitionClass).onLeave(executionContext);
		}

		// Llamamos al nodo espec�fico
		if (delegateSpecificClass instanceof PROJBPMLeaveEventHandler) {
			((PROJBPMLeaveEventHandler) delegateSpecificClass).onLeave(executionContext);
		}

		if (!BPMContants.TRANSICION_VUELTA_ATRAS.equals(delegateTransitionClass)) {
			if (debeDestruirTareaProcedimiento(executionContext)) {
				if (isDecisionNode(executionContext)) {
					String nombreDecision = getNombreNodo(executionContext) + "Decision";
					setVariable(nombreDecision, getDecision(executionContext), executionContext);
					logger.debug("\tDecisi�n de la tarea: " + getVariable(nombreDecision, executionContext));
				}

				proxyFactory.proxy(EXTJBPMProcessApi.class).borraTimersTarea(getTareaExterna(executionContext).getId());

				finalizarTarea(executionContext);
				finalizarOperacionesAsociadas(executionContext);
			}
		}

		// Borramos las posibles variables de listado de tareas del nodo
		executionContext.getContextInstance().deleteVariable(BPMContants.BPM_LISTADO_TAREAS_VUELTA_ATRAS + "_" + getNombreNodo(executionContext));

		// A�adimos el nombre del nodo actual al contexto para poder detectar
		// una reentrada en el PROGenericEnterActionHandler
		setVariable(ConstantesBPMPFS.NOMBRE_NODO_SALIENTE, getNombreNodo(executionContext), executionContext);

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
		if (!BPMContants.TRANSICION_VUELTA_ATRAS.equals(transicion) && !StringUtils.isBlank(scriptValidacion)) {
			try {
				Object result = proxyFactory.proxy(JBPMProcessApi.class).evaluaScript(getProcedimiento(executionContext).getId(), tareaExterna.getId(), tareaExterna.getTareaProcedimiento().getId(),
						null, scriptValidacion);

				if (result instanceof Boolean && !(Boolean) result) {
					throw new UserException("bpm.error.script");
				}

				if (result instanceof String && ((String) result).length() > 0 && !"null".equalsIgnoreCase((String) result)) {
					throw new UserException((String) result);
				}

			} catch (UserException e) {
				logger.info("No se ha podido validar el formulario correctamente. Procedimiento [" + getProcedimiento(executionContext).getId() + "], tarea [" + tareaExterna.getId() + "]. Mensaje ["
						+ e.getMessage() + "]", e);
				// Relanzamos la userException para que le aparezca al usuario
				// en pantalla
				throw (e);
			} catch (Exception e) {
				logger.info("No se ha podido validar el formulario correctamente. Procedimiento [" + getProcedimiento(executionContext).getId() + "], tarea [" + tareaExterna.getId() + "]", e);
				throw new UserException("bpm.error.script");
			}
		}

		// La seteamos por si acaso avanza sin haber despertado el BPM
		tareaExterna.setDetenida(false);
		proxyFactory.proxy(TareaExternaApi.class).borrar(tareaExterna);

		logger.debug("\tCaducamos la tarea: " + getNombreNodo(executionContext));
	}

	/**
	 * PONER JAVADOC FO.
	 * 
	 * @return boolean
	 */
	protected boolean isDecisionNode(ExecutionContext executionContext) {
		TareaExterna tareaExterna = getTareaExterna(executionContext);
		String script = tareaExterna.getTareaProcedimiento().getScriptDecision();

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
			result = proxyFactory.proxy(JBPMProcessApi.class)
					.evaluaScript(getProcedimiento(executionContext).getId(), tareaExterna.getId(), tareaExterna.getTareaProcedimiento().getId(), null, script).toString();
		} catch (Exception e) {
			logger.info("Error en el script de decisi�n [" + script + "]. Procedimiento [" + getProcedimiento(executionContext).getId() + "], tarea [" + tareaExterna.getId() + "].", e);
			throw new UserException("bpm.error.script");
		}
		return result;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getCity() {
		return city;
	}

}
