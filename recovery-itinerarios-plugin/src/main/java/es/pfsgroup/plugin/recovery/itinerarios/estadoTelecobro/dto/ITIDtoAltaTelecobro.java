package es.pfsgroup.plugin.recovery.itinerarios.estadoTelecobro.dto;

import javax.validation.constraints.NotNull;

import es.capgemini.devon.dto.WebDto;

public class ITIDtoAltaTelecobro extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 363624874996365318L;

	private Long id;
	private Long estado;
	private Boolean telecobro;
	
	
	private Long proveedor;
	
	private Long plazoInicial;
	
	private Long plazoFinal;
	
	private Long diasAntelacion;
	
	private Long plazoRespuesta;
	
	private Boolean automatico;

	public void setProveedor(Long proveedor) {
		this.proveedor = proveedor;
	}

	public Long getProveedor() {
		return proveedor;
	}

	public void setPlazoInicial(Long plazoInicial) {
		this.plazoInicial = plazoInicial;
	}

	public Long getPlazoInicial() {
		return plazoInicial;
	}

	public void setPlazoFinal(Long plazoFinal) {
		this.plazoFinal = plazoFinal;
	}

	public Long getPlazoFinal() {
		return plazoFinal;
	}

	public void setDiasAntelacion(Long diasAntelacion) {
		this.diasAntelacion = diasAntelacion;
	}

	public Long getDiasAntelacion() {
		return diasAntelacion;
	}

	public void setAutomatico(Boolean automatico) {
		this.automatico = automatico;
	}

	public Boolean getAutomatico() {
		return automatico;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setPlazoRespuesta(Long plazoRespuesta) {
		this.plazoRespuesta = plazoRespuesta;
	}

	public Long getPlazoRespuesta() {
		return plazoRespuesta;
	}

	public void setTelecobro(Boolean telecobro) {
		this.telecobro = telecobro;
	}

	public Boolean getTelecobro() {
		return telecobro;
	}

	public void setEstado(Long estado) {
		this.estado = estado;
	}

	public Long getEstado() {
		return estado;
	}
}
