package es.pfsgroup.plugin.recovery.iplus.controller;

import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.asunto.AsuntosManager;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Asunto;
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
		
		//Buscar el adjunto en Recovery y borrarlo	
		if (id == null || id.equals(0L)) {
			id = buscarIdAdjunto(asuntoId, nombre, descripcion);
		}
		if (id != null && !id.equals(0L)) {
			proxyFactory.proxy(GestionIplusApi.class).borrarAdjunto(asuntoId, id);
		}
		
		//Borrar el adjunto en IPLUS
		proxyFactory.proxy(GestionIplusApi.class).borrarAdjuntoIplus(asuntoId, nombre, descripcion);
		return "default";

	}

	private Long buscarIdAdjunto(Long idAsunto, String nombre,
			String descripcion) {
		
		Asunto asunto = proxyFactory.proxy(AsuntosManager.class).get(idAsunto);
        Set<AdjuntoAsunto> adjuntos = asunto.getAdjuntos();
        Long idAdjunto = null;
        for (AdjuntoAsunto adjuntoAsunto : adjuntos) {
        	if (adjuntoAsunto.getNombre().equalsIgnoreCase(nombre) || adjuntoAsunto.getNombre().equalsIgnoreCase(descripcion)) {
        		idAdjunto = adjuntoAsunto.getId();
        	}
		}
		return idAdjunto;
	}

}
