package es.pfsgroup.plugin.recovery.motorBusqueda.impl.manager;

import java.util.List;

import org.apache.commons.lang.NotImplementedException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.plugin.recovery.motorBusqueda.api.dao.TareasCalendarioDao;
import es.pfsgroup.plugin.recovery.motorBusqueda.api.dto.DtoTareas;
import es.pfsgroup.plugin.recovery.motorBusqueda.api.manager.MotorBusquedaManager;

@Component
public class MotorBusquedaManagerImpl implements MotorBusquedaManager{

	public static final String BO_PLUGIN_MOTOR_BUSQUEDA_MANAGER_BUSCAR_TAREAS_CALENDARIO = "plugin.motorBusqueda.manager.buscarTareasCalendario";
	public static final String BO_PLUGIN_MOTOR_BUSQUEDA_MANAGER_BUSCAR_TAREA_CALENDARIO = "plugin.motorBusqueda.manager.buscarTareaCalendario";
	public static final String BO_PLUGIN_MOTOR_BUSQUEDA_MANAGER_BUSCAR_TAREAS = "plugin.motorBusqueda.manager.buscarTareas";
	public static final String BO_PLUGIN_MOTOR_BUSQUEDA_MANAGER_BUSCAR_TAREA = "plugin.motorBusqueda.manager.buscarTarea";
	
    @Autowired(required = false)
    private TareasCalendarioDao tareasCalendarioDao;

    /**
     * {@inheritDoc}
     */
	@Override
	@BusinessOperation(BO_PLUGIN_MOTOR_BUSQUEDA_MANAGER_BUSCAR_TAREAS_CALENDARIO)
	public List<?> buscarTareasCalendario(DtoTareas dto) {
		try{
			return tareasCalendarioDao.obtenerTareasCalendario(dto);
		}catch(Throwable e){
    		throw new BusinessOperationException(e);
		}	
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(BO_PLUGIN_MOTOR_BUSQUEDA_MANAGER_BUSCAR_TAREA_CALENDARIO)
	public Object buscarTareaCalendario(DtoTareas dto) {
		try{
			return tareasCalendarioDao.obtenerTareaCalendario(dto);
		}catch(Throwable e){
    		throw new BusinessOperationException(e);
		}	
	}	
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(BO_PLUGIN_MOTOR_BUSQUEDA_MANAGER_BUSCAR_TAREAS)
	public List<?> buscarTareas(DtoTareas dto) {
		throw new NotImplementedException();
	}	
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(BO_PLUGIN_MOTOR_BUSQUEDA_MANAGER_BUSCAR_TAREA)
	public Object buscarTarea(DtoTareas dto) {
		throw new NotImplementedException();
	}	
	
}
