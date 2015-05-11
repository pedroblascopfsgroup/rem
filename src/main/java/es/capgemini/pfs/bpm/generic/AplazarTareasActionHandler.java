package es.capgemini.pfs.bpm.generic;

import java.util.Date;

import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;

/**
 * Paraliza la tarea. Marca la tarea como borrada lógica y detenida y destruye los timers asociados a la tarea
 *
 */
@Component(BPMContants.TRANSICION_APLAZAR_TAREAS)
public class AplazarTareasActionHandler extends BaseActionHandler implements JBPMEnterEventHandler {

    private static final long serialVersionUID = 1L;

    /**
     * Override del método onEnter. Se ejecuta al entrar al nodo
     */
    @Override
    public void onEnter() {
        TareaExterna tareaExterna = getTareaExterna();
        tareaExternaManager.detener(tareaExterna);

        //Borramos los posibles timers que pudiera tener
        BPMUtils.deleteTimer(getExecutionContext(), "timer" + getNombreNodo());

        Date plazo = (Date) getVariable(BPMContants.FECHA_APLAZAMIENTO_TAREAS);
        if (plazo == null) {
            logger.error("No se ha creado correctamente el timer de aplazamiento para el nodo " + getNombreNodo());
        } else {
            String nombreTimer = "timerAplazar" + getNombreNodo();
            creaTimer(plazo, nombreTimer, BPMContants.TRANSICION_ACTIVAR_TAREAS);
        }

        logger.debug("\tAplazamos la tarea, desactivamos su timer y creamos uno de activación [" + getNombreNodo() + "]");

        //Seteamos la constante de paralizado
        setVariable(BPMContants.BPM_DETENIDO, 1L);
    }
}
