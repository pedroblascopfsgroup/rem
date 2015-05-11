package es.pfsgroup.procedimientos.hipotecario.dto;

import java.math.BigDecimal;

import es.capgemini.pfs.procedimiento.ActualizarProcedimientoDtoInfo;

public class ActualizarProcedimientoDto implements
		ActualizarProcedimientoDtoInfo {
	
	private Integer estimacion;
	private Long id;
	private String numeroAutos;
	private Integer plazoRecuperacion;
	private BigDecimal principal;
	private Long tipoJuzgado;
	private String tipoPlaza;
	private Long tipoReclamacion;
	
	@Override
	public Integer getEstimacion() {
		return estimacion;
	}

	@Override
	public Long getId() {
		return id;
	}

	@Override
	public String getNumeroAutos() {
		return numeroAutos;
	}

	@Override
	public Integer getPlazoRecuperacion() {
		return plazoRecuperacion;
	}

	@Override
	public BigDecimal getPrincipal() {
		return principal;
	}

	@Override
	public Long getTipoJuzgado() {
		return tipoJuzgado;
	}

	@Override
	public String getTipoPlaza() {
		return tipoPlaza;
	}

	@Override
	public Long getTipoReclamacion() {
		return tipoReclamacion;
	}

	public void setEstimacion(Integer estimacion) {
		this.estimacion = estimacion;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setNumerosAutos(String numeroAutos) {
		this.numeroAutos = numeroAutos;
	}

	public void setPlazoRecuperacion(Integer plazoRecuperacion) {
		this.plazoRecuperacion = plazoRecuperacion;
	}

	public void setPrincipal(BigDecimal principal) {
		this.principal = principal;
	}

	public void setTipoJuzgado(Long tipoJuzgado) {
		this.tipoJuzgado = tipoJuzgado;
	}

	public void setTipoPlaza(String tipoPlaza) {
		this.tipoPlaza = tipoPlaza;
	}

	public void setTipoReclamacion(Long tipoReclamacion) {
		this.tipoReclamacion = tipoReclamacion;
	}

}
