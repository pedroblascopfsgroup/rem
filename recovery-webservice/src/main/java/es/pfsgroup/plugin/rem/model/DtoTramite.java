package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para mostrar el detalle de los trámites
 * @author Daniel Gutiérrez
 *
 */
public class DtoTramite extends WebDto {

	private static final long serialVersionUID = 0L;
	
	private Long idTramite;

	private Long idTipoTramite;
	
	private String tipoTramite;
	
	private Long idTramitePadre;

	private Long idActivo;
	
	private String nombre;
	
	private String estado;
	
	private Long idTrabajo;
	
	private Long numTrabajo;
	
	private String cartera;
	
	private Date fechaInicio;
	
	private Date fechaFinalizacion;
	
	private String tipoTrabajo;
	
	private String subtipoTrabajo;
	
	private String tipoActivo;
	
	private String subtipoActivo;
	
	private Long numActivo;
	
	private Boolean esMultiActivo;
	
	private Long countActivos;
	

	public Long getIdTramite() {
		return idTramite;
	}

	public void setIdTramite(Long idTramite) {
		this.idTramite = idTramite;
	}

	public Long getIdTipoTramite() {
		return idTipoTramite;
	}

	public void setIdTipoTramite(Long idTipoTramite) {
		this.idTipoTramite = idTipoTramite;
	}

	public String getTipoTramite() {
		return tipoTramite;
	}

	public void setTipoTramite(String tipoTramite) {
		this.tipoTramite = tipoTramite;
	}

	public Long getIdTramitePadre() {
		return idTramitePadre;
	}

	public void setIdTramitePadre(Long idTramitePadre) {
		this.idTramitePadre = idTramitePadre;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}
	
	public Long getIdTrabajo(){
		return idTrabajo;
	}
	
	public void setIdTrabajo(Long idTrabajo){
		this.idTrabajo = idTrabajo;
	}
	
	public Long getNumTrabajo() {
		return numTrabajo;
	}

	public void setNumTrabajo(Long numTrabajo) {
		this.numTrabajo = numTrabajo;
	}

	public String getCartera(){
		return cartera;
	}
	
	public void setCartera(String cartera){
		this.cartera = cartera;
	}
	
	public Date getFechaInicio(){
		return fechaInicio;
	}
	
	public void setFechaInicio(Date fechaInicio){
		this.fechaInicio = fechaInicio;
	}
	
	public Date getFechaFinalizacion(){
		return fechaFinalizacion;
	}
	
	public void setFechaFinalizacion(Date fechaFin){
		this.fechaFinalizacion = fechaFin;
	}
	
	public String getTipoTrabajo() {
		return tipoTrabajo;
	}

	public void setTipoTrabajo(String tipoTrabajo) {
		this.tipoTrabajo = tipoTrabajo;
	}

	public String getSubtipoTrabajo() {
		return subtipoTrabajo;
	}

	public void setSubtipoTrabajo(String subtipoTrabajo) {
		this.subtipoTrabajo = subtipoTrabajo;
	}	
	
	public String getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(String tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public String getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(String subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public Boolean getEsMultiActivo() {
		return esMultiActivo;
	}
	
	public void setEsMultiActivo(Boolean esMultiActivo) {
		this.esMultiActivo = esMultiActivo;
	}

	public Long getCountActivos() {
		return countActivos;
	}

	public void setCountActivos(Long countActivos) {
		this.countActivos = countActivos;
	}
	
}