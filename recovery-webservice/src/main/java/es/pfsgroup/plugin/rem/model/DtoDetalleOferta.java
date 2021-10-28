package es.pfsgroup.plugin.rem.model;

import java.util.Date;

public class DtoDetalleOferta {


	private String id;
	private String usuAlta;
	private String usuBaja;
	private String numOferta;
	private String intencionFinanciar;
	private String numVisitaRem;
	private String procedenciaVisita;
	private String sucursal;
	private String motivoRechazoDesc;
	private String ofertaExpress;
	private String necesitaFinanciacion;
	private String observaciones;
	private Date fechaEntradaCRMSF;
	private Boolean empleadoCaixa;
	DtoDeposito dtoDeposito;
	private String cuentaBancariaVirtual;
	private String cuentaBancariaCliente;
	private String numOfertaCaixa;
	private Boolean checkSubasta;
	private String titularesConfirmados;


	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getNumOferta() {
		return numOferta;
	}
	public void setNumOferta(String numOferta) {
		this.numOferta = numOferta;
	}
	public String getIntencionFinanciar() {
		return intencionFinanciar;
	}
	public void setIntencionFinanciar(String intencionFinanciar) {
		this.intencionFinanciar = intencionFinanciar;
	}
	public String getNumVisitaRem() {
		return numVisitaRem;
	}
	public void setNumVisitaRem(String numVisitaRem) {
		this.numVisitaRem = numVisitaRem;
	}
	public String getProcedenciaVisita() {
		return procedenciaVisita;
	}
	public void setProcedenciaVisita(String procedenciaVisita) {
		this.procedenciaVisita = procedenciaVisita;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getMotivoRechazoDesc() {
		return motivoRechazoDesc;
	}
	public void setMotivoRechazoDesc(String motivoRechazoDesc) {
		this.motivoRechazoDesc = motivoRechazoDesc;
	}
	public String getUsuAlta() {
		return usuAlta;
	}
	public void setUsuAlta(String usuAlta) {
		this.usuAlta = usuAlta;
	}
	public String getUsuBaja() {
		return usuBaja;
	}
	public void setUsuBaja(String usuBaja) {
		this.usuBaja = usuBaja;
	}
	public String getOfertaExpress() {
		return ofertaExpress;
	}
	public void setOfertaExpress(String ofertaExpress) {
		this.ofertaExpress = ofertaExpress;
	}
	public String getNecesitaFinanciacion() {
		return necesitaFinanciacion;
	}
	public void setNecesitaFinanciacion(String necesitaFinanciacion) {
		this.necesitaFinanciacion = necesitaFinanciacion;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public Date getFechaEntradaCRMSF() {
		return fechaEntradaCRMSF;
	}
	public void setFechaEntradaCRMSF(Date fechaEntradaCRMSF) {
		this.fechaEntradaCRMSF = fechaEntradaCRMSF;
	}
	public Boolean getEmpleadoCaixa() {
		return empleadoCaixa;
	}
	public void setEmpleadoCaixa(Boolean empleadoCaixa) {
		this.empleadoCaixa = empleadoCaixa;
	}
	public DtoDeposito getDtoDeposito() {
		return dtoDeposito;
	}
	public void setDtoDeposito(DtoDeposito dtoDeposito) {
		this.dtoDeposito = dtoDeposito;
	}
	public String getCuentaBancariaVirtual() {
		return cuentaBancariaVirtual;
	}
	public void setCuentaBancariaVirtual(String cuentaBancariaVirtual) {
		this.cuentaBancariaVirtual = cuentaBancariaVirtual;
	}
	public String getCuentaBancariaCliente() {
		return cuentaBancariaCliente;
	}
	public void setCuentaBancariaCliente(String cuentaBancariaCliente) {
		this.cuentaBancariaCliente = cuentaBancariaCliente;
	}
	public String getNumOfertaCaixa() {
		return numOfertaCaixa;
	}
	public void setNumOfertaCaixa(String numOfertaCaixa) {
		this.numOfertaCaixa = numOfertaCaixa;
	}
	public Boolean getCheckSubasta() {
		return checkSubasta;
	}
	public void setCheckSubasta(Boolean checkSubasta) {
		this.checkSubasta = checkSubasta;
	}
	
	public String getTitularesConfirmados() {
		return titularesConfirmados;
	}
	public void setTitularesConfirmados(String titularesConfirmados) {
		this.titularesConfirmados = titularesConfirmados;
	}
	
}