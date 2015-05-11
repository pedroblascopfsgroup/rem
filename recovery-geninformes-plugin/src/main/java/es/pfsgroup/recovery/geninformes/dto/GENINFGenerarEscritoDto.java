package es.pfsgroup.recovery.geninformes.dto;

import es.capgemini.pfs.asunto.model.Procedimiento;

public class GENINFGenerarEscritoDto {
	private String tipoEntidad;
	private String tipoEscrito;
	private Long idEntidad;
	private Boolean enviarPorEmail;
	private boolean adjuntarAEntidad;
	private Procedimiento procedimiento;
	private String sufijoInforme;
	
	public GENINFGenerarEscritoDto() {
		
	}
	
	public GENINFGenerarEscritoDto(String tipoEntidad, String tipoEscrito, Long idEntidad, Boolean enviarPorEmail, 
			boolean adjuntarAEntidad, Procedimiento procedimiento, String sufijoInforme) {
		setTipoEntidad(tipoEntidad);
		setTipoEscrito(tipoEscrito);
		setIdEntidad(idEntidad);
		setEnviarPorEmail(enviarPorEmail);
		setAdjuntarAEntidad(adjuntarAEntidad);
		setProcedimiento(procedimiento);
		setSufijoInforme(sufijoInforme);
	}
	
	public GENINFGenerarEscritoDto(String tipoEntidad, String tipoEscrito, Long idEntidad, Procedimiento procedimiento) {
		setTipoEntidad(tipoEntidad);
		setTipoEscrito(tipoEscrito);
		setIdEntidad(idEntidad);
		setEnviarPorEmail(null);
		setAdjuntarAEntidad(true);
		setProcedimiento(procedimiento);
		setSufijoInforme(null);
	}
	
	public String getTipoEntidad() {
		return tipoEntidad;
	}
	public void setTipoEntidad(String tipoEntidad) {
		this.tipoEntidad = tipoEntidad;
	}
	public String getTipoEscrito() {
		return tipoEscrito;
	}
	public void setTipoEscrito(String tipoEscrito) {
		this.tipoEscrito = tipoEscrito;
	}
	public Long getIdEntidad() {
		return idEntidad;
	}
	public void setIdEntidad(Long idEntidad) {
		this.idEntidad = idEntidad;
	}

	public Boolean getEnviarPorEmail() {
		return enviarPorEmail;
	}

	public void setEnviarPorEmail(Boolean enviarPorEmail) {
		this.enviarPorEmail = enviarPorEmail;
	}

	public boolean isAdjuntarAEntidad() {
		return adjuntarAEntidad;
	}

	public void setAdjuntarAEntidad(boolean adjuntarAEntidad) {
		this.adjuntarAEntidad = adjuntarAEntidad;
	}

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}
	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}
	public String getSufijoInforme() {
		return sufijoInforme;
	}
	public void setSufijoInforme(String sufijoInforme) {
		this.sufijoInforme = sufijoInforme;
	}
	
}
