package es.pfsgroup.plugin.recovery.masivo.dto;

public class MSVDocumentoPendienteDto {

	private Long id;
	private Long idAsunto;
	private Long idProcedimiento;
	private Long numeroCasoNova;
	private String codigoTipoInput;
	private String codigoTipoProcedimiento;
	private Long token;
	private Boolean requiereMail;
	private String codigoEstado;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdAsunto() {
		return idAsunto;
	}
	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}
	public Long getIdProcedimiento() {
		return idProcedimiento;
	}
	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}
	public Long getNumeroCasoNova() {
		return numeroCasoNova;
	}
	public void setNumeroCasoNova(Long numeroCasoNova) {
		this.numeroCasoNova = numeroCasoNova;
	}
	public String getCodigoTipoInput() {
		return codigoTipoInput;
	}
	public void setCodigoTipoInput(String codigoTipoInput) {
		this.codigoTipoInput = codigoTipoInput;
	}
	public String getCodigoTipoProcedimiento() {
		return codigoTipoProcedimiento;
	}
	public void setCodigoTipoProcedimiento(String codigoTipoProcedimiento) {
		this.codigoTipoProcedimiento = codigoTipoProcedimiento;
	}
	public Long getToken() {
		return token;
	}
	public void setToken(Long token) {
		this.token = token;
	}
	public Boolean getRequiereMail() {
		return requiereMail;
	}
	public void setRequiereMail(Boolean requiereMail) {
		this.requiereMail = requiereMail;
	}
	public void setCodigoEstado(String codigoEstado) {
		this.codigoEstado = codigoEstado;
	}
	public String getCodigoEstado() {
		return codigoEstado;
	}
	
	
	
	
}
