package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de un detalle gasto.
 *  
 * @author Luis Caballero
 *
 */
public class DtoDetalleEconomicoGasto extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Long gastoProveedor;
	private String impuestoIndirectoTipoCodigo;
	private Boolean impuestoIndirectoExento;
	private Double impuestoIndirectoTipoImpositivo;
	private Double impuestoIndirectoCuota;
	private Double irpfTipoImpositivo;
	private Double irpfCuota;
	private Double importeTotal;
	private Date fechaTopePago;
	private Integer repercutibleInquilino;
	private Double importePagado;
	private Date fechaPago;
	private String tipoPagadorCodigo;
	private String tipoPago;
	private String destinatariosPagoCodigo;
	private Boolean reembolsoTercero;
	private Boolean incluirPagoProvision;
	private Boolean abonoCuenta;
	private String iban;
	private String iban1;
	private String iban2;
	private String iban3;
	private String iban4;
	private String iban5;
	private String iban6;
	private String titularCuenta;
	private String nifTitularCuenta;
	private Boolean pagadoConexionBankia;
	private String oficina;
	private String numeroConexion;
	private Boolean optaCriterioCaja;
	private Date fechaConexion;
	private Boolean anticipo;
	private Date fechaAnticipo;
	private String cartera;
	private Double exencionlbk;
	private Double totalImportePromocion;
	private Double importeTotalPrinex;
	private Boolean prorrata;
	private Boolean gastoRefacturableB;
	private Double importeGastosRefacturables;
	private Long numeroGastoHaya;
	private Boolean bloquearCheckRefacturado;
	private Boolean bloquearGridRefacturados;
	private Boolean bloquearDestinatarios;
	private Boolean noAnyadirEliminarGastosRefacturados;
	private Double irpfTipoImpositivoRetG;
	private Double irpfCuotaRetG;
	private Double baseRetG;
	private Double baseImpI;
	private String clave;
	private String subclave;
	private Boolean retencionGarantiaAplica;
	private Double importeBrutoLbk;
	private String tipoRetencionCodigo;
	private Boolean pagoUrgente;

	public Long getGastoProveedor() {
		return gastoProveedor;
	}
	public void setGastoProveedor(Long gastoProveedor) {
		this.gastoProveedor = gastoProveedor;
	}
	public String getImpuestoIndirectoTipoCodigo() {
		return impuestoIndirectoTipoCodigo;
	}
	public void setImpuestoIndirectoTipoCodigo(String impuestoIndirectoTipoCodigo) {
		this.impuestoIndirectoTipoCodigo = impuestoIndirectoTipoCodigo;
	}
	public Boolean getImpuestoIndirectoExento() {
		return impuestoIndirectoExento;
	}
	public void setImpuestoIndirectoExento(Boolean impuestoIndirectoExento) {
		this.impuestoIndirectoExento = impuestoIndirectoExento;
	}
	public Double getImpuestoIndirectoTipoImpositivo() {
		return impuestoIndirectoTipoImpositivo;
	}
	public void setImpuestoIndirectoTipoImpositivo(
			Double impuestoIndirectoTipoImpositivo) {
		this.impuestoIndirectoTipoImpositivo = impuestoIndirectoTipoImpositivo;
	}
	public Double getImpuestoIndirectoCuota() {
		return impuestoIndirectoCuota;
	}
	public void setImpuestoIndirectoCuota(Double impuestoIndirectoCuota) {
		this.impuestoIndirectoCuota = impuestoIndirectoCuota;
	}
	public Double getIrpfTipoImpositivo() {
		return irpfTipoImpositivo;
	}
	public void setIrpfTipoImpositivo(Double irpfTipoImpositivo) {
		this.irpfTipoImpositivo = irpfTipoImpositivo;
	}
	public Double getIrpfCuota() {
		return irpfCuota;
	}
	public void setIrpfCuota(Double irpfCuota) {
		this.irpfCuota = irpfCuota;
	}
	public Double getImporteTotal() {
		return importeTotal;
	}
	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}
	public Date getFechaTopePago() {
		return fechaTopePago;
	}
	public void setFechaTopePago(Date fechaTopePago) {
		this.fechaTopePago = fechaTopePago;
	}
	public Integer getRepercutibleInquilino() {
		return repercutibleInquilino;
	}
	public void setRepercutibleInquilino(Integer repercutibleInquilino) {
		this.repercutibleInquilino = repercutibleInquilino;
	}
	public Double getImportePagado() {
		return importePagado;
	}
	public void setImportePagado(Double importePagado) {
		this.importePagado = importePagado;
	}
	public Date getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(Date fechaPago) {
		this.fechaPago = fechaPago;
	}
	public String getTipoPago() {
		return tipoPago;
	}
	public void setTipoPago(String tipoPago) {
		this.tipoPago = tipoPago;
	}
	public String getTipoPagadorCodigo() {
		return tipoPagadorCodigo;
	}
	public void setTipoPagadorCodigo(String tipoPagadorCodigo) {
		this.tipoPagadorCodigo = tipoPagadorCodigo;
	}
	public String getDestinatariosPagoCodigo() {
		return destinatariosPagoCodigo;
	}
	public void setDestinatariosPagoCodigo(String destinatariosPagoCodigo) {
		this.destinatariosPagoCodigo = destinatariosPagoCodigo;
	}
	public Boolean getReembolsoTercero() {
		return reembolsoTercero;
	}
	public void setReembolsoTercero(Boolean reembolsoTercero) {
		this.reembolsoTercero = reembolsoTercero;
	}
	public Boolean getIncluirPagoProvision() {
		return incluirPagoProvision;
	}
	public void setIncluirPagoProvision(Boolean incluirPagoProvision) {
		this.incluirPagoProvision = incluirPagoProvision;
	}
	public Boolean getAbonoCuenta() {
		return abonoCuenta;
	}
	public void setAbonoCuenta(Boolean abonoCuenta) {
		this.abonoCuenta = abonoCuenta;
	}
	public String getIban() {
		return iban;
	}
	public void setIban(String iban) {
		this.iban = iban;
	}
	public String getIban1() {
		return iban1;
	}
	public void setIban1(String iban1) {
		this.iban1 = iban1;
	}
	public String getIban2() {
		return iban2;
	}
	public void setIban2(String iban2) {
		this.iban2 = iban2;
	}
	public String getIban3() {
		return iban3;
	}
	public void setIban3(String iban3) {
		this.iban3 = iban3;
	}
	public String getIban4() {
		return iban4;
	}
	public void setIban4(String iban4) {
		this.iban4 = iban4;
	}
	public String getIban5() {
		return iban5;
	}
	public void setIban5(String iban5) {
		this.iban5 = iban5;
	}
	public String getIban6() {
		return iban6;
	}
	public void setIban6(String iban6) {
		this.iban6 = iban6;
	}
	public String getTitularCuenta() {
		return titularCuenta;
	}
	public void setTitularCuenta(String titularCuenta) {
		this.titularCuenta = titularCuenta;
	}
	public String getNifTitularCuenta() {
		return nifTitularCuenta;
	}
	public void setNifTitularCuenta(String nifTitularCuenta) {
		this.nifTitularCuenta = nifTitularCuenta;
	}
	public Boolean getPagadoConexionBankia() {
		return pagadoConexionBankia;
	}
	public void setPagadoConexionBankia(Boolean pagadoConexionBankia) {
		this.pagadoConexionBankia = pagadoConexionBankia;
	}
	public String getOficina() {
		return oficina;
	}
	public void setOficina(String oficina) {
		this.oficina = oficina;
	}
	public String getNumeroConexion() {
		return numeroConexion;
	}
	public void setNumeroConexion(String numeroConexion) {
		this.numeroConexion = numeroConexion;
	}
	public Boolean getOptaCriterioCaja() {
		return optaCriterioCaja;
	}
	public void setOptaCriterioCaja(Boolean optaCriterioCaja) {
		this.optaCriterioCaja = optaCriterioCaja;
	}
	public Date getFechaConexion() {
		return fechaConexion;
	}
	public void setFechaConexion(Date fechaConexion) {
		this.fechaConexion = fechaConexion;
	}
	public Boolean getAnticipo() {
		return anticipo;
	}
	public void setAnticipo(Boolean anticipo) {
		this.anticipo = anticipo;
	}
	public Date getFechaAnticipo() {
		return fechaAnticipo;
	}
	public void setFechaAnticipo(Date fechaAnticipo) {
		this.fechaAnticipo = fechaAnticipo;
	}
	public String getCartera() {
		return cartera;
	}
	public void setCartera(String cartera) {
		this.cartera = cartera;
	}
	public Boolean getProrrata() {
		return prorrata;
	}
	public void setProrrata(Boolean prorrata) {
		this.prorrata = prorrata;
	}
	public Double getExencionlbk() {
		return exencionlbk;
	}
	public void setExencionlbk(Double exencionlbk) {
		this.exencionlbk = exencionlbk;
	}
	public Double getTotalImportePromocion() {
		return totalImportePromocion;
	}
	public void setTotalImportePromocion(Double totalImportePromocion) {
		this.totalImportePromocion = totalImportePromocion;
	}
	public Double getImporteTotalPrinex() {
		return importeTotalPrinex;
	}
	public void setImporteTotalPrinex(Double importeTotalPrinex) {
		this.importeTotalPrinex = importeTotalPrinex;
	}
	public Boolean getGastoRefacturableB() {
		return gastoRefacturableB;
	}
	public void setGastoRefacturableB(Boolean gastoRefacturableB) {
		this.gastoRefacturableB = gastoRefacturableB;
	}
	public Long getNumeroGastoHaya() {
		return numeroGastoHaya;
	}
	public void setNumeroGastoHaya(Long numeroGastoHaya) {
		this.numeroGastoHaya = numeroGastoHaya;
	}
	public Boolean getBloquearCheckRefacturado() {
		return bloquearCheckRefacturado;
	}
	public void setBloquearCheckRefacturado(Boolean bloquearCheckRefacturado) {
		this.bloquearCheckRefacturado = bloquearCheckRefacturado;
	}
	public Boolean getBloquearGridRefacturados() {
		return bloquearGridRefacturados;
	}
	public void setBloquearGridRefacturados(Boolean bloquearGridRefacturados) {
		this.bloquearGridRefacturados = bloquearGridRefacturados;
	}
	public Double getImporteGastosRefacturables() {
		return importeGastosRefacturables;
	}
	public void setImporteGastosRefacturables(Double importeGastosRefacturables) {
		this.importeGastosRefacturables = importeGastosRefacturables;
	}
	public Boolean getBloquearDestinatarios() {
		return bloquearDestinatarios;
	}
	public void setBloquearDestinatarios(Boolean bloquearDestinatarios) {
		this.bloquearDestinatarios = bloquearDestinatarios;
	}
	public Boolean getNoAnyadirEliminarGastosRefacturados() {
		return noAnyadirEliminarGastosRefacturados;
	}
	public void setNoAnyadirEliminarGastosRefacturados(Boolean noAnyadirEliminarGastosRefacturados) {
		this.noAnyadirEliminarGastosRefacturados = noAnyadirEliminarGastosRefacturados;
	}
	public Double getIrpfTipoImpositivoRetG() {
		return irpfTipoImpositivoRetG;
	}
	public void setIrpfTipoImpositivoRetG(Double irpfTipoImpositivoRetG) {
		this.irpfTipoImpositivoRetG = irpfTipoImpositivoRetG;
	}
	public Double getIrpfCuotaRetG() {
		return irpfCuotaRetG;
	}
	public void setIrpfCuotaRetG(Double irpfCuotaRetG) {
		this.irpfCuotaRetG = irpfCuotaRetG;
	}
	public Double getBaseRetG() {
		return baseRetG;
	}
	public void setBaseRetG(Double baseRetG) {
		this.baseRetG = baseRetG;
	}
	public Double getBaseImpI() {
		return baseImpI;
	}
	public void setBaseImpI(Double baseImpI) {
		this.baseImpI = baseImpI;
	}
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
	public String getSubclave() {
		return subclave;
	}
	public void setSubclave(String subclave) {
		this.subclave = subclave;
	}

	public Boolean getRetencionGarantiaAplica() {
		return retencionGarantiaAplica;
	}
	public void setRetencionGarantiaAplica(Boolean retencionGarantiaAplica) {
		this.retencionGarantiaAplica = retencionGarantiaAplica;
	}

	public Double getImporteBrutoLbk() {
		return importeBrutoLbk;
	}
	public void setImporteBrutoLbk(Double importeBrutoLbk) {
		this.importeBrutoLbk = importeBrutoLbk;
	}
	public String getTipoRetencionCodigo() {
		return tipoRetencionCodigo;
	}
	public void setTipoRetencionCodigo(String tipoRetencionCodigo) {
		this.tipoRetencionCodigo = tipoRetencionCodigo;
	}
	public Boolean getPagoUrgente() {
		return pagoUrgente;
	}
	public void setPagoUrgente(Boolean pagoUrgente) {
		this.pagoUrgente = pagoUrgente;
	}
	
}
