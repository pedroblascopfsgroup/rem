package es.pfsgroup.concursal.concurso.dto;

import java.util.ArrayList;
import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.concursal.credito.model.Credito;

public class DtoContratoConcurso extends WebDto{
	
	private static final long serialVersionUID = -8258912402911081503L;

	private Contrato contrato;
	
	private List<Credito> creditos;
	
	private Long idProcedimiento;
	
	private Long idContratoExpediente;

	public DtoContratoConcurso() {
		super();
		creditos = new ArrayList<Credito>();
	}

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public List<Credito> getCreditos() {
		return creditos;
	}

	public void setCreditos(List<Credito> creditos) {
		this.creditos = creditos;
	}

	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}

	public Long getIdProcedimiento() {
		return idProcedimiento;
	}

	public void setIdContratoExpediente(Long idContratoExpediente) {
		this.idContratoExpediente = idContratoExpediente;
	}

	public Long getIdContratoExpediente() {
		return idContratoExpediente;
	}
	
	

}
