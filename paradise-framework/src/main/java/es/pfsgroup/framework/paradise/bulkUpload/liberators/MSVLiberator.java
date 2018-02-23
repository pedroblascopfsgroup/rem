package es.pfsgroup.framework.paradise.bulkUpload.liberators;

import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;

public interface MSVLiberator {
	
	int getFilaInicial();
	
	Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion);

	Boolean liberaFichero(MSVDocumentoMasivo fichero) throws Exception;
	
}
