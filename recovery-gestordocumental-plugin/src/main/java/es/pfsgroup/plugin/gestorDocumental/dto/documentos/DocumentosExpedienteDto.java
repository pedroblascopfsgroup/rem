package es.pfsgroup.plugin.gestorDocumental.dto.documentos;


public class DocumentosExpedienteDto extends UsuarioPasswordDto {

	/**
	 * Identificador que diferencia el tipo de relación (por expediente o por
	 * clases)
	 */
	private String tipoConsulta;

	/**
	 * Parámetro para indicar si se incluyen aquellos documentos que tienen la
	 * relación Expediente-Documento con el expediente introducido (El
	 * expediente tiene el código DOCUMENTO del XReference)
	 */
	private Boolean vinculoDocumento;
	
	/**
	 * Parámetro para indicar si se incluyen aquellos documentos que están en un
	 * expediente con relación Expediente-Expediente (El expediente tiene el
	 * código PROYECTO_1 o PROYECTO_2 del XReference)
	 */
	private Boolean vinculoExpediente;
	

	public String getTipoConsulta() {
		return tipoConsulta;
	}

	public void setTipoConsulta(String tipoConsulta) {
		this.tipoConsulta = tipoConsulta;
	}

	public Boolean getVinculoDocumento() {
		return vinculoDocumento;
	}

	public void setVinculoDocumento(Boolean vinculoDocumento) {
		this.vinculoDocumento = vinculoDocumento;
	}
	
	public Boolean getVinculoExpediente() {
		return vinculoExpediente;
	}
	
	public void setVinculoExpediente(Boolean vinculoExpediente) {
		this.vinculoExpediente = vinculoExpediente;
	}

}