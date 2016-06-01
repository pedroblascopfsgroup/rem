package es.pfsgroup.plugin.gestorDocumental.model.servicios;


public class ExpedientesServicios {

	/**
	 * Identificador interno del expediente en Haya
	 */
	private String id;
	
	/**
	 * Identificador del titular del expediente (por ejemplo Sareb)
	 */
	private String idExterno;
	
	/**
	 * Identificador del sistema origen del expediente
	 */
	private String idSistemaOrigen;
	
	/**
	 * Estado del expediente
	 */
	private String estadoExpediente;
	
	/**
	 * Titular del expediente
	 */
	private String cliente;
	

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getIdExterno() {
		return idExterno;
	}

	public void setIdExterno(String idExterno) {
		this.idExterno = idExterno;
	}

	public String getIdSistemaOrigen() {
		return idSistemaOrigen;
	}

	public void setIdSistemaOrigen(String idSistemaOrigen) {
		this.idSistemaOrigen = idSistemaOrigen;
	}

	public String getEstadoExpediente() {
		return estadoExpediente;
	}

	public void setEstadoExpediente(String estadoExpediente) {
		this.estadoExpediente = estadoExpediente;
	}
	
	public String getCliente() {
		return cliente;
	}

	public void setCliente(String cliente) {
		this.cliente = cliente;
	}
	
}