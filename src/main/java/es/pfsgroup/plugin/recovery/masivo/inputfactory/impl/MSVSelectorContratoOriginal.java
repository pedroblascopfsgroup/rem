package es.pfsgroup.plugin.recovery.masivo.inputfactory.impl;

import java.util.Map;

import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.masivo.inputfactory.MSVSelectorTipoInput;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;

@Component
public class MSVSelectorContratoOriginal implements MSVSelectorTipoInput{

	@Override
	public String getTipoInput(Map<String, Object> map) {
		if ( ("S".equals(map.get(COLUMNA_CONTRATO_NO_DISPONIBLE))) || ("SI".equals(map.get(COLUMNA_CONTRATO_NO_DISPONIBLE)))){
			return MSVDDOperacionMasiva.CODIGO_INPUT_CONTRATO_ORIGINAL_NO_RECIBIDO ;
		}else{
			return MSVDDOperacionMasiva.CODIGO_INPUT_CONTRATO_ORIGINAL_RECIBIDO;
		}
	}

	@Override
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {
		if (!Checks.esNulo(tipoOperacion)){
			if (MSVDDOperacionMasiva.CODIGO_CONFIRMAR_RECEPCION_ORIGINAL.equals(tipoOperacion.getCodigo())){
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
		return MSVDDOperacionMasiva.CODIGO_CONFIRMAR_RECEPCION_ORIGINAL;
	}

}
