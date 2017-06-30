package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoActivosExpediente extends WebDto {
	private static final long serialVersionUID = 1L;

	private Long idActivo;
	private Long numActivo;
	private String tipoActivo;
	private String subtipoActivo;
	private Double precioMinimo;
	private Double precioAprobadoVenta;
	private Double porcentajeParticipacion;
	private Double importeParticipacion;
	private String municipio;
	private String direccion;
	private String provincia;
	private String fincaRegistral;
	private Integer condiciones;
	private Integer bloqueos;
	private Integer tanteos;
	private Long idCondicion;
	

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public String getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(String tipo) {
		this.tipoActivo = tipo;
	}

	public String getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(String subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}

	public Double getPrecioMinimo() {
		return precioMinimo;
	}

	public void setPrecioMinimo(Double precioMinimo) {
		this.precioMinimo = precioMinimo;
	}

	public Double getPrecioAprobadoVenta() {
		return precioAprobadoVenta;
	}

	public void setPrecioAprobadoVenta(Double precioAprobadoVenta) {
		this.precioAprobadoVenta = precioAprobadoVenta;
	}

	public Double getPorcentajeParticipacion() {
		return porcentajeParticipacion;
	}

	public void setPorcentajeParticipacion(Double porcentajeParticipacion) {
		this.porcentajeParticipacion = porcentajeParticipacion;
	}

	public Double getImporteParticipacion() {
		return importeParticipacion;
	}

	public void setImporteParticipacion(Double importeParticipacion) {
		this.importeParticipacion = importeParticipacion;
	}

	public String getMunicipio() {
		return municipio;
	}

	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public Integer getCondiciones() {
		return condiciones;
	}

	public void setCondiciones(Integer condiciones) {
		this.condiciones = condiciones;
	}

	public Integer getBloqueos() {
		return bloqueos;
	}

	public void setBloqueos(Integer bloqueos) {
		this.bloqueos = bloqueos;
	}

	public Integer getTanteos() {
		return tanteos;
	}

	public void setTanteos(Integer tanteos) {
		this.tanteos = tanteos;
	}
	
	public Long getIdCondicion() {
		return idCondicion;
	}

	public void setIdCondicion(Long idCondicion) {
		this.idCondicion = idCondicion;
	}

	public String getProvincia() {
		return provincia;
	}

	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}

	public String getFincaRegistral() {
		return fincaRegistral;
	}

	public void setFincaRegistral(String fincaRegistral) {
		this.fincaRegistral = fincaRegistral;
	}
	
}
