package es.pfsgroup.framework.paradise.bulkUpload.api;

public interface  ParticularValidatorApi {
	
	public String getCarteraLocationByNumAgr (String numAgr);
	
	public String getCarteraLocationByNumAct (String numActive);
	
	public String getCarteraLocationTipPatrimByNumAct (String numActive);

	public String existeActivoEnAgrupacion(Long idActivo, Long idAgrupacion);
	
	public Boolean existeActivo(String numActivo);
	
	public Boolean estadoPublicar(String numActivo);
	
	public Boolean estadoOcultaractivo(String numActivo);
	
	public Boolean estadoDesocultaractivo(String numActivo);
	
	public Boolean estadoOcultarprecio(String numActivo);
	
	public Boolean estadoDesocultarprecio(String numActivo);
	
	public Boolean estadoDespublicar(String numActivo);
	
	public Boolean estadoAutorizaredicion(String numActivo);
	
}
