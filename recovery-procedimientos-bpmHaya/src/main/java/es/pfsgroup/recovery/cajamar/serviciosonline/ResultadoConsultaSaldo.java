package es.pfsgroup.recovery.cajamar.serviciosonline;

import es.capgemini.pfs.contrato.model.DDAplicativoOrigen;

public class ResultadoConsultaSaldo {

	private boolean error = false;
	private String estado = "";
	private String codigoError = "";
	private String mensajeError = "";
	private String claseApp = "";
	private String excedido = "";
	private String fechaImpago = "";
	private String numCuenta = "";
	private String oficina = "";
	private String riesgoGlobal = "";
	private String saldoAct = "";
	private String saldoGastos = "";
	private String saldoRetenido = "";
	private String capitalVencido = "";
	private String capitalNoVencido = "";
	private String demoraRecibos = "";
	private String demoras = "";
	private String impagado = "";
	private String intereses = "";
	private String disponible = "";
	private String interesesRecibos = "";
	private String movimientos3M = "";
	private String saldoMedio12M = "";
	private String saldoMedio3M = "";
	private String comisionDevolucion = "";
	private String dispuesto = "";
	private String fechaMora = "";
	private String financiado = "";
	private String importeLimite = "";
	private String iva = "";
	private String capitalDispuesto = "";
	private String capitalRecibosOpen = "";
	private String carencia = "";
	private String demoraRecibosOpen = "";
	private String interesesRecibosOpen = "";
	private String ivaRecibosOpen = "";
	private String importePol = "";
	//añadido
	private DDAplicativoOrigen aplicativo=null;
	
	public boolean isError() {
		return error;
	}
	public void setError(boolean error) {
		this.error = error;
	}
	public String getCodigoError() {
		return codigoError;
	}
	public void setCodigoError(String codigoError) {
		this.codigoError = codigoError;
	}
	public String getMensajeError() {
		return mensajeError;
	}
	public void setMensajeError(String mensajeError) {
		this.mensajeError = mensajeError;
	}
	public String getClaseApp() {
		return claseApp;
	}
	public void setClaseApp(String claseApp) {
		this.claseApp = claseApp;
	}
	public String getExcedido() {
		return excedido;
	}
	public void setExcedido(String excedido) {
		this.excedido = excedido;
	}
	public String getFechaImpago() {
		return fechaImpago;
	}
	public void setFechaImpago(String fechaImpago) {
		this.fechaImpago = fechaImpago;
	}
	public String getNumCuenta() {
		return numCuenta;
	}
	public void setNumCuenta(String numCuenta) {
		this.numCuenta = numCuenta;
	}
	public String getOficina() {
		return oficina;
	}
	public void setOficina(String oficina) {
		this.oficina = oficina;
	}
	public String getRiesgoGlobal() {
		return riesgoGlobal;
	}
	public void setRiesgoGlobal(String riesgoGlobal) {
		this.riesgoGlobal = riesgoGlobal;
	}
	public String getSaldoAct() {
		return saldoAct;
	}
	public void setSaldoAct(String saldoAct) {
		this.saldoAct = saldoAct;
	}
	public String getSaldoGastos() {
		return saldoGastos;
	}
	public void setSaldoGastos(String saldoGastos) {
		this.saldoGastos = saldoGastos;
	}
	public String getSaldoRetenido() {
		return saldoRetenido;
	}
	public void setSaldoRetenido(String saldoRetenido) {
		this.saldoRetenido = saldoRetenido;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public String getCapitalVencido() {
		return capitalVencido;
	}
	public void setCapitalVencido(String capitalVencido) {
		this.capitalVencido = capitalVencido;
	}
	public String getCapitalNoVencido() {
		return capitalNoVencido;
	}
	public void setCapitalNoVencido(String capitalNoVencido) {
		this.capitalNoVencido = capitalNoVencido;
	}
	public String getDemoraRecibos() {
		return demoraRecibos;
	}
	public void setDemoraRecibos(String demoraRecibos) {
		this.demoraRecibos = demoraRecibos;
	}
	public String getDemoras() {
		return demoras;
	}
	public void setDemoras(String demoras) {
		this.demoras = demoras;
	}
	public String getImpagado() {
		return impagado;
	}
	public void setImpagado(String impagado) {
		this.impagado = impagado;
	}
	public String getIntereses() {
		return intereses;
	}
	public void setIntereses(String intereses) {
		this.intereses = intereses;
	}
	public String getDisponible() {
		return disponible;
	}
	public void setDisponible(String disponible) {
		this.disponible = disponible;
	}
	public String getInteresesRecibos() {
		return interesesRecibos;
	}
	public void setInteresesRecibos(String interesesRecibos) {
		this.interesesRecibos = interesesRecibos;
	}
	public String getMovimientos3M() {
		return movimientos3M;
	}
	public void setMovimientos3M(String movimientos3m) {
		movimientos3M = movimientos3m;
	}
	public String getSaldoMedio12M() {
		return saldoMedio12M;
	}
	public void setSaldoMedio12M(String saldoMedio12M) {
		this.saldoMedio12M = saldoMedio12M;
	}
	public String getSaldoMedio3M() {
		return saldoMedio3M;
	}
	public void setSaldoMedio3M(String saldoMedio3M) {
		this.saldoMedio3M = saldoMedio3M;
	}
	public String getComisionDevolucion() {
		return comisionDevolucion;
	}
	public void setComisionDevolucion(String comisionDevolucion) {
		this.comisionDevolucion = comisionDevolucion;
	}
	public String getDispuesto() {
		return dispuesto;
	}
	public void setDispuesto(String dispuesto) {
		this.dispuesto = dispuesto;
	}
	public String getFechaMora() {
		return fechaMora;
	}
	public void setFechaMora(String fechaMora) {
		this.fechaMora = fechaMora;
	}
	public String getFinanciado() {
		return financiado;
	}
	public void setFinanciado(String financiado) {
		this.financiado = financiado;
	}
	public String getImporteLimite() {
		return importeLimite;
	}
	public void setImporteLimite(String importeLimite) {
		this.importeLimite = importeLimite;
	}
	public String getIva() {
		return iva;
	}
	public void setIva(String iva) {
		this.iva = iva;
	}
	public String getCapitalDispuesto() {
		return capitalDispuesto;
	}
	public void setCapitalDispuesto(String capitalDispuesto) {
		this.capitalDispuesto = capitalDispuesto;
	}
	public String getCapitalRecibosOpen() {
		return capitalRecibosOpen;
	}
	public void setCapitalRecibosOpen(String capitalRecibosOpen) {
		this.capitalRecibosOpen = capitalRecibosOpen;
	}
	public String getCarencia() {
		return carencia;
	}
	public void setCarencia(String carencia) {
		this.carencia = carencia;
	}
	public String getDemoraRecibosOpen() {
		return demoraRecibosOpen;
	}
	public void setDemoraRecibosOpen(String demoraRecibosOpen) {
		this.demoraRecibosOpen = demoraRecibosOpen;
	}
	public String getInteresesRecibosOpen() {
		return interesesRecibosOpen;
	}
	public void setInteresesRecibosOpen(String interesesRecibosOpen) {
		this.interesesRecibosOpen = interesesRecibosOpen;
	}
	public String getIvaRecibosOpen() {
		return ivaRecibosOpen;
	}
	public void setIvaRecibosOpen(String ivaRecibosOpen) {
		this.ivaRecibosOpen = ivaRecibosOpen;
	}
	public String getImportePol() {
		return importePol;
	}
	public void setImportePol(String importePol) {
		this.importePol = importePol;
	}
	public DDAplicativoOrigen getAplicativo() {
		return aplicativo;
	}
	public void setAplicativo(DDAplicativoOrigen aplicativo) {
		this.aplicativo = aplicativo;
	}

}
