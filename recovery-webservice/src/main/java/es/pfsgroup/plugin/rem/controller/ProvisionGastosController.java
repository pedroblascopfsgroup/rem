package es.pfsgroup.plugin.rem.controller;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.pfs.config.ConfigManager;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.ProvisionGastosApi;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.ProvisionGastosExcelReport;
import es.pfsgroup.plugin.rem.model.AuditoriaExportaciones;
import es.pfsgroup.plugin.rem.model.DtoProvisionGastos;
import es.pfsgroup.plugin.rem.model.DtoProvisionGastosFilter;


@Controller
public class ProvisionGastosController extends ParadiseJsonController {

	
	@Autowired
	private ProvisionGastosApi provisionGastosApi;
	
	protected static final Log logger = LogFactory.getLog(ProvisionGastosController.class);

	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;
	
	@Autowired
	private UsuarioManager usuarioManager;
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ConfigManager configManager;
	
	@Resource
	private Properties appProperties;
	
	private static final String RESPONSE_SUCCESS_KEY = "success";	
	private static final String RESPONSE_DATA_KEY = "data";
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findAll(DtoProvisionGastosFilter dto, ModelMap model){	
		
		try {

			DtoPage page = provisionGastosApi.findAll(dto);
			
			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			logger.error("Error al consultar las agrupaciones de gastos.", e);
			model.put("success", false);
			model.put("exception", e.getMessage());
		}
		
		return createModelAndViewJson(model);

	}		

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void generateExcelProvisionGastos(DtoProvisionGastosFilter dtoProvisionGastos, HttpServletRequest request, HttpServletResponse response) throws Exception {
		dtoProvisionGastos.setStart(excelReportGeneratorApi.getStart());
		dtoProvisionGastos.setLimit(excelReportGeneratorApi.getLimit());

		DtoPage page = provisionGastosApi.findAll(dtoProvisionGastos);
		List<DtoProvisionGastos> listaProvisionGastos = (List<DtoProvisionGastos>) page.getResults();

		ExcelReport report = new ProvisionGastosExcelReport(listaProvisionGastos);

		excelReportGeneratorApi.generateAndSend(report, response);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	@Transactional()
	public ModelAndView registrarExportacion(DtoProvisionGastosFilter dtoProvisionGastos, Boolean exportar, String buscador, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String intervaloTiempo = !Checks.esNulo(appProperties.getProperty("haya.tiempo.espera.export")) ? appProperties.getProperty("haya.tiempo.espera.export") : "300000";
		ModelMap model = new ModelMap();		 
		Boolean isSuperExport = false;
		Boolean permitido = true;
		String filtros = parameterParser(request.getParameterMap());
		Usuario user = usuarioManager.getUsuarioLogado();
		Long tiempoPermitido = System.currentTimeMillis() - Long.parseLong(intervaloTiempo);
		String cuentaAtras = null;
		try {
			Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "usuario.id", user.getId());
			Filter filtroConsulta = genericDao.createFilter(FilterType.EQUALS, "filtros", filtros);
			Filter filtroAccion = genericDao.createFilter(FilterType.EQUALS, "accion", true);
			Order orden = new Order(OrderType.DESC, "fechaExportacion");
			List<AuditoriaExportaciones> listaExportaciones =  genericDao.getListOrdered(AuditoriaExportaciones.class, orden, filtroUsuario, filtroConsulta, filtroAccion);
			
			if(listaExportaciones != null && !listaExportaciones.isEmpty()) {
				Long ultimaExport = listaExportaciones.get(0).getFechaExportacion().getTime();
				permitido = ultimaExport > tiempoPermitido ? false : true;

				double entero = Math.floor((ultimaExport - tiempoPermitido)/60000);
		        if (entero < 2) {
		        	cuentaAtras = "un minuto";
		        } else {
		        	cuentaAtras = Double.toString(entero);
		        	cuentaAtras = cuentaAtras.substring(0, 1) + " minutos";
		        }
			}
			
			if(permitido) {
				int count = provisionGastosApi.findAll(dtoProvisionGastos).getTotalCount();
				AuditoriaExportaciones ae = new AuditoriaExportaciones();
				ae.setBuscador(buscador);
				ae.setFechaExportacion(new Date());
				ae.setNumRegistros(Long.valueOf(count));
				ae.setUsuario(user);
				ae.setFiltros(filtros);
				ae.setAccion(exportar);
				genericDao.save(AuditoriaExportaciones.class, ae);
				model.put(RESPONSE_SUCCESS_KEY, true);
				model.put(RESPONSE_DATA_KEY, count);
				for(Perfil pef : user.getPerfiles()) {
					if(pef.getCodigo().equals("SUPEREXPORTADMIN")) {
						isSuperExport = true;
						break;
					}
				}
				if(isSuperExport) {
					model.put("limite", configManager.getConfigByKey("super.limite.exportar.excel.gastos").getValor());
					model.put("limiteMax", configManager.getConfigByKey("super.limite.maximo.exportar.excel.gastos").getValor());
				}else {
					model.put("limite", configManager.getConfigByKey("limite.exportar.excel.gastos").getValor());
					model.put("limiteMax", configManager.getConfigByKey("limite.maximo.exportar.excel.gastos").getValor());
				}
			} else {
				model.put("msg", cuentaAtras);
			}
		}catch(Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en provisionGastosController", e);
		}
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("rawtypes")
	private String parameterParser(Map map) {
		StringBuilder mapAsString = new StringBuilder("{");
	    for (Object key : map.keySet()) {
	    	if(!key.toString().equals("buscador") && !key.toString().equals("exportar"))
	    		mapAsString.append(key.toString() + "=" + ((String[])map.get(key))[0] + ",");
	    }
	    mapAsString.delete(mapAsString.length()-1, mapAsString.length());
	    if(mapAsString.length()>0)
	    	mapAsString.append("}");
	    return mapAsString.toString();
	}

}
