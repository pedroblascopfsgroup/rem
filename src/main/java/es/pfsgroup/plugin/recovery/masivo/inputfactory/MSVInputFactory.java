package es.pfsgroup.plugin.recovery.masivo.inputfactory;

import java.util.Map;

import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;

/**
 * Factoría de inputs
 * Devuelve el tipo selector correpondiente a un determinado tipo de operación
 * @author Diana
 *
 */
public interface MSVInputFactory {
	
	MSVSelectorTipoInput dameSelector(MSVDDOperacionMasiva tipoOperacion, Map<String, Object> map);

}
