package es.pfsgroup.plugin.recovery.config.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.binding.message.Message;
import org.springframework.binding.message.Severity;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.devon.validation.ErrorMessage;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.devon.web.fileupload.FileUpload;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoAmbitoActuacion;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.direccion.model.DDComunidadAutonoma;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.config.despachoExterno.ADMDespachoExternoManager;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMDespachoAmbitoActuacionDao;
import es.pfsgroup.plugin.recovery.coreextension.utils.UtilDiccionarioManager;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcel;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcelInformeSubasta;
import es.pfsgroup.recovery.ext.turnadodespachos.DDEstadoEsquemaTurnado;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaDespachoValidacionDto;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnado;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoBusquedaDto;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoConfig;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoDespachoDto;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoDto;
import es.pfsgroup.recovery.ext.turnadodespachos.TurnadoDespachosManager;

@Controller
public class TurnadoDespachosController {

	private final Log logger = LogFactory.getLog(getClass());

	private static final String VIEW_ESQUEMA_TURNADO_BUSCADOR = "plugin/config/turnadodespachos/buscadorEsquemas";
	private static final String VIEW_ESQUEMA_TURNADO_SEARCH = "plugin/config/turnadodespachos/busquedaEsquemasJSON";
	private static final String VIEW_ESQUEMA_TURNADO_EDITAR = "plugin/config/turnadodespachos/editarEsquema";
	private static final String VIEW_LETRADO_ESQUEMA_TURNADO_GET = "plugin/config/turnadodespachos/esquemaTurnadoJSON";
	private static final String VIEW_ESQUEMA_TURNADO_LETRADO = "plugin/config/turnadodespachos/editarEsquemaLetrado";
	private static final String JSP_DOWNLOAD_FILE = "plugin/geninformes/download";
	private static final String OK_KO_RESPUESTA_JSON = "plugin/coreextension/OkRespuestaJSON";
	private static final String VIEW_ASIGNAR_CALIDAD_PROVINCIA = "plugin/config/turnadodespachos/editarCalidadProvincia";
	
	private static final String VIEW_DEFAULT = "default";

	private static final String KEY_DATA = "data";
	
	private static final String CODIGO_ERROR_TIPO_FICHERO = "plugin.config.esquematurnado.carga.validacion.errorTipoFichero";
		
	@Resource
	private Properties appProperties;
	
	@Autowired
	private MessageSource messageSource;
	
	
	@Autowired
	private TurnadoDespachosManager turnadoDespachosManager;
	
	@Autowired
	private UtilDiccionarioManager utilDiccionarioManager;
	
	@Autowired
	private ADMDespachoExternoManager despachoExternoManager;
	private static final String KEY_MODO_CONSULTA = "modConsulta";
	
    @Autowired
    private UsuarioManager usuarioManager;
    
    @Autowired
    private FileUpload fileUpload;
    
    @Autowired
	private ADMDespachoAmbitoActuacionDao despachoAmbitoActuacionDao;
    
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String ventanaBusquedaEsquemas(ModelMap map) {
		map.put("estadosEsquema", utilDiccionarioManager.dameValoresDiccionario(DDEstadoEsquemaTurnado.class));
		return VIEW_ESQUEMA_TURNADO_BUSCADOR;
	}
	
	@RequestMapping
	public String ventanaEditarLetrado(@RequestParam(value="id", required=true) Long idDespacho, 
			Model model) {
		EsquemaTurnado esquemaVigente = null;
		
		
		DespachoExterno despacho = despachoExternoManager.getDespachoExterno(idDespacho);
		model.addAttribute("despacho", despacho);
		
		List<DespachoAmbitoActuacion> listaAmbitoActuacion = despachoExternoManager.getAmbitoGeograficoDespacho(idDespacho);
		List<String> listaComunidadesDespacho = new LinkedList<String>();
		List<String> listaProvinciasDespacho = new LinkedList<String>();
		List<DDProvincia> listaProvinciasDespachoNombre = new LinkedList<DDProvincia>();
		List<String> listaProvinciasPorcentaje = new LinkedList<String>();
		
		for(DespachoAmbitoActuacion ambitoActuacion : listaAmbitoActuacion) {
			
			if(ambitoActuacion.getComunidad() != null) {
				listaComunidadesDespacho.add(ambitoActuacion.getComunidad().getCodigo());
			}
			
			if(ambitoActuacion.getProvincia() != null) {
				listaProvinciasDespacho.add(ambitoActuacion.getProvincia().getCodigo());
				listaProvinciasDespachoNombre.add(ambitoActuacion.getProvincia());
				listaProvinciasPorcentaje.add(ambitoActuacion.getPorcentaje());
			}
		}
		
		model.addAttribute("listaComunidadesDespacho", listaComunidadesDespacho);
		model.addAttribute("listaProvinciasDespacho", listaProvinciasDespacho);
		model.addAttribute("listaProvinciasDespachoNombre", listaProvinciasDespachoNombre);
		model.addAttribute("listaProvinciasPorcentaje", listaProvinciasPorcentaje);
		
		List<EsquemaTurnadoConfig> listTipoImporteLitigio = new LinkedList<EsquemaTurnadoConfig>();
		List<EsquemaTurnadoConfig> listTipoCalidadLitigio = new LinkedList<EsquemaTurnadoConfig>();
		List<EsquemaTurnadoConfig> listTipoImporteConcursal = new LinkedList<EsquemaTurnadoConfig>();
		List<EsquemaTurnadoConfig> listTipoCalidadConcursal = new LinkedList<EsquemaTurnadoConfig>();
		
		EsquemaTurnado esquema = turnadoDespachosManager.getEsquemaVigente();
		List<EsquemaTurnadoConfig> configs = esquema.getConfiguracion();
		
		for(EsquemaTurnadoConfig config : configs) {
			
			if(config.getTipo().equals(EsquemaTurnadoConfig.TIPO_LITIGIOS_IMPORTE)) {
				listTipoImporteLitigio.add(config);
			}
			else if(config.getTipo().equals(EsquemaTurnadoConfig.TIPO_LITIGIOS_CALIDAD)) {
				listTipoCalidadLitigio.add(config);
			}
			else if(config.getTipo().equals(EsquemaTurnadoConfig.TIPO_CONCURSAL_IMPORTE)) {
				listTipoImporteConcursal.add(config);
			}
			else if(config.getTipo().equals(EsquemaTurnadoConfig.TIPO_CONCURSAL_CALIDAD)) {
				listTipoCalidadConcursal.add(config);
			}			
		}

		model.addAttribute("tiposImporteLitigio", listTipoImporteLitigio);
		model.addAttribute("tiposCalidadLitigio", listTipoCalidadLitigio);
		model.addAttribute("tiposImporteConcursal", listTipoImporteConcursal);
		model.addAttribute("tiposCalidadConcursal", listTipoCalidadConcursal);
		
		model.addAttribute("listaComunidadesAutonomas", utilDiccionarioManager.dameValoresDiccionario(DDComunidadAutonoma.class));
		model.addAttribute("listaProvincias", utilDiccionarioManager.dameValoresDiccionario(DDProvincia.class));
		
		return VIEW_ESQUEMA_TURNADO_LETRADO;
	}
	
	@RequestMapping
	public String buscarEsquemas(EsquemaTurnadoBusquedaDto dto
			, Model model) {
		
		Page page = (Page)turnadoDespachosManager.listaEsquemasTurnado(dto);
		model.addAttribute(KEY_DATA, page);

		Usuario usuarioLogado = usuarioManager.getUsuarioLogado();
		model.addAttribute("usuario", usuarioLogado);
		
		return VIEW_ESQUEMA_TURNADO_SEARCH;
	}

	@RequestMapping
	public String editarEsquema(@RequestParam(required=false) Long id
			, Model model) {
		EsquemaTurnado esquema = (id!=null) 
				? turnadoDespachosManager.get(id)
				: new EsquemaTurnado();
				
		boolean modoConsulta = turnadoDespachosManager.isModificable(esquema);
		model.addAttribute(KEY_MODO_CONSULTA, modoConsulta);
		model.addAttribute(KEY_DATA, esquema);
		return VIEW_ESQUEMA_TURNADO_EDITAR;
	}

	@RequestMapping
	public String getEsquemaVigente(Model model) {
		EsquemaTurnado esquema = null;
		try {
			esquema = turnadoDespachosManager.getEsquemaVigente();
		} catch (IllegalArgumentException iarExp) {
			esquema = new EsquemaTurnado();
		}
		model.addAttribute(KEY_DATA, esquema);
		return VIEW_LETRADO_ESQUEMA_TURNADO_GET;
	}
	
	@RequestMapping
	public String guardarEsquema(@ModelAttribute EsquemaTurnadoDto dto
			, Locale locale
			, Model model) {
		dto.validar(messageSource,locale);	
		turnadoDespachosManager.save(dto);
		return VIEW_DEFAULT;
	}

	@RequestMapping
	public String copiarEsquema(Long id, Model model) {
		turnadoDespachosManager.copy(id);
		return VIEW_DEFAULT;
	}

	@RequestMapping
	public String borrarEsquema(Long id, Model model) {
		turnadoDespachosManager.delete(id);
		return VIEW_DEFAULT;
	}

	@RequestMapping
	public String activarEsquema(Long id, boolean limpiarDatos, Model model) {
		try {
			if (limpiarDatos) {
				turnadoDespachosManager.limpiarTurnadoTodosLosDespachos(id);
			}
			turnadoDespachosManager.activarEsquema(id);
		} catch (Exception ex) {
			logger.warn("Error al activar el esquema de turnado", ex);
		}
		return VIEW_DEFAULT;
	}
	
	@RequestMapping
	public String guardarEsquemaDespacho(EsquemaTurnadoDespachoDto dto,
			Model model) {
		if (dto.validar()) {
			despachoExternoManager.saveEsquemaDespacho(dto);
		}
		return VIEW_DEFAULT;
	}
	
	@RequestMapping

	public String checkActivarEsquema(Long id
			, Model model
			, HttpServletResponse response) {
		boolean resultado = turnadoDespachosManager.checkActivarEsquema(id);
		response.setContentType("application/json");
		PrintWriter out;
		try {
			out = response.getWriter();
			out.println(String.format("{resultado:%s}", resultado));
		} catch (IOException e) {
			logger.error("No puedo recuperar objeto response de la petición HTTP", e);
		}
		return null;
	}
	
	@RequestMapping
    public String descargarConfiguracionDespachos(Model model) 
	{
		List<String> cabeceras=new ArrayList<String>();
		cabeceras.add("IDENTIFICACIÓN DEL DESPACHO");
		cabeceras.add("NOMBRE");
		cabeceras.add("TIPO IMPORTE - LITIGIOS");
		cabeceras.add("TIPO IMPORTE - CONCURSOS");
		cabeceras.add("TIPO CALIDAD - LITIGIOS");
		cabeceras.add("TIPO CALIDAD - CONCURSOS");
		
		List<List<String>> valores = new ArrayList<List<String>>();
		List<String> fila = null;
		
		String templatePar = ";Automatic;Text";
		String templateImpar = ";Grey;Text";
		String template = templatePar;

		// Se recuperan los datos únicamente de los despachos de tipo 'Despacho Externo'
		DDTipoDespachoExterno tipoDespachoExterno = (DDTipoDespachoExterno) utilDiccionarioManager.dameValorDiccionarioByCod(DDTipoDespachoExterno.class, DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO);
		List<DespachoExterno> despachosExternos = despachoExternoManager.getDespachoExternoByTipo(tipoDespachoExterno.getId());
		for(DespachoExterno despachoExterno : despachosExternos) {
			
			if(template == templateImpar) {
				template = templatePar;
			}
			else {
				template = templateImpar;
			}
		
			fila = new ArrayList<String>();
			
			fila.add(despachoExterno.getId() + template);
			fila.add(despachoExterno.getDescripcion() + template);
			fila.add((despachoExterno.getTurnadoCodigoImporteLitigios() == null ? "" : despachoExterno.getTurnadoCodigoImporteLitigios()) + template);
			fila.add((despachoExterno.getTurnadoCodigoImporteConcursal() == null ? "" : despachoExterno.getTurnadoCodigoImporteConcursal()) + template);
			fila.add((despachoExterno.getTurnadoCodigoCalidadLitigios() == null ? "" : despachoExterno.getTurnadoCodigoCalidadLitigios()) + template);
			fila.add((despachoExterno.getTurnadoCodigoCalidadConcursal() == null ? "" : despachoExterno.getTurnadoCodigoCalidadConcursal()) + template);
			
			valores.add(fila);
		}
				
		HojaExcelInformeSubasta hojaExcel = new HojaExcelInformeSubasta();
		hojaExcel.crearNuevoExcel("configuracion_despachos.xls", cabeceras, valores);
		
		FileItem excelFileItem = new FileItem(hojaExcel.getFile());
        excelFileItem.setFileName("configuracion_despachos.xls");
        excelFileItem.setContentType(HojaExcel.TIPO_EXCEL);
        excelFileItem.setLength(hojaExcel.getFile().length());
	    
        model.addAttribute("fileItem",excelFileItem);
		return JSP_DOWNLOAD_FILE;
	}
	
	@RequestMapping
    public String cargarConfiguracionDespachos(Model model,
			HttpServletRequest request) 
	{
		String resultado = "";
		try {
			WebFileItem uploadForm = fileUpload.fileUpload(request);
			
			if (uploadForm != null) {
	
				FileItem fileItem = uploadForm.getFileItem();
				
				// Se comprueba el tipo de fichero
				if (!fileItem.getContentType().equals("application/vnd.ms-excel")){
					List<Message> mensajes = new ArrayList<Message>();
					mensajes.add(new Message(this, messageSource.getMessage(CODIGO_ERROR_TIPO_FICHERO, new Object[] {}, MessageUtils.DEFAULT_LOCALE), Severity.ERROR));
					throw new ValidationException(ErrorMessageUtils.convertMessages(mensajes));					
				}
				else {
				
					// Se obtiene la Excel y se crea un DTO para que lo valide y obtenga los registros
					HojaExcel exc = new HojaExcel();
					exc.setFile(fileItem.getFile());
					exc.setRuta(fileItem.getFile().getAbsolutePath());
					
					EsquemaTurnado esquemaVigente = turnadoDespachosManager.getEsquemaVigente();
					
					EsquemaDespachoValidacionDto dto = new EsquemaDespachoValidacionDto();
					dto.setEsquema(esquemaVigente);
					dto.validarFichero(exc);
				
					// Se guardan los registros
					for(EsquemaTurnadoDespachoDto esquemaTurnadoDespachoDto : dto.getListaRegistros()) {
						
						List<DespachoAmbitoActuacion> listaAmbitoActuacion = despachoExternoManager.getAmbitoGeograficoDespacho(esquemaTurnadoDespachoDto.getId());
						List<String> listaComunidadesDespacho = new LinkedList<String>();
						List<String> listaProvinciasDespacho = new LinkedList<String>();
						
						for(DespachoAmbitoActuacion ambitoActuacion : listaAmbitoActuacion) {
							
							if(ambitoActuacion.getComunidad() != null) {
								listaComunidadesDespacho.add(ambitoActuacion.getComunidad().getCodigo());
							}
							
							if(ambitoActuacion.getProvincia() != null) {
								listaProvinciasDespacho.add(ambitoActuacion.getProvincia().getCodigo());
							}
						}
						esquemaTurnadoDespachoDto.setListaComunidades(StringUtils.join(listaComunidadesDespacho.toArray(), ","));
						esquemaTurnadoDespachoDto.setListaProvincias(StringUtils.join(listaProvinciasDespacho.toArray(), ","));							
						
						despachoExternoManager.saveEsquemaDespacho(esquemaTurnadoDespachoDto);
					}
					
					resultado = "ok";
				}
			}		
		}
		catch(ValidationException ve) {			
			for(ErrorMessage message : ve.getMessages()) {
				resultado += message.getText() + " ";
			}
		}
      		
		model.addAttribute("okko", resultado);
		
		return OK_KO_RESPUESTA_JSON;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String ventanaAsignarCalidadProvincia(@RequestParam(required=false) Long id
			, Model model) {
		List<DespachoAmbitoActuacion> listaAmbitoActuacion = (id!=null) 
				? despachoExternoManager.getAmbitoGeograficoDespacho(id)
				: new ArrayList<DespachoAmbitoActuacion>();
		
		ArrayList<DespachoAmbitoActuacion> listaBorrarAmbito = new ArrayList<DespachoAmbitoActuacion>();
		List<DDProvincia> listaProvinciasDespachoNombre = new LinkedList<DDProvincia>();
		List<String> listaProvinciasPorcentaje = new LinkedList<String>();
		for(DespachoAmbitoActuacion ambitoActuacion : listaAmbitoActuacion) {
			if(ambitoActuacion.getProvincia() != null) {
				listaProvinciasDespachoNombre.add(ambitoActuacion.getProvincia());
				listaProvinciasPorcentaje.add(ambitoActuacion.getPorcentaje());
			}
			else {
				listaBorrarAmbito.add(ambitoActuacion);
			}
		}
		/*
		 * Solo conservo objetos que contiene provincia en objetos de tipo DespachoAmbitoActuacion
		 */
		for(DespachoAmbitoActuacion borrarAmbito : listaBorrarAmbito) {
			listaAmbitoActuacion.remove(borrarAmbito);
		}

		model.addAttribute("despachoId", id);
		model.addAttribute("listaProvinciasDespachoNombre", listaProvinciasDespachoNombre);
		model.addAttribute("listaProvinciasPorcentaje", listaProvinciasPorcentaje);
		return VIEW_ASIGNAR_CALIDAD_PROVINCIA;
	}
	
	
	@RequestMapping
	public String guardarCalidadProvincia(@RequestParam(value = "despacho", required = true) Long idDespacho,
			@RequestParam(value = "codigoProvincia", required = true) String codProvincia,
			@RequestParam(value = "calidadProvincia", required = true) String calidad,
			Model model) 
	{	
		try {
			DespachoAmbitoActuacion despachoAmbitoActuacion = despachoAmbitoActuacionDao.getByDespachoYProvincia(idDespacho, codProvincia);
			despachoAmbitoActuacion.setPorcentaje(calidad);
			despachoExternoManager.guardarAmbitoActuacion(despachoAmbitoActuacion);
		}
		catch(Exception e) {
			logger.error("Error en el método guardarCalidadProvincia: " + e .getMessage());
			throw new BusinessOperationException(e);
		}
		
		return VIEW_DEFAULT;
	}
}
