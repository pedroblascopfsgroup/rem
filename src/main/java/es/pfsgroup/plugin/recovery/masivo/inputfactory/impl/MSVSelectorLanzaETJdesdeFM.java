package es.pfsgroup.plugin.recovery.masivo.inputfactory.impl;

import java.util.Map;

import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.masivo.inputfactory.MSVSelectorTipoInput;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;

@Component
public class MSVSelectorLanzaETJdesdeFM implements MSVSelectorTipoInput{

	@Override
	public String getTipoInput(Map<String, Object> map) {
		return MSVDDOperacionMasiva.CODIGO_INPUT_LANZAR_ETJ_DESDE_FM;	
	}

	@Override
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {
		if (!Checks.esNulo(tipoOperacion)){
			if (MSVDDOperacionMasiva.CODIGO_LANZAMIENTO_ETJ_DESDE_FM.equals(tipoOperacion.getCodigo())){
				return true;
			}else {
				return false;
			}
		}else{
			return false;
		}
	}

	@Override
	public String getTipoResolucion() {
		return MSVDDOperacionMasiva.CODIGO_LANZAMIENTO_ETJ_DESDE_FM;
	}

}
