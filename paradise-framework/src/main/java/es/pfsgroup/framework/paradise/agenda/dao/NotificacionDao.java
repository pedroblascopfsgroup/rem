package es.pfsgroup.framework.paradise.agenda.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager.RecoveryAnotacionApi;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.DtoCrearAnotacion;
import es.pfsgroup.plugin.recovery.mejoras.web.tareas.BuzonTareasViewHandler;
import es.pfsgroup.plugin.recovery.mejoras.web.tareas.BuzonTareasViewHandlerFactory;

@Repository("NotificacionDao")
public class NotificacionDao {
	
    @Autowired
    private ApiProxyFactory proxyFactory;  
    
    @Autowired
    private BuzonTareasViewHandlerFactory viewHandlerFactory;    

//    @Transactional
//    public void save(DtoCrearAnotacion anotacionDto){
//    	proxyFactory.proxy(RecoveryAnotacionApi.class).createAnotacion(anotacionDto);
//    }
    
    @Transactional
    public Object findOne(Long id) {
    	BuzonTareasViewHandler handler = viewHandlerFactory.getHandlerForSubtipoTarea(EXTSubtipoTarea.CODIGO_ANOTACION_NOTIFICACION);
    	return handler.getModel(id);
    }    
}
