package es.pfsgroup.plugin.recovery.calendario.impl.web.handler;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.pfsgroup.plugin.recovery.calendario.api.web.handler.CalendarioViewHandler;
import es.pfsgroup.plugin.recovery.motorBusqueda.api.dto.DtoTareas;

/**
 * Implementacion del manejador de la capa de presentación de Alarma
 * @author Guillem
 *
 */
@Component
public class TareaExternaViewHandler implements CalendarioViewHandler{

	protected static final String JSP_NAME = "plugin/calendario/asunto/detalleAnotacion";
	protected static final List<String> SUBTIPO_TAREA = Arrays.asList("700", "701");
	
	//protected static String SUBTIPO_TAREA = "700";
	private static final String BUSINESS_OPERATION = "plugin.motorBusqueda.manager.buscarTareaCalendario";
	
    @Autowired
    protected Executor executor;
    
    /**
     * {@inheritDoc}
     */
	@Override
	public String getJspName() {
		return JSP_NAME;
	}
	
    /**
     * {@inheritDoc}
     */
	@Override
	public boolean isValid(String subtipoTarea) {
		return SUBTIPO_TAREA.contains(subtipoTarea);
	}

    /**
     * {@inheritDoc}
     */
	@Override
	public Object getModel(DtoTareas dto) {
		return executor.execute(BUSINESS_OPERATION, dto);
	}

}
