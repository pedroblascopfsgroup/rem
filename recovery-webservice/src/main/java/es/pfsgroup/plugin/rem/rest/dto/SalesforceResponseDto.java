package es.pfsgroup.plugin.rem.rest.dto;

import java.util.List;

public class SalesforceResponseDto {

	private class SFAltaVisitaResponseDto {
		
		private String referenceId;
		private String id;

		public String getReferenceId() {
			return referenceId;
		}
		public void setReferenceId(String referenceId) {
			this.referenceId = referenceId;
		}
		public String getId() {
			return id;
		}
		public void setId(String id) {
			this.id = id;
		}

	}
	
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
