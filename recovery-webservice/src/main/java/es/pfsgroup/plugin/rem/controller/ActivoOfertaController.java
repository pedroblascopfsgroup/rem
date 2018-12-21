package es.pfsgroup.plugin.rem.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.framework.paradise.controller.ParadiseJsonController;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalMaestroApi;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaOutputDto;
import es.pfsgroup.plugin.rem.adapter.ActivoOfertaAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;

@Controller
public class ActivoOfertaController extends ParadiseJsonController {
	
	@Autowired 
    private GestorDocumentalMaestroApi gestorDocumentalMaestroApi;
	
	@Autowired 
    private ActivoApi activoApi;	
	
	@Autowired 
    private UploadAdapter uploadAdapter;
	
	@Autowired 
    private ActivoOfertaAdapter activoOfertaAdapter;
	
	protected static final Log logger = LogFactory.getLog(ActivoController.class);
	
	private static final String DOC_ADJUNTO_CREAR_OFERTA = "Guardando documento adjunto crear oferta.";

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView getListAdjuntos(String docCliente, Long idActivo, HttpServletRequest request, HttpServletResponse response){

		Activo activo = activoApi.get(idActivo);
		
		PersonaInputDto personaInputDto = new PersonaInputDto();
		personaInputDto.setEvent(PersonaInputDto.EVENTO_IDENTIFICADOR_INTERVINIENTE_ORIGEN);
		personaInputDto.setIdOrigen(activo.getCartera().getCodigo());
		personaInputDto.setIdIntervinienteOrigen(PersonaInputDto.ID_INTERVINIENTE_ORIGEN);
		personaInputDto.setIdIntervinienteHaya(PersonaInputDto.ID_INTERVINIENTE_HAYA);
		personaInputDto.setIdCliente(docCliente);
		PersonaOutputDto personaOutputDto = gestorDocumentalMaestroApi.ejecutarPersona(personaInputDto);
		
		ModelMap model = new ModelMap();
		
		try {
			model.put("data", activoOfertaAdapter.getAdjunto(personaOutputDto.getIdIntervinienteHaya()));
		} catch (Exception e) {
			logger.error(e.getMessage());
			model.put("success", false);
			model.put("errorMessage", e.getMessage());
		}
		
		return createModelAndViewJson(model);
		
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView saveDocumentoAdjuntoOferta(String docCliente, Long idActivo, HttpServletRequest request, HttpServletResponse response) {

		Activo activo = activoApi.get(idActivo);
		
		PersonaInputDto personaInputDto = new PersonaInputDto();
		personaInputDto.setEvent(PersonaInputDto.EVENTO_IDENTIFICADOR_INTERVINIENTE_ORIGEN);
		personaInputDto.setIdOrigen(activo.getCartera().getCodigo());
		personaInputDto.setIdIntervinienteOrigen(PersonaInputDto.ID_INTERVINIENTE_ORIGEN);
		personaInputDto.setIdIntervinienteHaya(PersonaInputDto.ID_INTERVINIENTE_HAYA);
		personaInputDto.setIdCliente(docCliente);
		PersonaOutputDto personaOutputDto = gestorDocumentalMaestroApi.ejecutarPersona(personaInputDto);
		
		ModelMap model = new ModelMap();
		
		try {

			WebFileItem fileItem = uploadAdapter.getWebFileItem(request);
			
			String errores = activoOfertaAdapter.uploadDocumento(fileItem, personaOutputDto.getIdIntervinienteHaya(), null);
			model.put("errores", errores);
			model.put("success", errores==null);
		
		} catch (Exception e) {
			e.printStackTrace();
			model.put("success", false);
			model.put("errores", e.getMessage());
		}
		
		logger.info(DOC_ADJUNTO_CREAR_OFERTA);

		return createModelAndViewJson(model);
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView eliminarDocumentoAdjuntoOferta(Long id, WebDto webDto, ModelMap model) {
		
		model.put("data", "true");
		logger.info(DOC_ADJUNTO_CREAR_OFERTA);

		return createModelAndViewJson(model);
	}

}
