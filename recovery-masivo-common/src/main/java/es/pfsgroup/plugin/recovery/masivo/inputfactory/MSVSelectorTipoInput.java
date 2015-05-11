package es.pfsgroup.plugin.recovery.masivo.inputfactory;

import java.util.Map;

import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;

public interface MSVSelectorTipoInput {
	
	public static final String COLUMNA_CONTRATO_NO_DISPONIBLE = "Contrato no disponible";
	public static final String COLUMNA_VALIDADO = "Validado (SI/NO)";
	public static final String COLUMNA_PRESENTACION_MANUAL = "Presentacion manual";
	
	Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion);

	String getTipoInput(Map<String, Object> map);
	
	String getTipoResolucion();

}
