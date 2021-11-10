package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoScreening extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long numOferta;
    private String codigoTarea ;
	private String usuarioLogado;
	private Long numExpedienteComercial;
	private Boolean isTareaActiva;
	
	private String motivoBloqueado;
	private String motivoDesbloqueado;
	private String observacionesBloqueado;
	private String observacionesDesbloqueado;
	private String comboResultado;
	
	private boolean bloqueo;

	public Long getNumOferta() {
		return numOferta;
	}

	public void setNumOferta(Long numOferta) {
		this.numOferta = numOferta;
	}

	public String getCodigoTarea() {
		return codigoTarea;
	}

	public void setCodigoTarea(String codigoTarea) {
		this.codigoTarea = codigoTarea;
	}

	public String getUsuarioLogado() {
		return usuarioLogado;
	}

	public void setUsuarioLogado(String usuarioLogado) {
		this.usuarioLogado = usuarioLogado;
	}

	public Long getNumExpedienteComercial() {
		return numExpedienteComercial;
	}

	public void setNumExpedienteComercial(Long numExpedienteComercial) {
		this.numExpedienteComercial = numExpedienteComercial;
	}

	public Boolean getIsTareaActiva() {
		return isTareaActiva;
	}

	public void setIsTareaActiva(Boolean isTareaActiva) {
		this.isTareaActiva = isTareaActiva;
	}

	public String getMotivoBloqueado() {
		return motivoBloqueado;
	}

	public void setMotivoBloqueado(String motivoBloqueado) {
		this.motivoBloqueado = motivoBloqueado;
	}

	public String getMotivoDesbloqueado() {
		return motivoDesbloqueado;
	}

	public void setMotivoDesbloqueado(String motivoDesbloqueado) {
		this.motivoDesbloqueado = motivoDesbloqueado;
	}

	public String getObservacionesBloqueado() {
		return observacionesBloqueado;
	}

	public void setObservacionesBloqueado(String observacionesBloqueado) {
		this.observacionesBloqueado = observacionesBloqueado;
	}

	public String getObservacionesDesbloqueado() {
		return observacionesDesbloqueado;
	}

	public void setObservacionesDesbloqueado(String observacionesDesbloqueado) {
		this.observacionesDesbloqueado = observacionesDesbloqueado;
	}

	public boolean isBloqueo() {
		return bloqueo;
	}

	public void setBloqueo(boolean bloqueo) {
		this.bloqueo = bloqueo;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getComboResultado() {
		return comboResultado;
	}

	public void setComboResultado(String comboResultado) {
		this.comboResultado = comboResultado;
	}
	
	
	
}
