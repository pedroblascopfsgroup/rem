package es.pfsgroup.plugin.liquidaciones.avanzado.controller;

import java.math.BigDecimal;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.DtoCalculoLiquidacion;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoLiquidacionCabecera;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoLiquidacionResumen;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoTramoLiquidacion;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQTramoPendientes;
import es.pfsgroup.plugin.liquidaciones.avanzado.manager.LiquidacionAvanzadoApi;
import es.pfsgroup.plugin.liquidaciones.avanzado.model.CalculoLiquidacion;
import es.pfsgroup.plugin.liquidaciones.avanzado.model.EntregaCalculoLiq;

@Controller
public class LiquidacionesController {
	
	private static final String DEFAULT = "default";
	private static final String JSP_ALTA_NUEVA_LIQUIDACION =  "plugin/liquidaciones/avanzado/introducirdatos";
	private static final String JSP_LISTADO_CALCULOS_LIQUIDACIONES= "plugin/liquidaciones/avanzado/calculosLiquidacionesJSON";
	private static final String JSP_LISTADO_ENTREGAS_LIQUIDACIONES= "plugin/liquidaciones/avanzado/entregasCalculoLiquidacionJSON";
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired 
	private LiquidacionAvanzadoApi liquidacionesManager;
	
	@Autowired
	private AsuntoApi asuntoApi;
	
	@Autowired
	private LiquidacionAvanzadoApi liquidacionApi;
	
	@Resource
	private Properties appProperties;
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String openReport(ModelMap model, Long idCalculo) {
		CalculoLiquidacion request = liquidacionesManager.getCalculoById(idCalculo);
		
		if (!Checks.esNulo(request)) {
		
			LIQTramoPendientes pendientes = new LIQTramoPendientes();
			
			pendientes.setSaldo(request.getCapital());
			pendientes.setIntDemoraCierre(request.getInteresesDemora()!=null?request.getInteresesDemora():BigDecimal.ZERO);
			pendientes.setIntereses(request.getInteresesOrdinarios()!=null?request.getInteresesOrdinarios():BigDecimal.ZERO);
			//pendientes.setIntereses(pendientes.getIntereses().add(request.getInteresesDemora()!=null?request.getInteresesDemora():BigDecimal.ZERO));
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
			
			//Actualizamos total calculo y estado
			request.setTotalCaculo(resumen.getTotalPagar());
			//request.setEstadoCalculo(estadoCalculo);
			liquidacionesManager.saveCalculoLiquidacionAvanzado(request);
			
			String logo = usuarioManager.getUsuarioLogado().getEntidad().configValue("logo");
			String codigoEntidad = usuarioManager.getUsuarioLogado().getEntidad().getCodigo();
			
			if (!Checks.esNulo(codigoEntidad)) {
				/*String logoEspecial = appProperties.getProperty("logoliquidacion" + codigoEntidad);
				if (!Checks.esNulo(logoEspecial)) {
					logo = logoEspecial;
				}*/
				
				
				//Seleccionamos el logo según el codigo entidad
				if (codigoEntidad.toUpperCase().equals("HAYA")) {
					logo = "plugin/liquidaciones/logoSareb.jpg";
				}
				
				if (codigoEntidad.toUpperCase().equals("HCJ")) {
					logo = "plugin/liquidaciones/logoCajamar.png";
				}
				
			}
			
			model.put("logo", logo);
			model.put("usuario", usuarioManager.getUsuarioLogado());
			model.put("cabecera", cabecera);
			model.put("cuerpo", cuerpo);
			model.put("resumen", resumen);
			return "reportPDF/plugin/liquidaciones/avanzado/liquidaciones";
		} else {
			throw new BusinessOperationException("plugin.liquidaciones.error.liquidacion.noencontrada");
		}
	}
	
    /**
     * Abre la ventana para crear una nueva liquidacion.
     * @param idAsunto
     */
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String abreCrearLiquidacion(ModelMap model,Long idAsunto) {
		
		model.put("actuaciones", asuntoApi.obtenerActuacionesAsunto(idAsunto));
		model.put("idAsunto", idAsunto);
		
		return JSP_ALTA_NUEVA_LIQUIDACION;
	}
	
	/**
	 * Guarda un registro de tipo CalculoLiquidacion
	 * @param calcLiq
	 * @return
	 */
	@RequestMapping
	public String guardaCalculoLiquidacion(DtoCalculoLiquidacion dtoCalcLiq){
		
		CalculoLiquidacion calaLiq = liquidacionApi.convertDtoCalculoLiquidacionTOCalculoLiquidacion(dtoCalcLiq);
		calaLiq = liquidacionApi.saveCalculoLiquidacionAvanzado(calaLiq);
		if(!Checks.esNulo(dtoCalcLiq.getTiposIntereses()) && dtoCalcLiq.getTiposIntereses().size()>0){
			liquidacionApi.creaTiposInteresParaCalculoLiquidacion(dtoCalcLiq.getTiposIntereses(), calaLiq);
		}
		
		return DEFAULT;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String obtenerCalculosLiquidacionesAsunto(ModelMap model, Long idAsunto){
		
		List<CalculoLiquidacion> listado= liquidacionesManager.obtenerCalculosLiquidacionesAsunto(idAsunto);
		model.put("historicoLiquidaciones", listado);
		return JSP_LISTADO_CALCULOS_LIQUIDACIONES;
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String obtenerEntregasCalculoLiquidacion(ModelMap model, Long idCalculo){
		List<EntregaCalculoLiq> listado= liquidacionesManager.getEntregasCalculo(idCalculo);
		model.put("entregas", listado);
		return JSP_LISTADO_ENTREGAS_LIQUIDACIONES;
	}
	
    /**
     * Abre la ventana para editar una nueva liquidacion.
     * @param idAsunto
     */
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String abreEditarLiquidacion(ModelMap model,Long idCalculoLiquidacion) {
		
		CalculoLiquidacion calcLiq = liquidacionesManager.getCalculoLiquidacion(idCalculoLiquidacion);
		DtoCalculoLiquidacion dto = liquidacionesManager.convertCalculoLiquidacionTODtoCalculoLiquidacion(calcLiq);
		model.put("actuaciones", asuntoApi.obtenerActuacionesAsunto(dto.getAsunto()));
		model.put("idAsunto", dto.getAsunto());
		model.put("dtoCalculoLiquidacion", dto);
		model.put("isEdit", true);
		
		return JSP_ALTA_NUEVA_LIQUIDACION;
	}
	

}
