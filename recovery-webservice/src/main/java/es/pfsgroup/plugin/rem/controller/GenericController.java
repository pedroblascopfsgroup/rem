package es.pfsgroup.plugin.rem.controller;

import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.ExpedienteComercialAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.api.GenericApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.api.UploadApi;
import es.pfsgroup.plugin.rem.logTrust.LogTrustAcceso;
import es.pfsgroup.plugin.rem.model.AuthenticationData;
import es.pfsgroup.plugin.rem.model.DtoMenuItem;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTareaDestinoSalto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.DDTipoDocumentoActivoDto;
import es.pfsgroup.plugin.rem.rest.dto.DocumentoDto;
import es.pfsgroup.plugin.rem.rest.dto.DocumentoRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import net.sf.json.JSONObject;


@Controller
public class GenericController extends ParadiseJsonController{
	
	@Autowired
	private GenericAdapter adapter;
	
	@Autowired
	private GenericApi genericApi;

	@Autowired
	private LogTrustAcceso trustMe;
	
	@Autowired
	private RestApi restApi;
	
	
	@Resource
	Properties appProperties;
	
	@Autowired
	private ActivoAdapter adapterActivo;

	@Autowired
	private TrabajoApi trabajoApi;

	@Autowired
	private ExpedienteComercialAdapter expedienteComercialAdapter;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GastoProveedorApi gastoProveedorApi;
	
	@Autowired
	private UploadApi uploadApi;
	

	
	private static final String DICCIONARIO_TIPO_DOCUMENTO = "tiposDocumento";
	
	private static final String DICCIONARIO_TIPO_DOCUMENTO_ENTIDAD_ACTIVO = "activo";
	private final Log logger = LogFactory.getLog(getClass());

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
	public ModelAndView getDiccionarioByTipoOferta(String diccionario, String codTipoOferta) {
		
		return createModelAndViewJson(new ModelMap("data", genericApi.getDiccionarioByTipoOferta(diccionario, codTipoOferta)));
	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDiccionarioTiposDocumento(String diccionario, String entidad) {	

		if (GenericController.DICCIONARIO_TIPO_DOCUMENTO.equals(diccionario)) {
			List<Dictionary> result = adapter.getDiccionario(diccionario);

			List<DDTipoDocumentoActivoDto> out = new ArrayList<DDTipoDocumentoActivoDto>();

			//si es un ñapa... lo se. Si el flag visible es 1, son docs del activo, sino, son del trabajo
			for (Dictionary ddTipoDocumentoActivo : result) {
				if(entidad == null || entidad.equals(GenericController.DICCIONARIO_TIPO_DOCUMENTO_ENTIDAD_ACTIVO)){
					if(((DDTipoDocumentoActivo)ddTipoDocumentoActivo).getVisible()){
						out.add(new DDTipoDocumentoActivoDto((DDTipoDocumentoActivo) ddTipoDocumentoActivo));
					}						
				}else{
					if(!((DDTipoDocumentoActivo)ddTipoDocumentoActivo).getVisible()){
						out.add(new DDTipoDocumentoActivoDto((DDTipoDocumentoActivo) ddTipoDocumentoActivo));
					}						
				}
				
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
		if(authData.getUserId() != null){
			adapter.registerUser();
		}
		
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
		
		if (menuItemsPerm != null && !menuItemsPerm.isEmpty()) {
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
		trustMe.registrarAcceso();
		
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
	
	@SuppressWarnings("unchecked")
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
	public ModelAndView getComboSubtipoTrabajo(String tipoTrabajoCodigo, Long idActivo){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboSubtipoTrabajo(tipoTrabajoCodigo, idActivo)));
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
	public ModelAndView getComboMotivoRechazoOferta(String tipoRechazoOfertaCodigo, Long idOferta){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboMotivoRechazoOferta(tipoRechazoOfertaCodigo, idOferta)));	
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
	public ModelAndView getComitesByCartera(String carteraCodigo, String subcarteraCodigo, ModelMap model){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComitesByCartera(carteraCodigo, subcarteraCodigo)));	
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
	public ModelAndView getComitesAlquilerByCartera(Long idActivo, ModelMap model){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComitesAlquilerByCartera(idActivo)));
	}

	@RequestMapping(method= RequestMethod.GET)
	public ModelAndView getComitesAlquilerByCarteraCodigo(String carteraCodigo, ModelMap model){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComitesAlquilerByCarteraCodigo(carteraCodigo)));
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
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipoTituloActivoTPA(Long numActivo){
		return createModelAndViewJson(new ModelMap("data", genericApi.getComboTipoTituloActivoTPA(numActivo)));	
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDiccionarioTiposDocumentoTributo(String diccionario, String entidad) {	
		return createModelAndViewJson(new ModelMap("data", genericApi.getDiccionarioTiposDocumentoTributo()));
	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDiccionarioLanzarTareaAdministrativa(String diccionario, Long idExpediente) {
		ExpedienteComercial expediente = null;
		List<Dictionary> lista = adapter.getDiccionario(diccionario);
		
		if(!Checks.esNulo(idExpediente)) {
			expediente = expedienteComercialApi.findOne(idExpediente);
		
			if(!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getOferta()) && 
					DDCartera.CODIGO_CARTERA_THIRD_PARTY.equalsIgnoreCase(expediente.getOferta().getActivoPrincipal().getCartera().getCodigo()) && 
					DDSubcartera.CODIGO_OMEGA.equalsIgnoreCase(expediente.getOferta().getActivoPrincipal().getSubcartera().getCodigo()) && 
					"tareaDestinoSalto".equals(diccionario)) {
				for(int i=0; i<lista.size(); i++) {
					DDTareaDestinoSalto tareaSalto = (DDTareaDestinoSalto) lista.get(i);
					if(DDTareaDestinoSalto.CODIGO_RESULTADO_PBC.equalsIgnoreCase(tareaSalto.getCodigo())) {
						tareaSalto.setDescripcion("PBC Venta");
						tareaSalto.setDescripcionLarga("PBC Venta");
					}
				}
			}
		}
		
		return createModelAndViewJson(new ModelMap("data", lista));
	}

		/**
	 * Inserta un documento a la entidad correspondiente  Ejem: IP:8080/pfs/rest/generic/altaDocumento
	 * HEADERS:
	 * Content-Type - application/json
	 * signature - 
	 * 
	 * BODY:
	 * {  
   "id":"112",
   "data": 
      {  "tipoEntidad":"T",
    	 "numEntidad":"161197",
    	 "tipoDocumento":"03",
    	 "subTipoDocumento":"26",
    	 "nombreDocumento":"prueba10.pdf",
    	 "descripcionDocumento":"prueba del post",
    	 "documento":"YnVlbm9zIGRpYXMgdGVuZ28gbGliZXJ0YWQgcGFyYSBoYWNlciBlbiBlbCB3ZWIgc2VydmljZSBjb21vIHlvIHZlYS4="
      
      }
   
} *  
	 *
	 * @param model
	 * @param request
	 * @return
	 */
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST , value = "/generic/altaDocumento")
	public void altaDocumento (ModelMap model, RestRequestWrapper request,HttpServletResponse response) {
		DocumentoRequestDto jsonData = null;
		JSONObject jsonFields = null;
		DocumentoDto documentoDto = null;
		String rutaFichero = appProperties.getProperty("files.temporaryPath","/tmp")+"/";
		WebFileItem webFileItem;
		FileItem fileItem;
		String tipoEntidad;
		String errores="";
		java.io.File file;
		String id = null;
		String descErrores = null;
		Map <String, String> validaciones = new HashMap<String, String>();
		validaciones.put("A", UploadApi.VALIDATE_WEBFILE_ACTIVO);
		validaciones.put("O", UploadApi.VALIDATE_WEBFILE_EXPEDIENTE);
		validaciones.put("T", UploadApi.VALIDATE_WEBFILE_TRABAJO);
		validaciones.put("G", UploadApi.VALIDATE_WEBFILE_GASTO_PROOVEDOR);
		try {
			jsonFields = request.getJsonObject();
			jsonData = (DocumentoRequestDto) request.getRequestData(DocumentoRequestDto.class);
			if(jsonFields.isNullObject() || jsonFields.isEmpty() || Checks.esNulo(jsonData)) {
				errores = RestApi.REST_MSG_MISSING_REQUIRED_FIELDS;
				descErrores = "Faltan campos";
				throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
			}else {
				String key = null;
				String value = null;
				id = jsonData.getId() ;
				if(Checks.esNulo(id)) {
					errores = RestApi.REST_MSG_MISSING_REQUIRED_FIELDS;
					descErrores = "Faltan campos";
						throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
				}else if (!Checks.esNulo(id)){
					try {
						Long.valueOf(id);	 
						Map<String, String> jsonDataFields = jsonData.getData().getDataFields(); 
						for (Object keys : jsonFields.getJSONObject("data").keySet()) {
							 key = String.valueOf(keys);
							 value = jsonDataFields.get(key);
							if (!jsonDataFields.containsKey(key) && !key.matches("subTipoDocumento")) 
								throw new Exception(RestApi.REST_MSG_UNKNOWN_KEY);
							if (Checks.esNulo(value))
								throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
							if ( key.matches("tipoEntidad|nombreDocumento|descripcionDocumento|documento|tipoDocumento|subTipoDocumento")) {
								String.valueOf(value);
								if (key.matches("nombreDocumento") && value.trim().length() <= 4) {
									throw new Exception (RestApi.REST_MSG_FORMAT_ERROR);
								}
							}else if ( key.matches("numEntidad")) {
								Long.valueOf(value);
							}
						}
						if (!Checks.esNulo(jsonDataFields.get("tipoEntidad")) 
						&& "O".equalsIgnoreCase(jsonDataFields.get("tipoEntidad"))
						&& Checks.esNulo(jsonDataFields.get("subTipoDocumento"))) {
							throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS +"_SUBTIPO");
						}
					}catch (Exception e) {
						if (RestApi.REST_MSG_MISSING_REQUIRED_FIELDS.equals(e.getMessage())) {
							errores = RestApi.REST_MSG_MISSING_REQUIRED_FIELDS;
							descErrores = "Faltan campos ["+key+"]";
							throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);	
						} else if(RestApi.REST_MSG_UNKNOWN_KEY.equals(e.getMessage())){
							errores = RestApi.REST_MSG_UNKNOWN_KEY;
							descErrores = " No se reconoce este campo. [ "+ key +" ]";
							throw new Exception(RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
						} else if ((RestApi.REST_MSG_MISSING_REQUIRED_FIELDS+"_SUBTIPO").equals(e.getMessage())) {
							errores = RestApi.REST_MSG_MISSING_REQUIRED_FIELDS;
							descErrores = "Faltan campos [ subtipoDocumento ]";
							throw new Exception (RestApi.REST_MSG_MISSING_REQUIRED_FIELDS);
						}else if (RestApi.REST_MSG_FORMAT_ERROR.equals(e.getMessage())) {
						//	Errores personalizados para error de formato
							if (key.matches("nombreDocumento")) {
								errores = RestApi.REST_MSG_FORMAT_ERROR;
								descErrores = "Error nombre incorrecto de documento ejemplo: nombre.extension";
								throw new Exception (RestApi.REST_MSG_FORMAT_ERROR);
							}
						}else {
							errores = RestApi.REST_MSG_FORMAT_ERROR;
							descErrores = "El formato del parametro [ "+key+" ] no es el correcto.";
							throw new Exception(RestApi.REST_MSG_FORMAT_ERROR);
						}
					}
					documentoDto = jsonData.getData();
					tipoEntidad = documentoDto.getTipoEntidad().trim().toUpperCase();
					byte [] fichero = DatatypeConverter.parseBase64Binary(documentoDto.getDocumento());
					file = new java.io.File(rutaFichero+documentoDto.getNombreDocumento()); 
					file.createNewFile(); 
					FileOutputStream fop = new FileOutputStream(file); 
					try {
						fop.write(fichero); 
						fop.flush(); 
					}finally {
						fop.close(); 
					}
					
					
					fileItem = new FileItem(file);
					fileItem.setFileName(documentoDto.getNombreDocumento());
					fileItem.setLength(fichero.length);
					webFileItem = new WebFileItem();
					webFileItem.setFileItem(fileItem);
					webFileItem.putParameter("tipo", documentoDto.getTipoDocumento());
					webFileItem.putParameter("subtipo", documentoDto.getSubTipoDocumento());
					webFileItem.putParameter("descripcion", documentoDto.getDescripcionDocumento());
					
					if (!tipoEntidad.matches("G|A|T|O")) {
						errores = RestApi.REST_MSG_INVALID_ENTITY_TYPE;
						descErrores = "El tipo de entidad especificada no existe";
						throw new Exception(RestApi.REST_MSG_INVALID_ENTITY_TYPE);
					}else {						
						webFileItem.putParameter("UploadAction", validaciones.get(tipoEntidad));
						webFileItem.putParameter("numEntidadDto", documentoDto.getNumEntidad().trim());
						Map <String, Object > data = uploadApi.validateAndUploadWebFileItem(webFileItem);
						if (!Checks.esNulo(data.get("error"))) {
							errores = (String)data.get("error");
							descErrores = (String) data.get("descError");
							throw new Exception(errores);
						}else {
							model.put("id", id);
							model.put("data", documentoDto);
							model.put("succes", true); 
						}
					}
				}
			}
			
		} catch (Exception e) {
			logger.error("Error alta documento en genericController", e);
			request.getPeticionRest().setErrorDesc(e.getMessage());
			errores = e.getMessage();
			if (Checks.esNulo(errores)) { 
				String [] splitError = e.toString().split("\\."); 
				errores = splitError[splitError.length -1];	
			}	
			model.put("id", id);
			model.put("error", errores);
			model.put("descError", descErrores);
			model.put("success", false);
			
		}
	
		restApi.sendResponse(response, model,request);
	}
 }

