package es.pfsgroup.plugin.rem.jbpm.handler;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.utils.BPMUtils;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;

public class ActivoActivarAlertaActionHandler extends ActivoBaseActionHandler implements ActivoJBPMEnterEventHandler{

	private static final long serialVersionUID = 1920406024815248515L;
	
	@Autowired 
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	ActivoTareaExternaApi activoTareaExternaManagerApi;

	@Override
	//TODO: este handler no sé si hace lo correcto. Preguntar:
	public void onEnter(ExecutionContext executionContext) {

    	ActivoTramite activoTramite = getActivoTramite(executionContext);
		for(TareaNotificacion t:activoTramite.getTareas()){
			if (!t.getAuditoria().isBorrado()) {
				if(t.getTareaFinalizada() == null || (t.getTareaFinalizada()!=null && t.getTareaFinalizada())){
					if(t.getTareaExterna()!=null){
						activoTareaExternaManagerApi.activarAlerta(t.getTareaExterna());
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
