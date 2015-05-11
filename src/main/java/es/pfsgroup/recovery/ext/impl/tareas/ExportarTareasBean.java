package es.pfsgroup.recovery.ext.impl.tareas;

import java.io.Serializable;

import es.capgemini.devon.files.FileItem;

public class ExportarTareasBean implements Serializable{

	/**
	 * SERIAL UID
	 */
	private static final long serialVersionUID = -309454553771426660L;

	public boolean enUso;
	
	public FileItem fileItem;
	
	public String ruta;

	public boolean isEnUso() {
		return enUso;
	}

	public void setEnUso(boolean enUso) {
		this.enUso = enUso;
	}

	public FileItem getFileItem() {
		return fileItem;
	}

	public void setFileItem(FileItem fileItem) {
		this.fileItem = fileItem;
	}

	public String getRuta() {
		return ruta;
	}

	public void setRuta(String ruta) {
		this.ruta = ruta;
	}

}
