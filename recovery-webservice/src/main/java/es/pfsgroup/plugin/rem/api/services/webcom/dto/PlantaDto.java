package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DoubleDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;

public class PlantaDto {
	
	private LongDataType numero;
	private StringDataType codTipoEstancia;
	private LongDataType numeroEstancias;
	private DoubleDataType estancias;
	private StringDataType descripcionEstancias;
	public LongDataType getNumero() {
		return numero;
	}
	public void setNumero(LongDataType numero) {
		this.numero = numero;
	}
	public StringDataType getCodTipoEstancia() {
		return codTipoEstancia;
	}
	public void setCodTipoEstancia(StringDataType codTipoEstancia) {
		this.codTipoEstancia = codTipoEstancia;
	}
	public LongDataType getNumeroEstancias() {
		return numeroEstancias;
	}
	public void setNumeroEstancias(LongDataType numeroEstancias) {
		this.numeroEstancias = numeroEstancias;
	}
	public DoubleDataType getEstancias() {
		return estancias;
	}
	public void setEstancias(DoubleDataType estancias) {
		this.estancias = estancias;
	}
	public StringDataType getDescripcionEstancias() {
		return descripcionEstancias;
	}
	public void setDescripcionEstancias(StringDataType descripcionEstancias) {
		this.descripcionEstancias = descripcionEstancias;
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((codTipoEstancia == null) ? 0 : codTipoEstancia.hashCode());
		result = prime
				* result
				+ ((descripcionEstancias == null) ? 0 : descripcionEstancias
						.hashCode());
		result = prime * result
				+ ((estancias == null) ? 0 : estancias.hashCode());
		result = prime * result + ((numero == null) ? 0 : numero.hashCode());
		result = prime * result
				+ ((numeroEstancias == null) ? 0 : numeroEstancias.hashCode());
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
		PlantaDto other = (PlantaDto) obj;
		if (codTipoEstancia == null) {
			if (other.codTipoEstancia != null)
				return false;
		} else if (!codTipoEstancia.equals(other.codTipoEstancia))
			return false;
		if (descripcionEstancias == null) {
			if (other.descripcionEstancias != null)
				return false;
		} else if (!descripcionEstancias.equals(other.descripcionEstancias))
			return false;
		if (estancias == null) {
			if (other.estancias != null)
				return false;
		} else if (!estancias.equals(other.estancias))
			return false;
		if (numero == null) {
			if (other.numero != null)
				return false;
		} else if (!numero.equals(other.numero))
			return false;
		if (numeroEstancias == null) {
			if (other.numeroEstancias != null)
				return false;
		} else if (!numeroEstancias.equals(other.numeroEstancias))
			return false;
		return true;
	}
}
