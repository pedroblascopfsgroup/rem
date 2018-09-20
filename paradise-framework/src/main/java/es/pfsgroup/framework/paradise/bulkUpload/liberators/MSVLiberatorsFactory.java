package es.pfsgroup.framework.paradise.bulkUpload.liberators;

import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;

/**
 * Factoría de liberadores
 * Devuelve el liberador correpondiente a un determinado tipo de operación
 * @author Carlos
 *
 */
public interface MSVLiberatorsFactory {
	
	MSVLiberator dameLiberator(MSVDDOperacionMasiva tipoOperacion);

}
