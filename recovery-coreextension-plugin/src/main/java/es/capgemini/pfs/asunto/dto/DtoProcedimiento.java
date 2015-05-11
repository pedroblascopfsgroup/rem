package es.capgemini.pfs.asunto.dto;

import es.capgemini.pfs.asunto.model.Procedimiento;

public class DtoProcedimiento {

	private Procedimiento procedimiento;
	private Boolean activo;

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public Boolean getActivo() {
		return activo;
	}

	public void setActivo(Boolean activo) {
		this.activo = activo;
	}

}
