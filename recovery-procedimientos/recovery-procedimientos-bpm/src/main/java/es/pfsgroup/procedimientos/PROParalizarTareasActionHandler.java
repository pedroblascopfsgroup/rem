package es.pfsgroup.procedimientos;

import java.util.Date;

import org.hibernate.Hibernate;
import org.hibernate.proxy.HibernateProxy;
import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bpm.ProcessManager;
import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.procedimientos.recoveryapi.JBPMProcessApi;
import es.pfsgroup.procedimientos.recoveryapi.ProcedimientoApi;
import es.pfsgroup.recovery.api.TareaExternaApi;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;

/**
 * Paraliza la tarea. Marca la tarea como borrada lógica y detenida y destruye
 * los timers asociados a la tarea
 * 
 */
public class PROParalizarTareasActionHandler extends PROBaseActionHandler implements PROJBPMEnterEventHandler {

    @Autowired
    private ProcessManager processManager;

    @Autowired
    private ApiProxyFactory proxyFactory;

    private static final long serialVersionUID = 1L;

    /**
     * Override del método onEnter. Se ejecuta al entrar al nodo
     */
    @Override
    @Transactional(readOnly = false)
    public void onEnter(ExecutionContext executionContext) {
        TareaExterna tareaExterna = getTareaExterna(executionContext);
        proxyFactory.proxy(TareaExternaApi.class).detener(tareaExterna);

        // Borramos los posibles timers que pudiera tener
        if (processManager.getTimer(executionContext.getProcessInstance(), "timer" + getNombreNodo(executionContext)) != null)
            BPMUtils.deleteTimer(executionContext, "timer" + getNombreNodo(executionContext));
        
        //esto es para borrar el resto de timers de cada tarea externa asociada
		proxyFactory.proxy(EXTJBPMProcessApi.class).borraTimersTarea(getTareaExterna(executionContext).getId());
        
        logger.debug("\tParalizamos la tarea y desactivamos su timer [" + getNombreNodo(executionContext) + "]");

        // Seteamos la constante de paralizado
        setVariable(BPMContants.BPM_DETENIDO, 1L, executionContext);

        cambiaEstadoProcedimientoAParalizado(tareaExterna);
    }

    private void cambiaEstadoProcedimientoAParalizado(final TareaExterna tarea) {
        if (tarea != null) {
            if (tarea.getTareaPadre() != null) {
                if (tarea.getTareaPadre().getProcedimiento() != null) {
                    final Procedimiento p = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(tarea.getTareaPadre().getProcedimiento().getId());
                    final MEJProcedimiento proc = getRealMejProcedimientoFromHibernateProxyOrNull(p);
                    if (proc != null) {
                        proc.setEstaParalizado(true);
                        proc.setFechaUltimaParalizacion(new Date());
                    }
                }
            }
        }

    }

}
