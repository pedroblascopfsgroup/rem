package es.pfsgroup.framework.paradise.bulkUpload.liberators;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;

public interface MSVLiberator {
	
	Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion);

	Boolean liberaFichero(MSVDocumentoMasivo fichero) throws Exception;
	
}
