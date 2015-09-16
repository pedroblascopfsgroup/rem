package es.pfsgroup.plugin.precontencioso.documento.dto;

import java.io.Serializable;
import java.util.Date;

public class SaveInfoSolicitudDTO implements Serializable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 6331386822344882895L;
	private String idDoc;
    private String actor;
    private String idSolicitud;
    
    private String estado;
    private String adjuntado;
    private Date fechaResultado;
    private String resultado;
    private Date fechaEnvio;
    private Date fechaRecepcion;
    private String comentario;
    private Long ejecutivo;
    
	public String getIdDoc() {
		return idDoc;
	}
	public void setIdDoc(String idDoc) {
		this.idDoc = idDoc;
	}
	public String getActor() {
		return actor;
	}
	public void setActor(String actor) {
		this.actor = actor;
	}
	public String getIdSolicitud() {
		return idSolicitud;
	}
	public void setIdSolicitud(String idSolicitud) {
		this.idSolicitud = idSolicitud;
	}
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
	public String getResultado() {
		return resultado;
	}
	public void setResultado(String resultado) {
		this.resultado = resultado;
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
	public Long getEjecutivo() {
		return ejecutivo;
	}
	public void setEjecutivo(Long ejecutivo) {
		this.ejecutivo = ejecutivo;
	}

}
