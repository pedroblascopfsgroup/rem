package es.pfsgroup.plugin.rem.model;

public class DtoTipoAgrupacion extends DtoCondicionEspecifica {

	private Long idAgrupacion;
	private Integer idCodigo;
	private String descripcion;
	private String descripcionLarga;
	
	public Long getIdAgrupacion() {
		return idAgrupacion;
	}
	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}
	public Integer getIdCodigo() {
		return idCodigo;
	}
	public void setIdCodigo(Integer idCodigo) {
		this.idCodigo = idCodigo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getDescripcionLarga() {
		return descripcionLarga;
	}
	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}
	


}
