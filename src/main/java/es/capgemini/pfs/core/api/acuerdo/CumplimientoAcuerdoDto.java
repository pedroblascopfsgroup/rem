package es.capgemini.pfs.core.api.acuerdo;

public interface CumplimientoAcuerdoDto {
	
	public Long getId();
	
	public Double getImportePagado();
	
	public String getFechaPago();
	
	public Boolean getCumplido();
	
	public Boolean getFinalizar();

}
