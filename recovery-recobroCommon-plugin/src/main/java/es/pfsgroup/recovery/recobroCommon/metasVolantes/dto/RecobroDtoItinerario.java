package es.pfsgroup.recovery.recobroCommon.metasVolantes.dto;

import es.capgemini.devon.dto.WebDto;

public class RecobroDtoItinerario  extends WebDto{


	private static final long serialVersionUID = -5830780712514804441L;
	
	private String id;
	private String nombre;
	private String fechaAlta;
	private String plazoMaxGestion;
	private String PlazoSinGestion;
	private Long idEsquema;
	private Long idEstado;
	private String porcentajeCobroParcial;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(String fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public String getPlazoMaxGestion() {
		return plazoMaxGestion;
	}
	public void setPlazoMaxGestion(String plazoMaxGestion) {
		this.plazoMaxGestion = plazoMaxGestion;
	}
	public String getPlazoSinGestion() {
		return PlazoSinGestion;
	}
	public void setPlazoSinGestion(String plazoSinGestion) {
		PlazoSinGestion = plazoSinGestion;
	}
	public Long getIdEsquema() {
		return idEsquema;
	}
	public void setIdEsquema(Long idEsquema) {
		this.idEsquema = idEsquema;
	}
	public Long getIdEstado() {
		return idEstado;
	}
	public void setIdEstado(Long idEstado) {
		this.idEstado = idEstado;
	}
	public String getPorcentajeCobroParcial() {
		return porcentajeCobroParcial;
	}
	public void setPorcentajeCobroParcial(String porcentajeCobroParcial) {
		this.porcentajeCobroParcial = porcentajeCobroParcial;
	}
	
	
}
