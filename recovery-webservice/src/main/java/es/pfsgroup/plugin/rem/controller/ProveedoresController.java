package es.pfsgroup.plugin.rem.controller;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.NumberUtils;
import org.apache.commons.lang.StringUtils;
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

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.FileUtils;
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
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.api.ProveedoresApi;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.IsNumber;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.ProveedorExcelReport;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.ACCION_CODIGO;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.ENTIDAD_CODIGO;
import es.pfsgroup.plugin.rem.logTrust.LogTrustEvento.REQUEST_STATUS_CODE;
import es.pfsgroup.plugin.rem.model.AuditoriaExportaciones;
import es.pfsgroup.plugin.rem.model.DtoActivoIntegrado;
import es.pfsgroup.plugin.rem.model.DtoActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoConductasInapropiadas;
import es.pfsgroup.plugin.rem.model.DtoDatosContacto;
import es.pfsgroup.plugin.rem.model.DtoDireccionDelegacion;
import es.pfsgroup.plugin.rem.model.DtoMediador;
import es.pfsgroup.plugin.rem.model.DtoMediadorEvalua;
import es.pfsgroup.plugin.rem.model.DtoMediadorEvaluaFilter;
import es.pfsgroup.plugin.rem.model.DtoMediadorOferta;
import es.pfsgroup.plugin.rem.model.DtoMediadorStats;
import es.pfsgroup.plugin.rem.model.DtoPersonaContacto;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoProveedor;
import es.pfsgroup.plugin.rem.proveedores.ProveedoresManager;


@Controller
public class ProveedoresController extends ParadiseJsonController {

	protected static final Log logger = LogFactory.getLog(ProveedoresController.class);

	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_ERROR_MESSAGE_KEY= "msgError";
	private static final String RESPONSE_DATA_KEY = "data";

	@Autowired
	private ProveedoresApi proveedoresApi;

	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;

	@Autowired
	private UploadAdapter uploadAdapter;

	@Autowired
	private LogTrustEvento trustMe;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ConfigManager configManager;
	
	@Resource
	private Properties appProperties;

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getProveedorById(Long id, ModelMap model, HttpServletRequest request) {
		model.put("data", proveedoresApi.getProveedorById(id));
		model.put("success", true);
		trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_PROVEEDOR, "datos", ACCION_CODIGO.CODIGO_VER);

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveProveedorById(DtoActivoProveedor dto, ModelMap model, HttpServletRequest request) {
		try{
			boolean success = proveedoresApi.saveProveedorById(dto);
			model.put("success", success);
			trustMe.registrarSuceso(request, dto.getId(), ENTIDAD_CODIGO.CODIGO_PROVEEDOR, "datos", ACCION_CODIGO.CODIGO_MODIFICAR);

		} catch (JsonViewerException jvex) {
			model.put("success", false);
			model.put("msg", jvex.getMessage());
			logger.warn("Excepción controlada en ProveedoresController", jvex);
			trustMe.registrarError(request, dto.getId(), ENTIDAD_CODIGO.CODIGO_PROVEEDOR, "datos", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);

		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
			trustMe.registrarError(request, dto.getId(), ENTIDAD_CODIGO.CODIGO_PROVEEDOR, "datos", ACCION_CODIGO.CODIGO_MODIFICAR, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public void generateExcelProveedores(DtoProveedorFilter dtoProveedorFiltro, HttpServletRequest request, HttpServletResponse response) throws IOException {
		dtoProveedorFiltro.setStart(excelReportGeneratorApi.getStart());
		dtoProveedorFiltro.setLimit(excelReportGeneratorApi.getLimit());

		List<DtoProveedorFilter> listaProveedores = proveedoresApi.getProveedores(dtoProveedorFiltro);

		ExcelReport report = new ProveedorExcelReport(listaProveedores);

		excelReportGeneratorApi.generateAndSend(report, response);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	@Transactional()
	public ModelAndView registrarExportacion(DtoProveedorFilter dtoProveedorFiltro, Boolean exportar, String buscador, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String intervaloTiempo = !Checks.esNulo(appProperties.getProperty("haya.tiempo.espera.export")) && StringUtils.isNumeric(appProperties.getProperty("haya.tiempo.espera.export")) ? appProperties.getProperty("haya.tiempo.espera.export") : "300000";
		ModelMap model = new ModelMap();		 
		Boolean isSuperExport = false;
		Boolean permitido = true;
		String filtros = parameterParser(request.getParameterMap());
		Usuario user = usuarioManager.getUsuarioLogado();
		Long tiempoPermitido = System.currentTimeMillis() - Long.parseLong(intervaloTiempo);
		String cuentaAtras = null;
		dtoProveedorFiltro.setStart(0);
		dtoProveedorFiltro.setLimit(1);
		List<DtoProveedorFilter> listaProveedores = null;
		int count = 0;
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
				listaProveedores = proveedoresApi.getProveedores(dtoProveedorFiltro);
				if(!Checks.estaVacio(listaProveedores)) {
					count = listaProveedores.get(0).getTotalCount();
				}
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
			logger.error("error en proveedoresController", e);
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
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getProveedores(DtoProveedorFilter dtoProveedorFiltro, ModelMap model) {
		try {
			List<DtoProveedorFilter> resultados = proveedoresApi.getProveedores(dtoProveedorFiltro);

			model.put("data", resultados);
			if (!Checks.estaVacio(resultados)) {
				model.put("totalCount", resultados.get(0).getTotalCount());

			} else {
				model.put("totalCount", 0);
			}

			model.put("success", true);

		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDireccionesDelegacionesByProveedor(DtoDireccionDelegacion dtoDireccionDelegacion, ModelMap model, HttpServletRequest request) {
		
		try{
			List<DtoDireccionDelegacion> resultados = proveedoresApi.getDireccionesDelegacionesByProveedor(dtoDireccionDelegacion);
			model.put("data", resultados);

			if (!Checks.estaVacio(resultados)) {
				model.put("totalCount", resultados.get(0).getTotalCount());

			} else {
				model.put("totalCount", 0);
			}

			model.put("success", true);
			trustMe.registrarSuceso(request, Long.parseLong(dtoDireccionDelegacion.getId()), ENTIDAD_CODIGO.CODIGO_PROVEEDOR, "delegaciones", ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
			trustMe.registrarError(request, Long.parseLong(dtoDireccionDelegacion.getId()), ENTIDAD_CODIGO.CODIGO_PROVEEDOR, "delegaciones", ACCION_CODIGO.CODIGO_VER , REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createDireccionDelegacion(DtoDireccionDelegacion dtoDireccionDelegacion, ModelMap model) {
		try {
			boolean success = proveedoresApi.createDireccionDelegacion(dtoDireccionDelegacion);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateDireccionDelegacion(DtoDireccionDelegacion dtoDireccionDelegacion, ModelMap model) {
		try {
			boolean success = proveedoresApi.updateDireccionDelegacion(dtoDireccionDelegacion);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteDireccionDelegacion(DtoDireccionDelegacion dtoDireccionDelegacion, ModelMap model) {
		try {
			boolean success = proveedoresApi.deleteDireccionDelegacion(dtoDireccionDelegacion);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getPersonasContactoByProveedor(DtoPersonaContacto dtoPersonaContacto, ModelMap model, HttpServletRequest request) {
		try{
			List<DtoPersonaContacto> resultados = proveedoresApi.getPersonasContactoByProveedor(dtoPersonaContacto);
			model.put("data", resultados);

			if (!Checks.estaVacio(resultados)) {
				model.put("totalCount", resultados.get(0).getTotalCount());

			} else {
				model.put("totalCount", 0);
			}

			model.put("success", true);
			trustMe.registrarSuceso(request, Long.parseLong(dtoPersonaContacto.getId()), ENTIDAD_CODIGO.CODIGO_PROVEEDOR, "personas", ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
			trustMe.registrarError(request, Long.parseLong(dtoPersonaContacto.getId()), ENTIDAD_CODIGO.CODIGO_PROVEEDOR, "personas", ACCION_CODIGO.CODIGO_VER, REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createPersonasContacto(DtoPersonaContacto dtoPersonaContacto, ModelMap model) {
		try {
			boolean success = proveedoresApi.createPersonasContacto(dtoPersonaContacto);
			model.put("success", success);

		} catch (Exception e) {
			if (e.getMessage().equals(ProveedoresManager.USUARIO_NOT_EXISTS_EXCEPTION_CODE)) {
				model.put("msg", ProveedoresManager.USUARIO_NOT_EXISTS_EXCEPTION_MESSAGE);
				model.put("success", false);

			} else {
				logger.error("Error en ProveedoresController", e);
				model.put("success", false);
			}
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updatePersonasContacto(DtoPersonaContacto dtoPersonaContacto, ModelMap model) {
		try {
			boolean success = proveedoresApi.updatePersonasContacto(dtoPersonaContacto);
			model.put("success", success);

		} catch (Exception e) {
			if (e.getMessage().equals(ProveedoresManager.USUARIO_NOT_EXISTS_EXCEPTION_CODE)) {
				model.put("msg", ProveedoresManager.USUARIO_NOT_EXISTS_EXCEPTION_MESSAGE);
				model.put("success", false);
			} else {
				logger.error("Error en ProveedoresController", e);
				model.put("success", false);
			}
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deletePersonasContacto(DtoPersonaContacto dtoPersonaContacto, ModelMap model) {
		try {
			boolean success = proveedoresApi.deletePersonasContacto(dtoPersonaContacto);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView setPersonaContactoPrincipal(DtoPersonaContacto dtoPersonaContacto, ModelMap model) {
		try {
			boolean success = proveedoresApi.setPersonaContactoPrincipal(dtoPersonaContacto);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getActivosIntegradosByProveedor(DtoActivoIntegrado dtoActivoIntegrado, ModelMap model, HttpServletRequest request) {
		try{
			List<DtoActivoIntegrado> resultados = proveedoresApi.getActivoIntegradoByProveedor(dtoActivoIntegrado);
			model.put("data", resultados);

			if (!Checks.estaVacio(resultados)) {
				model.put("totalCount", resultados.get(0).getTotalCount());
			} else {
				model.put("totalCount", 0);
			}
			model.put("success", true);
			trustMe.registrarSuceso(request, Long.parseLong(dtoActivoIntegrado.getId()), ENTIDAD_CODIGO.CODIGO_PROVEEDOR, "activoIntegrado", ACCION_CODIGO.CODIGO_VER);

		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
			trustMe.registrarError(request, Long.parseLong(dtoActivoIntegrado.getId()), ENTIDAD_CODIGO.CODIGO_PROVEEDOR, "activoIntegrado", ACCION_CODIGO.CODIGO_VER , REQUEST_STATUS_CODE.CODIGO_ESTADO_KO);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntos(Long id, ModelMap model, HttpServletRequest request) {
		try {
			model.put("data", proveedoresApi.getAdjuntos(id));
		} catch (GestorDocumentalException gex) {
			logger.error("Error en ProveedoresController sobre el Gestor Documental", gex);
			model.put("success", false);
			model.put("errorMessage", "Ha habido un problema al recuperar los archivos desde el gestor documental.");
		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
			model.put("errores", e.getCause());
		}
		trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_PROVEEDOR, "adjuntos", ACCION_CODIGO.CODIGO_VER);

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteAdjunto(DtoAdjunto dtoAdjunto, ModelMap model) {
		try {
			boolean success = proveedoresApi.deleteAdjunto(dtoAdjunto);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView upload(HttpServletRequest request, HttpServletResponse response) {
		ModelMap model = new ModelMap();
		WebFileItem fileItem = new WebFileItem();

		try {
			fileItem = uploadAdapter.getWebFileItem(request);

			String errores = proveedoresApi.upload(fileItem);

			model.put("errores", errores);
			model.put("success", errores == null);
			
		} catch (GestorDocumentalException ex) {
			logger.error("Error en ProveedoresController sobre el Gestor Documental", ex);
			model.put("success", false);
			if (ex.getMessage().contains("An item with the name '"+fileItem.getFileItem().getFileName()+"' already exists") || ex.getMessage().contains("Ya existe un elemento con el nombre")) {
				model.put("errorMessage", ProveedoresManager.ERROR_NOMBRE_DOCUMENTO_PROVEEDOR+": "+fileItem.getFileItem().getFileName());
			} else if (ex.getMessage().contains("Control duplicado, ya existe un documento igual")) {
			   	DDTipoDocumentoProveedor tipoDocumentoProveedor = genericDao.get(DDTipoDocumentoProveedor.class, 
			   			genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo")), 
			   			genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
				model.put("errorMessage", ProveedoresManager.ERROR_TIPO_UNICO_DOCUMENTO_PROVEEDOR+": "+tipoDocumentoProveedor.getDescripcion());
			} else {
				model.put("errorMessage", "Ha habido un problema con la subida del archivo al gestor documental.");
			}
		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			if (ProveedoresManager.ERROR_TIPO_DOCUMENTO_PROVEEDOR.equals(e.getMessage())) {
				model.put("errorMessage", ProveedoresManager.ERROR_TIPO_DOCUMENTO_PROVEEDOR);
			}
			model.put("success", false);
			model.put("errores", e.getCause());
		}

		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public void bajarAdjuntoProveedor(HttpServletRequest request, HttpServletResponse response) {
		DtoAdjunto dtoAdjunto = new DtoAdjunto();

		dtoAdjunto.setId(Long.parseLong(request.getParameter("id")));
		dtoAdjunto.setNombre(request.getParameter("nombreDocumento"));
		
		FileItem fileItem = proveedoresApi.getFileItemAdjunto(dtoAdjunto);

		try {
			ServletOutputStream salida = response.getOutputStream();

			response.setHeader("Content-disposition", "attachment; filename=" + fileItem.getFileName());
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

		} catch (FileException e) {
			logger.error("Error en ProveedoresController", e);
		} catch (IOException e) {
			logger.error("Error en ProveedoresController", e);
		}
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createProveedor(DtoProveedorFilter dtoProveedorFilter, ModelMap model) {
		try {
			boolean success = proveedoresApi.createProveedor(dtoProveedorFilter);
			model.put("success", success);

		} catch (Exception e) {
			if (e.getMessage().equals(ProveedoresManager.PROVEEDOR_EXISTS_EXCEPTION_CODE)) {
				model.put("msg", ProveedoresManager.PROVEEDOR_EXISTS_EXCEPTION_MESSAGE);
				model.put("success", false);
			} else {
				logger.error("Error en ProveedoresController", e);
				model.put("success", false);
			}
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getMediadorListFiltered(DtoMediador dto, ModelMap model) {
		try {
			model.put("data", proveedoresApi.getMediadorListFiltered(dto));
			model.put("success", true);
		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getIdProveedorByNif(HttpServletRequest request, ModelMap model) {
		try {
			model.put("id", proveedoresApi.getIdProveedorByNif(request.getParameter("nifProveedor")).toString());
			model.put("codigo", proveedoresApi.getCodigoProveedorByNif(request.getParameter("nifProveedor")).toString());
			model.put("success", true);
		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getMediadoresEvaluar(DtoMediadorEvaluaFilter dtoMediadorEvaluarFilter, WebDto webDto, ModelMap model) {
		try {
			Page resultPage = proveedoresApi.getMediadoresEvaluar(dtoMediadorEvaluarFilter);
			model.put("data", resultPage.getResults());

			if (!Checks.esNulo(resultPage)) {
				model.put("totalCount", resultPage.getTotalCount());
			} else {
				model.put("totalCount", 0);
			}
			model.put("success", true);
		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getStatsCarteraMediadores(DtoMediadorStats dtoMediadorStats, ModelMap model) {
		try {
			// La obtención de datos solo se hace si se pasa 1 mediador.
			if (!Checks.esNulo(dtoMediadorStats.getId())) {
				Page resultPage = proveedoresApi.getStatsCarteraMediadores(dtoMediadorStats);
				model.put("data", resultPage.getResults());
				model.put("totalCount", resultPage.getTotalCount());

			} else {
				model.put("totalCount", 0);
			}

			model.put("success", true);

		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getOfertasCarteraMediadores(DtoMediadorOferta dtoMediadorOferta, ModelMap model) {
		try {
			// La obtención de datos solo se hace si se pasa 1 mediador.
			if (!Checks.esNulo(dtoMediadorOferta.getId())) {
				Page resultPage = proveedoresApi.getOfertasCarteraMediadores(dtoMediadorOferta);
				model.put("data", resultPage.getResults());
				model.put("totalCount", resultPage.getTotalCount());

			} else {
				model.put("totalCount", 0);
			}

			model.put("success", true);

		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateMediadoresEvaluar(DtoMediadorEvalua dtoMediadorEvalua, ModelMap model) {
		try {
			boolean success = proveedoresApi.updateMediadoresEvaluar(dtoMediadorEvalua);
			model.put("success", success);

		} catch (Exception e) {
			if (e.getMessage().equals(ProveedoresManager.USUARIO_NOT_EXISTS_EXCEPTION_CODE)) {
				model.put("msg", ProveedoresManager.USUARIO_NOT_EXISTS_EXCEPTION_MESSAGE);
				model.put("success", false);
			} else {
				logger.error("Error en ProveedoresController", e);
				model.put("success", false);
			}
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView setVigentesConPropuestas() {
		ModelMap model = new ModelMap();

		try {
			boolean success = proveedoresApi.setVigentesConPropuestas();
			model.put("success", success);

		} catch (Exception e) {
			model.put("msg", ProveedoresManager.ERROR_EVALUAR_MEDIADORES_MESSAGE);
			model.put("success", false);
			logger.error("Error en ProveedoresController", e);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView searchProveedorCodigo(@RequestParam String codigoUnicoProveedor) {
		ModelMap model = new ModelMap();

		try {
			model.put("data", proveedoresApi.searchProveedorCodigo(codigoUnicoProveedor));
			model.put("success", true);

		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView searchProveedorCodigoUvem(@RequestParam String codigoProveedorUvem) {
		ModelMap model = new ModelMap();

		try {
			model.put("data", proveedoresApi.searchProveedorCodigoUvem(codigoProveedorUvem));
			model.put("success", true);
		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getMediadoresActivos() {
		ModelMap model = new ModelMap();

		try {
			model.put("data", proveedoresApi.getMediadoresActivos());
			model.put("success", true);
		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
		}
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getConductasInapropiadasByProveedor(Long id, ModelMap model, HttpServletRequest request) {
		try {
			model.put(RESPONSE_DATA_KEY, proveedoresApi.getConductasInapropiadasByProveedor(id));
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, e.getMessage());
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveConductasInapropiadas(DtoConductasInapropiadas dto, ModelMap model, HttpServletRequest request) {
		try{
			boolean success = proveedoresApi.saveConductasInapropiadas(dto);
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, e.getMessage());
		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method= RequestMethod.GET)
	public ModelAndView getComboDelegacionesByProveedor(String id) {
		return createModelAndViewJson(new ModelMap(RESPONSE_DATA_KEY, proveedoresApi.getDelegacionesByProveedor(id)));	
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteConductasInapropiadas(String id, ModelMap model) {
		try {
			boolean success = proveedoresApi.deleteConductasInapropiadas(id);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView uploadConducta(HttpServletRequest request, HttpServletResponse response) {
		ModelMap model = new ModelMap();
		WebFileItem fileItem = new WebFileItem();

		try {
			fileItem = uploadAdapter.getWebFileItem(request);

			String errores = proveedoresApi.uploadConducta(fileItem);

			model.put("errores", errores);
			model.put("success", errores == null);
			
		} catch (GestorDocumentalException ex) {
			logger.error("Error en ProveedoresController sobre el Gestor Documental", ex);
			model.put("success", false);
			if (ex.getMessage().contains("An item with the name '"+fileItem.getFileItem().getFileName()+"' already exists") || ex.getMessage().contains("Ya existe un elemento con el nombre")) {
				model.put("errorMessage", ProveedoresManager.ERROR_NOMBRE_DOCUMENTO_PROVEEDOR+": "+fileItem.getFileItem().getFileName());
			} else if (ex.getMessage().contains("Control duplicado, ya existe un documento igual")) {
			   	DDTipoDocumentoProveedor tipoDocumentoProveedor = genericDao.get(DDTipoDocumentoProveedor.class, 
			   			genericDao.createFilter(FilterType.EQUALS, "codigo", fileItem.getParameter("tipo")), 
			   			genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
				model.put("errorMessage", ProveedoresManager.ERROR_TIPO_UNICO_DOCUMENTO_PROVEEDOR+": "+tipoDocumentoProveedor.getDescripcion());
			} else {
				model.put("errorMessage", "Ha habido un problema con la subida del archivo al gestor documental.");
			}
		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			if (ProveedoresManager.ERROR_TIPO_DOCUMENTO_PROVEEDOR.equals(e.getMessage())) {
				model.put("errorMessage", ProveedoresManager.ERROR_TIPO_DOCUMENTO_PROVEEDOR);
			}
			model.put("success", false);
			model.put("errores", e.getCause());
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDatosContactoById(Long id, ModelMap model, HttpServletRequest request) {
		model.put("data", proveedoresApi.getDatosContactoById(id));
		model.put("success", true);
		trustMe.registrarSuceso(request, id, ENTIDAD_CODIGO.CODIGO_PROVEEDOR, "datos", ACCION_CODIGO.CODIGO_VER);

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDatosContactoById(DtoDatosContacto dto, ModelMap model, HttpServletRequest request) {
		try{
			boolean success = proveedoresApi.saveDatosContactoById(dto);
			model.put("success", success);

		} catch (JsonViewerException jvex) {
			model.put("success", false);
			model.put("msg", jvex.getMessage());
			logger.warn("Excepción controlada en ProveedoresController", jvex);

		} catch (Exception e) {
			logger.error("Error en ProveedoresController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboMunicipioMultiple(String codigoProvincia){
		return createModelAndViewJson(new ModelMap("data", proveedoresApi.getComboMunicipioMultiple(codigoProvincia)));
	}
}
