package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.MappedColumn;

public class CabeceraDto {

	
	@MappedColumn("ID_SUBDIVISION_REM")
	private LongDataType idSubdivisionAgrupacionRem;
	


	public LongDataType getIdSubdivisionAgrupacionRem() {
		return idSubdivisionAgrupacionRem;
	}

	public void setIdSubdivisionAgrupacionRem(
			LongDataType idSubdivisionAgrupacionRem) {
		this.idSubdivisionAgrupacionRem = idSubdivisionAgrupacionRem;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((idSubdivisionAgrupacionRem == null) ? 0 : idSubdivisionAgrupacionRem.hashCode());
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
		CabeceraDto other = (CabeceraDto) obj;
		if (idSubdivisionAgrupacionRem == null) {
			if (other.idSubdivisionAgrupacionRem != null)
				return false;
		} else if (!idSubdivisionAgrupacionRem.equals(other.idSubdivisionAgrupacionRem))
			return false;
		return true;
	}

	
}
