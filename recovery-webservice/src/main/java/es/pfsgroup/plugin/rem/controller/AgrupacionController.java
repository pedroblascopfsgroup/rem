package es.pfsgroup.plugin.rem.controller;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.excel.AgrupacionExcelReport;
import es.pfsgroup.plugin.rem.excel.AgrupacionListadoActivosExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.AgrupacionesVigencias;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.DtoAgrupaciones;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesActivo;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesCreateDelete;
import es.pfsgroup.plugin.rem.model.DtoCondicionEspecificaAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoDatosPublicacionActivo;
import es.pfsgroup.plugin.rem.model.DtoEstadoDisponibilidadComercial;
import es.pfsgroup.plugin.rem.model.DtoFoto;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoOfertaActivo;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.DtoSubdivisiones;
import es.pfsgroup.plugin.rem.model.DtoVigenciaAgrupacion;
import es.pfsgroup.plugin.rem.model.VActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.VBusquedaAgrupaciones;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

@Controller
public class AgrupacionController extends ParadiseJsonController {

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

	private final Log logger = LogFactory.getLog(getClass());

	/**
	 * Método para modificar la plantilla de JSON utilizada en el servlet.
	 * 
	 * @param request
	 * @param binder
	 * @throws Exception
	 */
	/*******************************************************
	 * NOTA FASE II : Se refactoriza en ParadiseJsonController.java
	 *******************************************************/
	/*
	 * @InitBinder protected void initBinder(HttpServletRequest request,
	 * ServletRequestDataBinder binder) throws Exception{
	 * 
	 * JsonWriterConfiguratorTemplateRegistry registry =
	 * JsonWriterConfiguratorTemplateRegistry.load(request);
	 * registry.registerConfiguratorTemplate( new
	 * SojoJsonWriterConfiguratorTemplate(){
	 * 
	 * @Override public SojoConfig getJsonConfig() { SojoConfig config= new
	 * SojoConfig(); config.setIgnoreNullValues(true); return config; } } );
	 * 
	 * SimpleDateFormat dateFormat = new
	 * SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss"); dateFormat.setLenient(false);
	 * dateFormat.setTimeZone(TimeZone.getDefault());
	 * //binder.registerCustomEditor(Date.class, new
	 * CustomDateEditor(dateFormat, true));
	 * binder.registerCustomEditor(Date.class, new
	 * ParadiseCustomDateEditor(dateFormat, true));
	 * 
	 * binder.registerCustomEditor(boolean.class, new
	 * CustomBooleanEditor("true", "false", true));
	 * binder.registerCustomEditor(Boolean.class, new
	 * CustomBooleanEditor("true", "false", true));
	 * binder.registerCustomEditor(String.class, new
	 * StringTrimmerEditor(false)); NumberFormat f =
	 * NumberFormat.getInstance(Locale.ENGLISH); f.setGroupingUsed(false);
	 * f.setMaximumFractionDigits(2); f.setMinimumFractionDigits(2);
	 * binder.registerCustomEditor(double.class, new
	 * CustomNumberEditor(Double.class, f, true));
	 * binder.registerCustomEditor(Double.class, new
	 * CustomNumberEditor(Double.class, f, true));
	 * 
	 * /*binder.registerCustomEditor(Float.class, new
	 * CustomNumberEditor(Float.class, true));
	 * binder.registerCustomEditor(Long.class, new
	 * CustomNumberEditor(Long.class, true));
	 * binder.registerCustomEditor(Integer.class, new
	 * CustomNumberEditor(Integer.class, true)); }
	 */

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
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getAgrupacionById(Long id, int pestana, ModelMap model) {

		model.put("data", adapter.getAgrupacionById(id));

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getAgrupacionBynumAgrupRem(Long numAgrupRem, ModelMap model) {

		Long idAgrupacion= adapter.getAgrupacionIdByNumAgrupRem(numAgrupRem);
		
		model.put("data", idAgrupacion);

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListActivosAgrupacionById(DtoAgrupacionFilter filtro, Long id, ModelMap model) {

		//TODO cambiar Page por el nuevo dto.
		DtoEstadoDisponibilidadComercial page = adapter.getListActivosAgrupacion(filtro, id);
		if(!Checks.esNulo(page)) {
			model.put("data", page.getListado());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);
		} else {
			model.put("success", false);
		}
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAgrupaciones(DtoAgrupacionFilter dtoAgrupacionFilter, ModelMap model) {

		Page page = adapter.getListAgrupaciones(dtoAgrupacionFilter);
		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());

		return createModelAndViewJson(model);
	}

	/*
	 * private ModelAndView createModelAndViewJson(ModelMap model) {
	 * 
	 * return new ModelAndView("jsonView", model); }
	 */

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createActivoAgrupacion(@RequestParam Long idEntidad, @RequestParam Long numActivo,
			@RequestParam(required = false) Integer activoPrincipal, ModelMap model) {

		try {
			adapter.createActivoAgrupacion(numActivo, idEntidad, activoPrincipal,false);
			model.put("success", true);

		} catch (JsonViewerException jvex) {
			model.put("success", false);
			model.put("msg", jvex.getMessage());
		}

		catch (Exception e) {
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
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

	@SuppressWarnings("unchecked")
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
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteActivoAgrupacion(@RequestParam Long id, ModelMap model) {

		try {
			boolean success = adapter.deleteActivoAgrupacion(id);
			model.put("success", success);

		} catch (JsonViewerException jvex) {
			jvex.printStackTrace();
			model.put("success", false);
			model.put("msg", jvex.getMessage());
		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
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

	@SuppressWarnings("unchecked")
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

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createAgrupacion(DtoAgrupacionesCreateDelete dtoAgrupacion, ModelMap model) {

		try {
			boolean success = adapter.createAgrupacion(dtoAgrupacion);
			model.put("success", success);

		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
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

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListObservacionesAgrupacionById(Long id, ModelMap model) {

		model.put("data", adapter.getListObservacionesAgrupacionById(id));

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListVisitasAgrupacionById(Long id, ModelMap model) {

		model.put("data", adapter.getListVisitasAgrupacionById(id));

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListOfertasAgrupacion(Long id, WebDto webDto, ModelMap model) {

		model.put("data", adapter.getListOfertasAgrupacion(id));

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getAvisosAgrupacionById(Long id, ModelMap model) {

		model.put("data", adapter.getAvisosAgrupacionById(id));

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
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

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveAgrupacion(DtoAgrupaciones dtoAgrupacion, @RequestParam Long id, ModelMap model) {

		try {
			boolean success = adapter.saveAgrupacion(dtoAgrupacion, id);
			model.put("success", success);
			
		} catch (JsonViewerException jvex) {
			logger.error(jvex);
			model.put("success", false);
			model.put("msgError", jvex.getMessage());
		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveOfertaAgrupacion(DtoOfertaActivo dtoOferta, ModelMap model) {

		try {
			boolean success = adapter.saveOfertaAgrupacion(dtoOferta);
			model.put("success", success);
		}catch (JsonViewerException jvex) {
			model.put("success", false);
			model.put("msg", jvex.getMessage());
		}catch (Exception e) {
			logger.error("error actualizando oferta",e);
			if (e.getMessage().equals(AgrupacionAdapter.OFERTA_AGR_LOTE_COMERCIAL_GESTORES_NULL_MSG)) {
				model.put("msg", AgrupacionAdapter.OFERTA_AGR_LOTE_COMERCIAL_GESTORES_NULL_MSG);
				model.put("success", false);
			} else {
				logger.error("error actualizando oferta",e);
				model.put("success", false);
			}
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
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
	@SuppressWarnings("unchecked")
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

	@SuppressWarnings("unchecked")
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

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	@Transactional(readOnly = false)
	public ModelAndView getFotosAgrupacionById(Long id, WebDto webDto, ModelMap model) {

		ActivoAgrupacion agrupacion = activoAgrupacionApi.get(id);
		List<DtoFoto> listaDtoFotos = new ArrayList<DtoFoto>();

		if (agrupacion.getTipoAgrupacion() != null
				&& (agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA)
						|| agrupacion.getTipoAgrupacion().getCodigo().equals(DDTipoAgrupacion.AGRUPACION_ASISTIDA))) {

			List<ActivoFoto> listaFotos = activoAgrupacionApi.getFotosAgrupacionById(id);

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

						listaDtoFotos.add(fotoDto);

					} catch (IllegalAccessException e) {
						logger.error(e);
					} catch (InvocationTargetException e) {
						logger.error(e);
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

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	@Transactional(readOnly = false)
	public ModelAndView getFotosSubdivisionById(DtoSubdivisiones subdivision, ModelMap model) {

		List<DtoFoto> listaDtoFotos = new ArrayList<DtoFoto>();
		List<ActivoFoto> listaFotos = activoAgrupacionApi.getFotosSubdivision(subdivision);

		if (listaFotos != null) {

			for (int i = 0; i < listaFotos.size(); i++) {

				try {

					DtoFoto fotoDto = new DtoFoto();

					BeanUtils.copyProperty(fotoDto, "id", listaFotos.get(i).getId());

					BeanUtils.copyProperties(fotoDto, listaFotos.get(i));

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
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView uploadFoto(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelMap model = new ModelMap();

		try {

			WebFileItem fileItem = uploadAdapter.getWebFileItem(request);

			String errores = activoAgrupacionApi.uploadFoto(fileItem);

			model.put("errores", errores);
			model.put("success", errores != null);

		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
			model.put("errores", e.getCause());
		}
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView uploadFotoSubdivision(HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		ModelMap model = new ModelMap();

		try {

			WebFileItem fileItem = uploadAdapter.getWebFileItem(request);

			String errores = activoAgrupacionApi.uploadFotoSubdivision(fileItem);

			model.put("errores", errores);
			model.put("success", errores != null);

		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
			model.put("errores", e.getCause());
		}
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListSubdivisionesAgrupacionById(DtoAgrupacionFilter agrupacionFilter, ModelMap model) {

		Page page = activoAgrupacionApi.getListSubdivisionesAgrupacionById(agrupacionFilter);

		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListActivosSubdivisionById(DtoSubdivisiones subdivisionFilter, ModelMap model) {

		Page page = activoAgrupacionApi.getListActivosSubdivisionById(subdivisionFilter);

		model.put("data", page.getResults());
		model.put("totalCount", page.getTotalCount());

		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public void generateExcel(DtoAgrupacionFilter dtoAgrupacionFilter, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		dtoAgrupacionFilter.setStart(excelReportGeneratorApi.getStart());
		dtoAgrupacionFilter.setLimit(excelReportGeneratorApi.getLimit());

		@SuppressWarnings("unchecked")
		List<VBusquedaAgrupaciones> listaAgrupaciones = (List<VBusquedaAgrupaciones>) adapter
				.getListAgrupaciones(dtoAgrupacionFilter).getResults();

		ExcelReport report = new AgrupacionExcelReport(listaAgrupaciones);

		excelReportGeneratorApi.generateAndSend(report, response);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createOferta(DtoOfertasFilter dtoOferta, ModelMap model) throws Exception {
		try {
			boolean success = adapter.createOfertaAgrupacion(dtoOferta);// trabajoApi.createPresupuestoTrabajo(presupuestoDto,
																		// idTrabajo);
			model.put("success", success);

		} catch (Exception e) {
			if (e.getMessage().equals(AgrupacionAdapter.OFERTA_INCOMPATIBLE_AGR_MSG)) {
				model.put("msg", AgrupacionAdapter.OFERTA_INCOMPATIBLE_AGR_MSG);
				model.put("success", false);
			} else {
				logger.error(e);
				model.put("success", false);
			}
		}
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getGestoresLoteComercial(@RequestParam Long agrId, @RequestParam String codigoGestor,
			ModelMap model) {

		try {
			model.put("data", adapter.getUsuariosPorCodTipoGestor(codigoGestor));
			model.put("success", true);
		} catch (Exception e) {
			logger.error(e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
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

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void exportarActivosLoteComercial(Long agrID, DtoAgrupacionFilter dtoAgrupacionFilter,
			HttpServletRequest request, HttpServletResponse response) throws Exception {

		dtoAgrupacionFilter.setStart(excelReportGeneratorApi.getStart());
		dtoAgrupacionFilter.setLimit(excelReportGeneratorApi.getLimit());

		List<VActivosAgrupacion> listaActivosPorAgrupacion = (List<VActivosAgrupacion>) adapter
				.getListActivosAgrupacionById(dtoAgrupacionFilter, agrID).getResults();

		ExcelReport report = new AgrupacionListadoActivosExcelReport(listaActivosPorAgrupacion);

		excelReportGeneratorApi.generateAndSend(report, response);
	}
	
	@SuppressWarnings("unchecked")
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
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoVigencias(DtoVigenciaAgrupacion agrupacionFilter, ModelMap model) {

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
	
	@SuppressWarnings("unchecked")
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
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDatosPublicacionAgrupacion(Long id, ModelMap model) {
		model.put("data", adapter.getDatosPublicacionAgrupacion(id));
		model.put("success", true);
		
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView setDatosPublicacionAgrupacion(Long id, DtoDatosPublicacionActivo dto, ModelMap model) {
		try {
			model.put("success", activoEstadoPublicacionApi.setDatosPublicacionAgrupacion(id, dto));
		} catch (JsonViewerException e) {
				model.put("msg", e.getMessage());
				model.put("success", false);
				logger.error("Error al guardar los datos de publicacion de la agrupacion", e);
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCondicionEspecificaByAgrupacion(Long id, ModelMap model) {

		model.put("data", activoAgrupacionApi.getCondicionEspecificaByAgrupacion(id));
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createCondicionEspecifica(DtoCondicionEspecificaAgrupacion dto, ModelMap model) {

		model.put("data", activoAgrupacionApi.createCondicionEspecifica(dto));
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveCondicionEspecifica(DtoCondicionEspecificaAgrupacion dto, ModelMap model) {

		model.put("data", activoAgrupacionApi.saveCondicionEspecifica(dto));
		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView darDeBajaCondicionEspecifica(DtoCondicionEspecificaAgrupacion dto, ModelMap model) {

		model.put("data", activoAgrupacionApi.darDeBajaCondicionEspecifica(dto));
		return createModelAndViewJson(model);
	}
}