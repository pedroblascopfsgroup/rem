package es.pfsgroup.plugin.rem.model;

import java.util.Date;

public class DtoGastoRepercutido {

	private Long id;
	private String tipoGastoCodigo;
	private Double importe;
	private Long meses;
	private Date fechaAlta;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getTipoGastoCodigo() {
		return tipoGastoCodigo;
	}
	public void setTipoGastoCodigo(String tipoGastoCodigo) {
		this.tipoGastoCodigo = tipoGastoCodigo;
	}
	public Double getImporte() {
		return importe;
	}
	public void setImporte(Double importe) {
		this.importe = importe;
	}
	public Long getMeses() {
		return meses;
	}
	public void setMeses(Long meses) {
		this.meses = meses;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	
	
	

}