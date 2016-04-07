package es.pfsgroup.plugin.gestordocumental.dto.documentos;


public class ModificarMetadatosDto extends UsuarioPasswordDto {	

	/**
	 * Objeto constituido por los metadatos generales del documento
	 */
	private String generalDocumentoModif;
	
	/**
	 * Objeto constituido por los metadatos de dónde está archivado físicamente el documento
	 */
	private String archivoFisico;


	public String getGeneralDocumentoModif() {
		return generalDocumentoModif;
	}

	public void setGeneralDocumentoModif(String generalDocumentoModif) {
		this.generalDocumentoModif = generalDocumentoModif;
	}

	public String getArchivoFisico() {
		return archivoFisico;
	}

	public void setArchivoFisico(String archivoFisico) {
		this.archivoFisico = archivoFisico;
	}

}