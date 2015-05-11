package es.pfsgroup.plugin.recovery.masivo.utils.liberators;

import java.io.IOException;

import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDocumentoMasivo;

public interface MSVLiberator {
	
	Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion);

	Boolean liberaFichero(MSVDocumentoMasivo fichero) throws IllegalArgumentException, IOException;
	
}
