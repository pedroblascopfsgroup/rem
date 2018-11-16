package es.pfsgroup.plugin.rem.controller;


import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.JsonWriterConfiguratorTemplateRegistry;
import org.springframework.web.servlet.view.json.writer.sojo.SojoConfig;
import org.springframework.web.servlet.view.json.writer.sojo.SojoJsonWriterConfiguratorTemplate;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GenericApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.model.AuthenticationData;
import es.pfsgroup.plugin.rem.model.DtoMenuItem;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.rest.dto.DDTipoDocumentoActivoDto;



@Controller
public class GenericController extends ParadiseJsonController{
	
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
	@Override
	protected void initBinder(HttpServletRequest request,  ServletRequestDataBinder binder) throws Exception{
        
		super.initBinder(request, binder);
		
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
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDiccionario(String diccionario) {	
		
		return createModelAndViewJson(new ModelMap("data", adapter.getDiccionario(diccionario)));
		
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDiccionarioDeGastos(String diccionario) {	
		
		return createModelAndViewJson(new ModelMap("data", adapter.getDiccionarioDeGastos(diccionario)));
		
	}


	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDiccionarioTiposDocumento(String diccionario) {	

		if ("tiposDocumento".equals(diccionario)) {
			List<Dictionary> result = adapter.getDiccionario(diccionario);

			List<DDTipoDocumentoActivoDto> out = new ArrayList<DDTipoDocumentoActivoDto>();

			for (Dictionary ddTipoDocumentoActivo : result) {
				if(((DDTipoDocumentoActivo)ddTipoDocumentoActivo).getVisible())
					out.add(new DDTipoDocumentoActivoDto((DDTipoDocumentoActivo) ddTipoDocumentoActivo));
			}

			return createModelAndViewJson(new ModelMap("data", out));	
		}

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
	public ModelAndView getDiccionarioPorCuenta(String tipoCodigo){
		return createModelAndViewJson(new ModelMap("data", genericApi.getDiccionarioPorCuenta(tipoCodigo)));
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDiccionarioTipoBloqueo(String areaCodigo){
		return createModelAndViewJson(new ModelMap("data", genericApi.getDiccionarioTipoBloqueo(areaCodigo)));
	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDiccionarioCarteraPorCodigoFestor() {	
		
		String diccionario = "entidadesPropietarias";
		
		AuthenticationData authData =  genericApi.getAuthenticationData();
		
		String[] codigosGestor = authData.getCodigoGestor().split(",");
		
		for(String codGestor : codigosGestor) {
			if(GestorActivoApi.CODIGO_GESTOR_COMITE_INVERSION_INMOBILIARIA_LIBERBANK.equals(codGestor) || 
				GestorActivoApi.CODIGO_GESTOR_COMITE_DIRECCION_LIBERBANK.equals(codGestor) || 
				GestorActivoApi.CODIGO_GESTOR_COMITE_INMOBILIARIO_LIBERBANK.equals(codGestor))
					diccionario = "gestorCommiteLiberbank";
		}
		
		return createModelAndViewJson(new ModelMap("data", adapter.getDiccionario(diccionario)));
		
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getIndicadorCondicionPrecioFiltered(String codigoCartera){
		return createModelAndViewJson(new ModelMap("data", genericApi.getIndicadorCondicionPrecioFiltered(codigoCartera)));
	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboEspecial(String diccionario){
	
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboEspecial(diccionario)));
	}	
	
	/**
	 * @return Usuario identificado y sus funciones según perfil
	 */
	@RequestMapping(method = RequestMethod.GET) 
	public ModelAndView getAuthenticationData(WebDto webDto, ModelMap model){

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
		
		List<DtoMenuItem> menuItemsPerm = genericApi.getMenuItems(tipo);			
		
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
	public ModelAndView getComboMunicipioSinFiltro(){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboMunicipioSinFiltro()));
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getUnidadPoblacionalByProvincia(String codigoProvincia){
		return createModelAndViewJson(new ModelMap("data", genericApi.getUnidadPoblacionalByProvincia(codigoProvincia)));		
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboSubtipoActivo(String codigoTipoActivo){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboSubtipoActivo(codigoTipoActivo)));	
	}	

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipoGestor(WebDto webDto, ModelMap model){
		model.put("data", genericApi.getComboTipoGestor());
		
		return new ModelAndView("jsonView", model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipoGestorByActivo(WebDto webDto, ModelMap model, String idActivo){
		model.put("data", genericApi.getComboTipoGestorByActivo(webDto, model, idActivo));
		
		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipoGestorOfertas(WebDto webDto, ModelMap model){
		model.put("data", genericApi.getComboTipoGestorOfertas());
		
		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipoGestorActivos(WebDto webDto, ModelMap model){

		Set<String> tipoGestorCodigos = new HashSet<String>();

		tipoGestorCodigos.add("GADM"); // Gestor de admision
		tipoGestorCodigos.add("GACT"); // Gestor de activos
		tipoGestorCodigos.add("GCOM"); // Gestor comercial
		tipoGestorCodigos.add("GGADM"); // Gestoría de Admisión

		model.put("data", genericApi.getComboTipoGestorFiltrado(tipoGestorCodigos));

		return new ModelAndView("jsonView", model);
	}		

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipoTrabajoCreaFiltered(String idActivo){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboTipoTrabajoCreaFiltered(idActivo)));	
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
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboSubtipoClaseActivo(String tipoClaseActivoCodigo){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboSubtipoClaseActivo(tipoClaseActivoCodigo)));	
	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboMotivoRechazoOferta(String tipoRechazoOfertaCodigo){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboMotivoRechazoOferta(tipoRechazoOfertaCodigo)));	
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTextosInformativos(ModelMap model){
		model.put("texto", "texto de prueba");
		
		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getJuzgadosPlaza(Long idPlaza, ModelMap model){
		model.put("data", genericApi.getComboTipoJuzgadoPlaza(idPlaza));
		
		return new ModelAndView("jsonView", model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboSubtipoGasto(String codigoTipoGasto){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboSubtipoGasto(codigoTipoGasto)));	
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboEjercicioContabilidad(ModelMap model){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboEjercicioContabilidad()));	
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComitesByCartera(String carteraCodigo, ModelMap model){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComitesByCartera(carteraCodigo)));	
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComitesByIdExpediente(String idExpediente, ModelMap model){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComitesByIdExpediente(idExpediente)));	
	}
	
	@RequestMapping(method= RequestMethod.GET)
	public ModelAndView getComboNotarios(ModelMap model) {
		
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboProveedorBySubtipo(DDTipoProveedor.COD_NOTARIO)));
		
	}
	
	@RequestMapping(method= RequestMethod.GET)
	public ModelAndView getComboTipoDestinoComercialCreaFiltered() {
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboTipoDestinoComercialCreaFiltered()));	
	}
	
	@RequestMapping(method= RequestMethod.GET)
	public ModelAndView getComboGestoriasGasto() {
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboGestoriasGasto()));	
	}
	
	@RequestMapping(method= RequestMethod.GET)
	public ModelAndView getComboSubcartera(String idCartera) {
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboSubcartera(idCartera)));	
	}
	
	@RequestMapping(method= RequestMethod.GET)
	public ModelAndView getComboTipoAgrupacion() {
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboTipoAgrupacion()));
	}
	
	@RequestMapping(method= RequestMethod.GET)
	public ModelAndView getTodosComboTipoAgrupacion()
	{
		return createModelAndViewJson(new ModelMap("data", genericApi.getTodosComboTipoAgrupacion()));
	}
}
