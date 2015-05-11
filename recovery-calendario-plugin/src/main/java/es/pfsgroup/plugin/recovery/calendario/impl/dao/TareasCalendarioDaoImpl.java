package es.pfsgroup.plugin.recovery.calendario.impl.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.pfsgroup.plugin.recovery.motorBusqueda.api.dao.TareasCalendarioDao;
import es.pfsgroup.plugin.recovery.motorBusqueda.api.dto.DtoTareas;

/**
 * Implementación para la persistencia de las tareas del calendario
 * @author Guillem
 *
 */
@Repository("TareasCalendarioDao")
@Component
public class TareasCalendarioDaoImpl extends AbstractEntityDao<EXTTareaNotificacion, Long> implements TareasCalendarioDao{

	
    
    @Autowired
    private AnotacionDaoImpl anotacionDaoImpl;
    
    @Autowired
    private TareaExternaDaoImpl tareaExternaDaoImpl;
    
	/**
	 * {@inheritDoc}
	 */
	@Override
    @Transactional
	public List<?> obtenerTareasCalendario(DtoTareas dto) {
		try{		
			//List tareas = anotacionDaoImpl.obtenerAnotaciones(dto);
			//tareas.addAll(tareaExternaDaoImpl.obtenerTareasExternas(dto));
			//return tareas;
			return tareaExternaDaoImpl.obtenerTareasExternas(dto);
		}catch(Throwable e){
    		throw new BusinessOperationException(e);
		}	
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
    @Transactional
	public Object obtenerTareaCalendario(DtoTareas dto) {
		try{			
			return anotacionDaoImpl.obtenerAnotacion(dto);
		}catch(Throwable e){
    		throw new BusinessOperationException(e);
		}	
	}
	
}
