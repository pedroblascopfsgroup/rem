package es.pfsgroup.plugin.recovery.config.controller;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.despachoExterno.model.DespachoAmbitoActuacion;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.direccion.model.DDComunidadAutonoma;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.config.despachoExterno.ADMDespachoExternoManager;
import es.pfsgroup.plugin.recovery.coreextension.utils.UtilDiccionarioManager;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcel;
import es.pfsgroup.plugin.recovery.coreextension.utils.jxl.HojaExcelInformeSubasta;
import es.pfsgroup.recovery.ext.turnadodespachos.DDEstadoEsquemaTurnado;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnado;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoBusquedaDto;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoConfig;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoDespachoDto;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoDto;
import es.pfsgroup.recovery.ext.turnadodespachos.TurnadoDespachosManager;
//import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoComponente;

@Controller
public class TurnadoDespachosController {

	private final Log logger = LogFactory.getLog(getClass());

	private static final String VIEW_ESQUEMA_TURNADO_BUSCADOR = "plugin/config/turnadodespachos/buscadorEsquemas";
	private static final String VIEW_ESQUEMA_TURNADO_SEARCH = "plugin/config/turnadodespachos/busquedaEsquemasJSON";
	private static final String VIEW_ESQUEMA_TURNADO_EDITAR = "plugin/config/turnadodespachos/editarEsquema";
	//private static final String VIEW_ESQUEMA_TURNADO_GUARDAR_JSON = "plugin/config/turnadodespachos/editarEsquema";
	private static final String VIEW_LETRADO_ESQUEMA_TURNADO_GET = "plugin/config/turnadodespachos/esquemaTurnadoJSON";
	private static final String VIEW_ESQUEMA_TURNADO_LETRADO = "plugin/config/turnadodespachos/editarEsquemaLetrado";
	private static final String JSP_DOWNLOAD_FILE = "plugin/geninformes/download";
	
	private static final String VIEW_DEFAULT = "default";

	private static final String KEY_DATA = "data";
	
	@Autowired
	private TurnadoDespachosManager turnadoDespachosManager;
	
	@Autowired
	private UtilDiccionarioManager utilDiccionarioManager;
	
	@Autowired
	private ADMDespachoExternoManager despachoExternoManager;
	private static final String KEY_MODO_CONSULTA = "modConsulta";
	
    @Autowired
    private UsuarioManager usuarioManager;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String ventanaBusquedaEsquemas(ModelMap map) {
		map.put("estadosEsquema", utilDiccionarioManager.dameValoresDiccionario(DDEstadoEsquemaTurnado.class));
		return VIEW_ESQUEMA_TURNADO_BUSCADOR;
	}
	
	@RequestMapping
	public String ventanaEditarLetrado(@RequestParam(value="id", required=true) Long idDespacho, 
			Model model) {
		
		DespachoExterno despacho = despachoExternoManager.getDespachoExterno(idDespacho);
		model.addAttribute("despacho", despacho);
		
		List<DespachoAmbitoActuacion> listaAmbitoActuacion = despachoExternoManager.getAmbitoGeograficoDespacho(idDespacho);
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
		
		model.addAttribute("listaComunidadesDespacho", listaComunidadesDespacho);
		model.addAttribute("listaProvinciasDespacho", listaProvinciasDespacho);
		
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
	public String getEsquemaVigente(EsquemaTurnadoDto dto
			, Model model) {
		EsquemaTurnado esquema = turnadoDespachosManager.getEsquemaVigente();
		model.addAttribute(KEY_DATA, esquema);
		return VIEW_LETRADO_ESQUEMA_TURNADO_GET;
	}
	
	@RequestMapping
	public String guardarEsquema(@ModelAttribute EsquemaTurnadoDto dto
			, Model model) {
		if (dto.validar()) {
			turnadoDespachosManager.save(dto);
		}
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
	public String activarEsquema(Long id, Model model) {
		try {
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
	public String descargarConfiguracionDespachos(Model model) 
	{
		List<String> cabeceras=new ArrayList<String>();
		cabeceras.add("IDENTIFICACIÓN DEL DESPACHO");
		cabeceras.add("NOMBRE");
		cabeceras.add("TIPO IMPORTE - LITIGIOS");
		cabeceras.add("TIPO IMPORTE - CONCURSOS");
		cabeceras.add("TIPO CALIDAD - LITIGIOS");
		cabeceras.add("TIPO CALIDAD - CONCURSAL");
		
		List<List<String>> valores = new ArrayList<List<String>>();
		List<String> fila = null;
		
		String templatePar = ";Automatic;Text";
		String templateImpar = ";Grey;Text";
		String template = templatePar;
		
		List<DespachoExterno> despachosExternos = despachoExternoManager.buscaDespachosExternos();
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
}
