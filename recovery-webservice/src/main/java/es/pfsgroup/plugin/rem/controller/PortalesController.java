package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.PortalesDto;
import es.pfsgroup.plugin.rem.rest.dto.PortalesRequestDto;
import es.pfsgroup.plugin.rem.rest.filter.RestRequestWrapper;

@Controller
public class PortalesController {

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private UsuarioManager usuarioApi;

	private final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private RestApi restApi;

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.POST, value = "/portales")
	public void portales(ModelMap model, RestRequestWrapper request, HttpServletResponse response) {

		PortalesRequestDto jsonData = null;
		Activo activo = null;
		ActivoSituacionPosesoria activoSituacionPosesoria = null;
		List<PortalesDto> listaPortalesDto = null;
		HashMap<String, List<String>> errorsList = null;
		ArrayList<Map<String, Object>> listaRespuesta = new ArrayList<Map<String, Object>>();
		

		try {
			jsonData = (PortalesRequestDto) request.getRequestData(PortalesRequestDto.class);
			listaPortalesDto = jsonData.getData();
			logger.debug("PETICIÓN: " + jsonData);

			for (int i = 0; i < listaPortalesDto.size(); i++) {

				PortalesDto portalesDto = listaPortalesDto.get(i);
				errorsList = restApi.validateRequestObject(portalesDto, TIPO_VALIDACION.INSERT);
				if (errorsList.size() == 0) {

					activo = activoApi.get(portalesDto.getIdActivoHaya());
					Usuario user = usuarioApi.get(portalesDto.getIdUsuarioRemAccion());

					if (activo.getSituacionPosesoria() == null) {

						Date fechaCrear = new Date();
						activoSituacionPosesoria = new ActivoSituacionPosesoria();
						activoSituacionPosesoria.getAuditoria().setUsuarioCrear(user.getUsername());
						activoSituacionPosesoria.getAuditoria().setFechaCrear(fechaCrear);
						activoSituacionPosesoria.setActivo(activo);
						activo.setSituacionPosesoria(activoSituacionPosesoria);

					}

					activoSituacionPosesoria = activo.getSituacionPosesoria();
					activoSituacionPosesoria.setPublicadoPortalExterno(portalesDto.getPublicado());

					Date fechaMod = new Date();
					activoSituacionPosesoria.getAuditoria().setUsuarioModificar(user.getUsername());
					activoSituacionPosesoria.getAuditoria().setFechaModificar(fechaMod);

					activoApi.saveOrUpdate(activo);
				}

			}

			model.put("id", jsonData.getId());
			model.put("invalidFields", errorsList);

		} catch (Exception e) {

			logger.error(e);
			model.put("error", RestApi.REST_MSG_UNEXPECTED_ERROR);

		}

		restApi.sendResponse(response, model);
	}

}
