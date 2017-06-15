package es.pfsgroup.plugin.rem.model;

import java.util.Date;

/**
 * Dto para el informe juridico
 * @author David Gonzalez
 *
 */
public class DtoInformeJuridico {
	private Long id;
	private Long idActivo;
	private Long idExpediente;
	private Date fechaEmision;
	private String resultadoBloqueo;
	
	
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Long getIdExpediente() {
		return idExpediente;
	}
	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}
	public Date getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(Date fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getResultadoBloqueo() {
		return resultadoBloqueo;
	}
	public void setResultadoBloqueo(String resultadoBloqueo) {
		this.resultadoBloqueo = resultadoBloqueo;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}

}