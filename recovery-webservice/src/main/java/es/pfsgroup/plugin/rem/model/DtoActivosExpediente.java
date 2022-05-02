package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoActivosExpediente extends WebDto {
	private static final long serialVersionUID = 1L;

	private Long idActivo;
	private Long numActivo;
	private String tipoActivo;
	private String subtipoActivo;
	private Double precioMinimo;
	private String subdivision;
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
	private String puerta;
	private Float superficieConstruida;
	private String activoEPA;
	private Boolean esPisoPiloto;
	private Date fechaEscrituracion;
	

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

	public String getPuerta() {
		return puerta;
	}

	public void setPuerta(String puerta) {
		this.puerta = puerta;
	}

	public Float getSuperficieConstruida() {
		return superficieConstruida;
	}

	public void setSuperficieConstruida(Float superficieConstruida) {
		this.superficieConstruida = superficieConstruida;
	}

	public String getSubdivision() {
		return subdivision;
	}

	public void setSubdivision(String subdivision) {
		this.subdivision = subdivision;
	}

	public String getActivoEPA() {
		return activoEPA;
	}

	public void setActivoEPA(String activoEPA) {
		this.activoEPA = activoEPA;
	}

	public Boolean getEsPisoPiloto() {
		return esPisoPiloto;
	}

	public void setEsPisoPiloto(Boolean esPisoPiloto) {
		this.esPisoPiloto = esPisoPiloto;
	}

	public Date getFechaEscrituracion() {
		return fechaEscrituracion;
	}

	public void setFechaEscrituracion(Date fechaEscrituracion) {
		this.fechaEscrituracion = fechaEscrituracion;
	}
	
	
}
