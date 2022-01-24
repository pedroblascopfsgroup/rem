package es.pfsgroup.plugin.rem.model;

import java.util.Date;

/**
 * Dto para el tab de patrimonio contrato
 * @author Luis Adelantado
 *
 */
public class DtoActivoPatrimonioContrato extends DtoTabActivo {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7429602301888781560L;

	private Long idActivo;
	private Date fechaCreacion;
	private String nomPrinex;
	private String uhedit;
	private String idContrato;
	private String estadoContrato;
	private Date fechaFirma;
	private Date fechaFinContrato;
	private String inquilino;
	private Double deudaPendiente;
	private Long recibosPendientes;
	private Double cuota;
	private Date ultimoReciboPagado;
	private Date ultimoReciboAdeudado;
	private Boolean multiplesResultados;
	private Boolean tieneRegistro;
	private String numeroActivoHaya;
	private Long ofertaREM;
	private Long idExpediente;
	private String idContratoAntiguo;
	private Boolean esDivarian;
	private String suborigenContrato;
	private String suborigenContratoDescripcion;
	private Date fechaObligadoCumplimiento;
	private Double fianzaObligatoria;
	private Date fechaAvalBancario;
	private Double importeAvalBancario;
	private Double importeDepositoBancario;
	private Boolean isCarteraCajamar;
	
	
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Date getFechaCreacion() {
		return fechaCreacion;
	}
	public void setFechaCreacion(Date fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}
	public String getNomPrinex() {
		return nomPrinex;
	}
	public void setNomPrinex(String nomPrinex) {
		this.nomPrinex = nomPrinex;
	}
	public String getUhedit() {
		return uhedit;
	}
	public void setUhedit(String uhedit) {
		this.uhedit = uhedit;
	}
	public String getIdContrato() {
		return idContrato;
	}
	public void setIdContrato(String idContrato) {
		this.idContrato = idContrato;
	}
	public String getEstadoContrato() {
		return estadoContrato;
	}
	public void setEstadoContrato(String estadoContrato) {
		this.estadoContrato = estadoContrato;
	}
	public Date getFechaFirma() {
		return fechaFirma;
	}
	public void setFechaFirma(Date fechaFirma) {
		this.fechaFirma = fechaFirma;
	}
	public Date getFechaFinContrato() {
		return fechaFinContrato;
	}
	public void setFechaFinContrato(Date fechaFinContrato) {
		this.fechaFinContrato = fechaFinContrato;
	}
	public String getInquilino() {
		return inquilino;
	}
	public void setInquilino(String inquilino) {
		this.inquilino = inquilino;
	}
	public Double getDeudaPendiente() {
		return deudaPendiente;
	}
	public void setDeudaPendiente(Double deudaPendiente) {
		this.deudaPendiente = deudaPendiente;
	}
	public Long getRecibosPendientes() {
		return recibosPendientes;
	}
	public void setRecibosPendientes(Long recibosPendientes) {
		this.recibosPendientes = recibosPendientes;
	}
	public Double getCuota() {
		return cuota;
	}
	public void setCuota(Double cuota) {
		this.cuota = cuota;
	}
	public Date getUltimoReciboPagado() {
		return ultimoReciboPagado;
	}
	public void setUltimoReciboPagado(Date ultimoReciboPagado) {
		this.ultimoReciboPagado = ultimoReciboPagado;
	}
	public Date getUltimoReciboAdeudado() {
		return ultimoReciboAdeudado;
	}
	public void setUltimoReciboAdeudado(Date ultimoReciboAdeudado) {
		this.ultimoReciboAdeudado = ultimoReciboAdeudado;
	}
	public Boolean getMultiplesResultados() {
		return multiplesResultados;
	}
	public void setMultiplesResultados(Boolean multiplesResultados) {
		this.multiplesResultados = multiplesResultados;
	}
	public String getNumeroActivoHaya() {
		return numeroActivoHaya;
	}
	public void setNumeroActivoHaya(String numeroActivoHaya) {
		this.numeroActivoHaya = numeroActivoHaya;
	}
	public Long getOfertaREM() {
		return ofertaREM;
	}
	public void setOfertaREM(Long ofertaREM) {
		this.ofertaREM = ofertaREM;
	}
	public Long getIdExpediente() {
		return idExpediente;
	}
	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}
	public Boolean getTieneRegistro() {
		return tieneRegistro;
	}
	public void setTieneRegistro(Boolean tieneRegistro) {
		this.tieneRegistro = tieneRegistro;
	}
	public String getIdContratoAntiguo() {
		return idContratoAntiguo;
	}
	public void setIdContratoAntiguo(String idContratoAntiguo) {
		this.idContratoAntiguo = idContratoAntiguo;
	}
	public Boolean getEsDivarian() {
		return esDivarian;
	}
	public void setEsDivarian(Boolean esDivarian) {
		this.esDivarian = esDivarian;
	}
	public String getSuborigenContrato() {
		return suborigenContrato;
	}
	public void setSuborigenContrato(String suborigenContrato) {
		this.suborigenContrato = suborigenContrato;
	}
	public String getSuborigenContratoDescripcion() {
		return suborigenContratoDescripcion;
	}
	public void setSuborigenContratoDescripcion(String suborigenContratoDescripcion) {
		this.suborigenContratoDescripcion = suborigenContratoDescripcion;
	}
	public Date getFechaObligadoCumplimiento() {
		return fechaObligadoCumplimiento;
	}
	public void setFechaObligadoCumplimiento(Date fechaObligadoCumplimiento) {
		this.fechaObligadoCumplimiento = fechaObligadoCumplimiento;
	}
	public Double getFianzaObligatoria() {
		return fianzaObligatoria;
	}
	public void setFianzaObligatoria(Double fianzaObligatoria) {
		this.fianzaObligatoria = fianzaObligatoria;
	}
	public Date getFechaAvalBancario() {
		return fechaAvalBancario;
	}
	public void setFechaAvalBancario(Date fechaAvalBancario) {
		this.fechaAvalBancario = fechaAvalBancario;
	}
	public Double getImporteAvalBancario() {
		return importeAvalBancario;
	}
	public void setImporteAvalBancario(Double importeAvalBancario) {
		this.importeAvalBancario = importeAvalBancario;
	}
	public Double getImporteDepositoBancario() {
		return importeDepositoBancario;
	}
	public void setImporteDepositoBancario(Double importeDepositoBancario) {
		this.importeDepositoBancario = importeDepositoBancario;
	}
	public Boolean getIsCarteraCajamar() {
		return isCarteraCajamar;
	}
	public void setIsCarteraCajamar(Boolean isCarteraCajamar) {
		this.isCarteraCajamar = isCarteraCajamar;
	}
	
}