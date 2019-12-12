package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoAgrupacion;

public interface  ActivoAdjuntosAgrupacionApi {

	//public FileItem getFileItemAdjunto(Long id);
	
	public List<DtoAdjuntoAgrupacion> getAdjuntos(Long idAgrupacion);
	
	public FileItem download(Long id) throws Exception;
	
	public FileItem getFileItemAdjunto(Long id, Long idAgrupacion) throws Exception;

	String uploadDocumento(WebFileItem webFileItem, Long idDocRestClient, ActivoAgrupacion agrupacion, String matricula, Usuario usuarioLogado) throws Exception;

	Boolean deleteAdjunto(DtoAdjunto dtoAdjunto);
    
}
