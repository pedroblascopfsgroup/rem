package es.pfsgroup.plugin.liquidaciones.avanzado.controller;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoLiquidacionCabecera;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoLiquidacionResumen;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoReportRequest;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoTramoLiquidacion;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQTramoPendientes;
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
		LIQTramoPendientes pendientes = new LIQTramoPendientes();
		
		pendientes.setSaldo(request.getCapital());
		pendientes.setIntereses(request.getInteresesOrdinarios()!=null?request.getInteresesOrdinarios():BigDecimal.ZERO);
		pendientes.setIntereses(pendientes.getIntereses().add(request.getInteresesDemora()!=null?request.getInteresesDemora():BigDecimal.ZERO));
		pendientes.setImpuestos(request.getImpuestos());
		pendientes.setComisiones(request.getComisiones());
		pendientes.setGastos(request.getGastos()!=null?request.getGastos():BigDecimal.ZERO);
		pendientes.setGastos(pendientes.getGastos().add(request.getOtrosGastos()!=null?request.getOtrosGastos():BigDecimal.ZERO));
		pendientes.setCostasLetrado(request.getCostasLetrado()!=null?request.getCostasLetrado():BigDecimal.ZERO);
		pendientes.setCostasProcurador(request.getCostasProcurador()!=null?request.getCostasProcurador():BigDecimal.ZERO);
		pendientes.setSobranteEntrega(BigDecimal.ZERO);
		
		
		LIQDtoLiquidacionCabecera cabecera = liquidacionesManager.completarCabecera(request);
		List<LIQDtoTramoLiquidacion> cuerpo = liquidacionesManager.obtenerLiquidaciones(request,pendientes);
		LIQDtoLiquidacionResumen resumen = liquidacionesManager.crearResumen(request,cuerpo, pendientes);
		
		String logo = usuarioManager.getUsuarioLogado().getEntidad().configValue("logo");
		String codigoEntidad = usuarioManager.getUsuarioLogado().getEntidad().getCodigo();
		
		if (!Checks.esNulo(codigoEntidad)) {
			//Seleccionamos el logo según el codigo entidad
			if (codigoEntidad.toUpperCase().equals("HCJ")) {
				logo = "plugin/liquidaciones/logoSarebLiquidaciones.jpg";
			}
			
			if (codigoEntidad.toUpperCase().equals("CAJAMAR")) {
				logo = "plugin/liquidaciones/logoCajamarLiquidaciones.png";
			}
		}
		
		model.put("logo", logo);
		model.put("usuario", usuarioManager.getUsuarioLogado());
		model.put("cabecera", cabecera);
		model.put("cuerpo", cuerpo);
		model.put("resumen", resumen);
		return "reportPDF/plugin/liquidaciones/avanzado/liquidaciones";
	}
	
	

}
