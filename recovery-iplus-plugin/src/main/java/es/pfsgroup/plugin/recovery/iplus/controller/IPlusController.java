package es.pfsgroup.plugin.recovery.iplus.controller;

import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.iplus.manager.GestionIplusApi;

@Controller
public class IPlusController implements IPlusControllerApi {

	private static final String JSP_FILE_ATTACHMENT = "plugin/bankiaWeb/fileAttachment";

	@Autowired
	private ApiProxyFactory proxyFactory;

	@RequestMapping
	public String bajarDocumento(ModelMap map, Long idAsunto, String nombre, String descripcion) {
		
        FileItem file = proxyFactory.proxy(GestionIplusApi.class).bajarAdjunto(idAsunto, nombre, descripcion);
        map.put("fileItem", file);
	 	return JSP_FILE_ATTACHMENT;

	}

	@RequestMapping
	public String borrarAdjunto(ModelMap map, Long asuntoId, Long id, String nombre, String descripcion) {
		
		String nombreAdjunto = (nombre == null ? null : nombre.toUpperCase());
		String descAdjunto = (descripcion == null ? null : descripcion.toUpperCase());
		
		System.out.println("[IPlusController.borrarAdjunto] 1: " + asuntoId + "-" + id + "-" + nombreAdjunto + "-" + descAdjunto);
		//Buscar el adjunto en Recovery y borrarlo	
		if (id == null || id.equals(0L)) {
			id = buscarIdAdjunto(asuntoId, nombreAdjunto, descAdjunto);
		}
		System.out.println("[IPlusController.borrarAdjunto] 2: " + asuntoId + "-" + id + "-" + nombreAdjunto + "-" + descAdjunto);
		if (id != null && !id.equals(0L)) {
			proxyFactory.proxy(GestionIplusApi.class).borrarAdjunto(asuntoId, id);
		}
		
		//Borrar el adjunto en IPLUS
		proxyFactory.proxy(GestionIplusApi.class).borrarAdjuntoIplus(asuntoId, nombreAdjunto, descAdjunto);
		return "default";

	}

	private Long buscarIdAdjunto(Long idAsunto, String nombre,
			String descripcion) {
	
		System.out.println("[IPlusController.buscarIdAdjunto]: " + idAsunto + "-" + nombre + "-" + descripcion);
        Long idAdjunto = null;
		
		Asunto asunto = proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
		if (asunto == null) {
			System.out.println("[IPlusController.buscarIdAdjunto]: asunto es nulo");			
		} else {
	        Set<AdjuntoAsunto> adjuntos = asunto.getAdjuntos();
	        if (adjuntos != null) {
		        for (AdjuntoAsunto adjuntoAsunto : adjuntos) {
		        	String nombreAAsunto = adjuntoAsunto.getNombre().toUpperCase();
		        	String descripcionAAsunto = adjuntoAsunto.getDescripcion();
					System.out.println("[IPlusController.buscarIdAdjunto]: nombreAAsunto=" + nombreAAsunto + 
							" -descripcionAAsunto=" + descripcionAAsunto);
					if ((nombre != null && nombre.endsWith(nombreAAsunto)) ||
							(descripcion != null && descripcion.endsWith(nombreAAsunto)) ) {
		        		idAdjunto = adjuntoAsunto.getId();
		        		break;
		        	}
				}
	        }
		}
		return idAdjunto;
	}

}
