package es.pfsgroup.plugin.rem.model;

import java.util.HashMap;

import es.pfsgroup.commons.utils.Checks;

public class ResultadoProcesarFila {
	
	HashMap<String, String> hMap;

	public HashMap<String, String> gethMap() {
		return hMap;
	}

	public void sethMap(HashMap<String, String> hMap) {
		this.hMap = hMap;
	}

	public ResultadoProcesarFila() {
		this.hMap = new HashMap<String, String>();
	}
	
	public void addResultado(String clave,String valor) {
		this.hMap.put(clave, valor);
	}
	
	public Boolean isHashmapVacio() {
		if(Checks.estaVacio(this.hMap)) {
			return true;
		}else {
			return false;
		}	
	}

}
