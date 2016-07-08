package es.pfsgroup.framework.paradise.bulkUpload.controller;

import java.util.ArrayList;
import java.util.List;

public class GridFilter {

	private String tipo;
	
	private String campoFiltrado;
	
	private String comparacion;
	
	private List<String> valoresFiltrado;

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	public String getCampoFiltrado() {
		return campoFiltrado;
	}

	public void setCampoFiltrado(String campoFiltrado) {
		this.campoFiltrado = campoFiltrado;
	}

	public List<String> getValoresFiltrado() {
		return valoresFiltrado;
	}

	public void setValoresFiltrado(List<String> valoresFiltrado) {
		this.valoresFiltrado = valoresFiltrado;
	}

	public String getComparacion() {
		return comparacion;
	}

	public void setComparacion(String comparacion) {
		this.comparacion = comparacion;
	}

	public List<String> getValoresFiltradoComas() {
		List<String> valores = new ArrayList<String>();
		for (String valor : this.valoresFiltrado) {
			valores.add("'"+valor+"'");
		}
		return valores;
	}

}
