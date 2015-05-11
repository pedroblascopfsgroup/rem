package es.pfsgroup.plugin.recovery.busquedaProcedimientos;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.busquedaProcedimientos.procedimiento.BPRProcedimientoApi;

@Controller
public class BusquedaProcedimientosController {
    
    @Autowired
	private ApiProxyFactory proxyFactory;
    
    /**
     * Metodo que devuelve los usuarios para el instant de usuarios
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getDemandadosInstant(String query, Boolean carterizado, ModelMap model) {
        model.put("data", proxyFactory.proxy(BPRProcedimientoApi.class).getDemandadosInstant(query));
        return "plugin/busquedaProcedimientos/json/listaDemandadosJSON";
    }

}
