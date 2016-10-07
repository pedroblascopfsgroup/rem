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

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((idActivoHaya == null) ? 0 : idActivoHaya.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		ActivoVinculadoDto other = (ActivoVinculadoDto) obj;
		if (idActivoHaya == null) {
			if (other.idActivoHaya != null)
				return false;
		} else if (!idActivoHaya.equals(other.idActivoHaya))
			return false;
		return true;
	}

	
}
