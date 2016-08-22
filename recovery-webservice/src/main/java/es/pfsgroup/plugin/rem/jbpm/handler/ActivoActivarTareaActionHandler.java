package es.pfsgroup.plugin.rem.jbpm.handler;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoTareasManagerApi;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;

public class ActivoActivarTareaActionHandler extends ActivoBaseActionHandler implements ActivoJBPMEnterEventHandler{

	private static final long serialVersionUID = 3022615631064850781L;
	
	@Autowired
	ApiProxyFactory proxyFactory;
	
	@Autowired
	ActivoTareaExternaApi activoTareaExternaManagerApi;
	
	@Autowired
	JBPMActivoTareasManagerApi jbpmActivoTareasManagerApi;

	/**
     * Override del método onEnter. Se ejecuta al entrar al nodo
     */
    public void onEnter(ExecutionContext executionContext) {

        this.setVariable(BPMContants.FECHA_APLAZAMIENTO_TAREAS, null, executionContext);

        TareaExterna tareaExterna = this.getTareaExterna(executionContext);

        if (tareaExterna.getDetenida()) {
            TareaNotificacion tarea = tareaExterna.getTareaPadre();

            jbpmActivoTareasManagerApi.iniciaFechasTarea(tarea, executionContext);

            activoTareaExternaManagerApi.activar(tareaExterna);
            
            try {
            	this.generarTimerTareaActivo(tareaExterna.getId(), executionContext);
			} catch (Exception e) {
				e.printStackTrace();
			}

            if (this.existeTransicionDeAlerta(executionContext)) {
                this.creaTimerDeAlerta(tarea, executionContext);
            }
        }

        //Seteamos la constante de paralizado
        setVariable(BPMContants.BPM_DETENIDO, 0L, executionContext);
        
        cambiaEstadoProcedimientoAActivado(tareaExterna);
        
    }
	
    private void cambiaEstadoProcedimientoAActivado(final TareaExterna tarea) {
        if (tarea != null) {
            if (tarea.getTareaPadre() != null) {
            	TareaActivo tareaActivo = (TareaActivo)tarea.getTareaPadre();
                if (tareaActivo.getTramite() != null) {
                	ActivoTramite activoTramite = tareaActivo.getTramite();
                	//TODO: ver si esto hace falta.
//                    final Procedimiento p = proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(tarea.getTareaPadre().getProcedimiento().getId());
//                    final MEJProcedimiento proc = getRealMejProcedimientoFromHibernateProxyOrNull(p);
                    if (activoTramite != null) {
                    	activoTramite.setEstaParalizado(false);
                    }
                }
            }
        }

    }
}
