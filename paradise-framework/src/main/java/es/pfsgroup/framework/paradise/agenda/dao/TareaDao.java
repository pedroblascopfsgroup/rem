package es.pfsgroup.framework.paradise.agenda.dao;

import java.util.List;

import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaValorDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.pfsgroup.framework.paradise.jbpm.JBPMProcessManager;
import es.pfsgroup.plugin.recovery.mejoras.web.tareas.BuzonTareasViewHandler;
import es.pfsgroup.plugin.recovery.mejoras.web.tareas.BuzonTareasViewHandlerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository("TareaDao")
public class TareaDao {
	
    @Autowired
    private TareaExternaValorDao tareaExternaValorDao;
    
    @Autowired
    private BuzonTareasViewHandlerFactory viewHandlerFactory;
    
    @Autowired
    private JBPMProcessManager jbpmManager;
    
    @Transactional
    public void save(List<TareaExternaValor> listaValores){
    	for (int i = 0; i < listaValores.size(); i++) {
    		tareaExternaValorDao.saveOrUpdate(listaValores.get(i));
    	}
    }
    
    @Transactional
    public Object findOne(Long id){
    	BuzonTareasViewHandler handler = viewHandlerFactory.getHandlerForSubtipoTarea(EXTSubtipoTarea.CODIGO_ANOTACION_TAREA);
    	return handler.getModel(id);
    }

    public void advance(TareaExterna tarea){        
        jbpmManager.signalToken(tarea.getTokenIdBpm(), BPMContants.TRANSICION_AVANZA_BPM);
    }
}
