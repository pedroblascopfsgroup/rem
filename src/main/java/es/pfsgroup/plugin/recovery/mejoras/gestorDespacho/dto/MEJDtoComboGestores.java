package es.pfsgroup.plugin.recovery.mejoras.gestorDespacho.dto;

import es.capgemini.devon.dto.WebDto;

public class MEJDtoComboGestores extends WebDto{

	
	/**
	 * 
	 */
	private static final long serialVersionUID = -5395013967789401552L;

	/**
	 * cadena que se va escribiendo en el combo
	 */
	private String query;
	
	/**
	 * tipo de despacho para poder buscar por
	 * depacho colaborador, externo, interno o procurador
	 */
	private String tipoDespacho;
	/**
	 * id del despacho colaborador seleccionado
	 */
	private Long id;
	
	/**
	 * Id del gestor utilizado para poder obtner la pagina para el combo
	 * */
	private Long codigo;
	public String getQuery() {
		return query;
	}
	public void setQuery(String query) {
		this.query = query;
	}
	public String getTipoDespacho() {
		return tipoDespacho;
	}
	public void setTipoDespacho(String tipoDespacho) {
		this.tipoDespacho = tipoDespacho;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public void setCodigo(Long codigo) {
		this.codigo = codigo;
	}
	public Long getCodigo() {
		return codigo;
	}
	
	
	

}
