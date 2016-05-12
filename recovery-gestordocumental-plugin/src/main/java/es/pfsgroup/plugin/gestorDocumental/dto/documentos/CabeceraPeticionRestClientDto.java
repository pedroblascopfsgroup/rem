package es.pfsgroup.plugin.gestorDocumental.dto.documentos;


public class CabeceraPeticionRestClientDto {

	/**
	 * Tipo de expediente
	 */
	private String codTipo;

	/**
	 * Clase de expediente
	 */
	private String codClase;

	/**
	 * Identificador del documento (DataID)
	 */
	private Integer idDocumento;

	/**
	 * Identificador interno de Haya del expediente
	 */
	private String idExpedienteHaya;
	

	public String getCodTipo() {
		return codTipo;
	}

	public void setCodTipo(String codTipo) {
		this.codTipo = codTipo;
	}

	public String getCodClase() {
		return codClase;
	}

	public void setCodClase(String codClase) {
		this.codClase = codClase;
	}

	public Integer getIdDocumento() {
		return idDocumento;
	}

	public void setIdDocumento(Integer idDocumento) {
		this.idDocumento = idDocumento;
	}

	public String getIdExpedienteHaya() {
		return idExpedienteHaya;
	}

	public void setIdExpedienteHaya(String idExpedienteHaya) {
		this.idExpedienteHaya = idExpedienteHaya;
	}

}