package es.pfsgroup.plugin.rem.propuestaprecios.dto;

import java.util.Date;

public class DtoGenerarPropuestaPreciosEntidad03 extends DtoGenerarPropuestaPrecios {
	
	private Date fechaEntrada;
	private Date fechaValorLiquidativo;
	private Double valorVentaWeb = (double) 0.0;
	private Double diferenciaConValorTasacion = (double) 0.0; // Tasacion - Importe
	private Double porcSobreTasacion = (double) 0.0; // Tasacion - %
	private Double procSobreVnc = (double) 0.0; // VNC - %
	private Double mayorValoracion = (double) 0.0;
	private String tipoTasacionDescripcion;
	

	public Date getFechaEntrada() {
		return fechaEntrada;
	}

	public void setFechaEntrada(Date fechaEntrada) {
		this.fechaEntrada = fechaEntrada;
	}

	public Date getFechaValorLiquidativo() {
		return fechaValorLiquidativo;
	}

	public void setFechaValorLiquidativo(Date fechaValorLiquidativo) {
		this.fechaValorLiquidativo = fechaValorLiquidativo;
	}

	public Double getValorVentaWeb() {
		return valorVentaWeb;
	}

	public void setValorVentaWeb(Double valorVentaWeb) {
		this.valorVentaWeb = valorVentaWeb;
	}

	public Double getDiferenciaConValorTasacion() {
		return diferenciaConValorTasacion;
	}

	public void setDiferenciaConValorTasacion(Double diferenciaConValorTasacion) {
		this.diferenciaConValorTasacion = diferenciaConValorTasacion;
	}

	public Double getPorcSobreTasacion() {
		return porcSobreTasacion;
	}

	public void setPorcSobreTasacion(Double porcSobreTasacion) {
		this.porcSobreTasacion = porcSobreTasacion;
	}

	public Double getProcSobreVnc() {
		return procSobreVnc;
	}

	public void setProcSobreVnc(Double procSobreVnc) {
		this.procSobreVnc = procSobreVnc;
	}

	public Double getMayorValoracion() {
		return mayorValoracion;
	}

	public void setMayorValoracion(Double mayorValoracion) {
		this.mayorValoracion = mayorValoracion;
	}

	public String getTipoTasacionDescripcion() {
		return tipoTasacionDescripcion;
	}

	public void setTipoTasacionDescripcion(String tipoTasacionDescripcion) {
		this.tipoTasacionDescripcion = tipoTasacionDescripcion;
	}
	
}
