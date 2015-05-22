package es.pfsgroup.procedimientos;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;

public class PROActivarAlertaActionHandler extends PROBaseActionHandler implements PROJBPMEnterEventHandler{

	private static final long serialVersionUID = 1920406024815248515L;
	
	@Autowired 
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;

	@Override
	public void onEnter(ExecutionContext executionContext) {
		TareaExternaApi tareaExternaManager = proxyFactory.proxy(TareaExternaApi.class);    	
    	Procedimiento prc = getProcedimiento(executionContext);
		for(TareaNotificacion t:prc.getTareas()){
			if (!t.getAuditoria().isBorrado()) {
				if(t.getTareaFinalizada() == null || (t.getTareaFinalizada()!=null && t.getTareaFinalizada())){
					if(t.getTareaExterna()!=null){
						tareaExternaManager.activarAlerta(t.getTareaExterna());
						genericDao.update(TareaNotificacion.class, t);
						HibernateUtils.merge(t);
					}
				}
			}
		}
        logger.debug("\tEjecutamos el timer y caducamos la tarea: " + getNombreNodo(executionContext));
        String nombreTimer = "timer" + getNombreNodo(executionContext);
        BPMUtils.deleteTimer(executionContext, nombreTimer);	
	}

}
