package es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.dto;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotEmpty;

import es.capgemini.devon.dto.WebDto;

public class PTEDtoPlazoTarea extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 992506285782028049L;
	
	private Long id;
	private Long idProcedimiento;
	private String nombreProcedimiento;
	private Long idTareaProcedimiento;
	private String nombreTareaProcedimiento;
	private Long idTipoJuzgado;
	private String nombreTipoJuzgado;
	private String idTipoPlaza;
	private String nombreTipoPlaza;
	
	@NotNull (message="plugin.plazosExterna.messages.plazoNoVacio")
	@NotEmpty (message="plugin.plazosExterna.messages.plazoNoVacio")
	private String scriptPlazo;
	private String observaciones;
	private Boolean absoluto;
	
	
	public void setId(Long id) {
		this.id = id;
	}
	public Long getId() {
		return id;
	}
	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}
	public Long getIdProcedimiento() {
		return idProcedimiento;
	}
	public void setNombreProcedimiento(String nombreProcedimiento) {
		this.nombreProcedimiento = nombreProcedimiento;
	}
	public String getNombreProcedimiento() {
		return nombreProcedimiento;
	}
	public void setIdTareaProcedimiento(Long idTareaProcedimiento) {
		this.idTareaProcedimiento = idTareaProcedimiento;
	}
	public Long getIdTareaProcedimiento() {
		return idTareaProcedimiento;
	}
	public void setNombreTareaProcedimiento(String nombreTareaProcedimiento) {
		this.nombreTareaProcedimiento = nombreTareaProcedimiento;
	}
	public String getNombreTareaProcedimiento() {
		return nombreTareaProcedimiento;
	}
	public void setIdTipoJuzgado(Long idTipoJuzgado) {
		this.idTipoJuzgado = idTipoJuzgado;
	}
	public Long getIdTipoJuzgado() {
		return idTipoJuzgado;
	}
	public void setNombreTipoJuzgado(String nombreTipoJuzgado) {
		this.nombreTipoJuzgado = nombreTipoJuzgado;
	}
	public String getNombreTipoJuzgado() {
		return nombreTipoJuzgado;
	}
	public void setIdTipoPlaza(String idTipoPlaza) {
		this.idTipoPlaza = idTipoPlaza;
	}
	public String getIdTipoPlaza() {
		return idTipoPlaza;
	}
	public void setNombreTipoPlaza(String nombreTipoPlaza) {
		this.nombreTipoPlaza = nombreTipoPlaza;
	}
	public String getNombreTipoPlaza() {
		return nombreTipoPlaza;
	}
	public void setScriptPlazo(String scriptPlazo) {
		this.scriptPlazo = scriptPlazo;
	}
	public String getScriptPlazo() {
		return scriptPlazo;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setAbsoluto(Boolean absoluto) {
		this.absoluto = absoluto;
	}
	public Boolean getAbsoluto() {
		return absoluto;
	}
	
	

}
