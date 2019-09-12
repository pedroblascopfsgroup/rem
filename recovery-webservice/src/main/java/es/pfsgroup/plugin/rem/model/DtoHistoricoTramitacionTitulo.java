package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPresentacion;



/**
 * Dto para el grid HistoricoTramitacionTitulo de los activos de Divarian
 * @author Julian Dolz
 *
 */
public class DtoHistoricoTramitacionTitulo extends WebDto {

	private static final long serialVersionUID = 0L;
	private Long idActivo;
	private Long idHistorico;
	private Long titulo;
	private Date fechaPresentacionRegistro;
	private Date fechaCalificacion;
	private Date fechaInscripcion;
	private String estadoPresentacion;
	private String codigoEstadoPresentacion;
	private String observaciones;
	private Integer tieneCalificacionNoSubsanada;
	
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Long getIdHistorico() {
		return idHistorico;
	}
	public void setIdHistorico(Long idHistorico) {
		this.idHistorico = idHistorico;
	}
	public Long getTitulo() {
		return titulo;
	}
	public void setTitulo(Long titulo) {
		this.titulo = titulo;
	}
	public Date getFechaPresentacionRegistro() {
		return fechaPresentacionRegistro;
	}
	public void setFechaPresentacionRegistro(Date fechaPresentacionRegistro) {
		this.fechaPresentacionRegistro = fechaPresentacionRegistro;
	}
	public Date getFechaCalificacion() {
		return fechaCalificacion;
	}
	public void setFechaCalificacion(Date fechaCalificacion) {
		this.fechaCalificacion = fechaCalificacion;
	}
	public Date getFechaInscripcion() {
		return fechaInscripcion;
	}
	public void setFechaInscripcion(Date fechaInscripcion) {
		this.fechaInscripcion = fechaInscripcion;
	}
	public String getEstadoPresentacion() {
		return estadoPresentacion;
	}
	public void setEstadoPresentacion(String estadoPresentacion) {
		this.estadoPresentacion = estadoPresentacion;
	}
	public String getCodigoEstadoPresentacion() {
		return codigoEstadoPresentacion;
	}
	public void setCodigoEstadoPresentacion(String codigoEstadoPresentacion) {
		this.codigoEstadoPresentacion = codigoEstadoPresentacion;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public Integer getTieneCalificacionNoSubsanada() {
		return tieneCalificacionNoSubsanada;
	}
	public void setTieneCalificacionNoSubsanada(Integer tieneCalificacionNoSubsanada) {
		this.tieneCalificacionNoSubsanada = tieneCalificacionNoSubsanada;
	}
	
	

}