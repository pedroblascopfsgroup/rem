package es.pfsgroup.plugin.gestordocumental.dto.documentos;

import java.io.File;

public class CrearVersionDto extends UsuarioPasswordDto {

	/**
	 * El fichero que se añadirá como nueva versión
	 */
	private File documento;


	public File getDocumento() {
		return documento;
	}

	public void setDocumento(File documento) {
		this.documento = documento;
	}

}