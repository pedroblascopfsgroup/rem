package es.pfsgroup.plugin.recovery.masivo.utils.liberators;

import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;

/**
 * Factor�a de liberadores
 * Devuelve el liberador correpondiente a un determinado tipo de operaci�n
 * @author Carlos
 *
 */
public interface MSVLiberatorsFactory {
	
	MSVLiberator dameLiberator(MSVDDOperacionMasiva tipoOperacion);

}
