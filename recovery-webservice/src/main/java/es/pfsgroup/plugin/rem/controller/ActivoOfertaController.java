package es.pfsgroup.plugin.rem.controller;

import java.util.List;

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
import es.pfsgroup.plugin.rem.adapter.ActivoOfertaAdapter;
import es.pfsgroup.plugin.rem.model.AdjuntoComprador;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.ClienteGDPR;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;

@Controller
public class ActivoOfertaController extends ParadiseJsonController {
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired 
    private UploadAdapter uploadAdapter;
	
	@Autowired 
    private ActivoOfertaAdapter activoOfertaAdapter;
	
	protected static final Log logger = LogFactory.getLog(ActivoOfertaController.class);
	
	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_ERROR_KEY = "error";
	private static final String RESPONSE_ERROR_MESSAGE_KEY = "errorMessage";
	private static final String DOC_ADJUNTO_CREAR_OFERTA = "Guardando documento adjunto crear oferta.";

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntos(String docCliente, String idActivo, String idAgrupacion){
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "documento", docCliente);
		ClienteComercial clienteCom = genericDao.get(ClienteComercial.class, filtro);
		
		ModelMap model = new ModelMap();
		
		try {
			model.put(RESPONSE_DATA_KEY, activoOfertaAdapter.getAdjunto(clienteCom.getIdPersonaHaya(), docCliente, idActivo, idAgrupacion));
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, e.getMessage());
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDocumentoAdjuntoOferta(String docCliente, HttpServletRequest request) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "documento", docCliente);
		ClienteComercial clienteCom = genericDao.get(ClienteComercial.class, filtro);
		
		ModelMap model = new ModelMap();
		
		try {

			WebFileItem fileItem = uploadAdapter.getWebFileItem(request);
			
			List<DtoAdjunto> listaAdjuntos = activoOfertaAdapter.getAdjunto(clienteCom.getIdPersonaHaya(), docCliente, null, null);
			if(listaAdjuntos.size() <= 0) {
				String errores = activoOfertaAdapter.uploadDocumento(fileItem, clienteCom.getIdPersonaHaya());
				model.put("errores", errores);
				model.put(RESPONSE_SUCCESS_KEY, errores==null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_KEY, e.getMessage());
		}
		
		logger.info(DOC_ADJUNTO_CREAR_OFERTA);

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView eliminarDocumentoAdjuntoOferta(String docCliente) {
		
		Filter filtroCliente = genericDao.createFilter(FilterType.EQUALS, "documento", docCliente);
		ClienteComercial clienteCom = genericDao.get(ClienteComercial.class, filtroCliente);
		
		ModelMap model = new ModelMap();
		
		List<DtoAdjunto> listaAdjuntos = null;
		try {
			listaAdjuntos = activoOfertaAdapter.getAdjunto(clienteCom.getIdPersonaHaya(), docCliente, null, null);						
		} catch (GestorDocumentalException e) {
			e.printStackTrace();
		}
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idDocRestClient", listaAdjuntos.get(0).getId());
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		AdjuntoComprador adjComprador = genericDao.get(AdjuntoComprador.class, filtro, filtroBorrado);
		
		//Filtro para conseguir el ClienteGDPR a traves del Cliente Comercial
		Filter filtroClienteGDPR = genericDao.createFilter(FilterType.EQUALS, "cliente", clienteCom);
		ClienteGDPR clienteGDPR = (ClienteGDPR) genericDao.get(ClienteGDPR.class, filtroClienteGDPR);

		boolean success = activoOfertaAdapter.deleteAdjunto(adjComprador, clienteGDPR);
		model.put(RESPONSE_SUCCESS_KEY, success);

		return createModelAndViewJson(model);
	}
}
