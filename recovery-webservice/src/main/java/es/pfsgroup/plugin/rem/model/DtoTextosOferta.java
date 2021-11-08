package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;




/**
 * Dto para los textos de una oferta
 * @author Jose Villel
 *
 */
public class DtoTextosOferta extends WebDto{

	private static final long serialVersionUID = 0L;

	private Long id;
	private String campoCodigo;
	private String campoDescripcion;
	private String texto;
	private String fecha;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}

	public String getCampoCodigo() {
		return campoCodigo;
	}
	public void setCampoCodigo(String campoCodigo) {
		this.campoCodigo = campoCodigo;
	}
	public String getCampoDescripcion() {
		return campoDescripcion;
	}
	public void setCampoDescripcion(String campoDescripcion) {
		this.campoDescripcion = campoDescripcion;
	}
	public String getTexto() {
		return texto;
	}
	public void setTexto(String texto) {
		this.texto = texto;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	
	

	

}