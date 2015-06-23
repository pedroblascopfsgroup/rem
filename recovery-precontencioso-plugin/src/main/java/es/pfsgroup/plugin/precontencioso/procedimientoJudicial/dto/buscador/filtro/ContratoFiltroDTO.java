package es.pfsgroup.plugin.precontencioso.procedimientoJudicial.dto.buscador.filtro;

import es.capgemini.devon.dto.WebDto;

public class ContratoFiltroDTO extends WebDto {

	private static final long serialVersionUID = -4813995130531970921L;

	private String codigo;	
	private String tipoProducto;
	private String nif;
	private String nombre;
	private String apellido;

	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getTipoProducto() {
		return tipoProducto;
	}
	public void setTipoProducto(String tipoProducto) {
		this.tipoProducto = tipoProducto;
	}
	public String getNif() {
		return nif;
	}
	public void setNif(String nif) {
		this.nif = nif;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getApellido() {
		return apellido;
	}
	public void setApellido(String apellido) {
		this.apellido = apellido;
	}
}
