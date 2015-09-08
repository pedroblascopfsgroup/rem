package es.pfsgroup.procedimientos;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.procedimientos.recoveryapi.ProcedimientoApi;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;

public class PROActivarTareaActionHandler extends PROBaseActionHandler implements PROJBPMEnterEventHandler{

	/**
	 * 
	 */
	private static final long serialVersionUID = 3022615631064850781L;
	
	@Autowired
	ApiProxyFactory proxyFactory;

	@Autowired
	IntegracionBpmService bpmIntegrationService;
	
	/**
     * Override del m�todo onEnter. Se ejecuta al entrar al nodo
     */
    public void onEnter(ExecutionContext executionContext) {
        //Seteamos el tiempo de aplazamiento
        setVariable(BPMContants.FECHA_APLAZAMIENTO_TAREAS, null, executionContext);

        TareaExterna tareaExterna = getTareaExterna(executionContext);

        if (tareaExterna.getDetenida()) {
            TareaNotificacion tarea = tareaExterna.getTareaPadre();

            iniciaFechasTarea(tarea, executionContext);

            proxyFactory.proxy(TareaExternaApi.class).activar(tareaExterna);
            
            try {
            	generarTimerTareaProcedimiento(tareaExterna.getId(), executionContext);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

            if (existeTransicionDeAlerta(executionContext)) {
                creaTimerDeAlerta(tarea, executionContext);
            }
        }

        //Seteamos la constante de paralizado
        setVariable(BPMContants.BPM_DETENIDO, 0L, executionContext);
        
        cambiaEstadoProcedimientoAActivado(tareaExterna);
        
        // Integración
        bpmIntegrationService.notificaActivarTarea(tareaExterna);
        
    }
	
    private void cambiaEstadoProcedimientoAActivado(final TareaExterna tarea) {
        if (tarea != null) {
            if (tarea.getTareaPadre() != null) {
                if (tarea.getTareaPadre().getProcedimiento() != null) {
                    final Procedimiento p = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(tarea.getTareaPadre().getProcedimiento().getId());
                    final MEJProcedimiento proc = getRealMejProcedimientoFromHibernateProxyOrNull(p);
                    if (proc != null) {
                        proc.setEstaParalizado(false);
                    }
                }
            }
        }

    }
}
