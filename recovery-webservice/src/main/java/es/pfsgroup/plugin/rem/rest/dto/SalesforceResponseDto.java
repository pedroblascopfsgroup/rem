package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class SalesforceResponseDto {
	
	private Boolean hasErrors;
	private List<SFAltaVisitaResponseDto> results;

	public Boolean getHasErrors() {
		return hasErrors;
	}
	public void setHasErrors(Boolean hasErrors) {
		this.hasErrors = hasErrors;
	}
	public List<SFAltaVisitaResponseDto> getResults() {
		return results;
	}
	public void setResults(List<SFAltaVisitaResponseDto> results) {
		this.results = results;
	}

}
