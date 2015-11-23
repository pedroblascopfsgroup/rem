package es.pfsgroup.plugin.precontencioso.liquidacion.controller;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.core.api.parametrizacion.ParametrizacionApi;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.api.GestorTareasApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.GenerarLiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.LiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.dto.LiquidacionDTO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDTipoLiquidacionPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;

@Controller
public class LiquidacionController {

	private static final String DEFAULT = "default";
	private static final String JSON_LIQUIDACIONES = "plugin/precontencioso/liquidacion/json/liquidacionesJSON";
	private static final String JSON_PLANTILLAS = "plugin/precontencioso/liquidacion/json/plantillasJSON";
	private static final String JSON_OCULTAR_BOTON_SOLICITAR = "plugin/precontencioso/liquidacion/json/ocultarBtnSolicitarJSON";
	private static final String JSP_EDITAR_LIQUIDACION = "plugin/precontencioso/liquidacion/popups/editarLiquidacion";
	private static final String JSP_PLANTILLAS_LIQUIDACION = "plugin/precontencioso/liquidacion/popups/seleccionarPlantillaLiquidacion";
	private static final String JSP_SOLICITAR_LIQUIDACION = "plugin/precontencioso/liquidacion/popups/solicitarLiquidacion";
	private static final String JSP_DOWNLOAD_FILE = "plugin/geninformes/download";
	
	private static final String CODIGO_TIPO_GESTOR_APODERADO = "APOD";

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private LiquidacionApi liquidacionApi;

	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	@Autowired
	private UsuarioManager usuarioManager;

	@Autowired(required = false)
	private GenerarLiquidacionApi generarLiquidacionApi;
	
	@Autowired
	private GestorTareasApi gestorTareasManager;

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getLiquidacionesPorProcedimientoId(@RequestParam(value = "idProcedimientoPCO", required = true) Long idProcedimientoPCO, ModelMap model) {

		List<LiquidacionDTO> liquidaciones = liquidacionApi.getLiquidacionesPorIdProcedimientoPCO(idProcedimientoPCO);
		model.put("liquidaciones", liquidaciones);
		
		return JSON_LIQUIDACIONES;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getOcultarBotonSolicitar(ModelMap model) {
		Parametrizacion visibleBtnSolicitar = proxyFactory.proxy(ParametrizacionApi.class).buscarParametroPorNombre(Parametrizacion.VISIBLE_BOTON_SOLICITAR_LIQUIDACION);
		model.put("ocultarBtnSolicitar", ("1".equals(visibleBtnSolicitar.getValor()) ? true : false));
		return JSON_OCULTAR_BOTON_SOLICITAR;
	}
	
	@SuppressWarnings("unchecked")
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

	@SuppressWarnings("unchecked")
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
		BigDecimal capitalVencido = new BigDecimal(request.getParameter("capitalVencido"));
		BigDecimal capitalNoVencido = new BigDecimal(request.getParameter("capitalNoVencido"));
		BigDecimal interesesOrdinarios = new BigDecimal(request.getParameter("interesesOrdinarios"));
		BigDecimal interesesDemora = new BigDecimal(request.getParameter("interesesDemora"));
		BigDecimal total = new BigDecimal(request.getParameter("total"));
		String apoderadoNombre = request.getParameter("apoderadoNombre");
		BigDecimal comisiones = new BigDecimal(request.getParameter("comisiones"));
		BigDecimal gastos = new BigDecimal(request.getParameter("gastos"));
		BigDecimal impuestos = new BigDecimal(request.getParameter("impuestos"));

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
	public String visar(@RequestParam(value = "idLiquidacion", required = true) Long id, ModelMap model) {
		LiquidacionDTO liquidacionDto = new LiquidacionDTO();
		liquidacionDto.setId(id);
		liquidacionApi.visar(liquidacionDto);
		
		LiquidacionPCO liquidacion = liquidacionApi.getLiquidacionPCOById(liquidacionDto.getId());
		gestorTareasManager.recalcularTareasPreparacionDocumental(liquidacion.getProcedimientoPCO().getProcedimiento().getId());
		
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

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String generar(@RequestParam(value = "idLiquidacion", required = true) Long idLiquidacion, Long idPlantilla, ModelMap model) {

		if (generarLiquidacionApi == null) {
			logger.error("liquidacioncontroller.generar: No existe una implementacion para generar liquidaciones");
			throw new BusinessOperationException("Not implemented generarLiquidacionApi");
		}

		FileItem documentoLiquidacion = generarLiquidacionApi.generarDocumento(idLiquidacion, idPlantilla);
		model.put("fileItem", documentoLiquidacion);

		return JSP_DOWNLOAD_FILE;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getPlantillasLiquidacion(ModelMap model) {

		if (generarLiquidacionApi == null) {
			logger.error("liquidacioncontroller.generar: No existe una implementacion para generar liquidaciones");
			throw new BusinessOperationException("Not implemented generarLiquidacionApi");
		}

		List<DDTipoLiquidacionPCO> plantillas = generarLiquidacionApi.getPlantillasLiquidacion();
		model.put("plantillas", plantillas);
		return JSON_PLANTILLAS;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abrirPlantillasLiquidacion(@RequestParam(value = "idLiquidacion", required = true) Long id, ModelMap model) {
		List<DDTipoLiquidacionPCO> plantillas = null;

		if (generarLiquidacionApi != null) {
			plantillas = generarLiquidacionApi.getPlantillasLiquidacion();
		}

		model.put("ocultarCombo", Checks.estaVacio(plantillas));
		model.put("idLiquidacionSeleccionada", id);
		return JSP_PLANTILLAS_LIQUIDACION;
	}
}