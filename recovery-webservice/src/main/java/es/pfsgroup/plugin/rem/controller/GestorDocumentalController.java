package es.pfsgroup.plugin.rem.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

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
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoConfigDocumento;
import es.pfsgroup.plugin.rem.model.DtoSubirDocumento;

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

	@Autowired
	private ActivoAdapter adapter;

	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private GenericABMDao genericDao;


	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView upload(HttpServletRequest request, DtoSubirDocumento dto) {
		ModelMap model = new ModelMap();
		try {
			WebFileItem webFileItem = uploadAdapter.getWebFileItem(request);
			String entidad = webFileItem.getParameter("entidad");
			String idEntidad = webFileItem.getParameter("idEntidad"); 
			//redireccion de si viene de trabajo o activo
			if(entidad != null) {
				if(webFileItem.getParameter("entidad").equalsIgnoreCase("activo")) {
					adapter.upload(webFileItem);
				}else{
					trabajoApi.upload(webFileItem);
				}
			}
			if(!entidad.equals(null) && !idEntidad.equals(null) && dto != null) {
				guardarFormularioSubidaDocumento(idEntidad , entidad, dto);
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
	
	@RequestMapping(method = RequestMethod.POST)
	public void guardarFormularioSubidaDocumento(String idEntidad , String entidad, DtoSubirDocumento dto) throws ParseException {
		ActivoAdmisionDocumento activoAdmisionDocumento;
		ActivoConfigDocumento activoConfigDocumento;
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "activo.id",Long.parseLong(idEntidad));
		activoAdmisionDocumento = genericDao.get(ActivoAdmisionDocumento.class, f2);
		
		Filter activ = genericDao.createFilter(FilterType.EQUALS, "id",Long.parseLong(idEntidad));
		Activo activo = genericDao.get(Activo.class, activ);
		
		
		if(activoAdmisionDocumento != null) {
			activoAdmisionDocumento.getActivo();
		}else {
			SimpleDateFormat parser = new SimpleDateFormat("dd/MM/yyyy");
			
			
//			if(dto.getFechaObtencion() != null) {
//				//Date parser1 = new SimpleDateFormat("dd/MM/yyyy").parse(dto.getFechaCaducidad());
//				//Date fechaObtencion = parser.parse(dto.getFechaCaducidad());
//				activoAdmisionDocumento.setFechaObtencion(dto.getFechaObtencion());
//			}
			if(dto.getFechaCaducidad() != null) {
				Date fechaCaducidad = parser.parse(dto.getFechaCaducidad());
				activoAdmisionDocumento.setFechaObtencion(fechaCaducidad);
			}
//			if(dto.getFechaEmision() != null) {
//				//Date fechaEmesion = parser.parse(dto.getFechaEmision());
//				activoAdmisionDocumento.setFechaObtencion(dto.getFechaEmision());
//			}
//			if(dto.getFechaEtiqueta() != null) {
//				//Date fechaEtiqueta = parser.parse(dto.getFechaEtiqueta());
//				activoAdmisionDocumento.setFechaObtencion(dto.getFechaEtiqueta());
//			}
//			
//			if("SI".equalsIgnoreCase(dto.getAplica())) {
//				activoAdmisionDocumento.setAplica(true);
//			}else {
//				activoAdmisionDocumento.setAplica(false);
//			}
			activoAdmisionDocumento.setRegistro(dto.getRegistro());
			activoAdmisionDocumento.setActivo(activo);
			genericDao.save(ActivoAdmisionDocumento.class, activoAdmisionDocumento);
			
		}
		
	}
}
