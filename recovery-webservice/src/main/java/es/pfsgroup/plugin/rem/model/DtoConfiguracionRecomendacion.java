package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoConfiguracionRecomendacion extends WebDto {
	private static final long serialVersionUID = 0L;
	
    private String id;
    private String cartera;
    private String subcartera;
    private String tipoComercializacion;
    private String equipoGestion;
	private Double porcentajeDescuento;
	private Double importeMinimo;
	private String recomendacionRCDC;

	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getCartera() {
		return cartera;
	}
	public void setCartera(String cartera) {
		this.cartera = cartera;
	}
	public String getSubcartera() {
		return subcartera;
	}
	public void setSubcartera(String subcartera) {
		this.subcartera = subcartera;
	}
	public String getTipoComercializacion() {
		return tipoComercializacion;
	}
	public void setTipoComercializacion(String tipoComercializacion) {
		this.tipoComercializacion = tipoComercializacion;
	}
	public String getEquipoGestion() {
		return equipoGestion;
	}
	public void setEquipoGestion(String equipoGestion) {
		this.equipoGestion = equipoGestion;
	}
	public Double getPorcentajeDescuento() {
		return porcentajeDescuento;
	}
	public void setPorcentajeDescuento(Double porcentajeDescuento) {
		this.porcentajeDescuento = porcentajeDescuento;
	}
	public Double getImporteMinimo() {
		return importeMinimo;
	}
	public void setImporteMinimo(Double importeMinimo) {
		this.importeMinimo = importeMinimo;
	}
	public String getRecomendacionRCDC() {
		return recomendacionRCDC;
	}
	public void setRecomendacionRCDC(String recomendacionRCDC) {
		this.recomendacionRCDC = recomendacionRCDC;
	}
}