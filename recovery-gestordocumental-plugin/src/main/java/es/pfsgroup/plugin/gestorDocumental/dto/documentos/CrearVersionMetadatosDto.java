package es.pfsgroup.plugin.gestorDocumental.dto.documentos;

import java.io.File;

public class CrearVersionMetadatosDto extends UsuarioPasswordDto {

	/**
	 * El fichero que se añadirá como nueva versión
	 */
	private File documento;

	/**
	 * Objeto constituido por los metadatos generales del documento
	 */
	private String generalDocumentoModif;
	
	/**
	 * Objeto constituido por los metadatos de dónde está archivado físicamente el documento
	 */
	private String archivoFisico;


	public File getDocumento() {
		return documento;
	}

	public void setDocumento(File documento) {
		this.documento = documento;
	}

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