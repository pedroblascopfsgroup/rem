package es.pfsgroup.plugin.rem.model;


import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el grid de listado de Pujas de la ventana de ofertas de concurrencia en comercial del activo
 */
public class DtoPujaDetalle extends WebDto {
	private static final long serialVersionUID = 0L;

	private Long id;
	private Long idActivo;
	private Long idOferta;
	private Long idConcurrencia;
	private Double importePuja;
	private Date fechaCrear;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Long getIdOferta() {
		return idOferta;
	}
	public void setIdOferta(Long idOferta) {
		this.idOferta = idOferta;
	}
	public Long getIdConcurrencia() {
		return idConcurrencia;
	}
	public void setIdConcurrencia(Long idConcurrencia) {
		this.idConcurrencia = idConcurrencia;
	}
	public Double getImportePuja() {
		return importePuja;
	}
	public void setImportePuja(Double importePuja) {
		this.importePuja = importePuja;
	}
	public Date getFechaCrear() {
		return fechaCrear;
	}
	public void setFechaCrear(Date fechaCrear) {
		this.fechaCrear = fechaCrear;
	}
	
}