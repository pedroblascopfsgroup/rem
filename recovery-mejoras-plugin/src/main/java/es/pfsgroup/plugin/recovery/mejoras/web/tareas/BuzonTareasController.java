package es.pfsgroup.plugin.recovery.mejoras.web.tareas;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class BuzonTareasController {
	protected final Log logger = LogFactory.getLog(getClass());

    private static final String DEFAULT_JSP = null;

    private static final String DATA_KEY = "data";

    @Autowired
    private BuzonTareasViewHandlerFactory viewHandlerFactory;
    

    @RequestMapping
    public String abreTarea(Long idTarea, String subtipoTarea, ModelMap model) {
    	
    	BuzonTareasViewHandler handler = viewHandlerFactory.getHandlerForSubtipoTarea(subtipoTarea);
    	
    	if (handler != null){
    		model.put(DATA_KEY, handler.getModel(idTarea));
            return handler.getJspName();
    	}else{
    		return DEFAULT_JSP;
    	}
    }
}
