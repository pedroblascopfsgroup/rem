package es.pfsgroup.plugin.recovery.masivo;

import java.util.List;
import java.util.Map;

import es.pfsgroup.plugin.recovery.masivo.dto.MSVResultadoOperacionMasivaDto;

public interface MSVComponenteMasivoListener {
	
	String getNombreOperacionMasiva();

	@SuppressWarnings("rawtypes")
	MSVResultadoOperacionMasivaDto ejecuta(List<Long> lista, Map parameterMap);

}
