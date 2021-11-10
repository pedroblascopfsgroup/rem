package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoTestigoObligatorio extends WebDto {
	private static final long serialVersionUID = 0L;
	
    private String id;
    private String cartera;
    private String subcartera;
    private String tipoComercializacion;
    private String equipoGestion;
	private Double porcentajeDescuento;
	private Double importeMinimo;
	private String requiereTestigos;
	private int totalCount;
	
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
	public String getRequiereTestigos() {
		return requiereTestigos;
	}
	public void setRequiereTestigos(String requiereTestigos) {
		this.requiereTestigos = requiereTestigos;
	}
	public int getTotalCount() {
		return totalCount;
	}
	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}
	
	

}
