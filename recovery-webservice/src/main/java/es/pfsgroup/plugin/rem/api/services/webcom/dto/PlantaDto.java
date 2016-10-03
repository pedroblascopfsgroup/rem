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
}
