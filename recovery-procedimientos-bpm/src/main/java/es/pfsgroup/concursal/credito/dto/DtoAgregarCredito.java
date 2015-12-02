package es.pfsgroup.concursal.credito.dto;

import javax.validation.constraints.NotNull;

import es.capgemini.devon.dto.WebDto;

public class DtoAgregarCredito extends WebDto{
	
	private static final long serialVersionUID = 4134246258943431546L;

	@NotNull
	private Long idProcedimiento;
	
	@NotNull
	private Long idContratoExpediente;

	private Long idCredito;
	
	private Long supervisorTipoCredito;
	
	private Double supervisorPrincipal;
	
	private Long externoTipoCredito;
		
	private Double externoPrincipal;
	
	private Long definitivoTipoCredito;
	
	private Double definitivoPrincipal;
	
	private Long estadoCredito;	
	
	private String fechaVencimiento;

	public Long getIdProcedimiento() {
		return idProcedimiento;
	}

	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}

	public Long getIdContratoExpediente() {
		return idContratoExpediente;
	}

	public void setIdContratoExpediente(Long idContratoExpediente) {
		this.idContratoExpediente = idContratoExpediente;
	}

	public void setDefinitivoTipoCredito(Long definitivoTipoCredito) {
		this.definitivoTipoCredito = definitivoTipoCredito;
	}

	public Long getDefinitivoTipoCredito() {
		return definitivoTipoCredito;
	}

	public void setDefinitivoPrincipal(Double definitivoPrincipal) {
		this.definitivoPrincipal = definitivoPrincipal;
	}

	public Double getDefinitivoPrincipal() {
		return definitivoPrincipal;
	}

	public void setIdCredito(Long idCredito) {
		this.idCredito = idCredito;
	}

	public Long getIdCredito() {
		return idCredito;
	}

	public void setEstadoCredito(Long estadoCredito) {
		this.estadoCredito = estadoCredito;
	}

	public Long getEstadoCredito() {
		return estadoCredito;
	}

	public void setSupervisorTipoCredito(Long supervisorTipoCredito) {
		this.supervisorTipoCredito = supervisorTipoCredito;
	}

	public Long getSupervisorTipoCredito() {
		return supervisorTipoCredito;
	}

	public void setSupervisorPrincipal(Double supervisorPrincipal) {
		this.supervisorPrincipal = supervisorPrincipal;
	}

	public Double getSupervisorPrincipal() {
		return supervisorPrincipal;
	}

	public void setExternoTipoCredito(Long externoTipoCredito) {
		this.externoTipoCredito = externoTipoCredito;
	}

	public Long getExternoTipoCredito() {
		return externoTipoCredito;
	}

	public void setExternoPrincipal(Double externoPrincipal) {
		this.externoPrincipal = externoPrincipal;
	}

	public Double getExternoPrincipal() {
		return externoPrincipal;
	}

	public String getFechaVencimiento() {
		return fechaVencimiento;
	}

	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	
}
