package es.pfsgroup.plugin.rem.controller;


import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.JsonWriterConfiguratorTemplateRegistry;
import org.springframework.web.servlet.view.json.writer.sojo.SojoConfig;
import org.springframework.web.servlet.view.json.writer.sojo.SojoJsonWriterConfiguratorTemplate;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GenericApi;
import es.pfsgroup.plugin.rem.model.AuthenticationData;



@Controller
public class GenericController {
	
	@Autowired
	private GenericAdapter adapter;
	
	@Autowired
	private GenericApi genericApi;

	
	/**
	 * Método para modificar la plantilla de JSON utilizada en el servlet.
	 * @param request
	 * @param binder
	 * @throws Exception
	 */
	@InitBinder
	protected void initBinder(HttpServletRequest request,  ServletRequestDataBinder binder) throws Exception{
        
	    JsonWriterConfiguratorTemplateRegistry registry = JsonWriterConfiguratorTemplateRegistry.load(request);             
	    registry.registerConfiguratorTemplate(
	         new SojoJsonWriterConfiguratorTemplate(){
	                
	        	 	@Override
	                public SojoConfig getJsonConfig() {
	                    SojoConfig config= new SojoConfig();
                        config.setIgnoreNullValues(false);
                        return config;
	        	 	}
	         }
	   );

	    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
        dateFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, false));
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDiccionario(String diccionario) {	
		
		return createModelAndViewJson(new ModelMap("data", adapter.getDiccionario(diccionario)));
		
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDiccionarioTareas(String diccionario) {	
		
		return createModelAndViewJson(new ModelMap("data", adapter.getDiccionarioTareas(diccionario)));
		
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDiccionarioSubtipoProveedor(String codigoTipoProveedor){
		return createModelAndViewJson(new ModelMap("data", genericApi.getDiccionarioSubtipoProveedor(codigoTipoProveedor)));
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboEspecial(String diccionario){
	
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboEspecial(diccionario)));
	}	
	
	/**
	 * @return Usuario identificado y sus funciones según perfil
	 */
	@RequestMapping(method = RequestMethod.GET) 
	public ModelAndView getAuthenticationData(){

		AuthenticationData authData =  genericApi.getAuthenticationData();		
		return new ModelAndView("jsonView",  new ModelMap("data", authData));
	}
	
	/**
	 * @return Los items de los menus a los que tiene acceso el usuario identificado (Izquierdo y superior)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET) 
	public ModelAndView getMenuItems(String tipo){

		ModelMap map = new ModelMap();
		
		JSONArray menuItemsPerm = genericApi.getMenuItems(tipo);			
		
		if (menuItemsPerm != null && menuItemsPerm.size()>0) {
			//Devolvemos las opciones de menu permitidas.
			map.put("data",menuItemsPerm);
			map.put("success", true);
		} else {
			map.put("success", false);
		}

		return new ModelAndView("jsonView", map);

	}
	
	/**
	 * Comprueba si se ha registrado el acceso del usuario, y sino lo registra
	 */
	@RequestMapping(method = RequestMethod.GET) 
	public ModelAndView registerUser(){

		adapter.registerUser();	
		
		return new ModelAndView("jsonView",  new ModelMap("success", true));
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboMunicipio(String codigoProvincia){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboMunicipio(codigoProvincia)));		
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboSubtipoActivo(String codigoTipoActivo){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboSubtipoActivo(codigoTipoActivo)));	
	}	

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipoGestor(WebDto webDto, ModelMap model){
		
		model.put("data", genericApi.getComboTipoGestor());
		
		return new ModelAndView("jsonView", model);
		
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipoTrabajoCreaFiltered(){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboTipoTrabajoCreaFiltered()));	
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboSubtipoCarga(String codigoTipoCarga){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboSubtipoCarga(codigoTipoCarga)));	
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboSubtipoTrabajo(String tipoTrabajoCodigo){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboSubtipoTrabajo(tipoTrabajoCodigo)));	
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboSubtipoTrabajoCreaFiltered(String tipoTrabajoCodigo){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboSubtipoTrabajoCreaFiltered(tipoTrabajoCodigo)));	
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboSubtipoTrabajoTarificado(String tipoTrabajoCodigo){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboSubtipoTrabajoTarificado(tipoTrabajoCodigo)));	
	}	
		
	private ModelAndView createModelAndViewJson(ModelMap model) {
		return new ModelAndView("jsonView", model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTextosInformativos(ModelMap model){
		
		model.put("texto", "texto de prueba");
		
		return new ModelAndView("jsonView", model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getJuzgadosPlaza(Long idPlaza, ModelMap model){
		model.put("data", genericApi.getComboTipoJuzgadoPlaza(idPlaza));
		
		return new ModelAndView("jsonView", model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboSubtipoGasto(String codigoTipoGasto){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboSubtipoGasto(codigoTipoGasto)));	
	}
}
