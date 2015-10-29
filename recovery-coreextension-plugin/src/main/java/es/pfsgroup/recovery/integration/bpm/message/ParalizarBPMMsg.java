package es.pfsgroup.recovery.integration.bpm.message;

import java.util.Date;

import es.capgemini.pfs.asunto.model.Procedimiento;

public class ParalizarBPMMsg {

	private final Procedimiento procedimiento;
	private final Date fechaActivacion;
	
	public ParalizarBPMMsg(Procedimiento procedimiento, Date fechaActivacion) {
		this.procedimiento = procedimiento;
		this.fechaActivacion = fechaActivacion;
	}

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public Date getFechaActivacion() {
		return fechaActivacion;
	}

}
