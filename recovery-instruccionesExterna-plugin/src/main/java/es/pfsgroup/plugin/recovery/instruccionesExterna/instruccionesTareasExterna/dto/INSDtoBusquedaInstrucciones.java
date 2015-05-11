package es.pfsgroup.plugin.recovery.instruccionesExterna.instruccionesTareasExterna.dto;

import es.capgemini.devon.dto.WebDto;

public class INSDtoBusquedaInstrucciones extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 7459521788865625163L;
	
	private Long id;
	private Long tipoProcedimiento;
	private Long tareaProcedimiento;
	private String label;
	
	public void setTipoProcedimiento(Long tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}
	public Long getTipoProcedimiento() {
		return tipoProcedimiento;
	}
	public void setTareaProcedimiento(Long tareaProcedimiento) {
		this.tareaProcedimiento = tareaProcedimiento;
	}
	public Long getTareaProcedimiento() {
		return tareaProcedimiento;
	}
	public void setLabel(String label) {
		this.label = label;
	}
	public String getLabel() {
		return label;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getId() {
		return id;
	}
	

}
