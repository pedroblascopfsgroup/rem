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
	private Double importePrincipalSujeto;
	private Double importePrincipalNoSujeto;
	private Double importeRecargo;
	private Double importeInteresDemora;
	private Double importeCostas;
	private Double importeOtrosIncrementos;
	private Double importeProvisionesSuplidos;
	private String impuestoIndirectoTipoCodigo;
	private Boolean impuestoIndirectoExento;
	private Boolean renunciaExencionImpuestoIndirecto;
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
	private Long exencionlbk;
	private Long totalImportePromocion;
	private Long importeTotalPrinex;
	private Boolean prorrata;
	

	public Long getGastoProveedor() {
		return gastoProveedor;
	}
	public void setGastoProveedor(Long gastoProveedor) {
		this.gastoProveedor = gastoProveedor;
	}
	public Double getImportePrincipalSujeto() {
		return importePrincipalSujeto;
	}
	public void setImportePrincipalSujeto(Double importePrincipalSujeto) {
		this.importePrincipalSujeto = importePrincipalSujeto;
	}
	public Double getImportePrincipalNoSujeto() {
		return importePrincipalNoSujeto;
	}
	public void setImportePrincipalNoSujeto(Double importePrincipalNoSujeto) {
		this.importePrincipalNoSujeto = importePrincipalNoSujeto;
	}
	public Double getImporteRecargo() {
		return importeRecargo;
	}
	public void setImporteRecargo(Double importeRecargo) {
		this.importeRecargo = importeRecargo;
	}
	public Double getImporteInteresDemora() {
		return importeInteresDemora;
	}
	public void setImporteInteresDemora(Double importeInteresDemora) {
		this.importeInteresDemora = importeInteresDemora;
	}
	public Double getImporteCostas() {
		return importeCostas;
	}
	public void setImporteCostas(Double importeCostas) {
		this.importeCostas = importeCostas;
	}
	public Double getImporteOtrosIncrementos() {
		return importeOtrosIncrementos;
	}
	public void setImporteOtrosIncrementos(Double importeOtrosIncrementos) {
		this.importeOtrosIncrementos = importeOtrosIncrementos;
	}
	public Double getImporteProvisionesSuplidos() {
		return importeProvisionesSuplidos;
	}
	public void setImporteProvisionesSuplidos(Double importeProvisionesSuplidos) {
		this.importeProvisionesSuplidos = importeProvisionesSuplidos;
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
	public Boolean getRenunciaExencionImpuestoIndirecto() {
		return renunciaExencionImpuestoIndirecto;
	}
	public void setRenunciaExencionImpuestoIndirecto(
			Boolean renunciaExencionImpuestoIndirecto) {
		this.renunciaExencionImpuestoIndirecto = renunciaExencionImpuestoIndirecto;
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
	public Long getExencionlbk() {
		return exencionlbk;
	}
	public void setExencionlbk(Long exencionlbk) {
		this.exencionlbk = exencionlbk;
	}
	public Long getTotalImportePromocion() {
		return totalImportePromocion;
	}
	public void setTotalImportePromocion(Long totalImportePromocion) {
		this.totalImportePromocion = totalImportePromocion;
	}
	public Long getImporteTotalPrinex() {
		return importeTotalPrinex;
	}
	public void setImporteTotalPrinex(Long importeTotalPrinex) {
		this.importeTotalPrinex = importeTotalPrinex;
	}
	public Boolean getProrrata() {
		return prorrata;
	}
	public void setProrrata(Boolean prorrata) {
		this.prorrata = prorrata;
	}
	
   	
}
