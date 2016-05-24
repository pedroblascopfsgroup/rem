package es.pfsgroup.plugin.precontencioso.burofax.controller;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.WebRequest;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.precontencioso.burofax.manager.BurofaxCMManager;
import es.pfsgroup.plugin.precontencioso.burofax.manager.BurofaxManager;
import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.GestorTareasApi;

@Controller
public class BurofaxCMController {

	private static final String JSON_RESPUESTA  ="plugin/precontencioso/burofax/json/respuestaJSON";
	
	@Autowired
	private BurofaxManager burofaxManager;
	
	@Autowired
	private BurofaxCMManager burofaxCMManager;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	protected final Log logger = LogFactory.getLog(getClass());
	
    /**
     * Metodo para guardar el envio de burofaxes en BD (particularizado para Cajamar)
     * @param request
     * @param model
     * @return
     * @throws Exception 
     */
    @RequestMapping
    public String guardarEnvioBurofax(WebRequest request, ModelMap model,
    		Boolean certificado,Long idTipoBurofax, Boolean comboEditable, 
    		String codigoPropietaria, String localidadFirma, String notario, Boolean manual) throws Exception {
    	
    	String[] arrayIdEnvios=request.getParameter("arrayIdEnvios").replace("[","").replace("]","").replace("&quot;", "").split(",");
    	
    	//Configuramos el tipo de burofax
    	List<EnvioBurofaxPCO> listaEnvioBurofaxPCO=new ArrayList<EnvioBurofaxPCO>();
    	if(comboEditable) {
	    	String[] arrayIdDirecciones=request.getParameter("arrayIdDirecciones").replace("[","").replace("]","").replace("&quot;", "").split(",");
	    	String[] arrayIdBurofax=request.getParameter("arrayIdBurofax").replace("[","").replace("]","").replace("&quot;", "").split(",");
	    	listaEnvioBurofaxPCO=burofaxCMManager.configurarTipoBurofax(idTipoBurofax,arrayIdDirecciones,arrayIdBurofax,arrayIdEnvios,manual);
    	} else {
    		for (int i=0;i<arrayIdEnvios.length;i++) {
    			listaEnvioBurofaxPCO.add(burofaxManager.getEnvioBurofaxById(Long.valueOf(arrayIdEnvios[i])));
    		}
    	}
    	
    	burofaxCMManager.guardarEnvioBurofax(certificado,listaEnvioBurofaxPCO, codigoPropietaria, localidadFirma, notario);
		if (!Checks.estaVacio(listaEnvioBurofaxPCO)) {
			proxyFactory.proxy(GestorTareasApi.class).recalcularTareasPreparacionDocumental(listaEnvioBurofaxPCO.get(0).getBurofax().getProcedimientoPCO().getProcedimiento().getId());
		}
    		
		return JSON_RESPUESTA;
    }
    

}
