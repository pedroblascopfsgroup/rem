package es.pfsgroup.plugin.rem.gestorDocumental.api;

import java.util.List;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.GastoProveedor;

public interface GestorDocumentalAdapterApi {
	
	List<DtoAdjunto> getAdjuntosActivo (Activo activo) throws GestorDocumentalException;
	
	FileItem getFileItem(Long idDocumento) throws Exception; 
	
	Long upload(Activo activo, WebFileItem webFileItem, String userLogin, String matricula) throws Exception;
	
	Long uploadDocumentoGasto(GastoProveedor gasto, WebFileItem webFileItem, String userLogin, String matricula) throws Exception;
	
	boolean borrarAdjunto(Long idDocumento, String usuarioLogado);

	boolean modoRestClientActivado();

}
