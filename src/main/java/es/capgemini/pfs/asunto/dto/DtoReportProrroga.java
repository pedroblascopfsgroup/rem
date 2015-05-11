package es.capgemini.pfs.asunto.dto;

import es.capgemini.pfs.prorroga.model.Prorroga;

public class DtoReportProrroga {

	private static final long serialVersionUID = 1L;
	private final Prorroga prorroga;
	private String resolucionDesc;
	
	public DtoReportProrroga(Prorroga prorroga) {
		this.prorroga = prorroga;
	}
	
	public String getResolucionDesc() {
		return resolucionDesc;
	}
	public void setResolucionDesc(String resolucionDesc) {
		this.resolucionDesc = resolucionDesc;
	}
	public Prorroga getProrroga() {
		return prorroga;
	}
	
}
