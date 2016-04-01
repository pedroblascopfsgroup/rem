package es.pfsgroup.plugin.gestorDocumental.model.servicios;

public class PropuestaMetadatos extends ExpedientesServicios {

	/**
	 * Numero actualizado de cuenta Bancaria
	 */
	private String iban;
	
	/**
	 * Entidad
	 */
	private String entidad;
	
	/**
	 * Oficina / Sucursal
	 */
	private String oficina;
	
	/**
	 * Tipo de identificacion
	 */
	private String dc;
	
	/**
	 * Núm Cuenta
	 */
	private String cuenta;
	
	/**
	 * CIF/NIF Avalista de la cuenta
	 */
	private String avalista;
	
	/**
	 * Acreditado
	 */
	private String acreditado;
	
	
	public String getIban() {
		return iban;
	}

	public void setIban(String iban) {
		this.iban = iban;
	}

	public String getEntidad() {
		return entidad;
	}

	public void setEntidad(String entidad) {
		this.entidad = entidad;
	}

	public String getOficina() {
		return oficina;
	}

	public void setOficina(String oficina) {
		this.oficina = oficina;
	}

	public String getDc() {
		return dc;
	}

	public void setDc(String dc) {
		this.dc = dc;
	}

	public String getCuenta() {
		return cuenta;
	}

	public void setCuenta(String cuenta) {
		this.cuenta = cuenta;
	}

	public String getAvalista() {
		return avalista;
	}

	public void setAvalista(String avalista) {
		this.avalista = avalista;
	}

	public String getAcreditado() {
		return acreditado;
	}

	public void setAcreditado(String acreditado) {
		this.acreditado = acreditado;
	}
	
}