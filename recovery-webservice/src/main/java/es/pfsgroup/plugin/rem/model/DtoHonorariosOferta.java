package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoHonorariosOferta extends WebDto {

	private static final long serialVersionUID = 1L;

	private String ofertaID;
	private String id;
	private String tipoComision;
	private String tipoProveedor;
	private String nombre;
	private String idProveedor;
	private String tipoCalculo;
	private String importeCalculo;
	private String honorarios;


	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getOfertaID() {
		return ofertaID;
	}
	public void setOfertaID(String ofertaID) {
		this.ofertaID = ofertaID;
	}
	public String getTipoComision() {
		return tipoComision;
	}
	public void setTipoComision(String tipoComision) {
		this.tipoComision = tipoComision;
	}
	public String getTipoProveedor() {
		return tipoProveedor;
	}
	public void setTipoProveedor(String tipoProveedor) {
		this.tipoProveedor = tipoProveedor;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getIdProveedor() {
		return idProveedor;
	}
	public void setIdProveedor(String idProveedor) {
		this.idProveedor = idProveedor;
	}
	public String getTipoCalculo() {
		return tipoCalculo;
	}
	public void setTipoCalculo(String tipoCalculo) {
		this.tipoCalculo = tipoCalculo;
	}
	public String getImporteCalculo() {
		return importeCalculo;
	}
	public void setImporteCalculo(String importeCalculo) {
		this.importeCalculo = importeCalculo;
	}
	public String getHonorarios() {
		return honorarios;
	}
	public void setHonorarios(String honorarios) {
		this.honorarios = honorarios;
	}

}