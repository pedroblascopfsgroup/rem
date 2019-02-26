package es.pfsgroup.plugin.rem.rest.salesforce.api;

import es.pfsgroup.plugin.rem.model.DtoAltaVisita;
import es.pfsgroup.plugin.rem.rest.dto.SalesforceAuthDto;
import es.pfsgroup.plugin.rem.rest.dto.SalesforceResponseDto;

public interface SalesforceApi {
	
	public SalesforceAuthDto getAuthtoken() throws Exception ;
	public SalesforceResponseDto altaVisita(SalesforceAuthDto dto, DtoAltaVisita dtoAltaVisita) throws Exception ;
	
}
