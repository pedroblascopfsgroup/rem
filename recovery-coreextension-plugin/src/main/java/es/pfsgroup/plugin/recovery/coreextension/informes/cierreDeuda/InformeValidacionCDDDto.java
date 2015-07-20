package es.pfsgroup.plugin.recovery.coreextension.informes.cierreDeuda;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;

public class InformeValidacionCDDDto {

	private List<BienLoteDto> bienesLote;
	private Long idSubasta;
	private ProcedimientoSubastaCDD procedimientoSubastaCDD;
	private List<DatosLoteCDD> datosLoteCDD;
	private String mensajesValidacion="";
	private Boolean validacionOK;
	private Subasta subasta;
	private List<String> resultadoValidacion = new ArrayList<String>();
	
	public List<BienLoteDto> getBienesLote() {
		return bienesLote;
	}
	public void setBienesLote(List<BienLoteDto> bienesLote) {
		this.bienesLote = bienesLote;
	}
	public Long getIdSubasta() {
		return idSubasta;
	}
	public void setIdSubasta(Long idSubasta) {
		this.idSubasta = idSubasta;
	}
	public ProcedimientoSubastaCDD getProcedimientoSubastaCDD() {
		return procedimientoSubastaCDD;
	}
	public void setProcedimientoSubastaCDD(
			ProcedimientoSubastaCDD procedimientoSubastaCDD) {
		this.procedimientoSubastaCDD = procedimientoSubastaCDD;
	}
	public List<DatosLoteCDD> getDatosLoteCDD() {
		return datosLoteCDD;
	}
	public void setDatosLoteCDD(List<DatosLoteCDD> datosLoteCDD) {
		this.datosLoteCDD = datosLoteCDD;
	}
	public String getMensajesValidacion() {
		return mensajesValidacion;
	}
	public void setMensajesValidacion(String mensajesValidacion) {
		this.mensajesValidacion = mensajesValidacion;
	}
	public Boolean getValidacionOK() {
		return validacionOK;
	}
	public void setValidacionOK(Boolean validacionOK) {
		this.validacionOK = validacionOK;
	}
	public Subasta getSubasta() {
		return subasta;
	}
	public void setSubasta(Subasta subasta) {
		this.subasta = subasta;
	}
	public List<String> getResultadoValidacion() {
		return resultadoValidacion;
	}
	public void setResultadoValidacion(List<String> resultadoValidacion) {
		this.resultadoValidacion = resultadoValidacion;
	}
}	