package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.MappedColumn;

public class ActivoVinculadoDto {
	
	@MappedColumn("ID_ACTIVO") 
	private LongDataType idActivoHaya;

	public LongDataType getIdActivoHaya() {
		return idActivoHaya;
	}

	public void setIdActivoHaya(LongDataType idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}

}
