package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;


@Entity
@Table(name = "VI_BUSQUEDA_GASTOS_PROVISION", schema = "${entity.schema}")
public class VGastosProvision implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
	@Column(name= "GPV_ID")
	private String id;
	
	@Column(name = "GPV_REF_EMISOR")
	private String numFactura;
	
	@Column(name = "DD_TGA_DESCRIPCION")
	private String tipoDescripcion;
	
	
	@Column(name = "DD_STG_DESCRIPCION")
	private String subtipoDescripcion;
	
	
	@Column(name = "GPV_CONCEPTO")
	private String concepto;
	
	@Column(name = "GPV_FECHA_EMISION")
	private Date fechaEmision;
	
	@Column(name = "DD_TPE_DESCRIPCION")
	private String periodicidadDescripcion;
	
	
	@Column(name = "DD_DEG_DESCRIPCION")
	private String destinatarioDescripcion;

	
	@Column(name = "PVE_COD_REM")
	private String codigoProveedorRem;

	
	@Column(name = "GDE_IMPORTE_TOTAL")
	private Double importeTotal;
	
	@Column(name = "GDE_FECHA_PAGO")
	private Date fechaPago;
	
	@Column(name = "GDE_FECHA_TOPE_PAGO")
	private Date fechaTopePago;
	
	@Column(name = "GPV_NUM_GASTO_HAYA")
	private Long numGastoHaya;
	
	@Column(name="PRG_ID")
	private Long idProvision;

	
	@Column(name = "DD_EAP_DESCRIPCION")
	private String estadoAutorizacionPropietarioDescripcion;
	
	@Column(name = "DD_EGA_CODIGO")
	private String estadoGastoCodigo;
	
	@Column(name = "DD_EGA_DESCRIPCION")
	private String estadoGastoDescripcion;


	
	@Column(name = "PRG_NUM_PROVISION")
	private Long numProvision;


	
	@Column(name = "PVE_NOMBRE")
	private String nombreProveedor;
	
	@Column(name = "MOTIVO_RECHAZO")
	private String motivoRechazo;
	
	@Transient
	private boolean esGastoAgrupado; 
	
	@Transient
	private Double importeTotalAgrupacion;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getNumFactura() {
		return numFactura;
	}

	public void setNumFactura(String numFactura) {
		this.numFactura = numFactura;
	}

	public String getTipoDescripcion() {
		return tipoDescripcion;
	}

	public void setTipoDescripcion(String tipoDescripcion) {
		this.tipoDescripcion = tipoDescripcion;
	}

	public String getSubtipoDescripcion() {
		return subtipoDescripcion;
	}

	public void setSubtipoDescripcion(String subtipoDescripcion) {
		this.subtipoDescripcion = subtipoDescripcion;
	}

	public String getConcepto() {
		return concepto;
	}

	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}

	public Date getFechaEmision() {
		return fechaEmision;
	}

	public void setFechaEmision(Date fechaEmision) {
		this.fechaEmision = fechaEmision;
	}

	public String getPeriodicidadDescripcion() {
		return periodicidadDescripcion;
	}

	public void setPeriodicidadDescripcion(String periodicidadDescripcion) {
		this.periodicidadDescripcion = periodicidadDescripcion;
	}

	public String getDestinatarioDescripcion() {
		return destinatarioDescripcion;
	}

	public void setDestinatarioDescripcion(String destinatarioDescripcion) {
		this.destinatarioDescripcion = destinatarioDescripcion;
	}

	public String getCodigoProveedorRem() {
		return codigoProveedorRem;
	}

	public void setCodigoProveedorRem(String codigoProveedorRem) {
		this.codigoProveedorRem = codigoProveedorRem;
	}

	public Double getImporteTotal() {
		return importeTotal;
	}

	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}

	public Date getFechaPago() {
		return fechaPago;
	}

	public void setFechaPago(Date fechaPago) {
		this.fechaPago = fechaPago;
	}

	public Date getFechaTopePago() {
		return fechaTopePago;
	}

	public void setFechaTopePago(Date fechaTopePago) {
		this.fechaTopePago = fechaTopePago;
	}

	public Long getNumGastoHaya() {
		return numGastoHaya;
	}

	public void setNumGastoHaya(Long numGastoHaya) {
		this.numGastoHaya = numGastoHaya;
	}

	public Long getIdProvision() {
		return idProvision;
	}

	public void setIdProvision(Long idProvision) {
		this.idProvision = idProvision;
	}

	public String getEstadoAutorizacionPropietarioDescripcion() {
		return estadoAutorizacionPropietarioDescripcion;
	}

	public void setEstadoAutorizacionPropietarioDescripcion(String estadoAutorizacionPropietarioDescripcion) {
		this.estadoAutorizacionPropietarioDescripcion = estadoAutorizacionPropietarioDescripcion;
	}

	public String getEstadoGastoDescripcion() {
		return estadoGastoDescripcion;
	}

	public void setEstadoGastoDescripcion(String estadoGastoDescripcion) {
		this.estadoGastoDescripcion = estadoGastoDescripcion;
	}

	public Long getNumProvision() {
		return numProvision;
	}

	public void setNumProvision(Long numProvision) {
		this.numProvision = numProvision;
	}

	public String getNombreProveedor() {
		return nombreProveedor;
	}

	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}

	public boolean isEsGastoAgrupado() {
		return esGastoAgrupado;
	}

	public void setEsGastoAgrupado(boolean esGastoAgrupado) {
		this.esGastoAgrupado = esGastoAgrupado;
	}

	public Double getImporteTotalAgrupacion() {
		return importeTotalAgrupacion;
	}

	public void setImporteTotalAgrupacion(Double importeTotalAgrupacion) {
		this.importeTotalAgrupacion = importeTotalAgrupacion;
	}

	public String getMotivoRechazo() {
		return motivoRechazo;
	}

	public void setMotivoRechazo(String motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}

	public String getEstadoGastoCodigo() {
		return estadoGastoCodigo;
	}

	public void setEstadoGastoCodigo(String estadoGastoCodigo) {
		this.estadoGastoCodigo = estadoGastoCodigo;
	}
	
	
	 
}