package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de Gastos Proveedor
 * @author Luis Caballero
 *
 */
public class DtoGastosFilter extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long id;
	private Long numGastoHaya;
	private Long idActivo;
	private Long numActivo;
	private Long numFactura;
	private String tipo;
	private String subtipo;
	private String concepto;
	private String idProveedor;
	private String codigoProveedor;
	private String fechaEmision;
	private Double importeTotal;
	private String fechaTopePago;
	private String fechaPago;
	private String periodicidad;
	private String destinatario;
	private String idDetalleGasto;
	private Long idProvision;
	
	private String estadoAutorizacionHayaCodigo;
	private String estadoAutorizacionPropietarioCodigo;
	private String otrosEstados;
//	private Long numGastoHaya;
	private String tipoGastoCodigo;
	private String importeDesde;
	private String numGastoGestoria;
	private String subtipoGastoCodigo;
	private String importeHasta;
	private String referenciaEmisor;
	private String necesitaAutorizacionPropietario;
	private String fechaTopePagoDesde;
//	private String destinatario;
	private String cubreSeguro;
	private String fechaTopePagoHasta;
//	private String periodicidad;
	private String numProvision;
	private String nifProveedor;
	private String codigoTipoProveedor;
	private String codigoSubtipoProveedor;
	private String nombreProveedor;
	
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getNumGastoHaya() {
		return numGastoHaya;
	}
	public void setNumGastoHaya(Long numGastoHaya) {
		this.numGastoHaya = numGastoHaya;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Long getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}
	public Long getNumFactura() {
		return numFactura;
	}
	public void setNumFactura(Long numFactura) {
		this.numFactura = numFactura;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getSubtipo() {
		return subtipo;
	}
	public void setSubtipo(String subtipo) {
		this.subtipo = subtipo;
	}
	public String getConcepto() {
		return concepto;
	}
	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}
	public String getIdProveedor() {
		return idProveedor;
	}
	public void setIdProveedor(String idProveedor) {
		this.idProveedor = idProveedor;
	}
	public String getCodigoProveedor() {
		return codigoProveedor;
	}
	public void setCodigoProveedor(String codigoProveedor) {
		this.codigoProveedor = codigoProveedor;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public Double getImporteTotal() {
		return importeTotal;
	}
	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}
	public String getFechaTopePago() {
		return fechaTopePago;
	}
	public void setFechaTopePago(String fechaTopePago) {
		this.fechaTopePago = fechaTopePago;
	}
	public String getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
	}
	public String getPeriodicidad() {
		return periodicidad;
	}
	public void setPeriodicidad(String periodicidad) {
		this.periodicidad = periodicidad;
	}
	public String getDestinatario() {
		return destinatario;
	}
	public void setDestinatario(String destinatario) {
		this.destinatario = destinatario;
	}
	public String getIdDetalleGasto() {
		return idDetalleGasto;
	}
	public void setIdDetalleGasto(String idDetalleGasto) {
		this.idDetalleGasto = idDetalleGasto;
	}
	public Long getIdProvision() {
		return idProvision;
	}
	public void setIdProvision(Long idProvision) {
		this.idProvision = idProvision;
	}
	public String getEstadoAutorizacionHayaCodigo() {
		return estadoAutorizacionHayaCodigo;
	}
	public void setEstadoAutorizacionHayaCodigo(String estadoAutorizacionHayaCodigo) {
		this.estadoAutorizacionHayaCodigo = estadoAutorizacionHayaCodigo;
	}
	public String getEstadoAutorizacionPropietarioCodigo() {
		return estadoAutorizacionPropietarioCodigo;
	}
	public void setEstadoAutorizacionPropietarioCodigo(
			String estadoAutorizacionPropietarioCodigo) {
		this.estadoAutorizacionPropietarioCodigo = estadoAutorizacionPropietarioCodigo;
	}
	public String getOtrosEstados() {
		return otrosEstados;
	}
	public void setOtrosEstados(String otrosEstados) {
		this.otrosEstados = otrosEstados;
	}
	public String getTipoGastoCodigo() {
		return tipoGastoCodigo;
	}
	public void setTipoGastoCodigo(String tipoGastoCodigo) {
		this.tipoGastoCodigo = tipoGastoCodigo;
	}
	public String getImporteDesde() {
		return importeDesde;
	}
	public void setImporteDesde(String importeDesde) {
		this.importeDesde = importeDesde;
	}
	public String getNumGastoGestoria() {
		return numGastoGestoria;
	}
	public void setNumGastoGestoria(String numGastoGestoria) {
		this.numGastoGestoria = numGastoGestoria;
	}
	public String getSubtipoGastoCodigo() {
		return subtipoGastoCodigo;
	}
	public void setSubtipoGastoCodigo(String subtipoGastoCodigo) {
		this.subtipoGastoCodigo = subtipoGastoCodigo;
	}
	public String getImporteHasta() {
		return importeHasta;
	}
	public void setImporteHasta(String importeHasta) {
		this.importeHasta = importeHasta;
	}
	public String getReferenciaEmisor() {
		return referenciaEmisor;
	}
	public void setReferenciaEmisor(String referenciaEmisor) {
		this.referenciaEmisor = referenciaEmisor;
	}
	public String getNecesitaAutorizacionPropietario() {
		return necesitaAutorizacionPropietario;
	}
	public void setNecesitaAutorizacionPropietario(
			String necesitaAutorizacionPropietario) {
		this.necesitaAutorizacionPropietario = necesitaAutorizacionPropietario;
	}
	public String getFechaTopePagoDesde() {
		return fechaTopePagoDesde;
	}
	public void setFechaTopePagoDesde(String fechaTopePagoDesde) {
		this.fechaTopePagoDesde = fechaTopePagoDesde;
	}
	public String getCubreSeguro() {
		return cubreSeguro;
	}
	public void setCubreSeguro(String cubreSeguro) {
		this.cubreSeguro = cubreSeguro;
	}
	public String getFechaTopePagoHasta() {
		return fechaTopePagoHasta;
	}
	public void setFechaTopePagoHasta(String fechaTopePagoHasta) {
		this.fechaTopePagoHasta = fechaTopePagoHasta;
	}
	public String getNumProvision() {
		return numProvision;
	}
	public void setNumProvision(String numProvision) {
		this.numProvision = numProvision;
	}
	public String getNifProveedor() {
		return nifProveedor;
	}
	public void setNifProveedor(String nifProveedor) {
		this.nifProveedor = nifProveedor;
	}
	public String getCodigoTipoProveedor() {
		return codigoTipoProveedor;
	}
	public void setCodigoTipoProveedor(String codigoTipoProveedor) {
		this.codigoTipoProveedor = codigoTipoProveedor;
	}
	public String getCodigoSubtipoProveedor() {
		return codigoSubtipoProveedor;
	}
	public void setCodigoSubtipoProveedor(String codigoSubtipoProveedor) {
		this.codigoSubtipoProveedor = codigoSubtipoProveedor;
	}
	public String getNombreProveedor() {
		return nombreProveedor;
	}
	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}

	
}