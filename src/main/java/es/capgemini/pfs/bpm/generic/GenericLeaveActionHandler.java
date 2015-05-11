package es.capgemini.pfs.bpm.generic;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.prorroga.model.Prorroga;
import es.capgemini.pfs.utils.JBPMProcessManager;

/**
 * PONER JAVADOC FO.
 */
@Component
public class GenericLeaveActionHandler extends GenericActionHandler {

    private static final long serialVersionUID = 1L;

    @Autowired
    private JBPMProcessManager jbpmUtils;

    private String city;

    /**
     * PONER JAVADOC FO.
     * @param delegateTransitionClass delegateTransitionClass
     * @param delegateSpecificClass delegateSpecificClass
     */
    @Override
    protected void process(Object delegateTransitionClass, Object delegateSpecificClass) {
        printInfoNode("Sale nodo");

        //Llamamos al nodo genï¿½rico de transiciï¿½n
        if (delegateTransitionClass instanceof JBPMLeaveEventHandler) {
            ((JBPMLeaveEventHandler) delegateTransitionClass).onLeave();
        }

        //Llamamos al nodo especï¿½fico
        if (delegateSpecificClass instanceof JBPMLeaveEventHandler) {
            ((JBPMLeaveEventHandler) delegateSpecificClass).onLeave();
        }

        if (!BPMContants.TRANSICION_VUELTA_ATRAS.equals(delegateTransitionClass)) {
            if (debeDestruirTareaProcedimiento()) {
                if (isDecisionNode()) {
                    String nombreDecision = getNombreNodo() + "Decision";
                    setVariable(nombreDecision, getDecision());
                    logger.debug("\tDecisión de la tarea: " + getVariable(nombreDecision));
                }

                finalizarTarea();
                finalizarOperacionesAsociadas();
            }
        }

        //Borramos las posibles variables de listado de tareas del nodo
        getExecutionContext().getContextInstance().deleteVariable(BPMContants.BPM_LISTADO_TAREAS_VUELTA_ATRAS + "_" + getNombreNodo());
    }

    /**
     * Finaliza las operaciones asociadas a la tarea (prorrogas, ...).
     */
    protected void finalizarOperacionesAsociadas() {
        //Buscamos si tiene prorroga activa
        Prorroga prorroga = getTareaExterna().getTareaPadre().getProrrogaAsociada();

        //Borramos (finalizamos) la prorroga si es que tiene
        if (prorroga != null) {
            tareaNotificacionManager.borrarNotificacionTarea(prorroga.getTarea().getId());
        }
    }

    /**
     * Finaliza la tarea activa del BPM del procedimiento.
     */
    protected void finalizarTarea() {
        TareaExterna tareaExterna = getTareaExterna();
        //TareaNotificacion tarea = tareaExterna.getTareaPadre();
        TareaProcedimiento tareaProcedimiento = tareaExterna.getTareaProcedimiento();

        String scriptValidacion = tareaProcedimiento.getScriptValidacionJBPM();
        //        String scriptAmpliado = context.get(BPMContants.FUNCIONES_GLOBALES_SCRIPT) + scriptValidacion;

        if (!StringUtils.isBlank(scriptValidacion)) {
            try {
                Object result = jbpmUtils.evaluaScript(getProcedimiento().getId(), tareaExterna.getId(),
                        tareaExterna.getTareaProcedimiento().getId(), null, scriptValidacion);

                if (result instanceof Boolean && !(Boolean) result) { throw new UserException("bpm.error.script"); }

                if (result instanceof String && ((String) result).length() > 0 && !"null".equalsIgnoreCase((String) result)) { throw new UserException(
                        (String) result); }

            } catch (UserException e) {
                logger.info("No se ha podido validar el formulario correctamente. Procedimiento [" + getProcedimiento().getId() + "], tarea ["
                        + tareaExterna.getId() + "]. Mensaje [" + e.getMessage() + "]", e);
                //Relanzamos la userException para que le aparezca al usuario en pantalla
                throw (e);
            } catch (Exception e) {
                logger.info("No se ha podido validar el formulario correctamente. Procedimiento [" + getProcedimiento().getId() + "], tarea ["
                        + tareaExterna.getId() + "]", e);
                throw new UserException("bpm.error.script");
            }
        }

        //La seteamos por si acaso avanza sin haber despertado el BPM
        tareaExterna.setDetenida(false);
        tareaExternaManager.borrar(tareaExterna);

        logger.debug("\tCaducamos la tarea: " + getNombreNodo());
    }

    /**
     * PONER JAVADOC FO.
     * @return boolean
     */
    protected boolean isDecisionNode() {
        TareaExterna tareaExterna = getTareaExterna();
        String script = tareaExterna.getTareaProcedimiento().getScriptDecision();

        return (!StringUtils.isBlank(script));
    }

    /**
     * PONER JAVADOC FO.
     * @return string
     */
    protected String getDecision() {
        TareaExterna tareaExterna = getTareaExterna();
        String script = tareaExterna.getTareaProcedimiento().getScriptDecision();
        String result;
        try {
            result = jbpmUtils.evaluaScript(getProcedimiento().getId(), tareaExterna.getId(), tareaExterna.getTareaProcedimiento().getId(), null,
                    script).toString();
        } catch (Exception e) {
            logger.info("Error en el script de decisión [" + script + "]. Procedimiento [" + getProcedimiento().getId() + "], tarea ["
                    + tareaExterna.getId() + "].", e);
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
