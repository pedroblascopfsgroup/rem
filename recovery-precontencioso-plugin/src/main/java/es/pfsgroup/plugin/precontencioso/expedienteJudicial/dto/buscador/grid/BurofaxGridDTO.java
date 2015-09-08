package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.grid;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class BurofaxGridDTO extends WebDto {

	private static final long serialVersionUID = 4729267154334892104L;

	private String estado;
	private String nif;
	private String apellidoNombre;
	private Date fechaSolicitud;
	private Date fechaEnvio;
	private Date fechaAcuse;
	private Boolean resultado;

	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public String getNif() {
		return nif;
	}
	public void setNif(String nif) {
		this.nif = nif;
	}
	public String getApellidoNombre() {
		return apellidoNombre;
	}
	public void setApellidoNombre(String apellidoNombre) {
		this.apellidoNombre = apellidoNombre;
	}
	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}
	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}
	public Date getFechaEnvio() {
		return fechaEnvio;
	}
	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}
	public Date getFechaAcuse() {
		return fechaAcuse;
	}
	public void setFechaAcuse(Date fechaAcuse) {
		this.fechaAcuse = fechaAcuse;
	}
	public Boolean getResultado() {
		return resultado;
	}
	public void setResultado(Boolean resultado) {
		this.resultado = resultado;
	}
}
