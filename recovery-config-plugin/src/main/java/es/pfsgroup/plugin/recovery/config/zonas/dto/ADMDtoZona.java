package es.pfsgroup.plugin.recovery.config.zonas.dto;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotEmpty;


public class ADMDtoZona {
	
	@NotNull
	@NotEmpty
	private String codigo;
	
	@NotNull
	@NotEmpty
	private String centro;
	
	@NotNull
	@NotEmpty
	private String descripcion;
	
	@NotNull
	@NotEmpty
	private String descripcionLarga;
	
	//private Zona  zonaPadre;
	
	//private String nivel;
	
	//private String oficina;

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCentro(String centro) {
		this.centro = centro;
	}

	public String getCentro() {
		return centro;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	//public void setZonaPadre(Zona zonaPadre) {
	//	this.zonaPadre = zonaPadre;
	//}

	//public String getZonaPadre() {
	//	return zonaPadre;
	//}

	//public void setNivel(String nivel) {
	//	this.nivel = nivel;
	//}

	//public String getNivel() {
	//	return nivel;
	//}

	//public void setOficina(String oficina) {
	//	this.oficina = oficina;
	//}

	//public String getOficina() {
	//	return oficina;
	//}

}
