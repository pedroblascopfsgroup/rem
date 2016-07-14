package es.pfsgroup.plugin.rem.controller;

import java.io.File;
import java.io.FileInputStream;
import java.lang.reflect.InvocationTargetException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomBooleanEditor;
import org.springframework.beans.propertyeditors.CustomNumberEditor;
import org.springframework.beans.propertyeditors.StringTrimmerEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.JsonWriterConfiguratorTemplateRegistry;
import org.springframework.web.servlet.view.json.writer.sojo.SojoConfig;
import org.springframework.web.servlet.view.json.writer.sojo.SojoJsonWriterConfiguratorTemplate;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.utils.FileUtils;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.framework.paradise.gestorEntidad.dto.GestorEntidadDto;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.ParadiseCustomDateEditor;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.ActivoTramiteManager;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.excel.ActivoExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReport;
import es.pfsgroup.plugin.rem.excel.ExcelReportGeneratorApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoFoto;
import es.pfsgroup.plugin.rem.model.DtoActivoCargas;
import es.pfsgroup.plugin.rem.model.DtoActivoCatastro;
import es.pfsgroup.plugin.rem.model.DtoActivoDatosRegistrales;
import es.pfsgroup.plugin.rem.model.DtoActivoFichaCabecera;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoActivoInformacionAdministrativa;
import es.pfsgroup.plugin.rem.model.DtoActivoInformacionComercial;
import es.pfsgroup.plugin.rem.model.DtoActivoInformeComercial;
import es.pfsgroup.plugin.rem.model.DtoActivoOcupanteLegal;
import es.pfsgroup.plugin.rem.model.DtoActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.DtoActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoActivoValoraciones;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.DtoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.DtoCondicionHistorico;
import es.pfsgroup.plugin.rem.model.DtoDistribucion;
import es.pfsgroup.plugin.rem.model.DtoFichaTrabajo;
import es.pfsgroup.plugin.rem.model.DtoFoto;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPreciosFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.DtoIncrementoPresupuestoActivo;
import es.pfsgroup.plugin.rem.model.DtoObservacion;
import es.pfsgroup.plugin.rem.model.DtoPrecioVigente;
import es.pfsgroup.plugin.rem.model.DtoPresupuestoGraficoActivo;
import es.pfsgroup.plugin.rem.model.VBusquedaActivos;
import es.pfsgroup.plugin.rem.model.VCondicionantesDisponibilidad;
import es.pfsgroup.plugin.rem.model.dd.DDRatingActivo;
import es.pfsgroup.plugin.rem.service.TabActivoService;
import es.pfsgroup.plugin.rem.trabajo.dto.DtoActivosTrabajoFilter;


@Controller
public class ActivoController {

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
	
	/**
	 * Método para modificar la plantilla de JSON utilizada en el servlet.
	 * 
	 * @param request
	 * @param binder
	 * @throws Exception
	 */
	@InitBinder
	protected void initBinder(HttpServletRequest request,  ServletRequestDataBinder binder) throws Exception{
        
	    JsonWriterConfiguratorTemplateRegistry registry = JsonWriterConfiguratorTemplateRegistry.load(request);             
	    registry.registerConfiguratorTemplate(new SojoJsonWriterConfiguratorTemplate(){
	                
	        	 	@Override
	                public SojoConfig getJsonConfig() {
	                    SojoConfig config= new SojoConfig();
                        config.setIgnoreNullValues(true);
                        return config;
	        	 	}
	         }
	   );


	    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
        dateFormat.setLenient(false);

        binder.registerCustomEditor(Date.class, new ParadiseCustomDateEditor(dateFormat, true));
        
        binder.registerCustomEditor(boolean.class, new CustomBooleanEditor("true", "false", true));
        binder.registerCustomEditor(Boolean.class, new CustomBooleanEditor("true", "false", true));
        binder.registerCustomEditor(String.class, new StringTrimmerEditor(false));
        NumberFormat f = NumberFormat.getInstance(Locale.ENGLISH);
    	f.setGroupingUsed(false);
    	f.setMaximumFractionDigits(2);
        f.setMinimumFractionDigits(2);
        binder.registerCustomEditor(double.class, new CustomNumberEditor(Double.class, f, true));
        binder.registerCustomEditor(Double.class, new CustomNumberEditor(Double.class, f, true));
       
        
        /*binder.registerCustomEditor(Float.class, new CustomNumberEditor(Float.class, true));
        binder.registerCustomEditor(Long.class, new CustomNumberEditor(Long.class, true));
        binder.registerCustomEditor(Integer.class, new CustomNumberEditor(Integer.class, true));*/

        
        
	}

	/**
	 * Método que recupera una Activo según su id y lo mapea a un DTO
	 * 
	 * @param id
	 *            Id del activo
	 * @param pestana
	 *            Pestaña del activo a cargar. Dependiendo de la pestaña
	 *            recibida, cargará un DTO u otro
	 * @param model
	 * @return
	 * ******************************************************
	 * NOTA FASE II : Se refactoriza en this.getTabActivo
	 * *******************************************************/
	/*@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getActivoById(Long id, int pestana, ModelMap model) {

		model.put("data", adapter.getActivoByIdParcial(id, pestana));

		return createModelAndViewJson(model);
	}*/
	
	/**
	 * Método que recupera un conjunto de datos del Activo según su id 
	 * @param id Id del activo
	 * @param pestana Pestaña del activo a cargar
	 * @param model
	 * @return
	 */
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTabActivo(Long id, String tab, ModelMap model) {

		try {
			model.put("data", adapter.getTabActivo(id, tab));
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("error", e.getMessage());
		}

		return createModelAndViewJson(model);
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getActivos(DtoActivoFilter dtoActivoFiltro,
			ModelMap model) {

		try {

			if (dtoActivoFiltro.getSort() != null){
				if (dtoActivoFiltro.getSort().equals("via")){
					dtoActivoFiltro.setSort("tipoViaCodigo, nombreVia, numActivo");
				}
				else{
					dtoActivoFiltro.setSort(dtoActivoFiltro.getSort()+",numActivo");	
				}
			}
			Page page = adapter.getActivos(dtoActivoFiltro);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	
	/********************************************************
	 * NOTA FASE II: Refactorizado en this.saveDatosBasicos
	 ********************************************************/
	/*@RequestMapping(method = RequestMethod.POST)

	public ModelAndView saveActivo(DtoActivoFichaCabecera activoDto,
			@RequestParam Long id, ModelMap model) {

		try {

			boolean success = adapter.saveActivo(activoDto, id);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		return createModelAndViewJson(model);

	}*/
	
	/**
	 * Guarda los datos de la pestaña de datos básicos
	 * @param activoDto
	 * @param id
	 * @param model
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDatosBasicos(DtoActivoFichaCabecera activoDto, @RequestParam Long id, ModelMap model) {

		try {

			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_DATOS_BASICOS);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoDatosRegistrales(DtoActivoDatosRegistrales activoDto, @RequestParam Long id,
			ModelMap model) {

		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_DATOS_REGISTRALES);
			model.put("success", success);
			// model.put("totalCount", page.getTotalCount());

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoCarga(DtoActivoCargas cargaDto,
			@RequestParam Long id, ModelMap model) {

		try {
			boolean success = adapter.saveActivoCarga(cargaDto, id);
			model.put("success", success);
			// model.put("totalCount", page.getTotalCount());

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoInformacionAdministrativa(
			DtoActivoInformacionAdministrativa activoDto,
			@RequestParam Long id, ModelMap model) {

		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_INFO_ADMINISTRATIVA);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoInformacionComercial(
			DtoActivoInformacionComercial activoDto, @RequestParam Long id,
			ModelMap model) {

		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_INFORMACION_COMERCIAL);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveValoresPreciosActivo(
			DtoActivoValoraciones valoracionesDto, @RequestParam Long id,
			ModelMap model) {

		try {
			boolean success = adapter.saveTabActivo(valoracionesDto, id, TabActivoService.TAB_VALORACIONES_PRECIOS);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoSituacionPosesoria(
			DtoActivoSituacionPosesoria activoDto, @RequestParam Long id,
			ModelMap model) {

		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_SIT_POSESORIA_LLAVES);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveActivoInformeComercial(
			DtoActivoInformeComercial activoDto, @RequestParam Long id,	ModelMap model) {

		try {
			boolean success = adapter.saveTabActivo(activoDto, id, TabActivoService.TAB_INFORME_COMERCIAL);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListCargasById(Long id, ModelMap model) {

		model.put("data", adapter.getListCargasById(id));

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListDistribucionesById(Long id, ModelMap model) {

		model.put("data", adapter.getListDistribucionesById(id));

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListObservacionesById(Long id, ModelMap model) {

		model.put("data", adapter.getListObservacionesById(id));

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAgrupacionesActivoById(Long id, ModelMap model) {

		model.put("data", adapter.getListAgrupacionesActivoById(id));

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListOcupantesLegalesById(Long id, ModelMap model) {

		model.put("data", adapter.getListOcupantesLegalesById(id));

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListLlavesById(Long id, ModelMap model) {

		model.put("data", adapter.getListLlavesById(id));

		return createModelAndViewJson(model);

	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListCatastroById(Long id, ModelMap model) {

		model.put("data", adapter.getListCatastroById(id));

		return createModelAndViewJson(model);

	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getValoresPreciosActivoById(@RequestParam Long id, ModelMap model) {

		model.put("data", adapter.getValoresPreciosActivoById(id));

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveCatastro(DtoActivoCatastro catastroDto,
			@RequestParam Long idCatastro, ModelMap model) {

		try {
			boolean success = adapter.saveCatastro(catastroDto, idCatastro);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deletePrecioVigente(DtoPrecioVigente precioVigenteDto, ModelMap model) {
	
		try {
			boolean success = activoApi.deleteValoracionPrecio(precioVigenteDto.getIdPrecioVigente());
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView savePrecioVigente(DtoPrecioVigente precioVigenteDto, ModelMap model) {

		try {
			boolean success = activoApi.savePrecioVigente(precioVigenteDto);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}	
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDistribucion(DtoDistribucion distribucionDto,
			@RequestParam Long idDistribucion, ModelMap model) {

		try {
			boolean success = adapter.saveDistribucion(distribucionDto,
					idDistribucion);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createDistribucion(DtoDistribucion distribucionDto,
			@RequestParam Long idEntidad, ModelMap model) {

		try {
			boolean success = adapter.createDistribucion(distribucionDto,
					idEntidad);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createCatastro(DtoActivoCatastro catastroDto,
			@RequestParam Long idEntidad, ModelMap model) {

		try {
			boolean success = adapter.createCatastro(catastroDto, idEntidad);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createOcupanteLegal(
			DtoActivoOcupanteLegal dtoOcupanteLegal,
			@RequestParam Long idEntidad, ModelMap model) {

		try {
			boolean success = adapter.createOcupanteLegal(dtoOcupanteLegal,
					idEntidad);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveOcupanteLegal(
			DtoActivoOcupanteLegal dtoOcupanteLegal,
			@RequestParam Long idActivoOcupanteLegal, ModelMap model) {

		try {
			boolean success = adapter.saveOcupanteLegal(dtoOcupanteLegal,
					idActivoOcupanteLegal);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteDistribucion(DtoDistribucion distribucionDto,
			@RequestParam Long idDistribucion, ModelMap model) {

		try {
			boolean success = adapter.deleteDistribucion(distribucionDto,
					idDistribucion);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteCatastro(DtoActivoCatastro catastroDto,
			@RequestParam Long idCatastro, ModelMap model) {

		try {
			boolean success = adapter.deleteCatastro(catastroDto, idCatastro);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteOcupanteLegal(
			DtoActivoOcupanteLegal dtoOcupanteLegal,
			@RequestParam Long idActivoOcupanteLegal, ModelMap model) {

		try {
			boolean success = adapter.deleteOcupanteLegal(dtoOcupanteLegal,
					idActivoOcupanteLegal);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveObservacionesActivo(DtoObservacion dtoObservacion,
			ModelMap model) {

		try {
			boolean success = adapter.saveObservacionesActivo(dtoObservacion);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createObservacionesActivo(
			DtoObservacion dtoObservacion, Long idEntidad, ModelMap model) {

		try {
			boolean success = adapter.createObservacionesActivo(dtoObservacion,
					idEntidad);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteObservacionesActivo(@RequestParam Long id,
			ModelMap model) {

		try {
			boolean success = adapter.deleteObservacion(id);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createCondicionHistorico(
			DtoCondicionHistorico dtoCondicionHistorico, Long idEntidad, ModelMap model) {

		try {
			boolean success = adapter.createCondicionHistorico(dtoCondicionHistorico,
					idEntidad);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListDocumentacionAdministrativaById(Long id,
			ModelMap model) {

		model.put("data", adapter.getListDocumentacionAdministrativaById(id));

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCargaById(Long id, ModelMap model) {

		model.put("data", adapter.getCargaById(id));

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTasacionById(Long id, ModelMap model) {

		model.put("data", adapter.getTasacionById(id));

		return createModelAndViewJson(model);

	}

	private ModelAndView createModelAndViewJson(ModelMap model) {

		return new ModelAndView("jsonView", model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboUsuarios(Long idTipoGestor, WebDto webDto,
			ModelMap model) {

		model.put("data", adapter.getComboUsuarios(idTipoGestor));

		return new ModelAndView("jsonView", model);

	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getGestores(Long idActivo, WebDto webDto, ModelMap model) {

		model.put("data", adapter.getGestores(idActivo));

		return new ModelAndView("jsonView", model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public void getFotoActivoById(Long idFoto, HttpServletRequest request,
			HttpServletResponse response) {

		FileItem fileItem = adapter.getFotoActivoById(idFoto).getAdjunto()
				.getFileItem();

		try {
			ServletOutputStream salida = response.getOutputStream();

			response.setHeader("Content-disposition", "inline");
			response.setHeader("Cache-Control",
					"must-revalidate, post-check=0,pre-check=0");
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
			e.printStackTrace();
		}

	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getFotosById(Long id, String tipoFoto, WebDto webDto,
			ModelMap model, HttpServletRequest request,
			HttpServletResponse response) {

		// Activo activo = activoApi.get(id);
		try {
			List<ActivoFoto> listaActivoFoto = adapter
					.getListFotosActivoById(id);

			List<DtoFoto> listaFotos = new ArrayList<DtoFoto>();

			if (listaActivoFoto != null) {

				for (int i = 0; i < listaActivoFoto.size(); i++) {

					DtoFoto fotoDto = new DtoFoto();

					if (listaActivoFoto.get(i).getTipoFoto() != null
							&& listaActivoFoto.get(i).getTipoFoto().getCodigo()
									.equals(tipoFoto)) {

						try {

							BeanUtils.copyProperty(fotoDto, "path",
									"/pfs/activo/getFotoActivoById.htm?idFoto="
											+ listaActivoFoto.get(i).getId());

							/*
							 * if (listaActivoFoto.get(i).getSubdivision() !=
							 * null) { BeanUtils.copyProperty(fotoDto,
							 * "subdivisionDescripcion",
							 * listaActivoFoto.get(i).getSubdivision
							 * ().getNombre()); }
							 */

							BeanUtils.copyProperties(fotoDto,
									listaActivoFoto.get(i));

							if (listaActivoFoto.get(i).getPrincipal() != null
									&& listaActivoFoto.get(i).getPrincipal()) {

								if (listaActivoFoto.get(i)
										.getInteriorExterior() != null) {
									if (listaActivoFoto.get(i)
											.getInteriorExterior()) {
										BeanUtils.copyProperty(fotoDto,
												"tituloFoto",
												"Principal INTERIOR");
									} else {
										BeanUtils.copyProperty(fotoDto,
												"tituloFoto",
												"Principal EXTERIOR");
									}
								}

							}

						} catch (IllegalAccessException e) {
							e.printStackTrace();
						} catch (InvocationTargetException e) {
							e.printStackTrace();
						}

						listaFotos.add(fotoDto);

					}

				}
			}

			model.put("data", listaFotos);

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

		return new ModelAndView("jsonView", model);
	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView updateFotosById(DtoFoto dtoFoto, ModelMap model) {

		try {
			boolean success = adapter.saveFoto(dtoFoto);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		model.put("success", true);

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.GET)
	public void getFotosByIdTemp(Long id, WebDto webDto, ModelMap model,
			HttpServletRequest request, HttpServletResponse response) {

		Activo activo = activoApi.get(id);

		List<DtoFoto> listaFotos = new ArrayList<DtoFoto>();

		if (activo.getFotos() != null) {

			for (int i = 0; i < activo.getFotos().size(); i++) {
				DtoFoto fotoDto = new DtoFoto();
				try {

					BeanUtils.copyProperties(fotoDto, activo.getFotos().get(i));
					BeanUtils.copyProperty(fotoDto, "fileItem", activo
							.getFotos().get(i).getAdjunto().getFileItem());
					BeanUtils.copyProperty(fotoDto, "path", activo.getFotos()
							.get(i).getAdjunto().getFileItem().getFile()
							.getPath());

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

						response.setHeader("Content-disposition",
								"attachment; filename="
										+ activo.getFotos().get(i).getAdjunto()
												.getFileItem().getFileName());
						response.setHeader("Cache-Control",
								"must-revalidate, post-check=0,pre-check=0");
						response.setHeader("Cache-Control", "max-age=0");
						response.setHeader("Expires", "0");
						response.setHeader("Pragma", "public");
						response.setDateHeader("Expires", 0); // prevents
																// caching at
																// the proxy
						response.setContentType(activo.getFotos().get(i)
								.getAdjunto().getFileItem().getContentType());

						// Write
						FileUtils.copy(activo.getFotos().get(i).getAdjunto()
								.getFileItem().getInputStream(), salida);
						salida.flush();
						salida.close();

					} catch (Exception e) {
						e.printStackTrace();
					}

				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaFotos.add(fotoDto);

			}
		}

		// model.put("data", adapter.getFotosById(id));

		// return new ModelAndView("jsonView", model);
	}

	@RequestMapping(method = RequestMethod.POST)
	// public ModelAndView insertarGestorAdicional(GestorEntidadDto
	// gestorEntidadDto, WebDto webDto, ModelMap model){
	public ModelAndView insertarGestorAdicional(Long idActivo,
			Long usuarioGestor, Long tipoGestor, WebDto webDto, ModelMap model) {

		try {
			GestorEntidadDto dto = new GestorEntidadDto();
			dto.setIdEntidad(idActivo);
			dto.setIdUsuario(usuarioGestor);
			dto.setIdTipoGestor(tipoGestor);

			boolean success = adapter.insertarGestorAdicional(dto);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		return new ModelAndView("jsonView", model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTramites(Long idActivo, WebDto webDto, ModelMap model) {

		model.put("data", adapter.getTramitesActivo(idActivo, webDto));

		return new ModelAndView("jsonView", model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getPreciosVigentesById(Long id, WebDto webDto, ModelMap model) {

		model.put("data", adapter.getPreciosVigentesById(id));

		return new ModelAndView("jsonView", model);
	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListPropietarioById(Long id, ModelMap model) {

		model.put("data", adapter.getListPropietarioById(id));

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListValoracionesById(Long id, WebDto webDto, ModelMap model) {

		model.put("data", adapter.getListValoracionesById(id));

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListTasacionById(Long id, ModelMap model) {

		model.put("data", adapter.getListTasacionById(id));

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdmisionCheckDocumentos(Long id, WebDto webDto, ModelMap model) {

		model.put("data", adapter.getListAdmisionCheckDocumentos(id));
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
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTramite(Long id, ModelMap model) {

		model.put("data", adapter.getTramite(id));

		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getComboInferiorMunicipio(String codigoMunicipio, WebDto webDto, ModelMap model){
		
		model.put("data", activoApi.getComboInferiorMunicipio(codigoMunicipio));
		
		return createModelAndViewJson(model);
		
	}

	/**
	 * Método que recupera las tareas activas de un trámite.
	 * 
	 * @param id
	 *            Id del trámite
	 * @return Listado de tareas asociadas al trámite y activas
	 * 
	 */
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTareasTramite( Long idTramite, WebDto webDto,  ModelMap model) {
		
		model.put("data", adapter.getTareasTramite(idTramite));

		return createModelAndViewJson(model);
	}

	/**
	 * Método que recupera las tareas de un trámite.
	 * 
	 * @param id
	 *            Id del trámite
	 * @return Listado de tareas asociadas al trámite y activas
	 */
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getTareasTramiteHistorico(Long idTramite, WebDto webDto, ModelMap model) {

		model.put("data", adapter.getTareasTramiteHistorico(idTramite));

		return createModelAndViewJson(model);
	}

	
	/**
	 * Método que recupera los activos de un trámite.
	 * 
	 * @param id
	 *            Id del trámite
	 * @return Listado de activos del tramite, tomando de cada activo un grupo de datos reducido
	 */
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
	 * @param id
	 *            Id del activo
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView crearTramite(Long idActivo, ModelMap model) {

		try {
			if(activoTramiteApi.existeTramiteAdmision(idActivo)){
				model.put("errorCreacion", "Ya existe un trámite de admisión para este activo");
				model.put("success", false);
			}else{
				if(activoApi.isVendido(idActivo)){
					model.put("errorCreacion", "No se puede lanzar un trámite de admisión de un activo vendido");
					model.put("success", false);
				}else{
					model.put("data", adapter.crearTramiteAdmision(idActivo));
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	/**
	 * Método que crea un nuevo trábajo a partir de un activo
	 * 
	 * @param id
	 *            Id del activo
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView crearTrabajo(DtoFichaTrabajo dtoTrabajo, Long idActivo) {

		boolean success = trabajoApi.saveFichaTrabajo(dtoTrabajo, idActivo);

		return createModelAndViewJson(new ModelMap("success", true));

	}

	/**
	 * 
	 * @param idActivo
	 * @param model
	 * @return
	 */
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveAdmisionDocumento(
			DtoAdmisionDocumento dtoAdmisionDocumento, ModelMap model) {

		try {

			boolean success = adapter.saveAdmisionDocumento(dtoAdmisionDocumento);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);
	}

	/**
	 * Recibe y guarda un adjunto
	 * 
	 * @param request
	 * @param response
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
			e.printStackTrace();
			model.put("success", false);
			model.put("errorMessage", "Ha habido un problema con la subida del fichero al gestor documental.");
		} catch (Exception e) {
			e.printStackTrace();
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
       		response.setDateHeader("Expires", 0); //prevents caching at the proxy
       		response.setContentType(fileItem.getContentType());       		
       		// Write
       		FileUtils.copy(fileItem.getInputStream(), salida);
       		salida.flush();
       		salida.close();
       	} catch (Exception e) { 
       		e.printStackTrace();
       	}

	}

	/**
	 * delete un adjunto.
	 * 
	 * @param asuntoId
	 *            long
	 * @param adjuntoId
	 *            long
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteAdjunto(DtoAdjunto dtoAdjunto, ModelMap model) {

		try {
			model.put("success", adapter.deleteAdjunto(dtoAdjunto));
		} catch (Exception e) {
			e.printStackTrace();
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
			e.printStackTrace();
			model.put("success", false);
			model.put("errorMessage", e.getMessage());
		}
		
		return createModelAndViewJson(model);

	}

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
	public ModelAndView uploadFoto(HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelMap model = new ModelMap();

		try {

			WebFileItem fileItem = uploadAdapter.getWebFileItem(request);

			String errores = activoApi.uploadFoto(fileItem);

			model.put("errores", errores);
			model.put("success", errores == null);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("errores", e.getCause());
		}
		return createModelAndViewJson(model);
		// return JsonViewer.createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteFotosActivoById(@RequestParam Long[] id,
			ModelMap model) {

		try {
			boolean success = adapter.deleteFotosActivoById(id);
			model.put("success", success);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findAllHistoricoPresupuestos(
			DtoHistoricoPresupuestosFilter dto, ModelMap model) {

		try {

			DtoPage page = adapter.findAllHistoricoPresupuestos(dto);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		// model.put("data", adapter.findAllHistoricoPresupuestos(dto));

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
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findAllIncrementosPresupuestoById(Long idPresupuesto,
			Long idActivo, ModelMap model) {

		try {

			if (idPresupuesto == null || idPresupuesto == 0) {
				idPresupuesto = activoApi.getUltimoPresupuesto(idActivo);
			}

			List<DtoIncrementoPresupuestoActivo> listaIncrementos = adapter
					.findAllIncrementosPresupuestoById(idPresupuesto);
			model.put("data", listaIncrementos);
			model.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView findLastPresupuesto(DtoActivosTrabajoFilter dto,
			ModelMap model) {

		try {

			// List<DtoPresupuestoGraficoActivo> presupuesto =
			// adapter.findLastPresupuesto(dto);
			DtoPresupuestoGraficoActivo presupuesto = adapter
					.findLastPresupuesto(dto);

			model.put("data", presupuesto);
			model.put("success", true);
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}
		// model.put("data", adapter.findAllHistoricoPresupuestos(dto));

		return createModelAndViewJson(model);

	}

	/**
	 * Método que recupera la foto principal de un activo
	 * 
	 * @param id
	 * @param model
	 * @param request
	 * @param response
	 */
	// TODO: Cuando esté el gestor documental, hacer que si el activo no tiene
	// foto devuelva una imagen tipo "Sin imagenes" por defecto.
	@RequestMapping(method = RequestMethod.GET)
	public void getFotoPrincipalById(Long id, ModelMap model,
			HttpServletRequest request, HttpServletResponse response) {

		List<ActivoFoto> listaActivoFoto = adapter
				.getListFotosActivoByIdOrderPrincipal(id);

		if (listaActivoFoto != null && !listaActivoFoto.isEmpty()) {

			FileItem fileItem = listaActivoFoto.get(0).getAdjunto()
					.getFileItem();
			try {
				ServletOutputStream salida = response.getOutputStream();

				response.setHeader("Content-disposition", "inline");
				response.setHeader("Cache-Control",
						"must-revalidate, post-check=0,pre-check=0");
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
				e.printStackTrace();
			}

		} else {
			try {
				// File menuItemsJsonFile = new
				// File(getClass().getResource("/").getPath()+"menuitems_"+tipo+"_"+MessageUtils.DEFAULT_LOCALE.getLanguage()+".json");

				ServletOutputStream salida = response.getOutputStream();

				response.setHeader("Content-disposition", "inline");
				response.setHeader("Cache-Control",
						"must-revalidate, post-check=0,pre-check=0");
				response.setHeader("Cache-Control", "max-age=0");
				response.setHeader("Expires", "0");
				response.setHeader("Pragma", "public");
				response.setDateHeader("Expires", 0); // prevents caching at the
														// proxy
				response.setContentType("Content-type: image/jpeg");

				File file = new File(getClass().getResource("/").getPath()
						+ "sin_imagen.png");
				file.createNewFile();
				FileInputStream fis = new FileInputStream(file);
				FileUtils.copy(fis, salida);
				salida.flush();
				salida.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

	}

	@RequestMapping(method = RequestMethod.GET)
	public void generateExcel(DtoActivoFilter dtoActivoFilter, HttpServletRequest request, HttpServletResponse response) throws Exception {

		dtoActivoFilter.setStart(excelReportGeneratorApi.getStart());
		dtoActivoFilter.setLimit(excelReportGeneratorApi.getLimit());
		
		@SuppressWarnings("unchecked")
		List<VBusquedaActivos> listaActivos = (List<VBusquedaActivos>) adapter.getActivos(dtoActivoFilter).getResults();
		
		//activoExcelReport.setListaActivos(listaActivos);
		List<DDRatingActivo> listaRating = utilDiccionarioApi.dameValoresDiccionarioSinBorrado(DDRatingActivo.class);
		Map<String,String> mapRating = new HashMap<String,String>();
		for (DDRatingActivo rating : listaRating) mapRating.put(rating.getCodigo(), rating.getDescripcion());
		
		
		ExcelReport report = new ActivoExcelReport(listaActivos, mapRating);
		
		excelReportGeneratorApi.generateAndSend(report, response);

	}
	

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCondicionantesDisponibilidad(Long id, ModelMap model){
		model.put("data", activoApi.getCondicionantesDisponibilidad(id));
		
		return createModelAndViewJson(model);
	}

	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView getHistoricoValoresPrecios(DtoHistoricoPreciosFilter dto, ModelMap model) {

		try {

			DtoPage page = activoApi.getHistoricoValoresPrecios(dto);

			model.put("data", page.getResults());
			model.put("totalCount", page.getTotalCount());
			model.put("success", true);

		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
		}

		return createModelAndViewJson(model);

	}
	

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getCondicionEspecificaByActivo(Long id, ModelMap model) {

		model.put("data", activoApi.getCondicionEspecificaByActivo(id));
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView createCondicionEspecifica(Long idEntidad, DtoCondicionEspecifica dtoCondicionEspecifica, ModelMap model) {

		model.put("success", activoApi.createCondicionEspecifica(idEntidad,dtoCondicionEspecifica));
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveCondicionEspecifica(DtoCondicionEspecifica dtoCondicionEspecifica, ModelMap model) {

		model.put("success", activoApi.saveCondicionEspecifica(dtoCondicionEspecifica));
		return createModelAndViewJson(model);
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getEstadoPublicacionByActivo(Long id, ModelMap model) {
		model.put("data", activoApi.getEstadoPublicacionByActivo(id));
		return createModelAndViewJson(model);
	}
	
}
