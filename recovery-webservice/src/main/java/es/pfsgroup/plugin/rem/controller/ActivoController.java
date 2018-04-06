package es.pfsgroup.plugin.rem.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import es.pfsgroup.plugin.rem.model.*;
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
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.FileUtils;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.ActivoPropagacionFieldTabMap;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.api.ActivoPropagacionApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.excel.ActivoExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.excel.PublicacionExcelReport;
import es.pfsgroup.plugin.rem.model.dd.DDRatingActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoHabitaculo;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;
import es.pfsgroup.plugin.rem.service.TabActivoService;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;

@Controller
public class ActivoController extends ParadiseJsonController {

	protected static final Log logger = LogFactory.getLog(ActivoController.class);

	@Autowired
	private ActivoAdapter adapter;

	@Autowired
	private UploadAdapter uploadAdapter;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private TrabajoApi trabajoApi;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	@Autowired
	private ExcelReportGeneratorApi excelReportGeneratorApi;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;

	@Autowired
	private ActivoPropagacionApi activoPropagacionApi;
	

	/**
	 * Método que recupera un conjunto de datos del Activo según su id
	 * 
	 * @param id
	 *            Id del activo
	 * @param tab
	 *            Pestaña del activo a cargar
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTabActivo(Long id, String tab, ModelMap model) {

		try {
			
			model.put("data",  adapter.getTabActivo(id, tab));
			
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
			model.put("error", e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getActivos(DtoActivoFilter dtoActivoFiltro, ModelMap model) {

		try {

			Page page = adapter.getActivos(dtoActivoFiltro);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	/**
	 * Guarda los datos de la pestaña de datos básicos
	 * 
	 * @param activoDto
	 * @param id
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDatosBasicos(DtoActivoFichaCabecera activoDto, @RequestParam Long id, ModelMap model) {

		try {

			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_DATOS_BASICOS);
			if (success)
				adapter.updatePortalPublicacion(id); // TODO: eliminar.
			model.put("success", success);

		} catch (JsonViewerException jvex) {
			model.put("success", false);
			model.put("msgError", jvex.getMessage());
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}
		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoDatosRegistrales(DtoActivoDatosRegistrales activoDto, @RequestParam Long id,
			ModelMap model) {

		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_DATOS_REGISTRALES);
			if (success)
				adapter.updatePortalPublicacion(id);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoCarga(DtoActivoCargas cargaDto, ModelMap model) {

		try {
			boolean success = activoApi.saveActivoCarga(cargaDto);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoCargaTab(DtoActivoCargasTab cargaDto, ModelMap model) {

		try {
			boolean success = activoApi.saveActivoCargaTab(cargaDto);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateActivoPropietarioTab(DtoPropietario propietario, ModelMap model) {

		try {
			boolean success = activoApi.updateActivoPropietarioTab(propietario);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createActivoPropietarioTab(DtoPropietario propietario, ModelMap model) {

		try {
			boolean success = activoApi.createActivoPropietarioTab(propietario);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteActivoPropietarioTab(DtoPropietario propietario, ModelMap model) {

		try {
			boolean success = activoApi.deleteActivoPropietarioTab(propietario);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoInformacionAdministrativa(DtoActivoInformacionAdministrativa activoDto,
			@RequestParam Long id, ModelMap model) {

		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_INFO_ADMINISTRATIVA);
			if (success)
				adapter.updatePortalPublicacion(id);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoInformacionComercial(DtoActivoInformacionComercial activoDto, @RequestParam Long id,
			ModelMap model) {

		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_INFORMACION_COMERCIAL);
			if (success)
				adapter.updatePortalPublicacion(id);

			// Después de haber guardado los cambios sobre informacion
			// comercial, recalculamos el rating del activo.
			activoApi.calcularRatingActivo(id);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveValoresPreciosActivo(DtoActivoValoraciones valoracionesDto, @RequestParam Long id,
			ModelMap model) {

		try {
			boolean success = adapter.saveTabActivo(valoracionesDto, id, TabActivoService.TAB_VALORACIONES_PRECIOS);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoAdministracion(DtoActivoAdministracion activoDto, @RequestParam Long id,
			ModelMap model) {

		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_ADMINISTRACION);
			if (success)
				adapter.updatePortalPublicacion(id);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoSituacionPosesoria(DtoActivoSituacionPosesoria activoDto, @RequestParam Long id,
			ModelMap model) {

		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_SIT_POSESORIA_LLAVES);
			if (success)
				adapter.updatePortalPublicacion(id);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}
		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoInformeComercial(DtoActivoInformeComercial activoDto, @RequestParam Long id,
			ModelMap model) {

		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_INFORME_COMERCIAL);
			if (success)
				adapter.updatePortalPublicacion(id);

			// Después de haber guardado los cambios sobre informacion
			// comercial, recalculamos el rating del activo.
			activoApi.calcularRatingActivo(id);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListCargasById(Long id, WebDto webDto, ModelMap model) {

		model.put("data", adapter.getListCargasById(id));

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListDistribucionesById(Long id, ModelMap model) {

		model.put("data", adapter.getListDistribucionesById(id));

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getNumeroPlantasActivo(Long idActivo, ModelMap model) {

		model.put("data", adapter.getNumeroPlantasActivo(idActivo));
		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTipoHabitaculoByNumPlanta(Long idActivo, Integer numPlanta, ModelMap model) {

		model.put("data", adapter.getTipoHabitaculoByNumPlanta(idActivo, numPlanta));
		return createModelAndViewJson(model);

	}
	

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListObservacionesById(Long id, ModelMap model) {

		model.put("data", adapter.getListObservacionesById(id));

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAgrupacionesActivoById(Long id, ModelMap model) {

		model.put("data", adapter.getListAgrupacionesActivoById(id));

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListVisitasActivoById(Long id, ModelMap model) {

		try {
			model.put("data", adapter.getListVisitasActivoById(id));
		} catch (IllegalAccessException e) {
			logger.error("error en activoController", e);
		} catch (InvocationTargetException e) {
			logger.error("error en activoController", e);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListOcupantesLegalesById(Long id, ModelMap model) {

		model.put("data", adapter.getListOcupantesLegalesById(id));

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getListLlavesById(DtoLlaves dto, ModelMap model) {

		try {
			DtoPage page = activoApi.getListLlavesByActivo(dto);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveLlave(DtoLlaves dto, ModelMap model) {

		try {
			boolean success = adapter.saveLlave(dto);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteLlave(DtoLlaves dto, ModelMap model) {

		try {
			boolean success = adapter.deleteLlave(dto);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createLlave(DtoLlaves dto, ModelMap model) {

		try {
			boolean success = adapter.createLlave(dto);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListCatastroById(Long id, ModelMap model) {

		model.put("data", adapter.getListCatastroById(id));

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getValoresPreciosActivoById(@RequestParam Long id, ModelMap model) {

		model.put("data", adapter.getValoresPreciosActivoById(id));

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveCatastro(DtoActivoCatastro catastroDto, @RequestParam Long idCatastro, ModelMap model) {

		try {
			boolean success = adapter.saveCatastro(catastroDto, idCatastro);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deletePrecioVigente(DtoPrecioVigente precioVigenteDto, ModelMap model) {

		try {
			boolean success = activoApi.deleteValoracionPrecio(precioVigenteDto.getIdPrecioVigente());
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deletePrecioVigenteSinGuardadoHistorico(DtoPrecioVigente precioVigenteDto, ModelMap model) {

		try {
			boolean success = activoApi
					.deleteValoracionPrecioConGuardadoEnHistorico(precioVigenteDto.getIdPrecioVigente(), false);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView savePrecioVigente(DtoPrecioVigente precioVigenteDto, ModelMap model) {

		try {
			boolean success = activoApi.savePrecioVigente(precioVigenteDto);
			if (success)
				adapter.updatePublicarActivo(precioVigenteDto.getIdActivo());
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveOfertaActivo(DtoOfertaActivo ofertaActivoDto, ModelMap model) {

		try {
			boolean success = activoApi.saveOfertaActivo(ofertaActivoDto);
			model.put("success", success);
		} catch (JsonViewerException jvex) {
			model.put("success", false);
			model.put("msg", jvex.getMessage());
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDistribucion(DtoDistribucion distribucionDto, @RequestParam Long idDistribucion,
			ModelMap model) {

		try {
			boolean success = adapter.saveDistribucion(distribucionDto, idDistribucion);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createDistribucion(DtoDistribucion distribucionDto, @RequestParam Long idEntidad,
			ModelMap model) {

		try {
			boolean success = adapter.createDistribucion(distribucionDto, idEntidad);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}
	

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createDistribucionFromRem(String numPlanta, String cantidad, String superficie, Long idActivo, String tipoHabitaculoCodigo, ModelMap model) {

		DtoDistribucion distribucionDto = new DtoDistribucion();
		DDTipoHabitaculo habitaculo = (DDTipoHabitaculo) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoHabitaculo.class, tipoHabitaculoCodigo);
		distribucionDto.setNumPlanta(numPlanta);
		distribucionDto.setCantidad(cantidad);
		distribucionDto.setSuperficie(superficie);
		distribucionDto.setTipoHabitaculoCodigo(tipoHabitaculoCodigo);
		distribucionDto.setTipoHabitaculoDescripcion(habitaculo.getDescripcion());
		
		try {
			boolean success = adapter.createDistribucion(distribucionDto, idActivo);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createCatastro(DtoActivoCatastro catastroDto, @RequestParam Long idEntidad, ModelMap model) {

		try {
			boolean success = adapter.createCatastro(catastroDto, idEntidad);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createOcupanteLegal(DtoActivoOcupanteLegal dtoOcupanteLegal, @RequestParam Long idEntidad,
			ModelMap model) {

		try {
			boolean success = adapter.createOcupanteLegal(dtoOcupanteLegal, idEntidad);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveOcupanteLegal(DtoActivoOcupanteLegal dtoOcupanteLegal,
			@RequestParam Long idActivoOcupanteLegal, ModelMap model) {

		try {
			boolean success = adapter.saveOcupanteLegal(dtoOcupanteLegal, idActivoOcupanteLegal);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteDistribucion(DtoDistribucion distribucionDto, @RequestParam Long idDistribucion,
			ModelMap model) {

		try {
			boolean success = adapter.deleteDistribucion(distribucionDto, idDistribucion);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteCatastro(DtoActivoCatastro catastroDto, @RequestParam Long idCatastro, ModelMap model) {

		try {
			boolean success = adapter.deleteCatastro(catastroDto, idCatastro);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteOcupanteLegal(DtoActivoOcupanteLegal dtoOcupanteLegal,
			@RequestParam Long idActivoOcupanteLegal, ModelMap model) {

		try {
			boolean success = adapter.deleteOcupanteLegal(dtoOcupanteLegal, idActivoOcupanteLegal);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveObservacionesActivo(DtoObservacion dtoObservacion, ModelMap model) {

		try {
			boolean success = adapter.saveObservacionesActivo(dtoObservacion);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createObservacionesActivo(DtoObservacion dtoObservacion, Long idEntidad, ModelMap model) {

		try {
			boolean success = adapter.createObservacionesActivo(dtoObservacion, idEntidad);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteObservacionesActivo(@RequestParam Long id, ModelMap model) {

		try {
			boolean success = adapter.deleteObservacion(id);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createCondicionHistorico(DtoCondicionHistorico dtoCondicionHistorico, Long idEntidad,
			ModelMap model) {

		try {
			boolean success = adapter.createCondicionHistorico(dtoCondicionHistorico, idEntidad);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListDocumentacionAdministrativaById(Long id, WebDto dto, ModelMap model) {

		model.put("data", adapter.getListDocumentacionAdministrativaById(id));

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCargaById(Long id, ModelMap model) {

		model.put("data", adapter.getCargaById(id));

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTasacionById(Long id, ModelMap model) {

		model.put("data", adapter.getTasacionById(id));

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboUsuarios(Long idTipoGestor, WebDto webDto, ModelMap model) {

		model.put("data", adapter.getComboUsuarios(idTipoGestor));

		return new ModelAndView("jsonView", model);

	}	

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboUsuariosGestoria(WebDto webDto, ModelMap model) {

		model.put("data", adapter.getComboUsuariosGestoria());

		return new ModelAndView("jsonView", model);

	}	
	

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getGestores(Long idActivo, WebDto webDto, ModelMap model) {

		model.put("data", adapter.getGestores(idActivo));

		return new ModelAndView("jsonView", model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getFotoActivoById(Long idFoto, HttpServletRequest request, HttpServletResponse response) {

		ActivoFoto actvFoto = adapter.getFotoActivoById(idFoto);
		if (actvFoto.getRemoteId() != null) {
			return new ModelAndView("redirect:" + actvFoto.getUrl());
		} else {
			FileItem fileItem = adapter.getFotoActivoById(idFoto).getAdjunto().getFileItem();

			try {
				ServletOutputStream salida = response.getOutputStream();

				response.setHeader("Content-disposition", "inline");
				response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
				response.setHeader("Cache-Control", "max-age=0");
				response.setHeader("Expires", "0");
				response.setHeader("Pragma", "public");
				response.setDateHeader("Expires", 0); // prevents caching at the
														// proxy

				if (fileItem.getContentType() != null) {
					response.setContentType(fileItem.getContentType());
				} else {
					response.setContentType("Content-type: image/jpeg");
				}

				// Write
				FileUtils.copy(fileItem.getInputStream(), salida);
				salida.flush();
				salida.close();

			} catch (Exception e) {
				logger.error("error en activoController", e);
			}
			return null;
		}

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	@Transactional(readOnly = false)
	public ModelAndView getFotosById(Long id, String tipoFoto, WebDto webDto, ModelMap model,
			HttpServletRequest request, HttpServletResponse response) {

		try {
			List<ActivoFoto> listaActivoFoto = adapter.getListFotosActivoById(id);
			List<DtoFoto> listaFotos = new ArrayList<DtoFoto>();

			if (listaActivoFoto != null) {

				for (int i = 0; i < listaActivoFoto.size(); i++) {

					DtoFoto fotoDto = new DtoFoto();

					if (listaActivoFoto.get(i).getTipoFoto() != null
							&& listaActivoFoto.get(i).getTipoFoto().getCodigo().equals(tipoFoto)) {

						try {
							if (listaActivoFoto.get(i).getRemoteId() != null) {
								BeanUtils.copyProperty(fotoDto, "path", listaActivoFoto.get(i).getUrlThumbnail());
							} else {
								BeanUtils.copyProperty(fotoDto, "path",
										"/pfs/activo/getFotoActivoById.htm?idFoto=" + listaActivoFoto.get(i).getId());
							}

							BeanUtils.copyProperties(fotoDto, listaActivoFoto.get(i));

							if (listaActivoFoto.get(i).getPrincipal() != null
									&& listaActivoFoto.get(i).getPrincipal()) {

								if (listaActivoFoto.get(i).getInteriorExterior() != null) {
									if (listaActivoFoto.get(i).getInteriorExterior()) {
										BeanUtils.copyProperty(fotoDto, "tituloFoto", "Principal INTERIOR");
									} else {
										BeanUtils.copyProperty(fotoDto, "tituloFoto", "Principal EXTERIOR");
									}
								}

							}

						} catch (IllegalAccessException e) {
							logger.error("error en activoController", e);
						} catch (InvocationTargetException e) {
							logger.error("error en activoController", e);
						}

						listaFotos.add(fotoDto);

					}

				}
			}

			model.put("data", listaFotos);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			return null;
		}

		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateFotosById(DtoFoto dtoFoto, ModelMap model) {

		try {
			boolean success = adapter.saveFoto(dtoFoto);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		model.put("success", true);

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.GET)
	public void getFotosByIdTemp(Long id, WebDto webDto, ModelMap model, HttpServletRequest request,
			HttpServletResponse response) {

		Activo activo = activoApi.get(id);

		List<DtoFoto> listaFotos = new ArrayList<DtoFoto>();

		if (activo.getFotos() != null) {

			for (int i = 0; i < activo.getFotos().size(); i++) {
				DtoFoto fotoDto = new DtoFoto();
				try {

					BeanUtils.copyProperties(fotoDto, activo.getFotos().get(i));
					BeanUtils.copyProperty(fotoDto, "fileItem", activo.getFotos().get(i).getAdjunto().getFileItem());
					BeanUtils.copyProperty(fotoDto, "path",
							activo.getFotos().get(i).getAdjunto().getFileItem().getFile().getPath());

					try {
						ServletOutputStream salida = response.getOutputStream();
						/*
						 * Accept-Ranges:bytes Connection:keep-alive
						 * Content-Length:2588 Content-Type:image/jpeg Date:Tue,
						 * 02 Feb 2016 15:40:57 GMT ETag:"a1c-5266d63c997c0"
						 * Last-Modified:Wed, 09 Dec 2015 01:55:51 GMT
						 * Server:nginx/1.6.2 Via:1.1
						 * dba4881aee9ac99f5dba4dcd7e8175b1.cloudfront.net
						 * (CloudFront) X-Amz-Cf-Id:
						 * AEGEJ3lgCW_2KJOmcyCViKW_d4IzBo01v4w0yzsbD235t9eciM0Evg
						 * == X-Cache:Miss from cloudfront
						 */

						response.setHeader("Content-disposition", "attachment; filename="
								+ activo.getFotos().get(i).getAdjunto().getFileItem().getFileName());
						response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
						response.setHeader("Cache-Control", "max-age=0");
						response.setHeader("Expires", "0");
						response.setHeader("Pragma", "public");
						response.setDateHeader("Expires", 0); // prevents
																// caching at
																// the proxy
						response.setContentType(activo.getFotos().get(i).getAdjunto().getFileItem().getContentType());

						// Write
						FileUtils.copy(activo.getFotos().get(i).getAdjunto().getFileItem().getInputStream(), salida);
						salida.flush();
						salida.close();

					} catch (Exception e) {
						logger.error("error en activoController", e);
					}

				} catch (IllegalAccessException e) {
					logger.error("error en activoController", e);
				} catch (InvocationTargetException e) {
					logger.error("error en activoController", e);
				}
				listaFotos.add(fotoDto);

			}
		}
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView insertarGestorAdicional(Long idActivo, Long usuarioGestor, Long tipoGestor, WebDto webDto,
			ModelMap model){

		try {
			GestorEntidadDto dto = new GestorEntidadDto();
			dto.setIdEntidad(idActivo);
			dto.setIdUsuario(usuarioGestor);
			dto.setIdTipoGestor(tipoGestor);

			boolean success = adapter.insertarGestorAdicional(dto);
			model.put("success", success);
			if(!success){
				model.put("errorCode", "msg.activo.gestores.noasignar.tramite.multiactivo");
			}

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
			model.put("errorCode", "msg.operacion.ko");
		}
		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTramites(Long idActivo, WebDto webDto, ModelMap model) {

		model.put("data", adapter.getTramitesActivo(idActivo, webDto));

		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getPreciosVigentesById(Long id, WebDto webDto, ModelMap model) {

		model.put("data", adapter.getPreciosVigentesById(id));

		return new ModelAndView("jsonView", model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListPropietarioById(Long id, ModelMap model) {

		model.put("data", adapter.getListPropietarioById(id));

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListValoracionesById(Long id, WebDto webDto, ModelMap model) {

		model.put("data", adapter.getListValoracionesById(id));

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListTasacionById(Long id, ModelMap model) {

		model.put("data", adapter.getListTasacionById(id));

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListTasacionByIdGrid(Long id, ModelMap model) {

		model.put("data", adapter.getListTasacionByIdGrid(id));

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdmisionCheckDocumentos(Long id, WebDto webDto, ModelMap model) {

		model.put("data", adapter.getListAdmisionCheckDocumentos(id));
		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListOfertasActivos(Long id, WebDto webDto, ModelMap model) {

		model.put("data", adapter.getListOfertasActivos(id));
		return createModelAndViewJson(model);

	}

	/**
	 * Método que recupera un Trámite según su id y lo mapea a un DTO
	 * 
	 * @param id
	 *            Id del trámite
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTramite(Long id, ModelMap model) {

		model.put("data", adapter.getTramite(id));

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboInferiorMunicipio(String codigoMunicipio, WebDto webDto, ModelMap model) {

		model.put("data", activoApi.getComboInferiorMunicipio(codigoMunicipio));

		return createModelAndViewJson(model);

	}

	/**
	 * Método que recupera las tareas activas de un trámite.
	 * 
	 * @param idTramite
	 *            Id del trámite
	 * @return Listado de tareas asociadas al trámite y activas
	 * 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTareasTramite(Long idTramite, WebDto webDto, ModelMap model) {

		model.put("data", adapter.getTareasTramite(idTramite));

		return createModelAndViewJson(model);
	}

	/**
	 * Método que recupera las tareas de un trámite.
	 * 
	 * @param idTramite
	 *            Id del trámite
	 * @return Listado de tareas asociadas al trámite y activas
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTareasTramiteHistorico(Long idTramite, WebDto webDto, ModelMap model) {

		model.put("data", adapter.getTareasTramiteHistorico(idTramite));

		return createModelAndViewJson(model);
	}

	/**
	 * Método que recupera los activos de un trámite.
	 * 
	 * @param idTramite
	 *            Id del trámite
	 * @return Listado de activos del tramite, tomando de cada activo un grupo
	 *         de datos reducido
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getActivosTramite(Long idTramite, WebDto webDto, ModelMap model) {

		List<Activo> listActivos = activoTramiteApi.getActivosTramite(idTramite);
		List<DtoActivoTramite> listDtoActivosTramite = activoTramiteApi.getDtoActivosTramite(listActivos);
		model.put("data", listDtoActivosTramite);
		model.put("totalCount", listDtoActivosTramite.size());

		return createModelAndViewJson(model);
	}

	/**
	 * Método que crea un nuevo trámite a partir de un activo
	 * 
	 * @param idActivo
	 *            Id del activo
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView crearTramite(Long idActivo, ModelMap model) {

		try {
			if (activoTramiteApi.existeTramiteAdmision(idActivo)) {
				model.put("errorCreacion", "Ya existe un trámite de admisión para este activo");
				model.put("success", false);
			} else {
				if (activoApi.isVendido(idActivo)) {
					model.put("errorCreacion", "No se puede lanzar un trámite de admisión de un activo vendido");
					model.put("success", false);
				} else {
					model.put("data", adapter.crearTramiteAdmision(idActivo));
				}
			}

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	/**
	 * Método que crea el trámite de publicación a partir de un activo (Para
	 * pruebas)
	 * 
	 * @param idActivo
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView crearTramitePublicacion(Long idActivo, ModelMap model) {

		try {
			model.put("data", adapter.crearTramitePublicacion(idActivo));

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	/**
	 * Método que crea un nuevo trábajo a partir de un activo
	 * 
	 * @param idActivo
	 *            : ID del activo
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView crearTrabajo(DtoFichaTrabajo dtoTrabajo, Long idActivo) {

		boolean success = trabajoApi.saveFichaTrabajo(dtoTrabajo, idActivo);

		return createModelAndViewJson(new ModelMap("success", success));

	}

	/**
	 *
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveAdmisionDocumento(DtoAdmisionDocumento dtoAdmisionDocumento, ModelMap model) {

		try {

			boolean success = adapter.saveAdmisionDocumento(dtoAdmisionDocumento);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	/**
	 * Recibe y guarda un adjunto
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView upload(HttpServletRequest request) {

		ModelMap model = new ModelMap();

		try {
			WebFileItem webFileItem = uploadAdapter.getWebFileItem(request);
			adapter.upload(webFileItem);
			model.put("success", true);
		} catch (GestorDocumentalException e) {
			logger.error("error en activoController", e);
			model.put("success", false);
			model.put("errorMessage", "Ha habido un problema con la subida del fichero al gestor documental.");
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
			model.put("errorMessage", "Ha habido un problema con la subida del fichero.");
		}
		return createModelAndViewJson(model);
	}

	/**
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping(method = RequestMethod.GET)
	public void bajarAdjuntoActivo(HttpServletRequest request, HttpServletResponse response) {

		Long id = null;
		try {
			id = Long.parseLong(request.getParameter("id"));
			ServletOutputStream salida = response.getOutputStream();
			FileItem fileItem = adapter.download(id);
			response.setHeader("Content-disposition", "attachment; filename=" + fileItem.getFileName());
			response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
			response.setHeader("Cache-Control", "max-age=0");
			response.setHeader("Expires", "0");
			response.setHeader("Pragma", "public");
			response.setDateHeader("Expires", 0); // prevents caching at the
													// proxy
			response.setContentType(fileItem.getContentType());
			// Write
			FileUtils.copy(fileItem.getInputStream(), salida);
			salida.flush();
			salida.close();
		} catch (Exception e) {
			logger.error("error en activoController", e);
		}

	}

	/**
	 * delete un adjunto.
	 * 
	 * @param dtoAdjunto
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteAdjunto(DtoAdjunto dtoAdjunto, ModelMap model) {

		try {
			model.put("success", adapter.deleteAdjunto(dtoAdjunto));
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
			model.put("errorMessage", e.getMessage());
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntos(Long id, ModelMap model) {

		try {
			model.put("data", adapter.getAdjuntosActivo(id));
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
			model.put("errorMessage", e.getMessage());
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getAvisosActivoById(Long id, ModelMap model) {

		model.put("data", adapter.getAvisosActivoById(id));

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

			String errores = activoApi.uploadFoto(fileItem);

			model.put("errores", errores);
			model.put("success", errores == null);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
			model.put("errores", e.getCause());
		}
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteFotosActivoById(@RequestParam Long[] id, ModelMap model) {

		try {
			boolean success = adapter.deleteFotosActivoById(id);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findAllHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dto, ModelMap model) {

		try {

			DtoPage page = adapter.findAllHistoricoPresupuestos(dto);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	/**
	 * Método que devuelve los incrementos con el idPresupuesto recibido. En
	 * caso de ser nulo o 0 el idPresupuesto, devuelve los del último ejercicio
	 * del Activo.
	 * 
	 * @param idPresupuesto
	 * @param idActivo
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findAllIncrementosPresupuestoById(Long idPresupuesto, Long idActivo, ModelMap model) {

		try {

			if (idPresupuesto == null || idPresupuesto == 0) {
				idPresupuesto = activoApi.getUltimoHistoricoPresupuesto(idActivo);
			}

			List<DtoIncrementoPresupuestoActivo> listaIncrementos = adapter
					.findAllIncrementosPresupuestoById(idPresupuesto);
			model.put("data", listaIncrementos);
			model.put("success", true);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findLastPresupuesto(DtoActivosTrabajoFilter dto, ModelMap model) {

		try {
			DtoPresupuestoGraficoActivo presupuesto = adapter.findLastPresupuesto(dto);

			model.put("data", presupuesto);
			model.put("success", true);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	/**
	 * Método que recupera la foto principal de un activo en forma thumbnail
	 * 
	 * @param id
	 * @param model
	 * @param request
	 * @param response
	 */
	@RequestMapping(method = RequestMethod.GET)
	public void getFotoPrincipalById(Long id, ModelMap model, HttpServletRequest request,
			HttpServletResponse response) {

		List<ActivoFoto> listaActivoFoto = adapter.getListFotosActivoByIdOrderPrincipal(id);

		if (listaActivoFoto != null && !listaActivoFoto.isEmpty() && listaActivoFoto.get(0).getUrlThumbnail() != null
				&& !listaActivoFoto.get(0).getUrlThumbnail().isEmpty()) {
			try {
				// HREOS-1719 En primera instancia obtener la foto de la URL
				String requestUrl = listaActivoFoto.get(0).getUrlThumbnail();
				URL url;
				URLConnection URLconn = null;
				String URLcontentType = null;
				try {
					url = new URL(requestUrl);
					URLconn = url.openConnection();
					URLcontentType = URLconn.getContentType();
				} catch (MalformedURLException me) {
					logger.error(me.getMessage());
					me.printStackTrace();
				} catch (IOException ioe) {
					logger.error(ioe.getMessage());
					ioe.printStackTrace();
				}

				ServletOutputStream salida = response.getOutputStream();

				response.setHeader("Content-disposition", "inline");
				response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
				response.setHeader("Cache-Control", "max-age=0");
				response.setHeader("Expires", "0");
				response.setHeader("Pragma", "public");
				response.setDateHeader("Expires", 0); // prevents caching at the
														// proxy

				if (!Checks.esNulo(URLcontentType)) {
					response.setContentType("Content-type: image/jpeg");
					FileUtils.copy(URLconn.getInputStream(), salida);
				} else {
					response.setContentType("Content-type: image/jpeg");
					File file = new File(getClass().getResource("/").getPath() + "sin_imagen.png");
					file.createNewFile();
					FileUtils.copy((new FileInputStream(file)), salida);
				}
				// Write
				salida.flush();
				salida.close();

			} catch (Exception e) {
				logger.error("error en activoController", e);
			}

		} else {
			try {

				ServletOutputStream salida = response.getOutputStream();

				response.setHeader("Content-disposition", "inline");
				response.setHeader("Cache-Control", "must-revalidate, post-check=0,pre-check=0");
				response.setHeader("Cache-Control", "max-age=0");
				response.setHeader("Expires", "0");
				response.setHeader("Pragma", "public");
				response.setDateHeader("Expires", 0); // prevents caching at the
														// proxy
				response.setContentType("Content-type: image/jpeg");

				File file = new File(getClass().getResource("/").getPath() + "sin_imagen.png");
				file.createNewFile();
				FileInputStream fis = new FileInputStream(file);
				FileUtils.copy(fis, salida);
				salida.flush();
				salida.close();
			} catch (Exception e) {
				logger.error("error en activoController", e);
			}
		}

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void generateExcel(DtoActivoFilter dtoActivoFilter, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		dtoActivoFilter.setStart(excelReportGeneratorApi.getStart());
		dtoActivoFilter.setLimit(excelReportGeneratorApi.getLimit());

		List<VBusquedaActivos> listaActivos = (List<VBusquedaActivos>) adapter.getActivos(dtoActivoFilter).getResults();

		List<DDRatingActivo> listaRating = utilDiccionarioApi.dameValoresDiccionarioSinBorrado(DDRatingActivo.class);
		Map<String, String> mapRating = new HashMap<String, String>();
		for (DDRatingActivo rating : listaRating)
			mapRating.put(rating.getCodigo(), rating.getDescripcion());

		ExcelReport report = new ActivoExcelReport(listaActivos, mapRating);

		excelReportGeneratorApi.generateAndSend(report, response);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCondicionantesDisponibilidad(Long id, ModelMap model) {
		model.put("data", activoApi.getCondicionantesDisponibilidad(id));

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveCondicionantesDisponibilidad(Long idActivo, DtoCondicionantesDisponibilidad dto,
			ModelMap model) {
		try {
			boolean success = activoApi.saveCondicionantesDisponibilidad(idActivo, dto);
			activoApi.updateCondicionantesDisponibilidad(idActivo);
			if (success)
				adapter.updatePortalPublicacion(idActivo);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoValoresPrecios(DtoHistoricoPreciosFilter dto, ModelMap model) {
		try {
			DtoPage page = activoApi.getHistoricoValoresPrecios(dto);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getPropuestas(DtoPropuestaFilter dtoPropuestaFiltro, ModelMap model) {

		try {

			Page page = activoApi.getPropuestas(dtoPropuestaFiltro);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCondicionEspecificaByActivo(Long id, ModelMap model) {

		model.put("data", activoApi.getCondicionEspecificaByActivo(id));
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica, ModelMap model) {

		model.put("success", activoApi.createCondicionEspecifica(dtoCondicionEspecifica));
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView darDeBajaCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica, ModelMap model) {

		model.put("success", activoApi.darDeBajaCondicionEspecifica(dtoCondicionEspecifica));
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica, ModelMap model) {

		model.put("success", activoApi.saveCondicionEspecifica(dtoCondicionEspecifica));
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoEstadosPublicacionVentaByIdActivo(DtoPaginadoHistoricoEstadoPublicacion dto, ModelMap model) {
		DtoPaginadoHistoricoEstadoPublicacion listadoPaginado = activoEstadoPublicacionApi.getHistoricoEstadosPublicacionVentaByIdActivo(dto);
		model.put("data", listadoPaginado.getListado());
		model.put("totalCount", listadoPaginado.getTotalCount());
		model.put("success", true);
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoEstadosPublicacionAlquilerByIdActivo(DtoPaginadoHistoricoEstadoPublicacion dto, ModelMap model) {
		DtoPaginadoHistoricoEstadoPublicacion listadoPaginado = activoEstadoPublicacionApi.getHistoricoEstadosPublicacionAlquilerByIdActivo(dto);
		model.put("data", listadoPaginado.getListado());
		model.put("totalCount", listadoPaginado.getTotalCount());
		model.put("success", true);
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getEstadoInformeComercialByActivo(Long id, ModelMap model) {
		model.put("data", activoApi.getEstadoInformeComercialByActivo(id));
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoMediadorByActivo(Long id, ModelMap model) {
		model.put("data", activoApi.getHistoricoMediadorByActivo(id));
		return createModelAndViewJson(model);
	}
	
	public List<DtoHistoricoMediador> getHistoricoMediadorByActivo(Long id) {
		return activoApi.getHistoricoMediadorByActivo(id);
	}

	public List<DtoCondicionEspecifica> getCondicionEspecificaByActivo(Long id) {
		return activoApi.getCondicionEspecificaByActivo(id);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createHistoricoMediador(DtoHistoricoMediador dto, ModelMap model) {
		
		try{
			model.put("success", activoApi.createHistoricoMediador(dto));
		}
		catch (JsonViewerException jvex) {
			model.put("success", false);
			model.put("msg", jvex.getMessage());
		}
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getActivosPublicacion(DtoActivosPublicacion dtoActivosPublicacion, ModelMap model) {
		try {
			Page page = activoApi.getActivosPublicacion(dtoActivosPublicacion);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public void generateExcelPublicaciones(DtoActivosPublicacion dtoActivosPublicacion, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		dtoActivosPublicacion.setStart(excelReportGeneratorApi.getStart());
		dtoActivosPublicacion.setLimit(excelReportGeneratorApi.getLimit());

		@SuppressWarnings("unchecked")
		List<VBusquedaPublicacionActivo> listaPublicacionesActivos = (List<VBusquedaPublicacionActivo>) activoApi
				.getActivosPublicacion(dtoActivosPublicacion).getResults();

		ExcelReport report = new PublicacionExcelReport(listaPublicacionesActivos);

		excelReportGeneratorApi.generateAndSend(report, response);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView setHistoricoEstadoPublicacion(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion,
			ModelMap model) {// TODO: eliminar.

		try {
			model.put("success", activoEstadoPublicacionApi.publicacionChangeState(dtoCambioEstadoPublicacion));
		} catch (SQLException e) {
			model.put("success", false);
			logger.error("Error en ActivoController: ", e);
		} catch (JsonViewerException jViewEx) {
			logger.error("Error en ActivoController", jViewEx);
			model.put("success", false);
			model.put("msgError", jViewEx.getMessage());
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoEstadoPublicacion(Long id, ModelMap model) {// TODO: eliminar.

		model.put("data", activoEstadoPublicacionApi.getHistoricoEstadoPublicacionByActivo(id));

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getDatosPublicacionActivo(Long id, ModelMap model) {
		model.put("data", activoEstadoPublicacionApi.getDatosPublicacionActivo(id));
		model.put("success", true);

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView setDatosPublicacionActivo(DtoDatosPublicacionActivo dto, ModelMap model) {
		try {
			model.put("success", activoEstadoPublicacionApi.setDatosPublicacionActivo(dto));
		} catch (JsonViewerException e) {
				model.put("msg", e.getMessage());
				model.put("success", false);
				logger.error("Error al guardar los datos de publicacion del activo", e);
		}

		return createModelAndViewJson(model);
	}
		

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createOferta(DtoOfertasFilter dtoOferta, ModelMap model) throws Exception {
		try {
			boolean success = adapter.createOfertaActivo(dtoOferta);
			model.put("success", success);

		} catch (Exception e) {
			if (e.getMessage().equals(ActivoAdapter.OFERTA_INCOMPATIBLE_MSG)) {
				model.put("msg", ActivoAdapter.OFERTA_INCOMPATIBLE_MSG);
				model.put("success", false);
			} else {
				logger.error("error en activoController", e);
				model.put("success", false);
			}
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getPropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto, ModelMap model) {
		try {
			List<DtoPropuestaActivosVinculados> dtoActivosVinculados = activoApi
					.getPropuestaActivosVinculadosByActivo(dto);

			model.put("data", dtoActivosVinculados);
			if (!Checks.estaVacio(dtoActivosVinculados)) {
				model.put("totalCount", dtoActivosVinculados.get(0).getTotalCount());
			} else {
				model.put("totalCount", 0);
			}
			model.put("success", true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createPropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto, ModelMap model) {
		try {
			boolean success = activoApi.createPropuestaActivosVinculadosByActivo(dto);
			model.put("success", success);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deletePropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto, ModelMap model) {
		try {
			boolean success = activoApi.deletePropuestaActivosVinculadosByActivo(dto);
			model.put("success", success);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView solicitarTasacion(Long idActivo, ModelMap model){
		try {
			model.put("success", activoApi.solicitarTasacion(idActivo));
		} catch (JsonViewerException jve) {
			model.put("success", false);
			model.put("msgError", jve.getMessage());
		} catch (Exception e) {
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getSolicitudTasacionBankia(Long id, ModelMap model) {

		try {
			model.put("data", activoApi.getSolicitudTasacionBankia(id));
			model.put("success", true);
		} catch (JsonViewerException jve) {
			model.put("success", false);
			model.put("msg", jve.getMessage());
		} catch (Exception e) {
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getProveedorByActivo(Long idActivo, ModelMap model) {

		try {

			List<VBusquedaProveedoresActivo> lista = activoApi.getProveedorByActivo(idActivo);

			model.put("data", lista);
			model.put("success", true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getGastoByActivo(Long idActivo, Long idProveedor, WebDto dto, ModelMap model) {

		try {
			Page lista = activoApi.getGastoByActivo(idActivo, idProveedor, dto);

			if(lista != null) {
				model.put("data", lista.getResults());
				model.put("totalCount", lista.getTotalCount());
			}
			model.put("success", true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getReglasPublicacionAutomatica(DtoReglasPublicacionAutomatica dto, ModelMap model) {

		try {
			List<DtoReglasPublicacionAutomatica> dtoReglasPublicacionAutomatica = activoApi
					.getReglasPublicacionAutomatica(dto);

			model.put("data", dtoReglasPublicacionAutomatica);
			if (!Checks.estaVacio(dtoReglasPublicacionAutomatica)) {
				model.put("totalCount", dtoReglasPublicacionAutomatica.get(0).getTotalCount());
			} else {
				model.put("totalCount", 0);
			}
			model.put("success", true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createReglaPublicacionAutomatica(DtoReglasPublicacionAutomatica dto, ModelMap model) {

		try {
			boolean success = activoApi.createReglaPublicacionAutomatica(dto);
			model.put("success", success);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteReglaPublicacionAutomatica(DtoReglasPublicacionAutomatica dto, ModelMap model) {
		try {
			boolean success = activoApi.deleteReglaPublicacionAutomatica(dto);
			model.put("success", success);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getProveedoresByActivoIntegrado(DtoActivoIntegrado dtoActivoIntegrado, ModelMap model) {

		try {
			List<DtoActivoIntegrado> resultados = activoApi.getProveedoresByActivoIntegrado(dtoActivoIntegrado);
			model.put("data", resultados);
			if (!Checks.estaVacio(resultados)) {
				model.put("totalCount", resultados.get(0).getTotalCount());
			} else {
				model.put("totalCount", 0);
			}
			model.put("success", true);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createActivoIntegrado(DtoActivoIntegrado dto, ModelMap model) {

		try {
			boolean success = activoApi.createActivoIntegrado(dto);
			model.put("success", success);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}
		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getActivoIntegrado(@RequestParam String id) {
		ModelMap model = new ModelMap();

		try {
			model.put("data", activoApi.getActivoIntegrado(id));
			model.put("success", true);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateActivoIntegrado(DtoActivoIntegrado dto) {
		ModelMap model = new ModelMap();

		try {
			model.put("data", activoApi.updateActivoIntegrado(dto));
			model.put("success", true);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getListMovimientosLlaveByLlave(ModelMap model, WebDto dto, Long idLlave, Long idActivo) {

		try {

			DtoPage page = activoApi.getListMovimientosLlaveByLlave(dto, idLlave, idActivo);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createMovimientoLlave(DtoMovimientoLlave dtoMovimiento, ModelMap model) {
		try {

			boolean success = adapter.createMovimientoLlave(dtoMovimiento);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveMovimientoLlave(DtoMovimientoLlave dto, ModelMap model) {

		try {
			boolean success = adapter.saveMovimientoLlave(dto);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteMovimientoLlave(DtoMovimientoLlave dto, ModelMap model) {

		try {
			boolean success = adapter.deleteMovimientoLlave(dto);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComercialActivo(DtoComercialActivo dto, ModelMap model) {

		try {
			model.put("data", activoApi.getComercialActivo(dto));
			model.put("success", true);
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveComercialActivo(DtoComercialActivo dto, ModelMap model) {

		try {
			model.put("success", activoApi.saveComercialActivo(dto));

		} catch (JsonViewerException jvex) {
			logger.error("error en activoController.saveComercialActivo", jvex);
			model.put("success", false);
			model.put("msgError", jvex.getMessage());
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteCarga(DtoActivoCargas dtoCarga, ModelMap model) {

		try {
			model.put("success", activoApi.deleteCarga(dtoCarga));
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
			model.put("errorMessage", e.getMessage());
		}

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)	
	public ModelAndView comprobarActivoFormalizable(Long numActivo, ModelMap model) {
		
		try {
			model.put("success", activoApi.esActivoFormalizable(numActivo));
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
			model.put("errorMessage", e.getMessage());
		}

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboUsuariosGestorActivos(WebDto webDto, ModelMap model) {
		
		EXTDDTipoGestor tipoGestorActivos= (EXTDDTipoGestor) utilDiccionarioApi.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GACT");

		model.put("data", adapter.getComboUsuarios(tipoGestorActivos.getId()));
		
		return new ModelAndView("jsonView", model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboSupervisorActivos(WebDto webDto, ModelMap model) {
		
		EXTDDTipoGestor tipoGestorActivos= (EXTDDTipoGestor) utilDiccionarioApi.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "SUPACT");

		model.put("data", adapter.getComboUsuarios(tipoGestorActivos.getId()));
		
		return new ModelAndView("jsonView", model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView propagarInformacion(@RequestParam(required = true) Long id, @RequestParam(required = true) String tab, ModelMap model) {

		List<String> fields = new ArrayList<String>();

		if (ActivoPropagacionFieldTabMap.map.get(tab) != null) {
			fields.addAll(ActivoPropagacionFieldTabMap.map.get(tab));
		}

		model.put("propagateFields", fields);
		model.put("activos", activoPropagacionApi.getAllActivosAgrupacionPorActivo(activoApi.get(id)));

		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivo(HttpServletRequest request, ModelMap model) {

		if (request != null) {
			try {
				RestRequestWrapper restRequest = new RestRequestWrapper(request);
				ActivoControllerDispatcher dispatcher = new ActivoControllerDispatcher(this);
			
				dispatcher.dispatchSave(restRequest.getJsonObject());
			} catch (Exception e) {
				logger.error("No se ha podido guardar el activo", e);
				model.put("error", e.getMessage());
			}
		}


		return new ModelAndView("jsonView", model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createTasacionActivo(String importeTasacionFin, String tipoTasacionCodigo, String nomTasador, Date fechaValorTasacion, Long idEntidad, ModelMap model) {

		try {
			boolean success = adapter.createTasacion(importeTasacionFin, tipoTasacionCodigo, nomTasador, fechaValorTasacion, idEntidad);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveTasacionActivo(DtoTasacion tasacionDto, ModelMap model) {


		try {
			boolean success = adapter.saveTasacion(tasacionDto);
			model.put("success", success);

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}
	
	/**
	 *  Guarda los datos de la pestaña patrimonio de un activo
	 * @param patrimonioDto dto de patrimonio
	 * @param id
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDatosPatrimonio(DtoActivoPatrimonio patrimonioDto, @RequestParam Long id, ModelMap model) {

		try {

			boolean success = adapter.saveTabActivo(patrimonioDto, id, TabActivoService.TAB_PATRIMONIO);
			if (success)
				adapter.updatePortalPublicacion(id); // TODO: eliminar.
			model.put("success", success);

		} catch (JsonViewerException jvex) {
			model.put("success", false);
			model.put("msgError", jvex.getMessage());
		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put("success", false);
		}
		return createModelAndViewJson(model);

	}
	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getHistoricoAdecuacionesAlquilerByActivo(DtoActivoPatrimonio dto, @RequestParam Long id, ModelMap model) {
		model.put("data", activoApi.getHistoricoAdecuacionesAlquilerByActivo(id));
		return createModelAndViewJson(model);
	}
	
	
}
