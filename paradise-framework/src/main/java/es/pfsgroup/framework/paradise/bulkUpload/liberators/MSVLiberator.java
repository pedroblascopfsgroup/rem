package es.pfsgroup.framework.paradise.bulkUpload.liberators;

import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;

public interface MSVLiberator {
	
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion);

	public Boolean liberaFichero(MSVDocumentoMasivo fichero) throws Exception;
	
}
