package es.pfsgroup.recovery.recobroCommon.cartera.dto;

import es.capgemini.devon.dto.WebDto;

public class RecobroDtoCartera  extends WebDto{


	private static final long serialVersionUID = -5830780712514804441L;
	
	private Long id;
	private String nombre;
	private String descripcion;
	private Long idEstado;
	private Long idEsquema;
	private Boolean notInEsquema;
	private String idRegla;
	private String fechaAlta;
	private String fechaAltaDesde;
	private String fechaAltaHasta;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getIdRegla() {
		return idRegla;
	}
	public void setIdRegla(String idRegla) {
		this.idRegla = idRegla;
	}
	public String getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(String fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public Long getIdEstado() {
		return idEstado;
	}
	public void setIdEstado(Long idEstado) {
		this.idEstado = idEstado;
	}
	public Long getIdEsquema() {
		return idEsquema;
	}
	public void setIdEsquema(Long idEsquema) {
		this.idEsquema = idEsquema;
	}
	public Boolean getNotInEsquema() {
		return notInEsquema;
	}
	public void setNotInEsquema(Boolean notInEsquema) {
		this.notInEsquema = notInEsquema;
	}
	public String getFechaAltaDesde() {
		return fechaAltaDesde;
	}
	public void setFechaAltaDesde(String fechaAltaDesde) {
		this.fechaAltaDesde = fechaAltaDesde;
	}
	public String getFechaAltaHasta() {
		return fechaAltaHasta;
	}
	public void setFechaAltaHasta(String fechaAltaHasta) {
		this.fechaAltaHasta = fechaAltaHasta;
	}

}
