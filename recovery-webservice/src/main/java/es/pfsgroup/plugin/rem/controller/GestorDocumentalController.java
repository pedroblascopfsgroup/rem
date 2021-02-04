package es.pfsgroup.plugin.rem.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalApi;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.DtoMetadatosEspecificos;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoConfigDocumento;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPresentacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDeDocumento;

@Controller
public class GestorDocumentalController extends ParadiseJsonController {

	protected static final Log logger = LogFactory.getLog(GestorDocumentalController.class);
	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_ERROR_KEY = "error";
	private static final String RESPONSE_MESSAGE_KEY = "msg";
	private static final String RESPONSE_ERROR_MESSAGE_KEY= "msgError";
	private static final String RESPONSE_TOTALCOUNT_KEY = "totalCount";
	private static final String ERROR_ACTIVO_NOT_EXISTS = "No existe el activo que esta buscando, pruebe con otro Nº de Activo";
	private static final String ERROR_ACTIVO_NO_NUMERICO = "El campo introducido es de carácter numérico";
	private static final String ERROR_GENERICO = "La operación no se ha podido realizar";
	private static final String ERROR_CONEXION_FOTOS = "Ha habido un error al conectar con CRM";
	private static final String ERROR_PRECIO_CERO = "No se puede realizar la operación. Está introduciendo un importe 0";
	SimpleDateFormat parser = new SimpleDateFormat("dd/MM/yyyy");

	@Autowired
	private ActivoAdapter activoAdapter;

	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private TrabajoApi trabajoApi;

	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
		

	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView upload(HttpServletRequest request, DtoMetadatosEspecificos dto) {
		ModelMap model = new ModelMap();
		try {
			WebFileItem webFileItem = uploadAdapter.getWebFileItem(request);
			String entidad = webFileItem.getParameter("entidad");
			String idEntidad = webFileItem.getParameter("idEntidad"); 
			String tipoDocumento = webFileItem.getParameter("tipo");
			Long idActivo = null;
			boolean tbjValidado = false;
			if( entidad != null && idEntidad != null && dto != null && tipoDocumento != null) {
				
				if(GestorDocumentalAdapterApi.ENTIDAD_ACTIVO.equalsIgnoreCase(entidad)) {
					idActivo = Long.parseLong(idEntidad);
					//tbjValidado = trabajoApi.activoTieneTrabajoValidadoByTipoDocumento(idActivo);
					activoAdapter.upload(webFileItem, dto);
				}else if(GestorDocumentalAdapterApi.ENTIDAD_TRABAJO.equalsIgnoreCase(entidad)){
					Trabajo trabajo = trabajoApi.findOne(Long.parseLong(idEntidad));
					Activo activo = trabajo.getActivo();
					if(activo != null) {
						idActivo = activo.getId();
					}
					trabajoApi.upload(webFileItem);
				}
				if(dto != null && idActivo != null) {				
					gestorDocumentalAdapterApi.guardarFormularioSubidaDocumento(idActivo, tipoDocumento, dto);
				}
				
			}

			model.put(RESPONSE_SUCCESS_KEY, true);			
		} catch (GestorDocumentalException e) {
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", "Ha habido un problema con la subida del fichero al gestor documental.");

		} catch (Exception e) {
			logger.error("error en activoController", e);
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put("errorMessage", "Ha habido un problema con la subida del fichero.");
		}

		return createModelAndViewJson(model);
	}
}
