package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoDetalleOferta extends WebDto {

	private static final long serialVersionUID = 1L;

	private String id;
	private String numOferta;
	private String intencionFinanciar;
	private String numVisitaRem;
	private String procedenciaVisita;


	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getNumOferta() {
		return numOferta;
	}
	public void setNumOferta(String numOferta) {
		this.numOferta = numOferta;
	}
	public String getIntencionFinanciar() {
		return intencionFinanciar;
	}
	public void setIntencionFinanciar(String intencionFinanciar) {
		this.intencionFinanciar = intencionFinanciar;
	}
	public String getNumVisitaRem() {
		return numVisitaRem;
	}
	public void setNumVisitaRem(String numVisitaRem) {
		this.numVisitaRem = numVisitaRem;
	}
	public String getProcedenciaVisita() {
		return procedenciaVisita;
	}
	public void setProcedenciaVisita(String procedenciaVisita) {
		this.procedenciaVisita = procedenciaVisita;
	}

}