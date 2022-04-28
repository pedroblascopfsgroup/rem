package es.pfsgroup.plugin.rem.controller;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.nio.charset.Charset;
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
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.restclient.caixabc.CaixaBcRestClient;
import org.apache.commons.beanutils.BeanUtils;
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
import es.capgemini.devon.exception.UserException;
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
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdjuntosAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.excel.AgrupacionExcelReport;
import es.pfsgroup.plugin.rem.excel.AgrupacionListadoActivosExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.utils.EmptyParamDetector;

@Controller
public class AgrupacionController extends ParadiseJsonController {

	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_MESSAGE_KEY = "msg";
	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_TOTALCOUNT_KEY = "totalCount";	
	
	public static final String ERROR_AGRUPACION_NOT_EXISTS = "No existe la agrupación que esta buscando, pruebe con otro Nº de Agrupación";
	public static final String ERROR_AGRUPACION_NO_NUMERICA = "El campo introducido es de carácter numérico";
	public static final String ERROR_GENERICO = "La operación no se ha podido realizar";
	 

	
	@Autowired
	private AgrupacionAdapter adapter;

	@Autowired
	private UploadAdapter uploadAdapter;

	@Autowired
	private ActivoAgrupacionApi activoAgrupacionApi;

	@Autowired
	private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;

	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;

	@Autowired
	private AgrupacionAdjuntosAdapter agrupacionAdjuntos;

	@Autowired
	private UsuarioManager usuarioManager;

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ConfigManager configManager;

	@Autowired
	private CaixaBcRestClient caixaBcRestClient;

	@Resource
	private Properties appProperties;

	/**
	 * Método que recupera una Agrupación según su id y lo mapea a un DTO
	 * 
	 * @param id
	 *            Id del activo
	 * @param pestana
	 *            Pestaña de la agrupación a cargar. Dependiendo de la pestaña
	 *            recibida, cargará un DTO u otro
	 * @param model
	 * @return
	 */
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getAgrupacionById(Long id, int pestana, ModelMap model, HttpServletRequest request) {

		model.put("data", adapter.getAgrupacionById(id));
	
		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getAgrupacionBynumAgrupRem(Long numAgrupRem, ModelMap model) {

		Long idAgrupacion= adapter.getAgrupacionIdByNumAgrupRem(numAgrupRem);
		
		model.put("data", idAgrupacion);

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListActivosAgrupacionById(DtoAgrupacionFilter filtro, Long id, ModelMap model, HttpServletRequest request) {

		Page page = adapter.getListActivosAgrupacionById(filtro, id,false);
		if(!Checks.esNulo(page)) {
			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);
		} else {
			model.put("success", false);
		}
		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getBusquedaAgrupacionesGrid(DtoAgrupacionGridFilter dto, ModelMap model) {
		try {
			Page page = adapter.getBusquedaAgrupacionesGrid(dto);
			model.put(RESPONSE_DATA_KEY, page.getResults());
			model.put(RESPONSE_TOTALCOUNT_KEY, page.getTotalCount());
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en AgrupacionController::getBusquedaAgrupacionesGrid", e);
		}
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAgrupaciones(DtoAgrupacionFilter dtoAgrupacionFilter, ModelMap model) {

		Page page = adapter.getListAgrupaciones(dtoAgrupacionFilter);
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createActivoAgrupacion(@RequestParam Long idEntidad, @RequestParam Long numActivo,
			@RequestParam(required = false) Integer activoPrincipal, ModelMap model) {

		try {
			adapter.createActivoAgrupacion(numActivo, idEntidad, activoPrincipal,false);
			model.put("success", true);

		} catch (JsonViewerException jvex) {
			model.put("success", false);
			model.put("msg", jvex.getMessage());
		} catch (Exception e) {
			logger.error("error anyadiendo activo a agrupación",e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView marcarPrincipal(@RequestParam Long idAgrupacion, @RequestParam Long idActivo, ModelMap model) {

		try {
			boolean success = adapter.marcarPrincipal(idAgrupacion, idActivo);
			model.put("success", success);

		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteOneActivoAgrupacionActivo(@RequestParam Long agrId, @RequestParam Long activoId, ModelMap model) {

		try {
			boolean success = adapter.deleteOneActivoAgrupacionActivo(agrId, activoId);
			model.put("success", success);

		} catch (JsonViewerException jvex) {
			model.put("success", false);
			model.put("msg", jvex.getMessage());
		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteActivoAgrupacion(@RequestParam Long id, ModelMap model) {

		try {
			boolean success = adapter.deleteActivoAgrupacion(id);
			model.put("success", success);

		} catch (JsonViewerException jvex) {
			logger.error("error agrupaciones controller ", jvex);
			model.put("success", false);
			model.put("msg", jvex.getMessage());
		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteActivosAgrupacion(@RequestParam Long[] id, ModelMap model) {

		try {
			boolean success = adapter.deleteActivosAgrupacion(id);
			model.put("success", success);

		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteAllActivosAgrupacion(@RequestParam Long id, ModelMap model) {

		try {
			boolean success = adapter.deleteAllActivosAgrupacion(id);
			model.put("success", success);

		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createAgrupacion(DtoAgrupacionesCreateDelete dtoAgrupacion, ModelMap model) {

		try {
			DtoAgrupacionesCreateDelete agrupDto = adapter.createAgrupacion(dtoAgrupacion);
			model.put("data", agrupDto);
			model.put("success", true);

		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteAgrupacionById(DtoAgrupacionesCreateDelete dtoAgrupacion, ModelMap model) {

		try {
			boolean success = adapter.deleteAgrupacionById(dtoAgrupacion);
			model.put("success", success);

		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteAgrupacionesById(Long id, ModelMap model) {
		try {
			model.put(RESPONSE_SUCCESS_KEY, adapter.deleteAgrupacionesById(id));
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en AgrupacionController::deleteAgrupacionesById", e);
		}
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createAgrupacionesGrid(DtoAgrupacionesCreateDelete dto, ModelMap model) {
		try {			
			model.put(RESPONSE_DATA_KEY, adapter.createAgrupacionesGrid(dto));
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			logger.error(e);
			model.put(RESPONSE_SUCCESS_KEY, false);
		}
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListObservacionesAgrupacionById(Long id, ModelMap model, HttpServletRequest request) {

		model.put("data", adapter.getListObservacionesAgrupacionById(id));

		return createModelAndViewJson(model);

	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListVisitasAgrupacionById(Long id, ModelMap model, HttpServletRequest request) {

		model.put("data", adapter.getListVisitasAgrupacionById(id));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListOfertasAgrupacion(Long id, WebDto webDto, ModelMap model, HttpServletRequest request) {

		model.put("data", adapter.getListOfertasAgrupacion(id));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getAvisosAgrupacionById(Long id, ModelMap model) {

		model.put("data", adapter.getAvisosAgrupacionById(id));

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView procesarMasivo(Long idProcess, Long idOperation, ModelMap model) {

		Boolean result = false;
		try {
			result =  adapter.procesarMasivo(idProcess, idOperation);
		} catch (Exception e) {
			logger.error("error procesando masivo",e);
		}

		model.put("data",result);
		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveAgrupacion(DtoAgrupaciones dtoAgrupacion, @RequestParam Long id, ModelMap model, HttpServletRequest request)
	{
		try
		{
			String success = adapter.saveAgrupacion(dtoAgrupacion, id);
			if(success.contains(AgrupacionAdapter.SPLIT_VALUE))
			{
				String[] response = success.split(AgrupacionAdapter.SPLIT_VALUE);
				if(response.length == 2)
				{
					model.put("success", response[0]);
					model.put("msgError", response[1]);
				}
			}
			else
			{
				model.put("success", success);
			}

		} catch (JsonViewerException jvex) {
			logger.error(jvex);
			model.put("success", false);
			model.put("msgError", jvex.getMessage());
		} catch (Exception e) {
			logger.error("error guardando agrupacion!",e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveObservacionesAgrupacion(DtoObservacion dtoObservacion, Long idAgrupacion, ModelMap model) {

		try {
			boolean success = adapter.saveObservacionesAgrupacion(dtoObservacion, idAgrupacion);
			model.put("success", success);

		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	/**
	 * 
	 * @param dtoObservacion
	 * @param id
	 *            En corresponde con el id de la Agrupacion
	 * @param model
	 * @return
	 */
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createObservacionesAgrupacion(DtoObservacion dtoObservacion, Long idEntidad, ModelMap model) {

		try {
			boolean success = adapter.createObservacionesAgrupacion(dtoObservacion, idEntidad);
			model.put("success", success);

		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteObservacionesAgrupacion(@RequestParam Long id, ModelMap model) {

		try {
			boolean success = adapter.deleteObservacionAgrupacion(id);
			model.put("success", success);

		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	@Transactional(readOnly = false)
	public ModelAndView getFotosAgrupacionById(Long id, String tipoFoto, WebDto webDto, ModelMap model, HttpServletRequest request) {

		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		List<DtoFoto> listaDtoFotos = new ArrayList<DtoFoto>();

		if (agrupacion.getTipoAgrupacion() != null
				&& (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA)
						|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_ASISTIDA) 
						|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER))) {

			List<ActivoFoto> listaFotos = activoAgrupacionApi.getFotosAgrupacionById(id);

			if (listaFotos != null) {

				for (int i = 0; i < listaFotos.size(); i++) {

					if (listaFotos.get(i).getTipoFoto() == null || (listaFotos.get(i).getTipoFoto() != null && listaFotos.get(i).getTipoFoto().getCodigo().equals(tipoFoto))) {
						
						try {
	
							DtoFoto fotoDto = new DtoFoto();
	
							if (listaFotos.get(i).getRemoteId() != null) {
								BeanUtils.copyProperty(fotoDto, "path", listaFotos.get(i).getUrlThumbnail());
							} else {
								BeanUtils.copyProperty(fotoDto, "path",
										"/pfs/activo/getFotoActivoById.htm?idFoto=" + listaFotos.get(i).getId());
							}
	
							BeanUtils.copyProperties(fotoDto, listaFotos.get(i));
							
							BeanUtils.copyProperty(fotoDto, "codigoSubtipoActivo", DDSubtipoActivo.CODIGO_EN_CONSTRUCCION);
							
							if(listaFotos.get(i).getDescripcionFoto() != null) {
								BeanUtils.copyProperty(fotoDto, "codigoDescripcionFoto", listaFotos.get(i).getDescripcionFoto().getCodigo());
								BeanUtils.copyProperty(fotoDto, "descripcion", listaFotos.get(i).getDescripcionFoto().getDescripcion());
								if (listaFotos.get(i).getDescripcionFoto().getSubtipo() != null) {
									BeanUtils.copyProperty(fotoDto, "codigoSubtipoActivo", listaFotos.get(i).getDescripcionFoto().getSubtipo().getCodigo());
								}
							}
							
							if(listaFotos.get(i).getActivo() != null && listaFotos.get(i).getActivo().getNumActivo() != null) {
								BeanUtils.copyProperty(fotoDto, "numeroActivo", listaFotos.get(i).getActivo().getNumActivo());
							}
	
							listaDtoFotos.add(fotoDto);
	
						} catch (IllegalAccessException e) {
							logger.error(e);
						} catch (InvocationTargetException e) {
							logger.error(e);
						}
					}

				}

			}

		} else {

			List<ActivoFoto> listaFotos = adapter.getFotosActivosAgrupacionById(id);

			if (listaFotos != null) {

				for (int i = 0; i < listaFotos.size(); i++) {

					try {

						DtoFoto fotoDto = new DtoFoto();
						if (listaFotos.get(i).getRemoteId() != null) {
							BeanUtils.copyProperty(fotoDto, "path", listaFotos.get(i).getUrlThumbnail());
						} else {
							BeanUtils.copyProperty(fotoDto, "path",
									"/pfs/activo/getFotoActivoById.htm?idFoto=" + listaFotos.get(i).getId());
						}
						BeanUtils.copyProperties(fotoDto, listaFotos.get(i));
						BeanUtils.copyProperty(fotoDto, "numeroActivo", listaFotos.get(i).getActivo().getId());
						
						BeanUtils.copyProperty(fotoDto, "codigoSubtipoActivo", DDSubtipoActivo.CODIGO_EN_CONSTRUCCION);
						
						if(listaFotos.get(i).getDescripcionFoto() != null) {
							BeanUtils.copyProperty(fotoDto, "codigoDescripcionFoto", listaFotos.get(i).getDescripcionFoto().getCodigo());
							BeanUtils.copyProperty(fotoDto, "descripcion", listaFotos.get(i).getDescripcionFoto().getDescripcion());
							if (listaFotos.get(i).getDescripcionFoto().getSubtipo() != null) {
								BeanUtils.copyProperty(fotoDto, "codigoSubtipoActivo", listaFotos.get(i).getDescripcionFoto().getSubtipo().getCodigo());
							}
						}

						listaDtoFotos.add(fotoDto);

					} catch (IllegalAccessException e) {
						logger.error(e);
					} catch (InvocationTargetException e) {
						logger.error(e);
					}

				}

			}

		}

		model.put("data", listaDtoFotos);

		return new ModelAndView("jsonView", model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	@Transactional(readOnly = false)
	public ModelAndView getFotosSubdivisionById(DtoSubdivisiones subdivision, ModelMap model, HttpServletRequest request) {

		List<DtoFoto> listaDtoFotos = new ArrayList<DtoFoto>();
		List<ActivoFoto> listaFotos = activoAgrupacionApi.getFotosSubdivision(subdivision);

		if (listaFotos != null) {

			for (int i = 0; i < listaFotos.size(); i++) {

				try {

					DtoFoto fotoDto = new DtoFoto();

					BeanUtils.copyProperty(fotoDto, "id", listaFotos.get(i).getId());

					BeanUtils.copyProperties(fotoDto, listaFotos.get(i));
					if (listaFotos.get(i).getRemoteId() != null) {
						BeanUtils.copyProperty(fotoDto, "path", listaFotos.get(i).getUrlThumbnail());
					} else {
						BeanUtils.copyProperty(fotoDto, "path", "/pfs/activo/getFotoActivoById.htm?idFoto=" + listaFotos.get(i).getId());
					}
					if (listaFotos.get(i).getPrincipal() != null && listaFotos.get(i).getPrincipal() && listaFotos.get(i).getInteriorExterior() != null) {
						if (listaFotos.get(i).getInteriorExterior()) {
							BeanUtils.copyProperty(fotoDto, "tituloFoto", "Principal INTERIOR");

						} else {
							BeanUtils.copyProperty(fotoDto, "tituloFoto", "Principal EXTERIOR");
						}
					}
					
					if (subdivision.getCodigoSubtipoActivo() != null) {
						BeanUtils.copyProperty(fotoDto, "codigoSubtipoActivo", subdivision.getCodigoSubtipoActivo());
					}
					
					if(listaFotos.get(i).getDescripcionFoto() != null) {
						BeanUtils.copyProperty(fotoDto, "codigoDescripcionFoto", listaFotos.get(i).getDescripcionFoto().getCodigo());
						BeanUtils.copyProperty(fotoDto, "descripcion", listaFotos.get(i).getDescripcionFoto().getDescripcion());
						if (listaFotos.get(i).getDescripcionFoto().getSubtipo() != null) {
							BeanUtils.copyProperty(fotoDto, "codigoSubtipoActivo", listaFotos.get(i).getDescripcionFoto().getSubtipo().getCodigo());
						}
					}
					
					if (!Checks.esNulo(listaFotos.get(i).getTipoFoto())) {
						fotoDto.setCodigoTipoFoto(listaFotos.get(i).getTipoFoto().getCodigo());
					}

					listaDtoFotos.add(fotoDto);

				} catch (IllegalAccessException e) {
					logger.error(e);
				} catch (InvocationTargetException e) {
					logger.error(e);
				}

			}

		}

		model.put("data", listaDtoFotos);

		return createModelAndViewJson(model);
	}

	/**
	 * Recibe y guarda una foto
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView uploadFotos(HttpServletRequest request, HttpServletResponse response){

		ModelMap model = new ModelMap();
		WebFileItem webFileItem = new WebFileItem();

		try {
			List<WebFileItem> webFileItemList = uploadAdapter.getWebMultipleFileItem(request);

			String errores = activoAgrupacionApi.uploadFotos(webFileItemList);

			model.put("errores", errores);
			model.put("success", errores != null);

		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
			model.put("errores", e.getCause());
		}
		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView uploadFotosSubdivision(HttpServletRequest request, HttpServletResponse response){

		ModelMap model = new ModelMap();

		try {
			List<WebFileItem> webFileItemList = uploadAdapter.getWebMultipleFileItem(request);

			String errores = activoAgrupacionApi.uploadFotosSubdivision(webFileItemList);

			model.put("errores", errores);
			model.put("success", errores != null);

		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
			model.put("errores", e.getCause());
		}
		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListSubdivisionesAgrupacionById(DtoAgrupacionFilter agrupacionFilter, ModelMap model, HttpServletRequest request) {

		Page page = activoAgrupacionApi.getListSubdivisionesAgrupacionById(agrupacionFilter);

		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListActivosSubdivisionById(DtoSubdivisiones subdivisionFilter, ModelMap model, HttpServletRequest request) {

		Page page = activoAgrupacionApi.getListActivosSubdivisionById(subdivisionFilter);

		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());

		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public void generateExcel(DtoAgrupacionGridFilter dto, HttpServletRequest request, HttpServletResponse response) throws Exception {
		dto.setStart(excelReportGeneratorApi.getStart());
		dto.setLimit(excelReportGeneratorApi.getLimit());
		List<VGridBusquedaAgrupaciones> listaAgrupaciones = (List<VGridBusquedaAgrupaciones>) adapter.getBusquedaAgrupacionesGrid(dto).getResults();		
		new EmptyParamDetector().isEmpty(listaAgrupaciones.size(), "agrupaciones",  usuarioManager.getUsuarioLogado().getUsername());
		ExcelReport report = new AgrupacionExcelReport(listaAgrupaciones);
		excelReportGeneratorApi.generateAndSend(report, response);
	}	
	
	@RequestMapping(method = RequestMethod.POST)
	@Transactional()
	public ModelAndView registrarExportacion(DtoAgrupacionGridFilter dto, Boolean exportar, HttpServletRequest request, HttpServletResponse response) throws Exception {
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
				int count = adapter.getBusquedaAgrupacionesGrid(dto).getTotalCount();
				AuditoriaExportaciones ae = new AuditoriaExportaciones();
				ae.setBuscador("agrupaciones");
				ae.setFechaExportacion(new Date());
				ae.setNumRegistros(Long.valueOf(count));
				ae.setUsuario(user);
				ae.setFiltros(filtros);
				ae.setAccion(exportar);
				genericDao.save(AuditoriaExportaciones.class, ae);
				model.put(RESPONSE_SUCCESS_KEY, true);
				model.put(RESPONSE_DATA_KEY, count);
				for(Perfil pef : user.getPerfiles()) {
					if(pef.getCodigo().equals("SUPEREXPORTACTAGR")) {
						isSuperExport = true;
						break;
					}
				}
				if(isSuperExport) {
					model.put("limite", configManager.getConfigByKey("super.limite.exportar.excel.activos").getValor());
					model.put("limiteMax", configManager.getConfigByKey("super.limite.maximo.exportar.excel.activos").getValor());
				}else {
					model.put("limite", configManager.getConfigByKey("limite.exportar.excel.activos").getValor());
					model.put("limiteMax", configManager.getConfigByKey("limite.maximo.exportar.excel.activos").getValor());
				}
			} else {
				model.put("msg",cuentaAtras);
			}
		}catch(Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en agrupacionController", e);
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

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createOferta(DtoOfertasFilter dtoOferta, ModelMap model) throws Exception {
		try {
			Oferta oferta = adapter.createOfertaAgrupacion(dtoOferta);
			boolean success = oferta != null;

			model.put("success", success);
		} catch (JsonViewerException jvex) {
			model.put("msg", jvex.getMessage());
			model.put("success", false);
		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}
		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getGestoresLoteComercial(@RequestParam Long agrId, @RequestParam String codigoGestor,
			ModelMap model) {

		try {
			if (GestorActivoApi.CODIGO_GESTOR_COMERCIAL_BACKOFFICE_INMOBILIARIO.equals(codigoGestor)) {
				model.put("data", adapter.getUsuariosPorCodTipoGestor(codigoGestor, agrId));
			} else {
				model.put("data", adapter.getUsuariosPorCodTipoGestor(codigoGestor));
			}
			model.put("success", true);
		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getGestoresLoteComercialPorTipo(@RequestParam Long agrId, ModelMap model) {

		try {
			model.put("data", adapter.getUsuariosPorCodTipoGestor(agrId));
			model.put("success", true);
		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDobleGestorActivo(@RequestParam Long agrId, @RequestParam String codigoGestorEdi,@RequestParam String codigoGestorSu,
			ModelMap model) {

		try {
			model.put("data", adapter.getUsuariosPorDobleCodTipoGestor(codigoGestorEdi,codigoGestorSu));
			model.put("success", true);
		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getUsuariosPorTipoGestorYCarteraDelLoteComercial(@RequestParam Long agrId, @RequestParam String codigoGestor,
			ModelMap model) {

		try {
			model.put("data", adapter.getUsuariosPorTipoGestorYCarteraDelLoteComercial(agrId, codigoGestor));
			model.put("success", true);
		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public void exportarActivosLoteComercial(Long agrID, DtoAgrupacionFilter dtoAgrupacionFilter,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		dtoAgrupacionFilter.setStart(excelReportGeneratorApi.getStart());
		dtoAgrupacionFilter.setLimit(excelReportGeneratorApi.getLimit());

		List<VActivosAgrupacion> listaActivosPorAgrupacion = (List<VActivosAgrupacion>) adapter
				.getListActivosAgrupacionById(dtoAgrupacionFilter, agrID,false).getResults();

		DtoAgrupaciones agruDto = adapter.getAgrupacionById(agrID);

		ExcelReport report = new AgrupacionListadoActivosExcelReport(listaActivosPorAgrupacion,agruDto);

		excelReportGeneratorApi.generateAndSend(report, response);
	}
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView reactivar(DtoAgrupacionesActivo agrupacion, ModelMap model) {

		try {
			if (agrupacion != null && agrupacion.getIdAgrupacion() != null
					&& agrupacion.getFechaInicioVigencia() != null && agrupacion.getFechaFinVigencia() != null) {
				DtoAgrupaciones agr = new DtoAgrupaciones();
				agr.setFechaInicioVigencia(agrupacion.getFechaInicioVigencia());
				agr.setFechaFinVigencia(agrupacion.getFechaFinVigencia());
				agr.setAgrupacionEliminada(false);
				// validamos el periodo de vigencia
				int validacionVigencia = adapter.validateVigencia(agr, Long.valueOf(agrupacion.getIdAgrupacion()));
				if (validacionVigencia == 0) {
					// guardamos los datos de vigencia
					adapter.saveAgrupacion(agr, Long.valueOf(agrupacion.getIdAgrupacion()));
				} else {
					model.put("success", true);
					switch (validacionVigencia) {
					case 2:
						model.put("errorCode", "reactivar.error.desc.fecha.fin.mayor.fecha.inicio");
						break;
					case 3:
						model.put("errorCode", "reactivar.error.desc.fecha.inicio.mayor.anterior");
						break;
					case 4:
						model.put("errorCode", "reactivar.error.desc.activo.otra.agrupacion.vigente");
						break;
					default:
						break;
					}

				}

				
			} else {
				logger.error("Parametros incorrectos al reactivar agrupacion");
				model.put("success", false);
			}

		} catch (Exception e) {
			logger.error("error reactivando la agrupación ", e);
			model.put("success", false);
		}
		model.put("data", agrupacion);

		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoVigencias(DtoVigenciaAgrupacion agrupacionFilter, ModelMap model, HttpServletRequest request) {

		try{
			List<AgrupacionesVigencias> vigencias = activoAgrupacionApi.getHistoricoVigenciaAgrupaciones(agrupacionFilter);
			List<DtoVigenciaAgrupacion> dtoVigenciasList = new ArrayList<DtoVigenciaAgrupacion>();
			if(vigencias != null){
				for(AgrupacionesVigencias vigencia : vigencias){
					DtoVigenciaAgrupacion dtoAux = new DtoVigenciaAgrupacion();
					dtoAux.setAgrId(vigencia.getId());
					dtoAux.setFechaInicioVigencia(vigencia.getFechaInicio());
					dtoAux.setFechaFinVigencia(vigencia.getFechaFin());
					dtoAux.setUsuarioModificacion(vigencia.getAuditoria().getUsuarioCrear());
					dtoAux.setFechaCrear(vigencia.getAuditoria().getFechaCrear());
					dtoVigenciasList.add(dtoAux);
				}
			}

			model.put("data", dtoVigenciasList);
			model.put("success", true);
		}catch(Exception e){
			logger.error("error obteniendo vigencias agrupacion ", e);
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView permiteEliminarAgrupacion(Long numAgrupacionRem, ModelMap model) {

		try {
			model.put("data", adapter.permiteEliminarAgrupacion(numAgrupacionRem));
			model.put("success", true);
		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDatosPublicacionAgrupacion(Long id, ModelMap model) {
		model.put("data", adapter.getDatosPublicacionAgrupacion(id));
		model.put("success", true);

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView setDatosPublicacionAgrupacion(Long id, DtoDatosPublicacionAgrupacion dto, ModelMap model) {
		try {
			model.put("success", activoEstadoPublicacionApi.setDatosPublicacionAgrupacion(id, dto));
		} catch (JsonViewerException e) {
				model.put("msg", e.getMessage());
				model.put("success", false);
				logger.error("Error al guardar los datos de publicacion de la agrupacion", e);
		}

		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCondicionEspecificaByAgrupacion(Long id, ModelMap model) {

		model.put("data", activoAgrupacionApi.getCondicionEspecificaByAgrupacion(id));
		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createCondicionEspecifica(DtoCondicionEspecificaAgrupacion dto, ModelMap model) {

		model.put("data", activoAgrupacionApi.createCondicionEspecifica(dto));
		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveCondicionEspecifica(DtoCondicionEspecificaAgrupacion dto, ModelMap model) {

		model.put("data", activoAgrupacionApi.saveCondicionEspecifica(dto));
		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView darDeBajaCondicionEspecifica(DtoCondicionEspecificaAgrupacion dto, ModelMap model) {

		model.put("data", activoAgrupacionApi.darDeBajaCondicionEspecifica(dto));
		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipoAgrupacion(ModelMap model) {

		try {
			List <DtoTipoAgrupacion> dto= activoAgrupacionApi.getComboTipoAgrupacion();

			model.put("data", dto);
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboTipoAgrupacionFiltro(ModelMap model) {
		try {
			model.put(RESPONSE_DATA_KEY, activoAgrupacionApi.getComboTipoAgrupacionFiltro());
			model.put(RESPONSE_SUCCESS_KEY, true);
		} catch (Exception e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			logger.error("error en AgrupacionController::getComboTipoAgrupacionFiltro", e);
		}		
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView refreshCacheFotos(@RequestParam Long id, ModelMap model) {
		try {
			boolean success = adapter.deleteCacheFotosAgr(id);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
			model.put("error",e.getMessage());
		}

		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView insertarActAutoTram(DtoAgrupaciones dto, Long id, ModelMap model, HttpServletRequest request) {
		try {
			model.put("success", activoAgrupacionApi.insertarActAutoTram(dto, id));

		} catch (Exception e) {
			logger.error("error en agrupacionController", e);
			model.put("success", false);
			model.put("errorCode", "msg.operacion.ko");
		}

		return new ModelAndView("jsonView", model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComercialAgrupacionById(Long id, int pestana, ModelMap model, HttpServletRequest request) {

		model.put("data", adapter.getComercialAgrupacionById(id));
		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveComercialAgrupacion(DtoAgrupaciones dtoAgrupacion, @RequestParam Long id, ModelMap model, HttpServletRequest request)
	{
		boolean success = true;
		model.put("success", success);
		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntosAgrupacion(Long idAgrupacion, ModelMap model) {

		try {
			model.put("data", agrupacionAdjuntos.getAdjuntosAgrupacion(idAgrupacion));
		} catch (GestorDocumentalException e) {
			logger.error("error en agrupacioncontroller", e);
			model.put("success", false);
			model.put("errorMessage",
					"Gestor documental: No existe la agrupacion o no tiene permisos para listar el contenedor");
		} catch (Exception e) {
			logger.error("error en agrupacioncontroller", e);
			model.put("success", false);
			model.put("errorMessage", e.getMessage());
		}

		return createModelAndViewJson(model);

	}
	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView upload(HttpServletRequest request) {

		ModelMap model = new ModelMap();
		
		try {
			WebFileItem webFileItem = uploadAdapter.getWebFileItem(request);
			
			agrupacionAdjuntos.uploadDocumento(webFileItem);
			model.put("success", true);
		} catch (GestorDocumentalException e) {
			logger.error("error en agrupacion", e);
			model.put("success", false);
			model.put("errorMessage", "Gestor documental: No existe la agrupacion o no tiene permiso para subir el documento");
		} catch (Exception e) {
			logger.error("error en agrupacionController", e);
			model.put("success", false);
			model.put("errorMessage",e.getMessage());
		}
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public void bajarAdjuntoAgrupacion(HttpServletRequest request, HttpServletResponse response) {
		ServletOutputStream salida = null;
		Long id = null;
		try {
			id = Long.parseLong(request.getParameter("id"));
			String nombreDocumento = request.getParameter("nombreDocumento");
			salida = response.getOutputStream();
			FileItem fileItem = agrupacionAdjuntos.download(id,nombreDocumento);
			response.setHeader("Content-disposition", "attachment; filename=" + fileItem.getFileName());
			response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
			response.setHeader("Cache-Control", "max-age=0");
			response.setHeader("Expires", "0");
			response.setHeader("Pragma", "public");
			response.setDateHeader("Expires", 0); // prevents caching at the
													// proxy
			if(!Checks.esNulo(fileItem.getContentType())) {
				response.setContentType(fileItem.getContentType());
			}
			
			// Write
			FileUtils.copy(fileItem.getInputStream(), salida);
			
		}catch(UserException ex) {
			try {
				salida.write(ex.toString().getBytes(Charset.forName("UTF-8")));
			} catch (IOException e) {
				e.printStackTrace();
			}
	
		} catch (Exception e) {
			logger.error("error en agrupacionController", e);
		}finally {
			try {
				salida.flush();			
				salida.close();
			} catch (IOException e) {
				logger.error("error agrupaciones controller ", e);
			}
		}
	
	}
	
	
	@RequestMapping(method= RequestMethod.POST)
	public ModelAndView deleteAdjunto(DtoAdjunto dtoAdjunto) {
		ModelMap model = new ModelMap();
		try {
			agrupacionAdjuntos.deleteAdjunto(dtoAdjunto);
			model.put("success", true);
		}catch (Exception e) {
			logger.error("error en agrupacionController", e);
			model.put("success", false);
			model.put("errorMessage",e.getMessage());
		}
		return createModelAndViewJson(model);
	}
	
	
	@RequestMapping(method= RequestMethod.GET)
	public ModelAndView getListAdjuntosAgrupacionByIdActivo(Long id) {
		ModelMap model = new ModelMap();
		try {
			Long idAgrupacion = agrupacionAdjuntos.getAgrupacionYubaiByIdActivo(id);
			if (Checks.esNulo(idAgrupacion)) throw new Exception();
			model.put("data", agrupacionAdjuntos.getAdjuntosAgrupacion(idAgrupacion));
			model.put("success", true);
		}catch (Exception e) {
			logger.error("error en agrupacionController", e);
			model.put("success", false);
			model.put("errorMessage",e.getMessage());
		}
		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView clonateOferta(String idOferta, ModelMap model) {
		try {
			boolean success = !Checks.esNulo(adapter.clonateOfertaAgrupacion(idOferta));
			model.put(RESPONSE_SUCCESS_KEY, success);

		} catch (Exception e) {
			if (e.getMessage().equals(ActivoAdapter.OFERTA_INCOMPATIBLE_MSG)) {
				model.put(RESPONSE_MESSAGE_KEY, ActivoAdapter.OFERTA_INCOMPATIBLE_MSG);
				model.put(RESPONSE_SUCCESS_KEY, false);
			} else {
				logger.error("error en activoController", e);
				model.put(RESPONSE_SUCCESS_KEY, false);
			}
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getAgrupacionExists(String numAgrupacion, ModelMap model) {

		try {
			Long idAgrupacion = activoAgrupacionApi.getIdByNumAgrupacion(Long.parseLong(numAgrupacion));
			
			if(!Checks.esNulo(idAgrupacion)) {
				model.put("success", true);
				model.put("data", idAgrupacion);
			}else {
				model.put("success", false);
				model.put("error", ERROR_AGRUPACION_NOT_EXISTS);
		}
		} catch (NumberFormatException e) {
			model.put("success", false);
			model.put("error", ERROR_AGRUPACION_NO_NUMERICA);
		} catch(Exception e) {
			logger.error("error obteniendo el activo ",e);
			model.put("success", false);
			model.put("error", ERROR_GENERICO);
		}
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView checkIdON(String numAgrupacion, ModelMap model) {

		try {
			model.put("success", activoAgrupacionApi.checkIdON(Long.parseLong(numAgrupacion)));
		} catch(Exception e) {
			logger.error("error obteniendo la agrupacion ",e);
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
	}
}