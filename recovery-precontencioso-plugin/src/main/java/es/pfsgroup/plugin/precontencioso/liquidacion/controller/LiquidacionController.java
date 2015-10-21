package es.pfsgroup.plugin.precontencioso.liquidacion.controller;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.core.api.parametrizacion.ParametrizacionApi;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.GestorTareasApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.LiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.dto.LiquidacionDTO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.geninformes.api.GENINFInformesApi;

@Controller
public class LiquidacionController {

	private static final String DEFAULT = "default";
	private static final String JSON_LIQUIDACIONES = "plugin/precontencioso/liquidacion/json/liquidacionesJSON";
	private static final String JSON_OCULTAR_BOTON_SOLICITAR = "plugin/precontencioso/liquidacion/json/ocultarBtnSolicitarJSON";
	private static final String JSP_EDITAR_LIQUIDACION = "plugin/precontencioso/liquidacion/popups/editarLiquidacion";
	private static final String JSP_SOLICITAR_LIQUIDACION = "plugin/precontencioso/liquidacion/popups/solicitarLiquidacion";
	public static final String JSP_DOWNLOAD_FILE = "plugin/geninformes/download";
	
	private static final String CODIGO_TIPO_GESTOR_APODERADO = "APOD";

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	LiquidacionApi liquidacionApi;

	@Autowired
	UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	UsuarioManager usuarioManager;

	@RequestMapping
	public String getLiquidacionesPorProcedimientoId(@RequestParam(value = "idProcedimientoPCO", required = true) Long idProcedimientoPCO, ModelMap model) {

		List<LiquidacionDTO> liquidaciones = liquidacionApi.getLiquidacionesPorIdProcedimientoPCO(idProcedimientoPCO);
		model.put("liquidaciones", liquidaciones);
		
		return JSON_LIQUIDACIONES;
	}

	@RequestMapping
	public String getOcultarBotonSolicitar(ModelMap model) {
		Parametrizacion visibleBtnSolicitar = proxyFactory.proxy(ParametrizacionApi.class).buscarParametroPorNombre(Parametrizacion.VISIBLE_BOTON_SOLICITAR_LIQUIDACION);
		model.put("ocultarBtnSolicitar", ("1".equals(visibleBtnSolicitar.getValor()) ? true : false));
		return JSON_OCULTAR_BOTON_SOLICITAR;
	}
	
	@RequestMapping
	public String abrirEditarLiquidacion(@RequestParam(value = "idLiquidacion", required = true) Long id, ModelMap model) {

		LiquidacionDTO liquidacionDto = liquidacionApi.getLiquidacionPorId(id);
		EXTDDTipoGestor tipoGestorApoderado = (EXTDDTipoGestor) diccionarioApi.dameValorDiccionarioByCod(EXTDDTipoGestor.class, CODIGO_TIPO_GESTOR_APODERADO);

		Parametrizacion visibleBtnSolicitar = proxyFactory.proxy(ParametrizacionApi.class).buscarParametroPorNombre(Parametrizacion.VISIBLE_BOTON_SOLICITAR_LIQUIDACION);
		model.put("ocultarBtnSolicitar", ("1".equals(visibleBtnSolicitar.getValor()) ? true : false));
		model.put("liquidacion", liquidacionDto);
		model.put("tipoGestorApoderado", tipoGestorApoderado);

		return JSP_EDITAR_LIQUIDACION;
	}

	@RequestMapping
	public String abrirSolicitarLiquidacion(@RequestParam(value = "idLiquidacion", required = true) Long id, ModelMap model) {

		LiquidacionDTO liquidacionDto = new LiquidacionDTO();
		liquidacionDto.setId(id);
		model.put("liquidacion", liquidacionDto);

		return JSP_SOLICITAR_LIQUIDACION;
	}

	@RequestMapping
	public String solicitar(@RequestParam(value = "idLiquidacion", required = true) Long id,
							@RequestParam(value = "fechaCierre", required = true) String fechaCierre, 
							ModelMap model) {

		SimpleDateFormat webDateFormat = new SimpleDateFormat("dd/MM/yyyy");

		Date fechaCierreDate = null;

		try {
			fechaCierreDate = webDateFormat.parse(fechaCierre);
		} catch (ParseException e) {
			logger.error(e.getLocalizedMessage());
			return DEFAULT;
		}

		LiquidacionDTO liquidacionDto = new LiquidacionDTO();
		liquidacionDto.setId(id);
		liquidacionDto.setFechaCierre(fechaCierreDate);
		
		liquidacionApi.solicitar(liquidacionDto);

		LiquidacionPCO liquidacion = proxyFactory.proxy(LiquidacionApi.class).getLiquidacionPCOById(liquidacionDto.getId());
		proxyFactory.proxy(GestorTareasApi.class).recalcularTareasPreparacionDocumental(liquidacion.getProcedimientoPCO().getProcedimiento().getId());

		return DEFAULT;
	}

	@RequestMapping
	public String editar(WebRequest request, ModelMap model) throws ParseException {

		Long id = Long.valueOf(request.getParameter("id"));
		Float capitalVencido = Float.valueOf(request.getParameter("capitalVencido"));
		Float capitalNoVencido = Float.valueOf(request.getParameter("capitalNoVencido"));
		Float interesesOrdinarios = Float.valueOf(request.getParameter("interesesOrdinarios"));
		Float interesesDemora = Float.valueOf(request.getParameter("interesesDemora"));
		Float total = Float.valueOf(request.getParameter("total"));
		String apoderadoNombre = request.getParameter("apoderadoNombre");
		Float comisiones = Float.valueOf(request.getParameter("comisiones"));
		Float gastos = Float.valueOf(request.getParameter("gastos"));
		Float impuestos = Float.valueOf(request.getParameter("impuestos"));

		Date fechaCierre = null;
		if (request.getParameter("fechaCierre") != null) {
			SimpleDateFormat webDateFormat = new SimpleDateFormat("dd/MM/yyyy");
			fechaCierre = webDateFormat.parse(request.getParameter("fechaCierre"));
		}

		String usuario = request.getParameter("apoderadoUsuarioId");

		Long usuarioId = null;
		if (!Checks.esNulo(usuario)) {
			usuarioId = Long.valueOf(usuario);
		}

		String despacho = request.getParameter("apoderadoDespachoId");

		Long despachoId = null;
		if (!Checks.esNulo(despacho)) {
			despachoId = Long.valueOf(despacho);
		}

		LiquidacionDTO liquidacionDto = new LiquidacionDTO();
		liquidacionDto.setId(id);
		liquidacionDto.setCapitalVencido(capitalVencido);
		liquidacionDto.setCapitalNoVencido(capitalNoVencido);
		liquidacionDto.setInteresesOrdinarios(interesesOrdinarios);
		liquidacionDto.setInteresesDemora(interesesDemora);
		liquidacionDto.setTotal(total);
		liquidacionDto.setApoderadoNombre(apoderadoNombre);
		liquidacionDto.setApoderadoUsuarioId(usuarioId);
		liquidacionDto.setApoderadoDespachoId(despachoId);
		liquidacionDto.setComisiones(comisiones);
		liquidacionDto.setGastos(gastos);
		liquidacionDto.setImpuestos(impuestos);
		liquidacionDto.setFechaCierre(fechaCierre);

		liquidacionApi.editarValoresCalculados(liquidacionDto);
		
		LiquidacionPCO liquidacion = proxyFactory.proxy(LiquidacionApi.class).getLiquidacionPCOById(liquidacionDto.getId());
		proxyFactory.proxy(GestorTareasApi.class).recalcularTareasPreparacionDocumental(liquidacion.getProcedimientoPCO().getProcedimiento().getId());
		
		return DEFAULT;
	}

	@RequestMapping
	public String confirmar(@RequestParam(value = "idLiquidacion", required = true) Long id, ModelMap model) {
		LiquidacionDTO liquidacionDto = new LiquidacionDTO();
		liquidacionDto.setId(id);
		liquidacionApi.confirmar(liquidacionDto);
		
		LiquidacionPCO liquidacion = proxyFactory.proxy(LiquidacionApi.class).getLiquidacionPCOById(liquidacionDto.getId());
		proxyFactory.proxy(GestorTareasApi.class).recalcularTareasPreparacionDocumental(liquidacion.getProcedimientoPCO().getProcedimiento().getId());
		
		return DEFAULT;
	}

	@RequestMapping
	public String descartar(@RequestParam(value = "idLiquidacion", required = true) Long id, ModelMap model) {
		LiquidacionDTO liquidacionDto = new LiquidacionDTO();
		liquidacionDto.setId(id);

		liquidacionApi.descartar(liquidacionDto);
		
		LiquidacionPCO liquidacion = proxyFactory.proxy(LiquidacionApi.class).getLiquidacionPCOById(liquidacionDto.getId());
		proxyFactory.proxy(GestorTareasApi.class).recalcularTareasPreparacionDocumental(liquidacion.getProcedimientoPCO().getProcedimiento().getId());

		return DEFAULT;
	}
	
	@RequestMapping
	public String generarDocumentoLiquidacion(@RequestParam(value = "idLiquidacion", required = true) Long id, 
			ModelMap model) {
		
		LiquidacionPCO liquidacion = proxyFactory.proxy(LiquidacionApi.class).getLiquidacionPCOById(id);
		
		HashMap<String, String> mapaVariables=new HashMap<String, String>();
		
		SimpleDateFormat fechaFormat = new SimpleDateFormat(FormatUtils.DD_DE_MES_DE_YYYY,MessageUtils.DEFAULT_LOCALE);
		
		if(!Checks.esNulo(liquidacion.getContrato())){
			mapaVariables.put("numContrato", liquidacion.getContrato().getNroContratoFormat());
		}
		else{
			mapaVariables.put("numContrato","[ERROR - No existe valor]");
		}
		if(!Checks.esNulo(liquidacion.getContrato().getTipoProductoEntidad())){
			mapaVariables.put("tipoProducto", liquidacion.getContrato().getTipoProductoEntidad().getDescripcion());
		}
		else{
			mapaVariables.put("tipoProducto", "[ERROR - No existe valor]");
		}
		if(!Checks.esNulo(liquidacion.getEstadoLiquidacion())){
			mapaVariables.put("estadoLiquidacion", liquidacion.getEstadoLiquidacion().getDescripcion());
		}
		else{
			mapaVariables.put("estadoLiquidacion", "[ERROR - No existe valor]");
		}
		if(!Checks.esNulo(liquidacion.getFechaSolicitud())){
			mapaVariables.put("fechaSolicitud", fechaFormat.format(liquidacion.getFechaSolicitud()));
		}
		else{
			mapaVariables.put("fechaSolicitud","[ERROR - No existe valor]");
		}
		if(!Checks.esNulo(liquidacion.getFechaRecepcion())){
			mapaVariables.put("fechaRecepcion", fechaFormat.format(liquidacion.getFechaRecepcion()));
		}
		else{
			mapaVariables.put("fechaRecepcion", "[ERROR - No existe valor]");
		}
		if(!Checks.esNulo(liquidacion.getFechaConfirmacion())){
			mapaVariables.put("fechaConfirmacion", fechaFormat.format(liquidacion.getFechaConfirmacion()));
		}
		else{
			mapaVariables.put("fechaConfirmacion", "[ERROR - No existe valor]");
		}
		if(!Checks.esNulo(liquidacion.getFechaCierre())){
			mapaVariables.put("fechaCierre", fechaFormat.format(liquidacion.getFechaCierre()));
		}
		else{
			mapaVariables.put("fechaCierre", "[ERROR - No existe valor]");
		}
		if(!Checks.esNulo(liquidacion.getCapitalVencido())){
			mapaVariables.put("capitalVencido", NumberFormat.getCurrencyInstance(new Locale("es","ES")).format(liquidacion.getCapitalVencido()));
		}
		else{
			mapaVariables.put("capitalVencido", "[ERROR - No existe valor]");
		}
		if(!Checks.esNulo(liquidacion.getCapitalNoVencido())){
			mapaVariables.put("capitalNoVencido", liquidacion.getCapitalNoVencido().toString());
		}
		else{
			mapaVariables.put("capitalNoVencido", "[ERROR - No existe valor]");
		}
		if(!Checks.esNulo(liquidacion.getInteresesOrdinarios())){
			mapaVariables.put("interesesOrdinarios", NumberFormat.getCurrencyInstance(new Locale("es","ES")).format(liquidacion.getInteresesOrdinarios()));
		}
		else{
			mapaVariables.put("interesesOrdinarios","[ERROR - No existe valor]");
		}
		if(!Checks.esNulo(liquidacion.getInteresesDemora())){
			mapaVariables.put("interesesDemora",NumberFormat.getCurrencyInstance(new Locale("es","ES")).format(liquidacion.getInteresesDemora()));
		}
		else{
			mapaVariables.put("interesesDemora", "[ERROR - No existe valor]");
		}
		if(!Checks.esNulo(liquidacion.getComisiones())){
			mapaVariables.put("comisiones",NumberFormat.getCurrencyInstance(new Locale("es","ES")).format(liquidacion.getComisiones()));
		}
		else{
			mapaVariables.put("comisiones", "[ERROR - No existe valor]");
		}
		if(!Checks.esNulo(liquidacion.getGastos())){
			mapaVariables.put("gastos",NumberFormat.getCurrencyInstance(new Locale("es","ES")).format(liquidacion.getGastos()));
		}
		else{
			mapaVariables.put("gastos", "[ERROR - No existe valor]");
		}
		if(!Checks.esNulo(liquidacion.getImpuestos())){
			mapaVariables.put("impuestos",NumberFormat.getCurrencyInstance(new Locale("es","ES")).format(liquidacion.getImpuestos()));
		}
		else{
			mapaVariables.put("impuestos", "[ERROR - No existe valor]");
		}
		if(!Checks.esNulo(liquidacion.getTotal())){
			mapaVariables.put("total", NumberFormat.getCurrencyInstance(new Locale("es","ES")).format(liquidacion.getTotal()));
		}
		else{
			mapaVariables.put("total", "[ERROR - No existe valor]");
		}
		if(!Checks.esNulo(liquidacion.getApoderado())){
			mapaVariables.put("apoderado", liquidacion.getApoderado().getUsuario().getApellidoNombre());
		}
		else{
			mapaVariables.put("apoderado", "[ERROR - No existe valor]");
		}
		
		String directorio=liquidacionApi.obtenerDirectorioDocumentos();
		
		InputStream is=null;
		try {
			is = new FileInputStream(directorio+"plantillaLiquidacion.docx");
		} catch (FileNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		FileItem resultado=null;
		try {
			resultado = proxyFactory.proxy(GENINFInformesApi.class).generarEscritoConVariables(mapaVariables, "plantillaLiquidacion.docx",is);
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		model.put("fileItem", resultado);
		
		return JSP_DOWNLOAD_FILE;
	}
	
}