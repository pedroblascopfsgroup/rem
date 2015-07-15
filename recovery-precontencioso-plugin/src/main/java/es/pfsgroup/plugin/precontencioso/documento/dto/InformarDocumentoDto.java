package es.pfsgroup.plugin.precontencioso.documento.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

public class InformarDocumentoDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1042740703163518903L;

	private String estado;
	private String adjuntado;
	private Date fechaResultado;
	private String respuesta;
	private Date fechaEnvio;
	private Date fechaRecepcion;
	private String comentario;
	
	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

	public String getAdjuntado() {
		return adjuntado;
	}

	public void setAdjuntado(String adjuntado) {
		this.adjuntado = adjuntado;
	}

	public Date getFechaResultado() {
		return fechaResultado;
	}

	public void setFechaResultado(Date fechaResultado) {
		this.fechaResultado = fechaResultado;
	}

	public String getRespuesta() {
		return respuesta;
	}

	public void setRespuesta(String respuesta) {
		this.respuesta = respuesta;
	}

	public Date getFechaEnvio() {
		return fechaEnvio;
	}

	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}

	public Date getFechaRecepcion() {
		return fechaRecepcion;
	}

	public void setFechaRecepcion(Date fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}

	public String getComentario() {
		return comentario;
	}

	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
}
