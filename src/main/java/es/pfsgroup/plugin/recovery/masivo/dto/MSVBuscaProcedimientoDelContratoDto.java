package es.pfsgroup.plugin.recovery.masivo.dto;

public class MSVBuscaProcedimientoDelContratoDto {
	private Long numeroCasoNova;
	private Long tipoProcedimiento;
	private boolean tieneCodigoProcEnJuzgado;
	private boolean tieneJuzgado;
	
	
	public Long getNumeroCasoNova() {
		return numeroCasoNova;
	}
	public void setNumeroCasoNova(Long numeroCasoNova) {
		this.numeroCasoNova = numeroCasoNova;
	}
	public Long getTipoProcedimiento() {
		return tipoProcedimiento;
	}
	public void setTipoProcedimiento(Long tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}
	public boolean getTieneCodigoProcEnJuzgado() {
		return tieneCodigoProcEnJuzgado;
	}
	public void setTieneCodigoProcEnJuzgado(Boolean tieneCodigoProcEnJuzgado) {
		this.tieneCodigoProcEnJuzgado = tieneCodigoProcEnJuzgado;
	}
	public boolean getTieneJuzgado() {
		return tieneJuzgado;
	}
	public void setTieneJuzgado(Boolean tieneJuzgado) {
		this.tieneJuzgado = tieneJuzgado;
	}
	
}
