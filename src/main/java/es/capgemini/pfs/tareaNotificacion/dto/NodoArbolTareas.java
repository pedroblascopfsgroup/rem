package es.capgemini.pfs.tareaNotificacion.dto;

import java.util.List;

/**
 * Clase que representa un nodo del arbol de tareas.
 * @author pamuller
 *
 */
public class NodoArbolTareas {

	private List<NodoArbolTareas> hijos;
	private String codigoTexto;
	private String textoAlternativo;
	private String textoTituloTab;
	private String textoAlternativoTituloTab;
	private String flow;
	private boolean hoja;

	/**
	 * @return the hijos
	 */
	public List<NodoArbolTareas> getHijos() {
		return hijos;
	}
	/**
	 * @param hijos the hijos to set
	 */
	public void setHijos(List<NodoArbolTareas> hijos) {
		this.hijos = hijos;
	}
	/**
	 * @return the codigoTexto
	 */
	public String getCodigoTexto() {
		return codigoTexto;
	}
	/**
	 * @param codigoTexto the codigoTexto to set
	 */
	public void setCodigoTexto(String codigoTexto) {
		this.codigoTexto = codigoTexto;
	}
	/**
	 * @return the textoAlternativo
	 */
	public String getTextoAlternativo() {
		return textoAlternativo;
	}
	/**
	 * @param textoAlternativo the textoAlternativo to set
	 */
	public void setTextoAlternativo(String textoAlternativo) {
		this.textoAlternativo = textoAlternativo;
	}
	/**
	 * @return the textoTituloTab
	 */
	public String getTextoTituloTab() {
		return textoTituloTab;
	}
	/**
	 * @param textoTituloTab the textoTituloTab to set
	 */
	public void setTextoTituloTab(String textoTituloTab) {
		this.textoTituloTab = textoTituloTab;
	}
	/**
	 * @return the textoAlternativoTituloTab
	 */
	public String getTextoAlternativoTituloTab() {
		return textoAlternativoTituloTab;
	}
	/**
	 * @param textoAlternativoTituloTab the textoAlternativoTituloTab to set
	 */
	public void setTextoAlternativoTituloTab(String textoAlternativoTituloTab) {
		this.textoAlternativoTituloTab = textoAlternativoTituloTab;
	}
	/**
	 * @return the flow
	 */
	public String getFlow() {
		return flow;
	}
	/**
	 * @param flow the flow to set
	 */
	public void setFlow(String flow) {
		this.flow = flow;
	}
	/**
	 * @return the hoja
	 */
	public boolean getHoja() {
		return hoja;
	}
	/**
	 * @param hoja the hoja to set
	 */
	public void setHoja(boolean hoja) {
		this.hoja = hoja;
	}

}
