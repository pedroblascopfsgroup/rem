package es.pfsgroup.plugin.precontencioso.documento.dto;

import java.io.Serializable;

public class InformarDocumentoDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1042740703163518903L;

	private String estado;
	private String adjuntado;
	private String fechaResultado;
	private String respuesta;
	private String fechaEnvio;
	private String fechaRecepcion;
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

	public String getFechaResultado() {
		return fechaResultado;
	}

	public void setFechaResultado(String fechaResultado) {
		this.fechaResultado = fechaResultado;
	}

	public String getRespuesta() {
		return respuesta;
	}

	public void setRespuesta(String respuesta) {
		this.respuesta = respuesta;
	}

	public String getFechaEnvio() {
		return fechaEnvio;
	}

	public void setFechaEnvio(String fechaAux) {
		this.fechaEnvio = fechaAux;
	}

	public String getFechaRecepcion() {
		return fechaRecepcion;
	}

	public void setFechaRecepcion(String fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}

	public String getComentario() {
		return comentario;
	}

	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
}
