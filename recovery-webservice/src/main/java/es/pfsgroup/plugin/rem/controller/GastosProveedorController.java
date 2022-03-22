package es.pfsgroup.plugin.rem.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import es.pfsgroup.plugin.rem.model.*;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.utils.FileUtils;
import es.capgemini.pfs.config.ConfigManager;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GastoAvisadorApi;
import es.pfsgroup.plugin.rem.api.GastoLineaDetalleApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.api.ProveedoresApi;
import es.pfsgroup.plugin.rem.excel.ElementosLineasExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.FacturasProveedoresExcelReport;
import es.pfsgroup.plugin.rem.excel.GestionGastosExcelReport;
import es.pfsgroup.plugin.rem.excel.TasasImpuestosExcelReport;
import es.pfsgroup.plugin.rem.excel.TrabajosGastoExcelReport;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.ACCION_CODIGO;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.ENTIDAD_CODIGO;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.REQUEST_STATUS_CODE;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.AuditoriaExportaciones;
import es.pfsgroup.plugin.rem.model.DtoActivoGasto;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAviso;
import es.pfsgroup.plugin.rem.model.DtoComboLineasDetalle;
import es.pfsgroup.plugin.rem.model.DtoDetalleEconomicoGasto;
import es.pfsgroup.plugin.rem.model.DtoElementosAfectadosLinea;
import es.pfsgroup.plugin.rem.model.DtoFichaGastoProveedor;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.DtoGestionGasto;
import es.pfsgroup.plugin.rem.model.DtoImpugnacionGasto;
import es.pfsgroup.plugin.rem.model.DtoInfoContabilidadGasto;
import es.pfsgroup.plugin.rem.model.DtoLineaDetalleGasto;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.model.DtoVImporteGastoLbk;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaGastoTrabajos;
import es.pfsgroup.plugin.rem.model.VElementosLineaDetalle;
import es.pfsgroup.plugin.rem.model.VFacturasProveedores;
import es.pfsgroup.plugin.rem.model.VGastosProveedor;
import es.pfsgroup.plugin.rem.model.VGastosProveedorExcel;
import es.pfsgroup.plugin.rem.model.VGridMotivosRechazoGastoCaixa;
import es.pfsgroup.plugin.rem.model.VTasacionesGastos;
import es.pfsgroup.plugin.rem.model.VTasasImpuestos;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;

@Controller
public class GastosProveedorController extends ParadiseJsonController {

	private final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private GastoProveedorApi gastoProveedorApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private ProveedoresApi proveedoresApi;
	
	@Autowired
	private List<GastoAvisadorApi> avisadores;

	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;

	@Autowired
	private LogTrustEvento trustMe;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Autowired
	private ConfigManager configManager;
	
	@Autowired
	private GastoLineaDetalleApi gastoLineaDetalleApi;
	
	@Resource
	private Properties appProperties;
	
	private static final String RESPONSE_SUCCESS_KEY = "success";	
	private static final String RESPONSE_DATA_KEY = "data";
	
	public static final String ERROR_GASTO_NOT_EXISTS = "No existe el gasto que esta buscando, pruebe con otro Nº de gasto";
	public static final String ERROR_GASTO_NO_NUMERICO = "El campo introducido es de carácter numérico";
	public static final String ERROR_GENERICO = "La operación no se ha podido realizar";

	/**
	 * Método que recupera un conjunto de datos del gasto según su id 
	 * @param id Id del gasto
	 * @param tab Pestaña del gasto a cargar
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTabGasto(Long id, String tab, ModelMap model, HttpServletRequest request) {

		try {
			model.put("data", gastoProveedorApi.getTabGasto(id, tab));
			model.put("success", true);
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, tab, ACCION_CODIGO.CODIGO_VER);
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("error", e.getMessage());
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, tab, ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}
	
	/**
	 * Método que recupera un trabajo según su id y lo mapea a un DTO
	 * @param id Id del trabajo
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findOne(Long id, ModelMap model){

		model.put("data", gastoProveedorApi.findOne(id));
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getIdGasto(Long numGasto, ModelMap model){

		try {
			Long idGasto = gastoProveedorApi.getIdGasto(numGasto);

			if(!Checks.esNulo(idGasto)) {
				model.put("success", true);
				model.put("data", idGasto);
			}else {
				model.put("success", false);
				model.put("error", ERROR_GASTO_NOT_EXISTS);
			}
		} catch(Exception e) {
			logger.error("error obteniendo el activo ",e);
			model.put("success", false);
			model.put("error", ERROR_GENERICO);
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListGastos(DtoGastosFilter dtoGastosFilter, ModelMap model) {
		try {

			DtoPage page = gastoProveedorApi.getListGastos(dtoGastosFilter);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			logger.error(e.getMessage(),e);
			model.put("success", false);
			model.put("exception", e.getMessage());
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void generateExcelTrabajosGasto(Long idGasto, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws IOException{

		List<VBusquedaGastoTrabajos> listaTrabajos = (List<VBusquedaGastoTrabajos>) getListTrabajosGasto(idGasto, model, request).getModel().get("data");

		ExcelReport report = new TrabajosGastoExcelReport(listaTrabajos);

		excelReportGeneratorApi.generateAndSend(report, response);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void generateExcelElementosGasto(Long idGasto, ModelMap model, HttpServletRequest request, HttpServletResponse response) throws IOException{


		String cartera = null;
		ExcelReport report = null;

		List<VElementosLineaDetalle> listaElementos = gastoLineaDetalleApi.getTodosElementosAfectados(idGasto);

		try {
			if (listaElementos != null && !listaElementos.isEmpty()) {
				cartera = gastoProveedorApi.getCodigoCarteraGastoByIdGasto(listaElementos.get(0).getIdGasto());
				report = new ElementosLineasExcelReport(listaElementos, cartera);
			}
			
			model.put("data", listaElementos);
				
			trustMe.registrarSuceso(request, idGasto, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "elementos", ACCION_CODIGO.CODIGO_VER);

			model.put("success", true);
			
			excelReportGeneratorApi.generateAndSend(report, response);
			
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			logger.error("error cargarElemetnosAfectados");
			model.put("success", false);
			trustMe.registrarError(request, idGasto, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "elementos", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

	}



	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView existeGasto(DtoFichaGastoProveedor dto, ModelMap model) {
		try {	
			
			boolean existeGasto = gastoProveedorApi.existeGasto(dto);
			
			model.put("existeGasto", existeGasto);
			model.put("success", true );
			
		} catch (JsonViewerException ex) {
			model.put("msg", ex.getMessage());
			model.put("success", false);
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}		
		
		return createModelAndViewJson(model);
		
	}	

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createGastosProveedor(DtoFichaGastoProveedor dto, ModelMap model) {
		try {	
			
			GastoProveedor gasto = gastoProveedorApi.createGastoProveedor(dto);
			
			model.put("id", gasto.getId() );
			model.put("success", true );
			
		} catch (JsonViewerException ex) {
			logger.error(ex.getMessage(),ex);
			model.put("msg", ex.getMessage());
			model.put("success", false);
		} catch (Exception e) {
			logger.error(e.getMessage(),e);
			model.put("success", false);
		}		
		
		return createModelAndViewJson(model);
		
	}	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveGastosProveedor(DtoFichaGastoProveedor dto, @RequestParam Long id,  ModelMap model, HttpServletRequest request) {
		try {		
			
			boolean respuesta = gastoProveedorApi.saveGastosProveedor(dto, id);
			model.put("success", respuesta );
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "gastosProveedor", ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (JsonViewerException ex) {
			model.put("msg", ex.getMessage());
			model.put("success", false);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "gastosProveedor", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "gastosProveedor", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteGastosProveedor(DtoFichaGastoProveedor dto, @RequestParam Long id,  ModelMap model) {
		
		try {
			boolean success = gastoProveedorApi.deleteGastoProveedor(id);
			model.put("success", success);

		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView searchProveedoresByNif(DtoProveedorFilter dto, ModelMap model) {
	
		try {
			model.put("data", gastoProveedorApi.searchProveedoresByNif(dto));
			model.put("success", true);
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
		
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView searchProveedorCodigo(@RequestParam String codigoUnicoProveedor) {
		ModelMap model = new ModelMap();
		
		try {
			model.put("data", gastoProveedorApi.searchProveedorCodigo(codigoUnicoProveedor));
			model.put("success", true);			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView searchPropietarioNif(@RequestParam String nifPropietario) {
		ModelMap model = new ModelMap();
		ActivoPropietario propietario = (ActivoPropietario) gastoProveedorApi.searchPropietarioNif(nifPropietario);
		Boolean carteraSareboBankia = false;
		if(!Checks.esNulo(propietario)&& !Checks.esNulo(propietario.getCartera())) {
			carteraSareboBankia = gastoProveedorApi.isCarteraPropietarioBankiaSareb(propietario);
		}
		try {
			model.put("data", propietario);
			model.put("carteraSareboBankia", carteraSareboBankia);
			model.put("success", true);			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView searchActivoCarteraAndGastoPrinex(@RequestParam String numGastoHaya) {
		ModelMap model = new ModelMap();

		try {
			model.put("data", gastoProveedorApi.searchActivoCarteraAndGastoPrinex(numGastoHaya));
			model.put("success", true);
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDetalleEconomico(DtoDetalleEconomicoGasto dto, @RequestParam Long id, ModelMap model, HttpServletRequest request) {
		try {		
			
			model.put("data", gastoProveedorApi.saveDetalleEconomico(dto, id));
			model.put("success", true);
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "detalleEconomico", ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "detalleEconomico", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListActivosGastos(@RequestParam Long idGasto, ModelMap model, HttpServletRequest request) {
		
		try {
			
			List<VBusquedaGastoActivo> listaActivos = gastoProveedorApi.getListActivosGastos(idGasto);
			model.put("data", listaActivos);
			model.put("success", true);
			trustMe.registrarSuceso(request, idGasto, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "activos", ACCION_CODIGO.CODIGO_VER);
	
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
			trustMe.registrarError(request, idGasto, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "activos", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListTrabajosGasto(@RequestParam Long idGasto, ModelMap model, HttpServletRequest request) {
		
		try {

			List<VBusquedaGastoTrabajos> lista = gastoProveedorApi.getListTrabajosGasto(idGasto);

			model.put("data", lista);
			model.put("success", true);
			trustMe.registrarSuceso(request, idGasto, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "trabajos", ACCION_CODIGO.CODIGO_VER);
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
			trustMe.registrarError(request, idGasto, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "trabajos", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
		
	}
	
	

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createGastoActivo(@RequestParam Long idGasto, @RequestParam Long numActivo, @RequestParam Long numAgrupacion, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.createGastoActivo(idGasto, numActivo, numAgrupacion);
			model.put("success", success);
			
		} catch (JsonViewerException ex) {
			model.put("msg", ex.getMessage());
			model.put("success", false);	
		} catch (Exception e) {
			logger.error(e.getMessage(),e);
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateGastoActivo(DtoActivoGasto dtoActivoGasto, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.updateGastoActivo(dtoActivoGasto);
			model.put("success", success);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteGastoActivo(DtoActivoGasto dtoActivoGasto, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.deleteGastoActivo(dtoActivoGasto);
			model.put("success", success);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateGastoContabilidad(DtoInfoContabilidadGasto dtoContabilidad, @RequestParam Long id, ModelMap model, HttpServletRequest request) {
		try {		
			
			boolean success = gastoProveedorApi.updateGastoContabilidad(dtoContabilidad, id);
			model.put("success", success);
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "contabilidad", ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "contabilidad", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateGastoByPrinexLBK( @RequestParam Long idGasto, ModelMap model) {
		try {

			boolean success = gastoProveedorApi.updateGastoByPrinexLBK(idGasto);
			model.put("success", success);

		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateGestionGasto(DtoGestionGasto dtoGestion, @RequestParam Long id, ModelMap model, HttpServletRequest request) {
		try {		
			
			boolean success = gastoProveedorApi.updateGestionGasto(dtoGestion, id);
			model.put("success", success);
			
		} catch (JsonViewerException ex) {
			model.put("msg", ex.getMessage());
			model.put("success", false);
			trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "gestion", ACCION_CODIGO.CODIGO_MODIFICAR);
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
			trustMe.registrarError(request, id, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "gestion", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateImpugnacionGasto(DtoImpugnacionGasto dtoImpugnacion, @RequestParam Long id, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.updateImpugnacionGasto(dtoImpugnacion, id);
			model.put("success", success);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView asignarTrabajos(Long idGasto, Long[] trabajos, ModelMap model) {
		try {		
			
			boolean success =gastoLineaDetalleApi.asignarTrabajosLineas(idGasto, trabajos);
			model.put("success", success);
			
		} catch (Exception e) {
			logger.error("Error en GastosProveedorController", e);
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntos(@RequestParam Long idGasto, ModelMap model, HttpServletRequest request){

		try {
			model.put("data", gastoProveedorApi.getAdjuntos(idGasto));
			trustMe.registrarSuceso(request, idGasto, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "adjuntos", ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			model.put("msg", e.getMessage());
			model.put("success", false);
			logger.error(e.getMessage());
			trustMe.registrarError(request, idGasto, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "adjuntos", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}
		
		return createModelAndViewJson(model);
		
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView desasignarTrabajos(Long idGasto, Long[] trabajos, ModelMap model) {
		try {		
			Long idTrabajo = trabajos[0];
			boolean success = gastoLineaDetalleApi.eliminarTrabajoLinea(idTrabajo,idGasto);
			model.put("success", success);
			
		} catch (Exception e) {
			logger.error("error desasignando trabajos",e);
			model.put("success", false);
		}	
		
		return createModelAndViewJson(model);
		
	}	

	/**
	 * Recibe y guarda un adjunto
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView upload(HttpServletRequest request, HttpServletResponse response)
		throws Exception {
		
		ModelMap model = new ModelMap();
		
		try {

			WebFileItem fileItem = uploadAdapter.getWebFileItem(request);
			
			String errores = gastoProveedorApi.upload(fileItem);			

			model.put("errores", errores);
			model.put("success", errores==null);
		
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("errores", e.getCause());
		}
		return createModelAndViewJson(model);
	}
	
	/**
     * delete un adjunto.
     * @param dtoAdjunto dto
     */
	@RequestMapping(method = RequestMethod.POST)
    public ModelAndView deleteAdjunto(DtoAdjunto dtoAdjunto) {
		
		boolean success= false;
		
		try {
			success = gastoProveedorApi.deleteAdjunto(dtoAdjunto);
		} catch(Exception ex) {
			logger.error(ex.getMessage());
		}
    	
    	return createModelAndViewJson(new ModelMap("success", success));

    }
	
	/**
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping(method = RequestMethod.GET)
	public void bajarAdjuntoGasto (HttpServletRequest request, HttpServletResponse response) {
        
		DtoAdjunto dtoAdjunto = new DtoAdjunto();
		
		dtoAdjunto.setId(Long.parseLong(request.getParameter("id")));
		dtoAdjunto.setIdEntidad(Long.parseLong(request.getParameter("idGasto")));
		String nombreDocumento = request.getParameter("nombreDocumento");
		dtoAdjunto.setNombre(nombreDocumento);
       	FileItem fileItem = gastoProveedorApi.getFileItemAdjunto(dtoAdjunto);
		
       	try { 
       		
       		if(!Checks.esNulo(fileItem)) {
       		
	       		ServletOutputStream salida = response.getOutputStream(); 
	       			
	       		response.setHeader("Content-disposition", "attachment; filename=\"" + fileItem.getFileName() +"\"");
	       		response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
	       		response.setHeader("Cache-Control", "max-age=0");
	       		response.setHeader("Expires", "0");
	       		response.setHeader("Pragma", "public");
	       		response.setDateHeader("Expires", 0); //prevents caching at the proxy
	       		response.setContentType(fileItem.getContentType());
	       		
	       		// Write
	       		FileUtils.copy(fileItem.getInputStream(), salida);
	       		salida.flush();
	       		salida.close();
       		}
       		
       	} catch (Exception e) { 
       		logger.error(e.getMessage());
       	}

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getNifProveedorByUsuario(ModelMap model){
		
		
		
		try {
			String nifProveedor = proveedoresApi.getNifProveedorByUsuarioLogado();
			
			if(Checks.esNulo(nifProveedor)) {
				model.put("msg", "No ha sido posible encontrar un proveedor asignado al usuario identificado.");
				model.put("data", -1);
				model.put("success", false);
			} else {
				model.put("data", nifProveedor);
				model.put("success", true);
			}


		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView searchProveedorCodigoByTipoEntidad(@RequestParam String codigoUnicoProveedor, @RequestParam String codigoTipoProveedor) {
		ModelMap model = new ModelMap();
		
		try {
			model.put("data", gastoProveedorApi.searchProveedorCodigoByTipoEntidad(codigoUnicoProveedor,codigoTipoProveedor));
			model.put("success", true);			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView searchGastoNumHaya(@RequestParam String numeroGastoHaya, @RequestParam String proveedorEmisor, @RequestParam String destinatario) {
		ModelMap model = new ModelMap();
		
		try {
			model.put("data", gastoProveedorApi.searchGastoNumHaya(numeroGastoHaya,proveedorEmisor,destinatario));
			model.put("success", true);			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView autorizarGastos(Long[] idsGasto, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.autorizarGastos(idsGasto);
			model.put("success", success);
			
		} catch (JsonViewerException ex) {
			model.put("msg", ex.getMessage());
			model.put("success", false);
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView autorizarGastosContabilidad(Long[] idsGasto, String fechaConta, String fechaPago, Boolean individual, ModelMap model) {
		try {

			boolean success = gastoProveedorApi.autorizarGastosContabilidad(idsGasto, fechaConta, fechaPago, individual);
			model.put("success", success);

		} catch (JsonViewerException ex) {
			model.put("msg", ex.getMessage());
			model.put("success", false);
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView autorizarGastosContabilidadAgrupacion(Long[] idsGasto, Long idAgrupacion, String fechaConta, String fechaPago, Boolean individual, ModelMap model) {
		try {

			boolean success = gastoProveedorApi.autorizarGastosContabilidadAgrupacion(idsGasto, idAgrupacion, fechaConta, fechaPago, individual);
			model.put("success", success);

		} catch (JsonViewerException ex) {
			model.put("msg", ex.getMessage());
			model.put("success", false);
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView rechazarGastos(Long[] idsGasto, String motivoRechazo, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.rechazarGastos(idsGasto, motivoRechazo);
			model.put("success", success);
			
		} catch (JsonViewerException ex) {
			model.put("msg", ex.getMessage());
			model.put("success", false);
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView autorizarGasto(Long idGasto, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.autorizarGasto(idGasto, true);
			model.put("success", success);
			
		} catch (JsonViewerException ex) {
			model.put("msg", ex.getMessage());
			model.put("success", false);
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView rechazarGasto(Long idGasto, String motivoRechazo, ModelMap model) {
		try {		
			
			boolean success = gastoProveedorApi.rechazarGasto(idGasto, motivoRechazo);
			model.put("success", success);
		
		} catch (JsonViewerException ex) {
			model.put("msg", ex.getMessage());
			model.put("success", false);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings({"unchecked"})
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView rechazarGastosContabilidad(Long[] idsGasto, String motivoRechazo, Boolean individual, ModelMap model) {
		try {

			boolean success = gastoProveedorApi.rechazarGastosContabilidad(idsGasto, motivoRechazo, individual);
			model.put("success", success);

		} catch (JsonViewerException ex) {
			model.put("msg", ex.getMessage());
			model.put("success", false);
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings({ "unchecked"})
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getAvisosGastoById(Long id, WebDto webDto, ModelMap model){

		Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
		GastoProveedor gasto = gastoProveedorApi.findOne(id);	
		
		DtoAviso avisosFormateados = new DtoAviso();
		avisosFormateados.setDescripcion("");
		
		for (GastoAvisadorApi avisador: avisadores) {
			
			DtoAviso aviso  = avisador.getAviso(gasto, usuarioLogado);
			if (!Checks.esNulo(aviso) && !Checks.esNulo(aviso.getDescripcion())) {
				avisosFormateados.setDescripcion(avisosFormateados.getDescripcion() + 
						formateaAviso(aviso.getDescripcion()));
			}
			if (!Checks.estaVacio(aviso.getDescripciones())) {
				for (String descripcion : aviso.getDescripciones()) {
					avisosFormateados.setDescripcion(avisosFormateados.getDescripcion() + 
							formateaAviso(descripcion));
				}
			}
			
        }
		
		model.put("data", avisosFormateados);
		
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void generateExcelGestionGastos(DtoGastosFilter dtoGastosFilter, HttpServletRequest request, HttpServletResponse response) throws IOException {
		dtoGastosFilter.setStart(excelReportGeneratorApi.getStart());
		dtoGastosFilter.setLimit(excelReportGeneratorApi.getLimit());

		DtoPage page = gastoProveedorApi.getListGastosExcel(dtoGastosFilter);
		List<VGastosProveedorExcel> listaGastosProveedor = (List<VGastosProveedorExcel>) page.getResults();

		ExcelReport report = new GestionGastosExcelReport(listaGastosProveedor);

		excelReportGeneratorApi.generateAndSend(report, response);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	@Transactional
	public ModelAndView registrarExportacion(DtoGastosFilter dtoGastosFilter, Boolean exportar, String buscador, HttpServletRequest request, HttpServletResponse response) throws Exception {
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
				int count = gastoProveedorApi.getListGastosExcel(dtoGastosFilter).getTotalCount();
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
			logger.error("error en gastosProveedorController", e);
		}
		return createModelAndViewJson(model);
		
	}
	
	@Transactional
	private void registrarExportacion(int count, String buscador) throws Exception {
		Usuario user = null;
				
		user = usuarioManager.getUsuarioLogado();
		AuditoriaExportaciones ae = new AuditoriaExportaciones();
		ae.setBuscador(buscador);
		ae.setFechaExportacion(new Date());
		ae.setNumRegistros(Long.valueOf(count));
		ae.setUsuario(user);
		ae.setAccion(true);
		genericDao.save(AuditoriaExportaciones.class, ae);		
		
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
	
	private String formateaAviso(String descripcion) {
		return  "<div class='div-aviso red'>" + descripcion + "</div>";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListGastosProvision(DtoGastosFilter dtoGastosFilter, ModelMap model) {
		try {

			DtoPage page = gastoProveedorApi.getListGastosProvision(dtoGastosFilter);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("exception", e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getListGastosProvisionAgrupGastos(Long id, ModelMap model) {
		try {

			List<VGastosProveedor> lista = gastoProveedorApi.getListGastosProvisionAgrupGastos(id);

			model.put("data", lista);
			model.put("success", true);

		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("exception", e.getMessage());
		}
		
		return createModelAndViewJson(model);
	}
	
	/**
	 * Este método recibe el activo o la agrupación de activos que se quiere asociar con el gasto
	 * y valida que no haya ningún activo que tenga una fecha de traspaso anterior a la fecha de 
	 * devengo del gasto.
	 * 
	 * @param idGasto: Gasto que se asociará con los activos.
	 * @param idActivo: El activo que se va a asociar con el gasto anterior.
	 * @param idAgrupacion: La agrupación de activos que se quiere asociar con el gasto
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView fechaDevengoPosteriorFechaTraspaso(Long idGasto, Long idActivo, Long idAgrupacion, ModelMap model) {

		try {
			boolean success = gastoProveedorApi.fechaDevengoPosteriorFechaTraspaso(idGasto, idActivo, idAgrupacion);
			model.put("fechaDevengoSuperior", success);
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("fechaDevengoSuperior", false);
			model.put("error", e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings({"unchecked"})
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView rechazarGastosContabilidadAgrupGastos(Long idAgrupGasto, Long[] idsGasto, String motivoRechazo, Boolean individual, ModelMap model) {
		try {

			boolean success = gastoProveedorApi.rechazarGastosContabilidadAgrupGastos(idAgrupGasto,idsGasto, motivoRechazo, individual);
			model.put("success", success);

		} catch (JsonViewerException ex) {
			model.put("msg", ex.getMessage());
			model.put("success", false);
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.POST)
	@Transactional
	public void generateExcelFacturas(HttpServletRequest request, HttpServletResponse response) throws Exception{

		List<VFacturasProveedores> listaFacturas = gastoProveedorApi.getListFacturas();
		
		ExcelReport report = new FacturasProveedoresExcelReport(listaFacturas);
		registrarExportacion(listaFacturas.size(), "gastos-facturas");
		excelReportGeneratorApi.generateAndSend(report, response);
	}

	@RequestMapping(method = RequestMethod.POST)
	@Transactional
	public void generateExcelTasasImpuestos(HttpServletRequest request, HttpServletResponse response) throws Exception{

		List<VTasasImpuestos> listaTasasImpuestos = gastoProveedorApi.getListTasasImpuestos();

		ExcelReport report = new TasasImpuestosExcelReport(listaTasasImpuestos);
		registrarExportacion(listaTasasImpuestos.size(), "gastos-tasas");
		excelReportGeneratorApi.generateAndSend(report, response);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getGastosRefacturados(@RequestParam String gastos, String nifPropietario, String tipoGasto) {
		ModelMap model = new ModelMap();
		
		List<String> gastosRefacturables = new ArrayList<String>();
		List<String> gastosNoRefacturables = new ArrayList<String>();
		
		try {	
			if(!Checks.esNulo(gastos)) {
				gastosRefacturables = gastoProveedorApi.getGastosRefacturados(gastos, nifPropietario, tipoGasto);
				gastosNoRefacturables = gastoProveedorApi.getGastosNoRefacturados(gastos, gastosRefacturables);
			}
			model.put("refacturable", gastosRefacturables);
			model.put("noRefacturable", gastosNoRefacturables);
			model.put("success", true);			
		} catch (Exception e) {
			logger.error(e.getMessage(),e);
			model.put("error", e.getMessage());
			model.put("success", false);		
		}

		return createModelAndViewJson(model);
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getGastosRefacturablesGastoCreado(String id) {
		ModelMap model = new ModelMap();
		
		List<Long> gastosRefacturables;
		int i;
		Long idEnLong = Long.parseLong(id);
	
		gastosRefacturables = gastoProveedorApi.getGastosRefacturablesGastoCreado(idEnLong);

		List<DtoDetalleEconomicoGasto> dto = new ArrayList<DtoDetalleEconomicoGasto>();
	
		for (i = 0; i < gastosRefacturables.size(); i++) {
			DtoDetalleEconomicoGasto dtoAuxiliar = new DtoDetalleEconomicoGasto();
			dtoAuxiliar.setNumeroGastoHaya(gastosRefacturables.get(i));
			
			dto.add(dtoAuxiliar);
		}
		
		try {			
			model.put("data", dto);
			model.put("success", true);			
		} catch (Exception e) {
			logger.error(e.getMessage(),e);
			model.put("success", false);		
		}

		return createModelAndViewJson(model);
	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView anyadirGastoRefacturable(@RequestParam String idGasto, String gastosRefacturables, String nifPropietario) {
		ModelMap model = new ModelMap();

		try {
			if(!Checks.esNulo(idGasto)) {
				gastoProveedorApi.anyadirGastosRefacturablesSiCumplenCondiciones(idGasto, gastosRefacturables, nifPropietario);
			}		
			model.put("success", true);			
		} catch (JsonViewerException jve) {
			logger.error(jve.getMessage(),jve);
			model.put("error", jve.getMessage());
			model.put("success", false);
		} catch (Exception e) {
			logger.error(e.getMessage(),e);
			model.put("error", e.getMessage());
			model.put("success", false);		
		} 

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView eliminarGastoRefacturado(@RequestParam Long idGasto, String numerosGasto) {
		ModelMap model = new ModelMap();
		List<String> gastosRefacturados = Arrays.asList(numerosGasto.split("/"));
		Boolean noTieneGastosRefacturados = false;	
		
		if(!Checks.esNulo(idGasto) && !Checks.estaVacio(gastosRefacturados)) {
			for (String numGastoRefacturado : gastosRefacturados) {
				noTieneGastosRefacturados = gastoProveedorApi.eliminarGastoRefacturado(idGasto, Long.valueOf(numGastoRefacturado));
			}
			
			if(gastoProveedorApi.isGastoSareb(gastoProveedorApi.findOne(idGasto))){
				gastoLineaDetalleApi.eliminarLineasRefacturadas(idGasto);
			}
		}
		
		try {	
			model.put("noTieneGastosRefacturados", noTieneGastosRefacturados);
			model.put("success", true);			
		} catch (Exception e) {
			logger.error(e.getMessage(),e);
			model.put("success", false);		
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getGastoLineaDetalle(Long idGasto) {
		ModelMap model = new ModelMap();
		
		try {			
			List<DtoLineaDetalleGasto> dtoLineaDetalleGastoLista =gastoLineaDetalleApi.getGastoLineaDetalle(idGasto);
			model.put("data", dtoLineaDetalleGastoLista);
			model.put("success", true);			
		} catch (Exception e) {
			logger.error(e.getMessage(),e);
			model.put("success", false);		
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveGastoLineaDetalle(HttpServletRequest request, DtoLineaDetalleGasto dtoLineaDetalleGasto) {
		
		
		ModelMap model = new ModelMap();
		try {
			model.put("success", gastoLineaDetalleApi.saveGastoLineaDetalle(dtoLineaDetalleGasto));
			
		}catch (Exception e) {
			logger.error("error en GastosProveedorController", e);
			model.put("success", false);
			model.put("errorMessage", "Error al crear/modificar LíneaDetalleGasto.");
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView deleteGastoLineaDetalle(Long idLineaDetalleGasto) {
		
		
		ModelMap model = new ModelMap();
		try {
			model.put("success", gastoLineaDetalleApi.deleteGastoLineaDetalle(idLineaDetalleGasto));
			
		}catch (Exception e) {
			logger.error("error en GastosProveedorController", e);
			model.put("success", false);
			model.put("errorMessage", "Error al borrar LíneaDetalleGasto.");
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView calcularCuentasYPartidas(Long idGasto, Long idLineaDetalleGasto, String subtipoGastoCodigo) {
			
		ModelMap model = new ModelMap();
		try {
			GastoProveedor gasto = gastoProveedorApi.findOne(idGasto);
			DtoLineaDetalleGasto linea = gastoLineaDetalleApi.calcularCuentasYPartidas(gasto, idLineaDetalleGasto, subtipoGastoCodigo, null);
			model.put("data", linea);
			model.put("success", true);
			
		}catch (Exception e) {
			logger.error("error en GastosProveedorController", e);
			model.put("success", false);
			model.put("errorMessage", "Error encontrar pp y cc.");
		}
		
		return createModelAndViewJson(model);
	}
	

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getVImporteGastoLbk(Long idGasto) {
			
		ModelMap model = new ModelMap();
		
		try {
			List<DtoVImporteGastoLbk> linea = gastoProveedorApi.getVImporteGastoLbk(idGasto);
			model.put("data", linea);
			model.put("success", true);
			
		}catch (Exception e) {
			logger.error("error en GastosProveedorController", e);
			model.put("success", false);
			model.put("errorMessage", "Error encontrar pp y cc.");
		}
		
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getElementosAfectados(Long idLinea, ModelMap model, HttpServletRequest request) {
		
		try {
			if(idLinea != -1) {
				List<VElementosLineaDetalle> elementosAfectados = gastoLineaDetalleApi.getElementosAfectados(idLinea);
				model.put("data", elementosAfectados);
				
				trustMe.registrarSuceso(request, idLinea, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "elementos", ACCION_CODIGO.CODIGO_VER);
			}
			model.put("success", true);
		} catch (Exception e) {
			logger.error(e.getMessage());
			logger.error("error cargarElemetnosAfectados");
			model.put("success", false);
			trustMe.registrarError(request, idLinea, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "elementos", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getLineasDetalleGastoCombo(@RequestParam Long idGasto, ModelMap model, HttpServletRequest request) {
		
		try {
			
			List<DtoComboLineasDetalle> elementosAfectados = gastoLineaDetalleApi.getLineasDetalleGastoCombo(idGasto);
			model.put("data", elementosAfectados);
			model.put("success", true);
			trustMe.registrarSuceso(request, idGasto, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "elementos", ACCION_CODIGO.CODIGO_VER);
	
		} catch (Exception e) {
			logger.error(e.getMessage());
			logger.error("error cargarComboLineas");
			model.put("success", false);
			trustMe.registrarError(request, idGasto, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "elementos", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView asociarElementosAgastos(DtoElementosAfectadosLinea dto, ModelMap model, HttpServletRequest request) {
		
		try {		
			model.put("success", true);
			model.put("data", gastoLineaDetalleApi.asociarElementosAgastos(dto));
			trustMe.registrarSuceso(request, dto.getIdGasto(), ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "elementos", ACCION_CODIGO.CODIGO_VER);
	
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
			trustMe.registrarError(request, dto.getIdGasto(), ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "elementos", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
		
	}
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView desasociarElementosAgastos(@RequestParam Long idElemento, ModelMap model, HttpServletRequest request) {
		
		try {		
			model.put("success", gastoLineaDetalleApi.desasociarElementosAgastos(idElemento));
			trustMe.registrarSuceso(request, idElemento, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "elementos", ACCION_CODIGO.CODIGO_VER);
	
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
			trustMe.registrarError(request, idElemento, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "elementos", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateElementosDetalle(@RequestParam Long id, DtoElementosAfectadosLinea dto, ModelMap model, HttpServletRequest request) {
		
		try {		
			model.put("success", gastoLineaDetalleApi.updateElementosDetalle(dto));
			trustMe.registrarSuceso(request, dto.getId(), ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "elementos", ACCION_CODIGO.CODIGO_VER);
	
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
			trustMe.registrarError(request, dto.getId(), ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "elementos", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView updateLineaSinActivos(@RequestParam Long idLinea,  ModelMap model, HttpServletRequest request) {
		
		try {		
			model.put("success", gastoLineaDetalleApi.updateLineaSinActivos(idLinea));
			trustMe.registrarSuceso(request, idLinea, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "elementos", ACCION_CODIGO.CODIGO_VER);
	
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
			trustMe.registrarError(request, idLinea, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "elementos", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
		
	}


	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTiposTrabajoByIdGasto(Long idGasto) {
			
		ModelMap model = new ModelMap();
		
		try {
			List<DDTipoTrabajo> linea = gastoProveedorApi.getTiposTrabajoByIdGasto(idGasto);
			model.put("data", linea);
			model.put("success", true);
			
		}catch (Exception e) {
			logger.error("error en GastosProveedorController - getTiposTrabajoByIdGasto", e);
			model.put("success", false);
			model.put("errorMessage", "Error al obtener los tipos de trabajo");
		}
		
		return createModelAndViewJson(model);
	}

	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getSubTiposTrabajoByIdGasto(Long idGasto) {
			
		ModelMap model = new ModelMap();
		
		try {
			List<DDSubtipoTrabajo> linea = gastoProveedorApi.getSubTiposTrabajoByIdGasto(idGasto);
			model.put("data", linea);
			model.put("success", true);
			
		}catch (Exception e) {
			logger.error("error en GastosProveedorController - getSubTiposTrabajoByIdGasto", e);
			model.put("success", false);
			model.put("errorMessage", "Error al obtener los subtipos de trabajo");
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView actualizarReparto(Long idLinea) {
			
		ModelMap model = new ModelMap();
		
		try {
			boolean hayReparto = gastoProveedorApi.actualizarReparto(idLinea);
			model.put("data", hayReparto);
			model.put("success", true);
			
		}catch (Exception e) {
			logger.error("error en GastosProveedorController - actualizarReparto", e);
			model.put("success", false);
			model.put("errorMessage", "Error al realizar el reparto");
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView actualizarRepartoTrabajo(Long idLinea) {
			
		ModelMap model = new ModelMap();
		
		try {
			boolean hayReparto = gastoProveedorApi.actualizarRepartoTrabajo(idLinea);
			model.put("data", hayReparto);
			model.put("success", true);
			
		}catch (Exception e) {
			logger.error("error en GastosProveedorController - actualizarRepartoTrabajo", e);
			model.put("success", false);
			model.put("errorMessage", "Error al realizar el reparto");
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView actualizarParticipacionTrabajosAfterInsert(Long idGasto) {
			
		ModelMap model = new ModelMap();
		
		try {
			gastoLineaDetalleApi.actualizarParticipacionTrabajosAfterInsert(idGasto);
			model.put("success", true);
			
		}catch (Exception e) {
			logger.error("error en GastosProveedorController - actualizarRepartoTrabajo", e);
			model.put("success", false);
			model.put("errorMessage", "Error al realizar el reparto");
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveCuentasPartidasGastoLineaDetalle(HttpServletRequest request, DtoLineaDetalleGasto dtoLineaDetalleGasto) {
		
		
		ModelMap model = new ModelMap();
		try {
			model.put("success", gastoLineaDetalleApi.updateCuentasPartidas(dtoLineaDetalleGasto));
			
		}catch (Exception e) {
			logger.error("error en GastosProveedorController", e);
			model.put("success", false);
			model.put("errorMessage", "Error al crear/modificar LíneaDetalleGasto.");
		}

			return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getAvisosSuplidos(Long idGasto, ModelMap model) {
		try {
			String validacion = gastoProveedorApi.validarAutorizacionSuplido(idGasto);
		
			model.put("error", validacion);
		} catch (JsonViewerException ex) {
			model.put("msg", ex.getMessage());
			model.put("success", false);
		}
				
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView validacionNifEmisorFactura(DtoFichaGastoProveedor dto, Long idGasto, ModelMap model) {
		String validacion = gastoProveedorApi.validacionNifEmisorFactura(dto, idGasto);
		
		model.put("error", validacion);
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getRechazosPropietario(Long idGasto) {
		ModelMap model = new ModelMap();
		
		try {
			List<VGridMotivosRechazoGastoCaixa> motivosRechazoList = gastoProveedorApi.getMotivosRechazoGasto(idGasto);
			model.put("data", motivosRechazoList);
			model.put("success", true);			
		} catch (Exception e) {
			logger.error(e.getMessage(),e);
			model.put("success", false);		
		}
		return createModelAndViewJson(model);
	}
		
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getGastoExists(String numGastoHaya, ModelMap model) {
		try {
			Long idGasto = gastoProveedorApi.getIdByNumGasto(Long.parseLong(numGastoHaya));
				
			if(!Checks.esNulo(idGasto)) {
				model.put("success", true);
				model.put("data", idGasto);
			}else {
				model.put("success", false);
				model.put("error", ERROR_GASTO_NOT_EXISTS);
			}
		} catch (NumberFormatException e) {
			model.put("success", false);
			model.put("error", ERROR_GASTO_NO_NUMERICO);
		} catch(Exception e) {
			logger.error("error obteniendo el activo ",e);
			model.put("success", false);
			model.put("error", ERROR_GENERICO);
		}
		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListTasacionesGasto(@RequestParam Long idGasto, ModelMap model, HttpServletRequest request) {

		try {

			List<VTasacionesGastos> lista = gastoProveedorApi.getListTasacionesGasto(idGasto);

			model.put("data", lista);
			model.put("success", true);
			trustMe.registrarSuceso(request, idGasto, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "trabajos", ACCION_CODIGO.CODIGO_VER);
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
			trustMe.registrarError(request, idGasto, ENTIDAD_CODIGO.CODIGO_GASTOS_PROVEEDOR, "trabajos", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteGastoTasacion(@RequestParam Long id,  ModelMap model) {

		try {
			boolean success = gastoProveedorApi.deleteGastoTasacion(id);
			model.put("success", success);

		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView asignarTasacionesGastos(Long idGasto, Long[] tasaciones, ModelMap model) {
		try {

			boolean success = gastoLineaDetalleApi.asignarTasacionesGastos(idGasto, tasaciones);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("Error en GastosProveedorController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
}
