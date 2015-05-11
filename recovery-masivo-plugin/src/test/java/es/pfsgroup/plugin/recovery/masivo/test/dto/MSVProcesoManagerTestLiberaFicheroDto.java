package es.pfsgroup.plugin.recovery.masivo.test.dto;

import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoAltaProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDocumentoMasivo;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesoMasivo;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel;

public class MSVProcesoManagerTestLiberaFicheroDto {
	private MSVProcesoMasivo proceso;
	private MSVDDEstadoProceso estadoFinal;
	private MSVDtoAltaProceso dto;
	private MSVDocumentoMasivo fichero;
	private MSVHojaExcel hojaExcel;
	private Integer numeroFilasExcel;
	
	public MSVProcesoMasivo getProceso() {
		return proceso;
	}
	public void setProceso(MSVProcesoMasivo proceso) {
		this.proceso = proceso;
	}
	public MSVDDEstadoProceso getEstadoFinal() {
		return estadoFinal;
	}
	public void setEstadoFinal(MSVDDEstadoProceso estadoFinal) {
		this.estadoFinal = estadoFinal;
	}
	public MSVDtoAltaProceso getDto() {
		return dto;
	}
	public void setDto(MSVDtoAltaProceso dto) {
		this.dto = dto;
	}
	public MSVDocumentoMasivo getFichero() {
		return fichero;
	}
	public void setFichero(MSVDocumentoMasivo fichero) {
		this.fichero = fichero;
	}
	public MSVHojaExcel getHojaExcel() {
		return hojaExcel;
	}
	public void setHojaExcel(MSVHojaExcel hojaExcel) {
		this.hojaExcel = hojaExcel;
	}
	public Integer getNumeroFilasExcel() {
		return numeroFilasExcel;
	}
	public void setNumeroFilasExcel(Integer numeroFilasExcel) {
		this.numeroFilasExcel = numeroFilasExcel;
	}
	
}
