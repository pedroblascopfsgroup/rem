package es.pfsgroup.concursal.credito.dto;

import java.util.Set;

import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.concursal.credito.model.Credito;

public class DtoCreditosContrato {
	
	private Contrato contrato;
	
	private String numeroAuto;
	
	private Set<Credito> creditos;

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	

	public Set<Credito> getCreditos() {
		return creditos;
	}

	public void setCreditos(Set<Credito> creditos) {
		this.creditos = creditos;
	}

	public void setNumeroAuto(String numeroAuto) {
		this.numeroAuto = numeroAuto;
	}

	public String getNumeroAuto() {
		return numeroAuto;
	}
}
