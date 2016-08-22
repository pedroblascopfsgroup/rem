package es.pfsgroup.plugin.rem.pruebaws;

import java.sql.Time;
import java.util.Date;

/**
 * 
 * Dto para recibir el Web Service de la entidad Trabajo
 *
 */

public class DtoTrabajoWS {
	private Long idTrabajo;
	private Long idActivo;
	private Long idTipoTrabajo;
	private Date fechaAccion;
	private Time horaAccion;
	private String usuarioAccion;
	private String descripcion;
	private String codigoApi;
	
	//Datos Contacto
	private String nomContacto;
	private String tlfContacto;
	private String emailContacto;
	private String desContacto;
	
	//Requiriente
	private String nomRequiriente;
	private String tlfRequiriente;
	private String emailRequiriente;
	private String desRequiriente;
	private Long idPrioridad;
	private Date fechaPrioridad;
	private Time horaPrioridad;
	private Boolean urgente;
	private Boolean riesgo;
	
	
	public Long getIdTrabajo() {
		return idTrabajo;
	}
	public void setIdTrabajo(Long idTrabajo) {
		this.idTrabajo = idTrabajo;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Long getIdTipoTrabajo() {
		return idTipoTrabajo;
	}
	public void setIdTipoTrabajo(Long idTipoTrabajo) {
		this.idTipoTrabajo = idTipoTrabajo;
	}
	public Date getFechaAccion() {
		return fechaAccion;
	}
	public void setFechaAccion(Date fechaAccion) {
		this.fechaAccion = fechaAccion;
	}
	public Time getHoraAccion() {
		return horaAccion;
	}
	public void setHoraAccion(Time horaAccion) {
		this.horaAccion = horaAccion;
	}
	public String getUsuarioAccion() {
		return usuarioAccion;
	}
	public void setUsuarioAccion(String usuarioAccion) {
		this.usuarioAccion = usuarioAccion;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getCodigoApi() {
		return codigoApi;
	}
	public void setCodigoApi(String codigoApi) {
		this.codigoApi = codigoApi;
	}
	public String getNomContacto() {
		return nomContacto;
	}
	public void setNomContacto(String nomContacto) {
		this.nomContacto = nomContacto;
	}
	public String getTlfContacto() {
		return tlfContacto;
	}
	public void setTlfContacto(String tlfContacto) {
		this.tlfContacto = tlfContacto;
	}
	public String getEmailContacto() {
		return emailContacto;
	}
	public void setEmailContacto(String emailContacto) {
		this.emailContacto = emailContacto;
	}
	public String getDesContacto() {
		return desContacto;
	}
	public void setDesContacto(String desContacto) {
		this.desContacto = desContacto;
	}
	public String getNomRequiriente() {
		return nomRequiriente;
	}
	public void setNomRequiriente(String nomRequiriente) {
		this.nomRequiriente = nomRequiriente;
	}
	public String getTlfRequiriente() {
		return tlfRequiriente;
	}
	public void setTlfRequiriente(String tlfRequiriente) {
		this.tlfRequiriente = tlfRequiriente;
	}
	public String getEmailRequiriente() {
		return emailRequiriente;
	}
	public void setEmailRequiriente(String emailRequiriente) {
		this.emailRequiriente = emailRequiriente;
	}
	public String getDesRequiriente() {
		return desRequiriente;
	}
	public void setDesRequiriente(String desRequiriente) {
		this.desRequiriente = desRequiriente;
	}
	public Long getIdPrioridad() {
		return idPrioridad;
	}
	public void setIdPrioridad(Long idPrioridad) {
		this.idPrioridad = idPrioridad;
	}
	public Date getFechaPrioridad() {
		return fechaPrioridad;
	}
	public void setFechaPrioridad(Date fechaPrioridad) {
		this.fechaPrioridad = fechaPrioridad;
	}
	public Time getHoraPrioridad() {
		return horaPrioridad;
	}
	public void setHoraPrioridad(Time horaPrioridad) {
		this.horaPrioridad = horaPrioridad;
	}
	public Boolean getUrgente() {
		return urgente;
	}
	public void setUrgente(Boolean urgente) {
		this.urgente = urgente;
	}
	public Boolean getRiesgo() {
		return riesgo;
	}
	public void setRiesgo(Boolean riesgo) {
		this.riesgo = riesgo;
	}
}
