package es.pfsgroup.plugin.liquidaciones.avanzado.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoLiquidacionCabecera;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoLiquidacionResumen;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoReportRequest;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoTramoLiquidacion;
import es.pfsgroup.plugin.liquidaciones.avanzado.manager.LiquidacionesAvanzadoManager;

@Controller
public class LiquidacionesController {
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired 
	private LiquidacionesAvanzadoManager liquidacionesManager;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String openReport(ModelMap model, LIQDtoReportRequest request) {
		
		LIQDtoLiquidacionCabecera cabecera = liquidacionesManager.completarCabecera(request);
		List<LIQDtoTramoLiquidacion> cuerpo = liquidacionesManager.obtenerLiquidaciones(request);
		LIQDtoLiquidacionResumen resumen = liquidacionesManager.crearResumen(request,cuerpo);
		
		String logo = usuarioManager.getUsuarioLogado().getEntidad().configValue("logo");
		model.put("logo", logo);
		model.put("usuario", usuarioManager.getUsuarioLogado());
		model.put("cabecera", cabecera);
		model.put("cuerpo", cuerpo);
		model.put("resumen", resumen);
		return "reportPDF/plugin/liquidaciones/avanzado/liquidaciones";
	}
	
	

}
