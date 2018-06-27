package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de Visitas
 * @author Luis Caballero
 *
 */
public class DtoVisitasFilter extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long id;
	private Long numVisitaRem;
	private Long numActivo;
	private Long numActivoRem;
	private Long idActivo;
	private Long idAgrupacion;
	private Date fechaSolicitud;
	private String nombre;
	private String numDocumento;
	private Date fechaVisita;
	private String estadoVisita;
	private String carteraCodigo;
	

	public Long getNumVisitaRem() {
		return numVisitaRem;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public void setNumVisitaRem(Long numVisitaRem) {
		this.numVisitaRem = numVisitaRem;
	}
	public Long getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}
	public Long getNumActivoRem() {
		return numActivoRem;
	}
	public void setNumActivoRem(Long numActivoRem) {
		this.numActivoRem = numActivoRem;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Long getIdAgrupacion() {
		return idAgrupacion;
	}
	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}
	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}
	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getNumDocumento() {
		return numDocumento;
	}
	public void setNumDocumento(String numDocumento) {
		this.numDocumento = numDocumento;
	}
	public Date getFechaVisita() {
		return fechaVisita;
	}
	public void setFechaVisita(Date fechaVisita) {
		this.fechaVisita = fechaVisita;
	}
	public String getEstadoVisita() {
		return estadoVisita;
	}
	public void setEstadoVisita(String estadoVisita) {
		this.estadoVisita = estadoVisita;
	}
	public String getCarteraCodigo() {
		return carteraCodigo;
	}
	public void setCarteraCodigo(String carteraCodigo) {
		this.carteraCodigo = carteraCodigo;
	}	
}