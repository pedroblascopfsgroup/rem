package es.pfsgroup.recovery.recobroCommon.metasVolantes.dto;

import es.capgemini.devon.dto.WebDto;

public class RecobroDtoMetaVolante  extends WebDto{


	private static final long serialVersionUID = -5830780712514804441L;
	
	private Long id;
	private Long orden;
	private Integer diasDesdeEntrega;
	private String bloqueo;
	private Long idItinerario;
	private String codigo;
	private String descripcion;
	private Long plazoMaxGestion;
	private Long plazoSinGestion;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getOrden() {
		return orden;
	}
	public void setOrden(Long orden) {
		this.orden = orden;
	}
	public Integer getDiasDesdeEntrega() {
		return diasDesdeEntrega;
	}
	public void setDiasDesdeEntrega(Integer diasDesdeEntrega) {
		this.diasDesdeEntrega = diasDesdeEntrega;
	}
	public String getBloqueo() {
		return bloqueo;
	}
	public void setBloqueo(String bloqueo) {
		this.bloqueo = bloqueo;
	}
	public Long getIdItinerario() {
		return idItinerario;
	}
	public void setIdItinerario(Long idItinerario) {
		this.idItinerario = idItinerario;
	}
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public Long getPlazoMaxGestion() {
		return plazoMaxGestion;
	}
	public void setPlazoMaxGestion(Long plazoMaxGestion) {
		this.plazoMaxGestion = plazoMaxGestion;
	}
	public Long getPlazoSinGestion() {
		return plazoSinGestion;
	}
	public void setPlazoSinGestion(Long plazoSinGestion) {
		this.plazoSinGestion = plazoSinGestion;
	}

	
	
	
	
}
