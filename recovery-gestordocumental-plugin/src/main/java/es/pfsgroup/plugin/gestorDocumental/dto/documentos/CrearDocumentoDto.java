package es.pfsgroup.plugin.gestorDocumental.dto.documentos;

import java.io.File;

public class CrearDocumentoDto extends UsuarioPasswordDto {
	
	/**
	 * El fichero que se añadirá como nueva versión
	 */
	private File documento;

	/**
	 * Descripción del documento para llevar a la propiedad del gestor
	 * documental
	 */
	private String descripcionDocumento;

	/**
	 * Objeto constituido por los metadatos generales del documento
	 */
	private String generalDocumento;

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

	public String getDescripcionDocumento() {
		return descripcionDocumento;
	}

	public void setDescripcionDocumento(String descripcionDocumento) {
		this.descripcionDocumento = descripcionDocumento;
	}

	public String getGeneralDocumento() {
		return generalDocumento;
	}

	public void setGeneralDocumento(String generalDocumento) {
		this.generalDocumento = generalDocumento;
	}

	public String getArchivoFisico() {
		return archivoFisico;
	}

	public void setArchivoFisico(String archivoFisico) {
		this.archivoFisico = archivoFisico;
	}

}