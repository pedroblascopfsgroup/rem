package es.pfsgroup.plugin.recovery.calendario.impl.web;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.bo.Executor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.calendario.api.web.handler.CalendarioViewHandler;
import es.pfsgroup.plugin.recovery.calendario.impl.web.dto.DtoBusquedaTareasImpl;

/**
 * Controlador web para el calendario
 * Mapea las peticiones de la capa de presentación
 * @author Guillem
 * 
 */
@Controller
public class CalendarioController {
    
	private static final String JSON_PLUGIN_CALENDARIO_CARGAR_MULTIPLES_CALENDARIO_EVENTO = "plugin/calendario/json/cargarMultiplesCalendarioEventoJSON";
	private static final String JSON_PLUGIN_CALENDARIO_CARGAR_MULTIPLES_CALENDARIO_NO_OPTIMIZADO_EVENTO = "plugin/calendario/json/cargarMultiplesCalendarioEventoNoOptimizadoJSON";
    private static final String JSON_PLUGIN_CALENDARIO_NUEVO_CALENDARIO_EVENTO = "plugin/calendario/json/nuevoCalendarioEventoJSON";
    private static final String JSON_PLUGIN_CALENDARIO_BORRAR_CALENDARIO_EVENTO = "plugin/calendario/json/borrarCalendarioEventoJSON";
    private static final String JSON_PLUGIN_CALENDARIO_MODIFICAR_CALENDARIO_EVENTO = "plugin/calendario/json/modificarCalendarioEventoJSON";
    
    private static final String BO_PLUGIN_MOTOR_BUSQUEDA_MANAGER_BUSCAR_TAREAS_CALENDARIO = "plugin.motorBusqueda.manager.buscarTareasCalendario";
    private static final String BO_PLUGIN_BUSQUEDA_TAREAS_TIENE_OPCION_BUZON_OPTINIZADO  = "es.pfsgroup.recovery.ext.api.tareas.opciones.tieneOpcionBuzonOptimizado";
 	
    private static final String DEFAULT_JSP = null;
    private static final String DATA_KEY = "data";
	
    @Autowired
    private Executor executor;
    
    @Autowired
    private List<CalendarioViewHandler> viewHandlers;

    /**
     * Método que carga tareas del calendario
     * @param dto
     * @param model
     * @return String
     */
    @RequestMapping
    @SuppressWarnings("unchecked")
    public String cargarTareasCalendario(DtoBusquedaTareasImpl dto, ModelMap model) {
        model.put("data", (List<?>) executor.execute(BO_PLUGIN_MOTOR_BUSQUEDA_MANAGER_BUSCAR_TAREAS_CALENDARIO, dto));
        if((Boolean)executor.execute(BO_PLUGIN_BUSQUEDA_TAREAS_TIENE_OPCION_BUZON_OPTINIZADO)){
        	return JSON_PLUGIN_CALENDARIO_CARGAR_MULTIPLES_CALENDARIO_EVENTO;
        }else{
        	return JSON_PLUGIN_CALENDARIO_CARGAR_MULTIPLES_CALENDARIO_NO_OPTIMIZADO_EVENTO;
        }
    }
    
    /**
     * Método que carga una tarea del calendario
     * @param dto
     * @param model
     * @return String
     */
    @RequestMapping
    @SuppressWarnings("unchecked")
    public String cargarTareaCalendario(DtoBusquedaTareasImpl dto, ModelMap model) {    	
        if (!Checks.estaVacio(viewHandlers)) {
            for (CalendarioViewHandler handler : viewHandlers) {
                if (handler.isValid(dto.getCodigoTipoSubTarea())) {                	
                    model.put(DATA_KEY, handler.getModel(dto));
                    return handler.getJspName();
                }
            }
        }
        return DEFAULT_JSP;
    }
       
    /**
     * Método que crea una tarea del calendario
     * @param dto
     * @param model
     * @return String
     */
    @RequestMapping
    public String nuevaTareaCalendario(DtoBusquedaTareasImpl dto, ModelMap model) {
        return JSON_PLUGIN_CALENDARIO_NUEVO_CALENDARIO_EVENTO;
    }

    /**
     * Método que borra una tarea del calendario
     * @param dto
     * @param model
     * @return String
     */
    @RequestMapping
    public String borrarTareaCalendario(DtoBusquedaTareasImpl dto, ModelMap model) {
        return JSON_PLUGIN_CALENDARIO_BORRAR_CALENDARIO_EVENTO;
    }
    
    /**
     * Método que modifica una tarea del calendario
     * @param dto
     * @param model
     * @return String
     */
    @RequestMapping
    public String modificarTareaCalendario(DtoBusquedaTareasImpl dto, ModelMap model) {
        return JSON_PLUGIN_CALENDARIO_MODIFICAR_CALENDARIO_EVENTO;
    }
    
}
