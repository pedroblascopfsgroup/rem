package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoOfertasAsociadasActivo extends WebDto {

	private static final long serialVersionUID = -1924262706851970473L;
	
	private Date fechaPreBloqueo;
	private Long numOferta;
	private Double importeOferta;
	private String tipoComprador;
	private String situacionOcupacional;
	
	public Date getFechaPreBloqueo() {
		return fechaPreBloqueo;
	}
	public void setFechaPreBloqueo(Date fechaPreBloqueo) {
		this.fechaPreBloqueo = fechaPreBloqueo;
	}
	public Long getNumOferta() {
		return numOferta;
	}
	public void setNumOferta(Long numOferta) {
		this.numOferta = numOferta;
	}
	public Double getImporteOferta() {
		return importeOferta;
	}
	public void setImporteOferta(Double importeOferta) {
		this.importeOferta = importeOferta;
	}
	public String getTipoComprador() {
		return tipoComprador;
	}
	public void setTipoComprador(String tipoComprador) {
		this.tipoComprador = tipoComprador;
	}
	public String getSituacionOcupacional() {
		return situacionOcupacional;
	}
	public void setSituacionOcupacional(String situacionOcupacional) {
		this.situacionOcupacional = situacionOcupacional;
	}
	
}
