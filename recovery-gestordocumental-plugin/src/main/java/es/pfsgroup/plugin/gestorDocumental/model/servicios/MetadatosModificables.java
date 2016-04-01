package es.pfsgroup.plugin.gestorDocumental.model.servicios;


public class MetadatosModificables {

	/**
	 * Identificador del titular del expediente (por ejemplo Sareb)
	 */
	private String idExterno;
	
	/**
	 * Identificador del sistema origen del expediente
	 */
	private String idSistemaOrigen;

	
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
	
}