package es.pfsgroup.framework.paradise.bulkUpload.api;

public interface  ParticularValidatorApi {
	
	public String getCarteraLocationByNumAgr (String numAgr);
	
	public String getCarteraLocationByNumAct (String numActive);
	
	public String getCarteraLocationTipPatrimByNumAct (String numActive);

	public String existeActivoEnAgrupacion(Long idActivo, Long idAgrupacion);
	
}
