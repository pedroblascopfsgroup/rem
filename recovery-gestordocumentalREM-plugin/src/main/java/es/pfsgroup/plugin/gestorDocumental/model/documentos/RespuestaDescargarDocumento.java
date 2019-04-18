package es.pfsgroup.plugin.gestorDocumental.model.documentos;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import es.capgemini.devon.files.FileItem;

public class RespuestaDescargarDocumento {

	/**
	 * Código del error
	 */
	private String codigoError;

	/**
	 * Mensaje del error
	 */
	private String mensajeError;

	/**
	 * Nombre del documento original en el gestor documental
	 */
	private String nombreDocumento;

	/**
	 * Descripción del documento
	 */
	private String descripcionDocumento;
	
	/**
	 * Valor con el tipo de almacenamiento en el gestor documental (archivado u online)
	 */
	private String tipoAlmacenamiento;
	
	/**
	 * Valor con el tamaño del fichero
	 */
	private String fileSize;
	
	/**
	 * Número de versión
	 */
	private String numVersion;
	
	
	/**
	 * Contenido binario del documento
	 */
	private FileItem fileItem;
	
	/**
	 * Content type
	 */
	private String contentType;

	public String getCodigoError() {
		return codigoError;
	}

	public void setCodigoError(String codigoError) {
		this.codigoError = codigoError;
	}

	public String getMensajeError() {
		return mensajeError;
	}

	public void setMensajeError(String mensajeError) {
		this.mensajeError = mensajeError;
	}

	public String getNombreDocumento() {
		return nombreDocumento;
	}

	public void setNombreDocumento(String nombreDocumento) {
		this.nombreDocumento = nombreDocumento;
	}
	
	public String getDescripcionDocumento() {
		return descripcionDocumento;
	}
	
	public void setDescripcionDocumento(String descripcionDocumento) {
		this.descripcionDocumento = descripcionDocumento;
	}
	
	public String getTipoAlmacenamiento() {
		return tipoAlmacenamiento;
	}
	
	public void setTipoAlmacenamiento(String tipoAlmacenamiento) {
		this.tipoAlmacenamiento = tipoAlmacenamiento;
	}
	
	public String getFileSize() {
		return fileSize;
	}
	
	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}
	
	public String getNumVersion() {
		return numVersion;
	}
	
	public void setNumVersion(String numVersion) {
		this.numVersion = numVersion;
	}

	public FileItem getFileItem() {
		return fileItem;
	}

	public void setFileItem(FileItem fileItem) {
		this.fileItem = fileItem;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

}