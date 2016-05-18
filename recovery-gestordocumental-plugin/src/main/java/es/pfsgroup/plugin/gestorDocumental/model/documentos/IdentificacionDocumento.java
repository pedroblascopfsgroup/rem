package es.pfsgroup.plugin.gestorDocumental.model.documentos;

public class IdentificacionDocumento {

	/**
	 * Tipo de expediente
	 */
	private String tipoExpediente;

	/**
	 * Clase de expediente
	 */
	private String claseExpediente;

	/**
	 * Identificador interno de Haya del expediente
	 */
	private String idExpedienteHaya;

	/**
	 * Código Serie documental
	 */
	private String serieDocumental;

	/**
	 * Código TDN1
	 */
	private String tdn1;

	/**
	 * Código TDN2
	 */
	private String tdn2;

	/**
	 * Identificador del documento (DataID)
	 */
	private Integer identificadorNodo;

	/**
	 * Nombre del nodo
	 */
	private String nombreNodo;

	public String getTipoExpediente() {
		return tipoExpediente;
	}

	public void setTipoExpediente(String tipoExpediente) {
		this.tipoExpediente = tipoExpediente;
	}

	public String getClaseExpediente() {
		return claseExpediente;
	}

	public void setClaseExpediente(String claseExpediente) {
		this.claseExpediente = claseExpediente;
	}

	public String getIdExpedienteHaya() {
		return idExpedienteHaya;
	}

	public void setIdExpedienteHaya(String idExpedienteHaya) {
		this.idExpedienteHaya = idExpedienteHaya;
	}

	public String getSerieDocumental() {
		return serieDocumental;
	}

	public void setSerieDocumental(String serieDocumental) {
		this.serieDocumental = serieDocumental;
	}

	public String getTdn1() {
		return tdn1;
	}

	public void setTdn1(String tdn1) {
		this.tdn1 = tdn1;
	}

	public String getTdn2() {
		return tdn2;
	}

	public void setTdn2(String tdn2) {
		this.tdn2 = tdn2;
	}

	public Integer getIdentificadorNodo() {
		return identificadorNodo;
	}

	public void setIdentificadorNodo(Integer identificadorNodo) {
		this.identificadorNodo = identificadorNodo;
	}

	public String getNombreNodo() {
		return nombreNodo;
	}

	public void setNombreNodo(String nombreNodo) {
		this.nombreNodo = nombreNodo;
	}

}