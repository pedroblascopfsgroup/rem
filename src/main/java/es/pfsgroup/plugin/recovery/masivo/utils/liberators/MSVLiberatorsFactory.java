package es.pfsgroup.plugin.recovery.masivo.utils.liberators;

import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;

/**
 * Factoría de liberadores
 * Devuelve el liberador correpondiente a un determinado tipo de operación
 * @author Carlos
 *
 */
public interface MSVLiberatorsFactory {
	
	MSVLiberator dameLiberator(MSVDDOperacionMasiva tipoOperacion);

}
