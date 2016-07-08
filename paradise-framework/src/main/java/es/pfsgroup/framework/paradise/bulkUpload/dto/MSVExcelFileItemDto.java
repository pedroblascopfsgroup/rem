package es.pfsgroup.framework.paradise.bulkUpload.dto;

import es.pfsgroup.framework.paradise.bulkUpload.model.ExcelFileBean;



public class MSVExcelFileItemDto {
	
	private Long processId;
	private Long idTipoOperacion;
	private String ruta;
	
	private ExcelFileBean excelFile;

	public Long getIdTipoOperacion() {
		return idTipoOperacion;
	}
	public void setIdTipoOperacion(Long idTipoOperacion) {
		this.idTipoOperacion = idTipoOperacion;
	}
	public ExcelFileBean getExcelFile() {
		return excelFile;
	}
	public void setExcelFile(ExcelFileBean excelFile) {
		this.excelFile = excelFile;
	}

	public void setRuta(String ruta) {
		this.ruta = ruta;
	}
	public String getRuta() {
		return ruta;
	}
	
	public Long getProcessId() {
		return processId;
	}
	public void setProcessId(Long processId) {
		this.processId = processId;
	}
	


}
