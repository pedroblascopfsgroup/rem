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
	

	private Long id;
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
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
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

   	
}
