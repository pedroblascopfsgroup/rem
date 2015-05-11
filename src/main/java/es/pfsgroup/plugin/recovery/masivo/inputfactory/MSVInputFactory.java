package es.pfsgroup.plugin.recovery.masivo.inputfactory;

import java.util.Map;

import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;

/**
 * Factor�a de inputs
 * Devuelve el tipo selector correpondiente a un determinado tipo de operaci�n
 * @author Diana
 *
 */
public interface MSVInputFactory {
	
	MSVSelectorTipoInput dameSelector(MSVDDOperacionMasiva tipoOperacion, Map<String, Object> map);

}
