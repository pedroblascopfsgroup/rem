package es.pfsgroup.framework.paradise.bulkUpload.liberators;

import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;

/**
 * Factor�a de liberadores
 * Devuelve el liberador correpondiente a un determinado tipo de operaci�n
 * @author Carlos
 *
 */
public interface MSVLiberatorsFactory {
	
	MSVLiberator dameLiberator(MSVDDOperacionMasiva tipoOperacion);

}
