package es.pfsgroup.procedimientos.subasta;

import static es.capgemini.pfs.BPMContants.TRANSICION_ACTIVAR_TAREAS;
import static es.capgemini.pfs.BPMContants.TRANSICION_APLAZAR_TAREAS;
import static es.capgemini.pfs.BPMContants.TRANSICION_PARALIZAR_TAREAS;
import static es.capgemini.pfs.BPMContants.TRANSICION_PRORROGA;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bpm.generic.GenericActionHandler;
import es.capgemini.pfs.bpm.generic.JBPMEnterEventHandler;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;

/**
 * Clase gen�rica para manejar los eventos de entrada a un state.
 *
 */
@Component
public class EntradaHandler extends GenericActionHandler {

    private static final long serialVersionUID = 889133646201763777L;

    /**
     * PONER JAVADOC FO.
     * @param delegateTransitionClass delegateTransitionClass
     * @param delegateSpecificClass delegateSpecificClass
     */
    @Override
    protected void process(Object delegateTransitionClass, Object delegateSpecificClass) {
        printInfoNode("Entra nodo");

        //Cambiamos el nombre de la variable listado de tareas para que no se solapen los nodos en un fork
        Object listadoTareas = getVariable(BPMContants.BPM_LISTADO_TAREAS_VUELTA_ATRAS);
        if (listadoTareas != null) {
            setVariable(BPMContants.BPM_LISTADO_TAREAS_VUELTA_ATRAS + "_" + getNombreNodo(), listadoTareas);
            setVariable(BPMContants.BPM_LISTADO_TAREAS_VUELTA_ATRAS, null);
        }

        if (debeCrearTareaProcedimiento()) {
            generaTransicionesParalizacion();
            generaTransicionesAplazamiento();
            generaTransicionProrroga();

            Long idTarea = procesarTarea();

            if (tieneProcesoBpmAsociado()) {
                lanzaNuevoBpmHijo();

                //No se quiere ver la tarea de lanzado un BPM externo
                tareaExternaManager.borrar(tareaExternaManager.get(idTarea));
            }

            generaTrancisionesDeAlerta(); //Necesita de la fecha de vencimiento de la tarea
        }

        //Llamamos al nodo gen�rico de transici�n
        if (delegateTransitionClass != null && delegateTransitionClass instanceof JBPMEnterEventHandler) {
            ((JBPMEnterEventHandler) delegateTransitionClass).onEnter();
        }

        //Llamamos al nodo espec�fico
        if (delegateSpecificClass != null && delegateSpecificClass instanceof JBPMEnterEventHandler) {
            ((JBPMEnterEventHandler) delegateSpecificClass).onEnter();
        }
    }

    /**
     * PONER JAVADOC FO.
     */
    protected void generaTransicionesParalizacion() {
        if (!existeTransicion(TRANSICION_PARALIZAR_TAREAS)) {
            nuevaTransicion(TRANSICION_PARALIZAR_TAREAS);
        }
        if (!existeTransicion(TRANSICION_ACTIVAR_TAREAS)) {
            nuevaTransicion(TRANSICION_ACTIVAR_TAREAS);
        }
    }

    /**
     * PONER JAVADOC FO.
     */
    protected void generaTransicionesAplazamiento() {
        if (!existeTransicion(TRANSICION_APLAZAR_TAREAS)) {
            nuevaTransicion(TRANSICION_APLAZAR_TAREAS);
        }
        if (!existeTransicion(TRANSICION_ACTIVAR_TAREAS)) {
            nuevaTransicion(TRANSICION_ACTIVAR_TAREAS);
        }
    }

    /**
     * PONER JAVADOC FO.
     */
    protected void generaTransicionProrroga() {
        if (!existeTransicion(TRANSICION_PRORROGA)) {
            nuevaTransicion(TRANSICION_PRORROGA);
        }
    }

    /**
     * PONER JAVADOC FO.
     */
    protected void generaTrancisionesDeAlerta() {
        if (existeTransicionDeAlerta() && !existeTimerDeAlerta()) {
            creaTimerDeAlerta(getTareaExterna().getTareaPadre());
            if (logger.isDebugEnabled()) {
                logger.debug("\tCreamos timer de alerta para esta tarea");
            }
        }
    }

    /** Crea una tarea externa en BD.
     * @throws Exception
     */
    @Transactional(readOnly = false)
    private Long procesarTarea() {

        //Recogemos el procedimiento del contexto
        Procedimiento procedimiento = getProcedimiento();
        Long idProcedimiento = procedimiento.getId();

        //Buscamos la tarea perteneciente a ese procedimiento con el código tarea y el idTipoProcedimiento y extraemos su ID tarea
        TareaProcedimiento tareaProcedimiento = getTareaProcedimiento();

        Long idTareaProcedimiento = tareaProcedimiento.getId();
        String nombreTarea = tareaProcedimiento.getDescripcion();

        //Creamos una nueva tarea extendida con el idProcedimiento y el idTipoTarea y el timer asociado
        //Por defecto la tarea ser� para un gestor
        String subtipoTarea = SubtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_GESTOR;

        //Si está marcada como supervisor se cambia el subtipo tarea
        if (tareaProcedimiento.getSupervisor()) {
            subtipoTarea = SubtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_SUPERVISOR;
        }

        TipoJuzgado juzgado = null;
        TipoPlaza plaza = null;

        juzgado = procedimiento.getJuzgado();
        if (juzgado != null) plaza = juzgado.getPlaza();

        Long idTipoPlaza = null;
        Long idTipoJuzgado = null;

        if (juzgado != null) idTipoJuzgado = juzgado.getId();
        if (plaza != null) idTipoPlaza = plaza.getId();

        Long plazoTarea = getPlazoTarea(idTipoPlaza, idTareaProcedimiento, idTipoJuzgado, idProcedimiento);
        Long idTarea = tareaExternaManager.crearTareaExterna(subtipoTarea, plazoTarea, nombreTarea, idProcedimiento, idTareaProcedimiento,
                getTokenId());

        //Si el BPM está detenido, detenemos la nueva tarea creada
        if (isBPMDetenido()) {
            tareaExternaManager.detener(tareaExternaManager.get(idTarea));
        }

        //Guardamos el id de la tarea externa de este nodo por si necesit�ramos recuperarla posteriormente (generalmente en timers)
        //NOTA. Si pasa dos veces por el mismo nodo se quedar� la �ltima ID de tarea (no pasa nada porque no habr�n dos tareas iguales ejecutandose en paralelo)
        setVariable("id" + getNombreNodo(), idTarea);

        if (logger.isDebugEnabled()) {
            logger.debug("\tCreamos la tarea: " + getNombreNodo());
        }

        return idTarea;
    }

}
