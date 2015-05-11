package es.capgemini.pfs.asunto.dto;

import es.capgemini.pfs.asunto.model.Procedimiento;

public class DtoReportAsuntoActuacion {

	private Procedimiento procedimiento;
	private String principal;
	
	public Procedimiento getProcedimiento() {
		return procedimiento;
	}
	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}
	public String getPrincipal() {
		return principal;
	}
	public void setPrincipal(String principal) {
		this.principal = principal;
	}

}
