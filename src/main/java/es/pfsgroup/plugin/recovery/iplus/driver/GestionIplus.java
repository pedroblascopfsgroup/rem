package es.pfsgroup.plugin.recovery.iplus.driver;

import java.io.File;
import java.util.List;
import java.util.Properties;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.plugin.recovery.iplus.IplusDocDto;

public interface GestionIplus {

	void almacenar(String idProcedi, int orden, String nombreFichero,
			File file);

	List<IplusDocDto> listaDocumentos(String idProcedi);

	FileItem abrirDocumento(String idProcedi, String nombre, String descripcion);

	void borrarDocumento(String idProcedi, String nombre, String descripcion);

	void modificarDocumento(String idProcedi, int orden,
			String nombreFichero, IplusDocDto dto);
	
	void setAppProperties(Properties appProperties);
	
}
