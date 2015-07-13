package es.pfsgroup.plugin.precontencioso.documento.dto;

import java.util.Date;

public class DocumentosUGPCODto {
	private Long id;
	private Long unidadGestionId;
	private String contrato;
	private String descripcionUG;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getUnidadGestionId() {
		return unidadGestionId;
	}
	public void setUnidadGestionId(Long unidadGestionId) {
		this.unidadGestionId = unidadGestionId;
	}
	public String getContrato() {
		return contrato;
	}
	public void setContrato(String contrato) {
		this.contrato = contrato;
	}
	public String getDescripcionUG() {
		return descripcionUG;
	}
	public void setDescripcionUG(String descripcionUG) {
		this.descripcionUG = descripcionUG;
	}
	
}
