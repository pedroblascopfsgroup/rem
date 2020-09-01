package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_BUSQUEDA_ALBARANES", schema = "${entity.schema}")
public class VbusquedaAlbaranes implements Serializable{

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ALB_ID")
	private Long id;
	
	@Column(name = "ALB_NUM_ALBARAN")
	private Long numAlbaran;
	
	@Column(name = "ALB_FECHA_ALBARAN")
	private Date fechaAlbaran;
	
	@Column(name = "DD_ESA_CODIGO")
	private String codigoEstadoAlbaran;
	
	@Column(name = "DD_ESA_DESCRIPCION")
	private String estadoAlbaran;
	
	@Column(name = "PFA_NUM_PREFACTURA")
	private Long numPrefactura;
	
	@Column(name = "PFA_FECHA_PREFACTURA")
	private Date fechaPrefactura;
	
	@Column(name = "DD_EPF_CODIGO")
	private String codigoEstadoPrefactura;
	
	@Column(name = "DD_EPF_DESCRIPCION")
	private String estadoPrefactura;
	
	@Column(name = "PVE_NOMBRE")
	private String proveedorNombre;
	
	@Column(name = "PVE_ID")
	private String proveedor;
	
	@Column(name = "PRO_DOCIDENTIF")
	private String solicitante;
	
	@Column(name = "PRO_NOMBRE")
	private String nombreSolicitante;
	
	@Column(name = "TBJ_NUM_TRABAJO")
	private Long numTrabajo;
	
	@Column(name = "TBJ_FECHA_SOLICITUD")
	private String anyoTrabajo;
	
	@Column(name = "DD_TTR_CODIGO")
	private String codigoTipologiaTrabajo;
	
	@Column(name = "DD_TTR_DESCRIPCION")
	private String tipologiaTrabajo;
	
	@Column(name = "DD_EST_CODIGO")
	private String codigoEstadoTrabajo;
	
	@Column(name = "DD_EST_DESCRIPCION")
	private String estadoTrabajo;
	
	@Column(name = "NUMPREFACTURA")
	private Long numPrefacturas;
	
	@Column(name = "NUMTRABAJO")
	private Long numTrabajos;
	
	@Column(name = "SUM_PRESUPUESTO")
	private Double importeTotal;
	
	@Column(name = "SUM_TOTAL")
	private Double importeTotalCliente;
	
	@Column(name = "VALIDARALBARAN")
	private Boolean validarAlbaran;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getNumAlbaran() {
		return numAlbaran;
	}

	public void setNumAlbaran(Long numAlbaran) {
		this.numAlbaran = numAlbaran;
	}

	public Date getFechaAlbaran() {
		return fechaAlbaran;
	}

	public void setFechaAlbaran(Date fechaAlbaran) {
		this.fechaAlbaran = fechaAlbaran;
	}

	public String getCodigoEstadoAlbaran() {
		return codigoEstadoAlbaran;
	}

	public void setCodigoEstadoAlbaran(String codigoEstadoAlbaran) {
		this.codigoEstadoAlbaran = codigoEstadoAlbaran;
	}

	public String getEstadoAlbaran() {
		return estadoAlbaran;
	}

	public void setEstadoAlbaran(String estadoAlbaran) {
		this.estadoAlbaran = estadoAlbaran;
	}

	public Long getNumPrefactura() {
		return numPrefactura;
	}

	public void setNumPrefactura(Long numPrefactura) {
		this.numPrefactura = numPrefactura;
	}

	public Date getFechaPrefactura() {
		return fechaPrefactura;
	}

	public void setFechaPrefactura(Date fechaPrefactura) {
		this.fechaPrefactura = fechaPrefactura;
	}

	public String getCodigoEstadoPrefactura() {
		return codigoEstadoPrefactura;
	}

	public void setCodigoEstadoPrefactura(String codigoEstadoPrefactura) {
		this.codigoEstadoPrefactura = codigoEstadoPrefactura;
	}

	public String getEstadoPrefactura() {
		return estadoPrefactura;
	}

	public void setEstadoPrefactura(String estadoPrefactura) {
		this.estadoPrefactura = estadoPrefactura;
	}

	public String getProveedor() {
		return proveedor;
	}

	public void setProveedor(String proveedor) {
		this.proveedor = proveedor;
	}

	public String getSolicitante() {
		return solicitante;
	}

	public void setSolicitante(String solicitante) {
		this.solicitante = solicitante;
	}

	public Long getNumTrabajo() {
		return numTrabajo;
	}

	public void setNumTrabajo(Long numTrabajo) {
		this.numTrabajo = numTrabajo;
	}

	public String getAnyoTrabajo() {
		return anyoTrabajo;
	}

	public void setAnyoTrabajo(String anyoTrabajo) {
		this.anyoTrabajo = anyoTrabajo;
	}

	public String getCodigoTipologiaTrabajo() {
		return codigoTipologiaTrabajo;
	}

	public void setCodigoTipologiaTrabajo(String codigoTipologiaTrabajo) {
		this.codigoTipologiaTrabajo = codigoTipologiaTrabajo;
	}

	public String getTipologiaTrabajo() {
		return tipologiaTrabajo;
	}

	public void setTipologiaTrabajo(String tipologiaTrabajo) {
		this.tipologiaTrabajo = tipologiaTrabajo;
	}

	public String getCodigoEstadoTrabajo() {
		return codigoEstadoTrabajo;
	}

	public void setCodigoEstadoTrabajo(String codigoEstadoTrabajo) {
		this.codigoEstadoTrabajo = codigoEstadoTrabajo;
	}

	public String getEstadoTrabajo() {
		return estadoTrabajo;
	}

	public void setEstadoTrabajo(String estadoTrabajo) {
		this.estadoTrabajo = estadoTrabajo;
	}

	public Long getNumPrefacturas() {
		return numPrefacturas;
	}

	public void setNumPrefacturas(Long numPrefacturas) {
		this.numPrefacturas = numPrefacturas;
	}

	public Long getNumTrabajos() {
		return numTrabajos;
	}

	public void setNumTrabajos(Long numTrabajos) {
		this.numTrabajos = numTrabajos;
	}

	public Double getImporteTotal() {
		return importeTotal;
	}

	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}

	public Double getImporteTotalCliente() {
		return importeTotalCliente;
	}

	public void setImporteTotalCliente(Double importeTotalCliente) {
		this.importeTotalCliente = importeTotalCliente;
	}

	public String getNombreSolicitante() {
		return nombreSolicitante;
	}

	public void setNombreSolicitante(String nombreSolicitante) {
		this.nombreSolicitante = nombreSolicitante;
	}

	public Boolean getValidarAlbaran() {
		return validarAlbaran;
	}

	public void setValidarAlbaran(Boolean validarAlbaran) {
		this.validarAlbaran = validarAlbaran;
	}
	
	
	
}
