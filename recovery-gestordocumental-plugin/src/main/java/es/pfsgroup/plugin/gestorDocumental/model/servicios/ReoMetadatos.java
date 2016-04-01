package es.pfsgroup.plugin.gestorDocumental.model.servicios;

public class ReoMetadatos extends ExpedientesServicios {

	/**
	 * Comunidad del expediente inmobiliario
	 */
	private String comunidad;
	
	/**
	 * Provincia del expediente inmobiliario
	 */
	private String provincia;
	
	/**
	 * Municipio del expediente inmobiliario
	 */
	private String municipio;
	
	/**
	 * Ámbito geográfico
	 */
	private String ambito;
	

	public String getComunidad() {
		return comunidad;
	}

	public void setComunidad(String comunidad) {
		this.comunidad = comunidad;
	}

	public String getProvincia() {
		return provincia;
	}

	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}

	public String getMunicipio() {
		return municipio;
	}

	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}

	public String getAmbito() {
		return ambito;
	}

	public void setAmbito(String ambito) {
		this.ambito = ambito;
	}
}