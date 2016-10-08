package es.pfsgroup.plugin.rem.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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
		public void portales(ModelMap model, RestRequestWrapper request,HttpServletResponse response) {
			
			PortalesRequestDto jsonData = null;		
			Activo activo = null;
			ActivoSituacionPosesoria activoSituacionPosesoria = null;
			List<PortalesDto> listaPortalesDto = null;
			List<String> errorList = null;
								
			try {
				jsonData = (PortalesRequestDto) request.getRequestData(PortalesRequestDto.class);
				listaPortalesDto = jsonData.getData();
				logger.debug("PETICIÓN: " + jsonData);
				
				errorList = new ArrayList<String>();
				
				for(int i=0; i < listaPortalesDto.size();i++){
					
					PortalesDto portalesDto = listaPortalesDto.get(i);
					errorList.add("");
					
					if (Checks.esNulo(portalesDto.getIdActivoHaya())) errorList.set(i, "No existe un valor IdActivoHaya en la llamada.");
					if (Checks.esNulo(portalesDto.getPublicado())) errorList.set(i, "No existe un valor Publicado en la llamada.");
					if (Checks.esNulo(portalesDto.getIdUsuarioRemAccion())) errorList.set(i, "No existe un valor IdUsuarioRemAccion en la llamada.");
					if (Checks.esNulo(portalesDto.getFechaAccion())) errorList.set(i, "No existe un valor FechaAccion en la llamada.");
					
					if (errorList.get(i).equals("")){
						
						activo = activoApi.get(portalesDto.getIdActivoHaya());
						if (activo == null) errorList.set(i, "No existe ningún activo con IdActivoHaya = "+portalesDto.getIdActivoHaya()+".");
						Usuario user = usuarioApi.get(portalesDto.getIdUsuarioRemAccion());
						if (Checks.esNulo(user)) errorList.set(i, "No existe ningún usuario con IdUsuarioRemAccion = "+portalesDto.getIdUsuarioRemAccion()+".");
						
						if (errorList.get(i).equals("")){
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
						}
					}

				}
				
				model.put("id", jsonData.getId());	
				model.put("error", errorList);
				
			} catch (Exception e) {
				
				e.printStackTrace();
				if (listaPortalesDto != null) {
					errorList = new ArrayList<String>();
					model.put("id", jsonData.getId());
					for(int i=0; i < listaPortalesDto.size();i++){
						errorList.add(e.getMessage());
					}
				} else {
					errorList = new ArrayList<String>();
					errorList.add(e.getMessage());
				}
				model.put("error", errorList);	
				
			}
			
			restApi.sendResponse(response, model);
		}
	
	
}
