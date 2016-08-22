package es.capgemini.pfs.web.direcciones.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.core.api.persona.PersonaApi;
import es.capgemini.pfs.core.api.telefono.api.TelefonosApi;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoTelefono;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.telefonos.model.DDEstadoTelefono;
import es.capgemini.pfs.telefonos.model.DDMotivoTelefono;
import es.capgemini.pfs.persona.model.DDOrigenTelefono;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.capgemini.pfs.direccion.api.DireccionApi;
import es.capgemini.pfs.direccion.dto.DireccionAltaDto;

@Controller
public class DireccionController {
	public static final String JSP_VENTANA_DIRECCION = "direcciones/altaDireccion";
	public static final String LISTADO_LOCALIDADES_JSON = "direcciones/listaLocalidadesJSON";
	
	public static final String JSON_LISTA_PERSONAS = "direcciones/listaPersonasJSON";
	public static final String JSON_RESULTADO_ALTA = "direcciones/resultadoAltaJSON";

	public static final String JSP_VENTANA_ABMDIRECCION = "direcciones/abmDireccion";

	@Autowired
	private Executor executor;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	/**
	 * Muestra la venta para dar de alta la dirección
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping
	public String altaDireccion(WebRequest request, ModelMap model){
		model.put("idAsunto", request.getParameter("idAsunto"));
		List<DDProvincia> provincias = (List<DDProvincia>) executor.execute("dictionaryManager.getList", "DDProvincia");
		model.put("provincias", provincias);
		List<DDTipoVia> tiposVia = (List<DDTipoVia>) proxyFactory.proxy(DireccionApi.class).getListTiposVia();
		model.put("tiposVia", tiposVia);
		return JSP_VENTANA_DIRECCION;
		
	}
	
	/**
	 * Guarda los datos de la dirección
	 * @param request
	 * @param model
	 * @throws Exception 
	 */
	@RequestMapping
	public String guardaDireccion(DireccionAltaDto dto, 
			WebRequest request, ModelMap model) throws Exception{			

		String resultado = proxyFactory.proxy(DireccionApi.class).guardarDireccion(dto);
		
		model.put("resultado", resultado);
		return JSON_RESULTADO_ALTA;
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListLocalidades(Long idProvincia, ModelMap model){
		List<Localidad> lista = proxyFactory.proxy(DireccionApi.class).getListLocalidades(idProvincia);
		model.put("listaData", lista);
		return LISTADO_LOCALIDADES_JSON;	
	}

	/**
     * Metodo que devuelve las personas para mostrarlos en el desplegable din�mico del campo asunto.
     * @param query
     * @param model
     * @return
     */
    @SuppressWarnings("unchecked")
    @RequestMapping
    public String getPersonasInstant(String query, String idAsunto, ModelMap model) {
    	Long idAsuntoLong = null;
    	if (!Checks.esNulo(idAsunto) && !"".equals(idAsunto)) {
    		idAsuntoLong = Long.parseLong(idAsunto);
    	}
        model.put("data", proxyFactory.proxy(DireccionApi.class).getPersonas(query, idAsuntoLong));
        
        return JSON_LISTA_PERSONAS;
    }

	/**
	 * Muestra la venta para el mantenimiento de la direcci�n
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping
	public String abmDireccion(@RequestParam(value = "idCliente", required = true) Long idCliente, ModelMap model){
		List<DDProvincia> provincias = (List<DDProvincia>) executor.execute("dictionaryManager.getList", "DDProvincia");
		model.put("provincias", provincias);
		List<DDTipoVia> tiposVia = (List<DDTipoVia>) proxyFactory.proxy(DireccionApi.class).getListTiposVia();
		model.put("tiposVia", tiposVia);

		/**TODO - de momento cojemos los dd de telefonos**/
		List<DDOrigenTelefono> origenesTelefono = proxyFactory.proxy(TelefonosApi.class).getOrigenesTelefono();
		List<DDTipoTelefono> tiposTelefono = proxyFactory.proxy(TelefonosApi.class).getTiposTelefono();
		List<DDMotivoTelefono> motivosTelefono = proxyFactory.proxy(TelefonosApi.class).getMotivosTelefono();
		List<DDEstadoTelefono> estadosTelefono = proxyFactory.proxy(TelefonosApi.class).getEstadosTelefono();
		Persona persona = proxyFactory.proxy(PersonaApi.class).getPersonaByCodClienteEntidad(idCliente);
		
		model.put("origenes", origenesTelefono);
		model.put("tipos", tiposTelefono);
		model.put("motivos", motivosTelefono);
		model.put("estados", estadosTelefono);
		
		model.put("persona", persona);
		
		model.put("idCliente", idCliente);

		return JSP_VENTANA_ABMDIRECCION;
	}
}
