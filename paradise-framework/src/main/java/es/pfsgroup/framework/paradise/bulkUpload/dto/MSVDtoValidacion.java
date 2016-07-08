package es.pfsgroup.framework.paradise.bulkUpload.dto;

import es.capgemini.devon.files.FileItem;

public class MSVDtoValidacion {
	
	private Long idProceso;
	private FileItem excelErrores;
	private Boolean ficheroTieneErrores;
	
	public Long getIdProceso() {
		return idProceso;
	}
	public void setIdProceso(Long idProceso) {
		this.idProceso = idProceso;
	}
	public FileItem getExcelErroresFormato() {
		return excelErrores;
	}
	public void setExcelErroresFormato(FileItem excelErroresFormato) {
		this.excelErrores = excelErroresFormato;
	}
	public void setFicheroTieneErrores(Boolean ficheroTieneErrores) {
		this.ficheroTieneErrores = ficheroTieneErrores;
	}
	public Boolean getFicheroTieneErrores() {
		return ficheroTieneErrores;
	}
	
	

}
