package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

public class CambiaEstadosDto implements Serializable {

	private Long idExpediente;
	private String estadoExpediente;
	private String estadoExpBC;

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	public String getEstadoExpediente() {
		return estadoExpediente;
	}

	public void setEstadoExpediente(String estadoExpediente) {
		this.estadoExpediente = estadoExpediente;
	}

	public String getEstadoExpBC() {
		return estadoExpBC;
	}

	public void setEstadoExpBC(String estadoExpBC) {
		this.estadoExpBC = estadoExpBC;
	}
}