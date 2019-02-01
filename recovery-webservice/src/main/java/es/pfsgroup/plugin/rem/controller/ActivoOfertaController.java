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
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.adapter.ActivoOfertaAdapter;
import es.pfsgroup.plugin.rem.clienteComercial.dao.ClienteComercialDao;
import es.pfsgroup.plugin.rem.model.AdjuntoComprador;
import es.pfsgroup.plugin.rem.model.ClienteComercial;
import es.pfsgroup.plugin.rem.model.ClienteGDPR;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.TmpClienteGDPR;

@Controller
public class ActivoOfertaController extends ParadiseJsonController {
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired 
    private UploadAdapter uploadAdapter;
	
	@Autowired 
    private ActivoOfertaAdapter activoOfertaAdapter;
	
	@Autowired
	private ClienteComercialDao clienteComercialDao;
	
	protected static final Log logger = LogFactory.getLog(ActivoOfertaController.class);
	
	private static final String RESPONSE_DATA_KEY = "data";
	private static final String RESPONSE_SUCCESS_KEY = "success";
	private static final String RESPONSE_ERROR_KEY = "error";
	private static final String RESPONSE_ERROR_MESSAGE_KEY = "errorMessage";
	private static final String DOC_ADJUNTO_CREAR_OFERTA = "Guardando documento adjunto crear oferta.";

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntos(String docCliente, Long idActivo, Long idAgrupacion){
		
		String idPersonaHaya = null;
		logger.error(">>>>>>>>>>>>>>>>>>> ENTRANDO EN METODO getListAdjuntos "+docCliente+" "+idActivo+" "+idAgrupacion);
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numDocumento", docCliente);
		ClienteGDPR clienteGDPR = genericDao.get(ClienteGDPR.class, filtro);
		if(!Checks.esNulo(clienteGDPR)) {
			ClienteComercial clienteCom = clienteGDPR.getCliente();
			if(!Checks.esNulo(clienteCom)) {
				idPersonaHaya = clienteCom.getIdPersonaHaya();
			} else {
				TmpClienteGDPR tmpClienteGDPR = genericDao.get(TmpClienteGDPR.class, genericDao.createFilter(FilterType.EQUALS, "numDocumento", docCliente));

				if(!Checks.esNulo(tmpClienteGDPR)) {
					idPersonaHaya = String.valueOf(tmpClienteGDPR.getIdPersonaHaya());
				}
			}
		} else {
			TmpClienteGDPR tmpClienteGDPR = genericDao.get(TmpClienteGDPR.class, genericDao.createFilter(FilterType.EQUALS, "numDocumento", docCliente));
			idPersonaHaya = String.valueOf(tmpClienteGDPR.getIdPersonaHaya());
			logger.error(">>>>>>>>>>>>>>>>>>>> REGISTRO EN TMP "+idPersonaHaya);
		}
		
		ModelMap model = new ModelMap();
		
		try {
			model.put(RESPONSE_DATA_KEY, activoOfertaAdapter.getAdjunto(idPersonaHaya, docCliente, idActivo, idAgrupacion));
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put(RESPONSE_SUCCESS_KEY, false);
			model.put(RESPONSE_ERROR_MESSAGE_KEY, e.getMessage());
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDocumentoAdjuntoOferta(String docCliente, String idEntidad, HttpServletRequest request) {
		
		TmpClienteGDPR tmpClienteGDPR;
		String idPersonaHaya = null;
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "numDocumento", docCliente);
		ClienteGDPR clienteGDPR = genericDao.get(ClienteGDPR.class, filtro);
		if(!Checks.esNulo(clienteGDPR)) {
			ClienteComercial clienteCom = clienteGDPR.getCliente();
			if(!Checks.esNulo(clienteCom)) {
				idPersonaHaya = clienteCom.getIdPersonaHaya();
			} else {
				tmpClienteGDPR = genericDao.get(TmpClienteGDPR.class, genericDao.createFilter(FilterType.EQUALS, "numDocumento", docCliente));
				
				if(!Checks.esNulo(tmpClienteGDPR)) {
					idPersonaHaya = String.valueOf(tmpClienteGDPR.getIdPersonaHaya());
				}
			}
		} else {
			tmpClienteGDPR = genericDao.get(TmpClienteGDPR.class, genericDao.createFilter(FilterType.EQUALS, "numDocumento", docCliente));
			idPersonaHaya = String.valueOf(tmpClienteGDPR.getIdPersonaHaya());
		}
		
		ModelMap model = new ModelMap();
		
		try {
			
			logger.error("------------------------------REQUEST:   "+ request);

			WebFileItem fileItem = uploadAdapter.getWebFileItem(request);
			
			List<DtoAdjunto> listaAdjuntos = activoOfertaAdapter.getAdjunto(idPersonaHaya, docCliente, null, null);
			if(listaAdjuntos.size() <= 0) {
				String errores = activoOfertaAdapter.uploadDocumento(fileItem, idPersonaHaya);
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
		
		Filter filtroCliente = genericDao.createFilter(FilterType.EQUALS, "numDocumento", docCliente);
		ClienteGDPR clienteGDPR = genericDao.get(ClienteGDPR.class, filtroCliente);
		ClienteComercial clienteCom = clienteGDPR.getCliente();
		
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

		boolean success = activoOfertaAdapter.deleteAdjunto(adjComprador, clienteGDPR);
		model.put(RESPONSE_SUCCESS_KEY, success);

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView deleteTmpClienteByDocumento(ModelMap model, String docCliente) {
		try {
			clienteComercialDao.deleteTmpClienteByDocumento(docCliente);
			model.put("success", true);
		} catch (Exception e) {
			model.put("success", false);
			logger.error("Error en ExpedienteComercialController", e);
		}

		return createModelAndViewJson(model);
	}
}
