package es.pfsgroup.plugin.precontencioso.liquidacion.generar;

public class BienesVO {

	private String NUMFINCA;
	private String MUNICIPIO;
	private String TOMO;
	private String LIBRO;
	private String FOLIO;
	
	public BienesVO(String numFinca, String municipio, String tomo,
			String libro, String folio) {
		super();
		NUMFINCA = numFinca;
		MUNICIPIO = municipio;
		TOMO = tomo;
		LIBRO = libro;
		FOLIO = folio;
	}
	
	public String NUMFINCA() {
		return NUMFINCA;
	}
	public String MUNICIPIO() {
		return MUNICIPIO;
	}
	public String TOMO() {
		return TOMO;
	}
	public String LIBRO() {
		return LIBRO;
	}
	public String FOLIO() {
		return FOLIO;
	}

}
