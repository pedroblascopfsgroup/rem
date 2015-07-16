package es.pfsgroup.plugin.precontencioso.liquidacion.controller;

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

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.LiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.dto.LiquidacionDTO;

@Controller
public class LiquidacionController {

	private static final String DEFAULT = "default";
	private static final String JSON_LIQUIDACIONES = "plugin/precontencioso/liquidacion/json/liquidacionesJSON";
	private static final String JSP_EDITAR_LIQUIDACION = "plugin/precontencioso/liquidacion/popups/editarLiquidacion";
	private static final String JSP_SOLICITAR_LIQUIDACION = "plugin/precontencioso/liquidacion/popups/solicitarLiquidacion";

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	LiquidacionApi liquidacionApi;

	@RequestMapping
	public String getLiquidacionesPorProcedimientoId(@RequestParam(value = "idProcedimientoPCO", required = true) Long idProcedimientoPCO, ModelMap model) {

		List<LiquidacionDTO> liquidaciones = liquidacionApi.getLiquidacionesPorIdProcedimientoPCO(idProcedimientoPCO);
		model.put("liquidaciones", liquidaciones);

		return JSON_LIQUIDACIONES;
	}

	@RequestMapping
	public String abrirEditarLiquidacion(@RequestParam(value = "idLiquidacion", required = true) Long id, ModelMap model) {

		LiquidacionDTO liquidacionDto = liquidacionApi.getLiquidacionPorId(id);
		model.put("liquidacion", liquidacionDto);

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

		return DEFAULT;
	}

	@RequestMapping
	public String editar(WebRequest request, ModelMap model) {

		Long id = Long.valueOf(request.getParameter("id"));
		Float capitalVencido = Float.valueOf(request.getParameter("capitalVencido"));
		Float capitalNoVencido = Float.valueOf(request.getParameter("capitalNoVencido"));
		Float interesesOrdinarios = Float.valueOf(request.getParameter("interesesOrdinarios"));
		Float interesesDemora = Float.valueOf(request.getParameter("interesesDemora"));
		Float total = Float.valueOf(request.getParameter("total"));

		String apoderado = request.getParameter("apoderadoId");

		Long apoderadoId = null;
		if (!Checks.esNulo(apoderado)) {
			apoderadoId = Long.valueOf(apoderado);
		}

		LiquidacionDTO liquidacionDto = new LiquidacionDTO();
		liquidacionDto.setId(id);
		liquidacionDto.setCapitalVencido(capitalVencido);
		liquidacionDto.setCapitalNoVencido(capitalNoVencido);
		liquidacionDto.setInteresesOrdinarios(interesesOrdinarios);
		liquidacionDto.setInteresesDemora(interesesDemora);
		liquidacionDto.setTotal(total);
		liquidacionDto.setApoderadoId(apoderadoId);

		liquidacionApi.editar(liquidacionDto);

		return DEFAULT;
	}

	@RequestMapping
	public String confirmar(@RequestParam(value = "idLiquidacion", required = true) Long id, ModelMap model) {
		LiquidacionDTO liquidacionDto = new LiquidacionDTO();
		liquidacionDto.setId(id);

		liquidacionApi.confirmar(liquidacionDto);

		return DEFAULT;
	}

	@RequestMapping
	public String descartar(@RequestParam(value = "idLiquidacion", required = true) Long id, ModelMap model) {
		LiquidacionDTO liquidacionDto = new LiquidacionDTO();
		liquidacionDto.setId(id);

		liquidacionApi.descartar(liquidacionDto);

		return DEFAULT;
	}
}