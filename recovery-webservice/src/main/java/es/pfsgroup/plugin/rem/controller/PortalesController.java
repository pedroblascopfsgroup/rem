package es.pfsgroup.plugin.rem.controller;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
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

		@SuppressWarnings("unchecked")
		@RequestMapping(method = RequestMethod.POST, value = "/portales")
		public ModelAndView portales(ModelMap model, RestRequestWrapper request) {
			
			PortalesRequestDto jsonData = null;		
			Activo activo = null;
			ActivoSituacionPosesoria activoSituacionPosesoria = null;
			PortalesDto portalesDto = null;
								
			try {
				jsonData = (PortalesRequestDto) request.getRequestData(PortalesRequestDto.class);
				portalesDto = jsonData.getData();
				logger.debug("PETICIÓN: " + jsonData);
				
				if (Checks.esNulo(portalesDto.getIdActivoHaya())) throw new Exception("No existe un valor IdActivoHaya en la llamada.");
				if (Checks.esNulo(portalesDto.getPublicado())) throw new Exception("No existe un valor Publicado en la llamada.");
				if (Checks.esNulo(portalesDto.getIdUsuarioRemAccion())) throw new Exception("No existe un valor IdUsuarioRemAccion en la llamada.");
				if (Checks.esNulo(portalesDto.getFechaAccion())) throw new Exception("No existe un valor FechaAccion en la llamada.");
				
				activo = activoApi.get(portalesDto.getIdActivoHaya());
				if (activo == null) throw new Exception("No existe ningun activo con IdActivoHaya = "+portalesDto.getIdActivoHaya()+".");

				Usuario user = usuarioApi.get(portalesDto.getIdUsuarioRemAccion());
				if (Checks.esNulo(user)) throw new Exception("No existe ningun usuario con IdUsuarioRemAccion = "+portalesDto.getIdUsuarioRemAccion()+".");
				
				if (activo.getSituacionPosesoria() == null) {	
					
					Date fechaCrear =  new Date();
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
				
				model.put("id", jsonData.getId());	
				model.put("error", "");
				
			} catch (Exception e) {
				
				e.printStackTrace();
				model.put("id", jsonData.getId());	
				model.put("error", e.getMessage());	
				
			}
			
			return new ModelAndView("jsonView", model);
		}
	
	
}
