package es.pfsgroup.plugin.recovery.masivo.dto;

import es.pfsgroup.plugin.recovery.masivo.model.ExcelFileBean;

public class MSVExcelFileItemDto {
	
	private Long idTipoOperacion;
	private String ruta;
	
	private ExcelFileBean excelFile;
	private Long idProceso;
	
	public Long getIdProceso() {
		return idProceso;
	}
	public void setIdProceso(Long idProceso) {
		this.idProceso = idProceso;
	}
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
	
	

}
