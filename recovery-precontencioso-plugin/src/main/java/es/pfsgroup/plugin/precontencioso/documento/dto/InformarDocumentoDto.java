package es.pfsgroup.plugin.precontencioso.documento.dto;

import java.io.Serializable;
import java.math.BigDecimal;

public class InformarDocumentoDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1042740703163518903L;

	private String estado;

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}
}
