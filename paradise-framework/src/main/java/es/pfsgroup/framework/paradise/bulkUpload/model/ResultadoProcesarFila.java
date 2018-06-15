package es.pfsgroup.framework.paradise.bulkUpload.model;

import java.util.HashMap;

import es.pfsgroup.commons.utils.Checks;

public class ResultadoProcesarFila {
	
	
	private boolean correcto = false;
	private String errorDesc = "";
	private int fila;
	
	HashMap<String, String> hMap = new HashMap<String, String>();

	public HashMap<String, String> gethMap() {
		return hMap;
	}

	public void sethMap(HashMap<String, String> hMap) {
		this.hMap = hMap;
	}
	
	

	public boolean isCorrecto() {
		return correcto;
	}

	public void setCorrecto(boolean correcto) {
		this.correcto = correcto;
	}

	public String getErrorDesc() {
		return errorDesc;
	}

	public void setErrorDesc(String errorDesc) {
		this.errorDesc = errorDesc;
	}

	public int getFila() {
		return fila;
	}

	public void setFila(int fila) {
		this.fila = fila;
	}

	public ResultadoProcesarFila() {
		this.hMap = new HashMap<String, String>();
	}
	
	public void addResultado(String clave,String valor) {
		this.hMap.put(clave, valor);
	}
	
	public String getResultado(String clave) {
		return this.hMap.get(clave);
	}
	
	public Boolean isHashmapVacio() {
		if(Checks.estaVacio(this.hMap)) {
			return true;
		}else {
			return false;
		}	
	}

}
