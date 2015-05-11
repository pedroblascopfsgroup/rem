package es.pfsgroup.plugin.recovery.masivo.dto;

import es.capgemini.devon.files.FileItem;

public class MSVDtoValidacionContendo {
	private Boolean ficheroTieneErrores;
	private FileItem excelErroresFormato;
	
	public void setFicheroTieneErrores(Boolean ficheroTieneErrores) {
		this.ficheroTieneErrores = ficheroTieneErrores;
	}
	public Boolean getFicheroTieneErrores() {
		return ficheroTieneErrores;
	}
	public void setExcelErroresFormato(FileItem excelErroresFormato) {
		this.excelErroresFormato = excelErroresFormato;
	}
	public FileItem getExcelErroresFormato() {
		return excelErroresFormato;
	}

}
