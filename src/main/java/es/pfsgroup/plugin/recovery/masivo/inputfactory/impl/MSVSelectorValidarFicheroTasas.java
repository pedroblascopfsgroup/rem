package es.pfsgroup.plugin.recovery.masivo.inputfactory.impl;

import java.util.Map;

import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.masivo.inputfactory.MSVSelectorTipoInput;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;

@Component
public class MSVSelectorValidarFicheroTasas implements MSVSelectorTipoInput{

	@Override
	public String getTipoInput(Map<String, Object> map) {
		if ("KO".equals(map.get(COLUMNA_VALIDADO))  || "NO".equals(map.get(COLUMNA_VALIDADO))  || "N".equals(map.get(COLUMNA_VALIDADO))){
			return MSVDDOperacionMasiva.CODIGO_INPUT_FICHERO_TASAS_NO_VALIDADO;
		} else if ( ("S".equals(map.get(COLUMNA_PRESENTACION_MANUAL))) || ("SI".equals(map.get(COLUMNA_PRESENTACION_MANUAL))) ){
			return MSVDDOperacionMasiva.CODIGO_INPUT_FICHERO_TASAS_MANUAL;
		} else {
			return MSVDDOperacionMasiva.CODIGO_INPUT_FICHERO_TASAS_VALIDADO;
		}
	}

	@Override
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {
		if (!Checks.esNulo(tipoOperacion)){
			if (MSVDDOperacionMasiva.CODIGO_VALIDAR_FICHERO_TASAS.equals(tipoOperacion.getCodigo())){
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
		return MSVDDOperacionMasiva.CODIGO_VALIDAR_FICHERO_TASAS;
	}

}
