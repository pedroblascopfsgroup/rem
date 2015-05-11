package es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes;

import es.capgemini.devon.dto.WebDto;

public class NMBDtoEmbargoProcedimiento extends WebDto {
	private static final long serialVersionUID = 1776291446943030947L;
	private Long id;
	private Long idProcedimiento;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdProcedimiento() {
		return idProcedimiento;
	}
	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}
	
}
