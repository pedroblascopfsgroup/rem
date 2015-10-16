package es.pfsgroup.recovery.integration.bpm;

import java.util.Map;

import es.pfsgroup.commons.utils.Checks;

public class DiccionarioDeCodigos {

	private final static String CODIGOS_PROCEDIMIENTO = "procedimientos";
	private final static String CODIGOS_TAREAS = "tareas";
	private final static String CODIGOS_DD = "dd";

	private final Map<String, Map<String, String>> diccionario;
	
	public DiccionarioDeCodigos(Map<String, Map<String, String>> diccionario) {
		this.diccionario=diccionario;
	}

	public Map<String, Map<String, String>> getDiccionario() {
		return diccionario;
	}

	public String getCodigoProcedimientoFinal(String codigoProcedimiento) {
		if (!diccionario.containsKey(CODIGOS_PROCEDIMIENTO) || Checks.esNulo(codigoProcedimiento)) {
			return codigoProcedimiento;
		}
		String valor = resolveKey(diccionario.get(CODIGOS_PROCEDIMIENTO), codigoProcedimiento, codigoProcedimiento);
		return valor;
	}

	public String getCodigoTareaFinal(String codigoTarea) {
		if (!diccionario.containsKey(CODIGOS_TAREAS) || Checks.esNulo(codigoTarea)) {
			return codigoTarea;
		}
		String valor = resolveKey(diccionario.get(CODIGOS_TAREAS), codigoTarea, codigoTarea);
		return valor;
	}

	public String getCodigoDDFinal(String codigoDD, String codigo) {
		if (Checks.esNulo(codigoDD) || Checks.esNulo(codigo)) {
			return codigo;
		}
		if (!diccionario.containsKey(CODIGOS_DD)) {
			return codigo;
		}
		String keyFinal = String.format("%s.%s", codigoDD, codigo);
		String valor = resolveKey(diccionario.get(CODIGOS_DD), keyFinal, codigo);
		return valor;
	}

	private String resolveKey(Map<String,String> map, String key, String defaultValue) {
		if (!map.containsKey(key)) {
			return defaultValue;
		}
		return map.get(key);
	}
	
}
