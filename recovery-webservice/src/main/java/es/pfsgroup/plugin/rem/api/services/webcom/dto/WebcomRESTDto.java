package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;

public interface WebcomRESTDto {
	

	LongDataType getIdUsuarioRemAccion();
	
	void setIdUsuarioRemAccion(LongDataType value);
	
	DateDataType getFechaAccion();
	
	void setFechaAccion(DateDataType value);	
	
}
