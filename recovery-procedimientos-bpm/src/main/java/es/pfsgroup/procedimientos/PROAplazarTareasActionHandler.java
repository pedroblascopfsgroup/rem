package es.pfsgroup.procedimientos;

import java.util.Date;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.recovery.ext.api.utils.EXTJBPMProcessApi;

public class PROAplazarTareasActionHandler extends PROBaseActionHandler implements PROJBPMEnterEventHandler {
	
	private static final long serialVersionUID = -2982086806356913730L;

	@Autowired
	private GenericABMDao genericDao;
	
	/**
     * Override del método onEnter. Se ejecuta al entrar al nodo
     */
    @Override
    public void onEnter(ExecutionContext executionContext) {
        TareaExternaApi tareaExternaManager = proxyFactory.proxy(TareaExternaApi.class);
    	Procedimiento prc = getProcedimiento(executionContext);
		for(TareaNotificacion t:prc.getTareas()){			
			if (!t.getAuditoria().isBorrado()) {
				if(t.getTareaFinalizada() == null || (t.getTareaFinalizada()!=null && !t.getTareaFinalizada())){
					if(t.getTareaExterna()!=null){
						tareaExternaManager.detener(t.getTareaExterna());
						genericDao.update(TareaNotificacion.class, t);
						HibernateUtils.merge(t);
					}
				}
			}
		}		
        //Borramos los posibles timers que pudiera tener
        BPMUtils.deleteTimer(executionContext, "timer" + getNombreNodo(executionContext));
       
        //esto es para borrar el resto de timers de cada tarea externa asociada
		proxyFactory.proxy(EXTJBPMProcessApi.class).borraTimersTarea(getTareaExterna(executionContext).getId());
		
        Date plazo = (Date) getVariable(BPMContants.FECHA_APLAZAMIENTO_TAREAS, executionContext);
        if (plazo == null) {
            logger.error("No se ha creado correctamente el timer de aplazamiento para el nodo " + getNombreNodo(executionContext));
        } else {
            String nombreTimer = "timerAplazar" + getNombreNodo(executionContext);
            creaTimer(plazo, nombreTimer, BPMContants.TRANSICION_ACTIVAR_TAREAS, executionContext);
        }
        logger.debug("\tAplazamos la tarea, desactivamos su timer y creamos uno de activación [" + getNombreNodo(executionContext) + "]");
        //Seteamos la constante de paralizado
        setVariable(BPMContants.BPM_DETENIDO, 1L, executionContext);
        setVariable(PROBPMContants.FECHA_PARALIZACION_TAREAS, new Date(), executionContext);
    }
}
