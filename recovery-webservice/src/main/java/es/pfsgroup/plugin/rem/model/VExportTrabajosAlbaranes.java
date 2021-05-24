package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_EXPORTAR_TRABAJOS_ALBARANES", schema = "${entity.schema}")
public class VExportTrabajosAlbaranes implements Serializable{

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ID")
	private Long id;
	
	@Column(name = "ALB_NUM_ALBARAN")
	private Long numAlbaran;
	
	@Column(name = "ALB_FECHA_ALBARAN")
	private Date fechaAlbaran;
	
	@Column(name = "DD_ESA_CODIGO")
	private String estadoAlbaranCodigo;
	
	@Column(name = "DD_ESA_DESCRIPCION")
	private String estadoAlbaranDescripcion;
	
	@Column(name = "NUMPREFACTURA_ALB")
	private Long numPrefacturasAlbaran;
	
	@Column(name = "NUMTRABAJO_ALB")
	private Long numTrabajosAlbaran;
	
	@Column(name = "SUM_PRESUPUESTO_ALB")
	private Double importeTotalAlbaran;
	
	@Column(name = "SUM_TOTAL_ALB")
	private Double importeTotalClienteAlbaran;
	
	@Column(name = "PFA_NUM_PREFACTURA")
	private Long numPrefactura;
	
	@Column(name = "PFA_FECHA_PREFACTURA")
	private Date fechaPrefactura;
	
	@Column(name = "PVE_ID")
	private Long IdProveedor;
	
	@Column(name = "PVE_NOMBRE")
	private String proveedor;
	
	@Column(name = "PRO_NOMBRE")
	private String propietario;
	
	@Column(name = "PRO_DOCIDENTIF")
	private String docPropietario;
	
	@Column(name = "DD_EPF_CODIGO")
	private String estadoPrefacturaCodigo;
	
	@Column(name = "DD_EPF_DESCRIPCION")
	private String estadoPrefacturaDescripcion;
	
	@Column(name = "GPV_NUM_GASTO_HAYA")
	private String numGastoHaya;
	
	@Column(name = "DD_EGA_CODIGO")
	private String estadoGastoCodigo;
	
	@Column(name = "DD_EGA_DESCRIPCION")
	private String estadoGastoDescripcion;
	
	@Column(name = "NUMTRABAJO_PFA")
	private Long numTrabajosPrefactura;
	
	@Column(name = "SUM_PRESUPUESTO_PFA")
	private Double importeTotalPrefactura;
	
	@Column(name = "SUM_TOTAL_PFA")
	private Double importeTotalClientePrefactura;
	
	@Column(name = "TBJ_NUM_TRABAJO")
	private Long numTrabajo;
	
	@Column(name = "DD_TTR_CODIGO")
	private String tipoTrabajoCodigo;
	
	@Column(name = "DD_TTR_DESCRIPCION")
	private String tipoTrabajoDescripcion;
	
	@Column(name = "DD_STR_CODIGO")
	private String subtipoTrabajoCodigo;
	
	@Column(name = "DD_STR_DESCRIPCION")
	private String subtipoTrabajoDescripcion;
	
	@Column(name = "TBJ_DESCRIPCION")
	private String descripcionTrabajo;
	
	@Column(name = "ANYO_TRABAJO")
	private String anyoTrabajo;
	
	@Column(name = "DD_EST_CODIGO")
	private String estadoTrabajoCodigo;
	
	@Column(name = "DD_EST_DESCRIPCION")
	private String estadoTrabajoDescripcion;
	
	@Column(name = "TBJ_IMPORTE_PRESUPUESTO")
	private Double importeTotalTrabajo;
	
	@Column(name = "TBJ_IMPORTE_TOTAL")
	private Double importeTotalClienteTrabajo;
	
	@Column(name = "DD_IRE_CODIGO")
	private String areaPeticionariaCodigo;
	
	@Column(name = "DD_IRE_DESCRIPCION")
	private String areaPeticionariaDescripcion;
	
	@Column(name = "DD_CRA_CODIGO")
	private String carteraPropietarioCodigo;
	
	@Column(name = "DD_CRA_DESCRIPCION")
	private String carteraPropietarioDescripcion;

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

	public String getEstadoAlbaranCodigo() {
		return estadoAlbaranCodigo;
	}

	public void setEstadoAlbaranCodigo(String estadoAlbaranCodigo) {
		this.estadoAlbaranCodigo = estadoAlbaranCodigo;
	}

	public String getEstadoAlbaranDescripcion() {
		return estadoAlbaranDescripcion;
	}

	public void setEstadoAlbaranDescripcion(String estadoAlbaranDescripcion) {
		this.estadoAlbaranDescripcion = estadoAlbaranDescripcion;
	}

	public Long getNumPrefacturasAlbaran() {
		return numPrefacturasAlbaran;
	}

	public void setNumPrefacturasAlbaran(Long numPrefacturasAlbaran) {
		this.numPrefacturasAlbaran = numPrefacturasAlbaran;
	}

	public Long getNumTrabajosAlbaran() {
		return numTrabajosAlbaran;
	}

	public void setNumTrabajosAlbaran(Long numTrabajosAlbaran) {
		this.numTrabajosAlbaran = numTrabajosAlbaran;
	}

	public Double getImporteTotalAlbaran() {
		return importeTotalAlbaran;
	}

	public void setImporteTotalAlbaran(Double importeTotalAlbaran) {
		this.importeTotalAlbaran = importeTotalAlbaran;
	}

	public Double getImporteTotalClienteAlbaran() {
		return importeTotalClienteAlbaran;
	}

	public void setImporteTotalClienteAlbaran(Double importeTotalClienteAlbaran) {
		this.importeTotalClienteAlbaran = importeTotalClienteAlbaran;
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

	public Long getIdProveedor() {
		return IdProveedor;
	}

	public void setIdProveedor(Long idProveedor) {
		IdProveedor = idProveedor;
	}

	public String getProveedor() {
		return proveedor;
	}

	public void setProveedor(String proveedor) {
		this.proveedor = proveedor;
	}

	public String getPropietario() {
		return propietario;
	}

	public void setPropietario(String propietario) {
		this.propietario = propietario;
	}

	public String getDocPropietario() {
		return docPropietario;
	}

	public void setDocPropietario(String docPropietario) {
		this.docPropietario = docPropietario;
	}

	public String getEstadoPrefacturaCodigo() {
		return estadoPrefacturaCodigo;
	}

	public void setEstadoPrefacturaCodigo(String estadoPrefacturaCodigo) {
		this.estadoPrefacturaCodigo = estadoPrefacturaCodigo;
	}

	public String getEstadoPrefacturaDescripcion() {
		return estadoPrefacturaDescripcion;
	}

	public void setEstadoPrefacturaDescripcion(String estadoPrefacturaDescripcion) {
		this.estadoPrefacturaDescripcion = estadoPrefacturaDescripcion;
	}

	public String getNumGastoHaya() {
		return numGastoHaya;
	}

	public void setNumGastoHaya(String numGastoHaya) {
		this.numGastoHaya = numGastoHaya;
	}

	public String getEstadoGastoCodigo() {
		return estadoGastoCodigo;
	}

	public void setEstadoGastoCodigo(String estadoGastoCodigo) {
		this.estadoGastoCodigo = estadoGastoCodigo;
	}

	public String getEstadoGastoDescripcion() {
		return estadoGastoDescripcion;
	}

	public void setEstadoGastoDescripcion(String estadoGastoDescripcion) {
		this.estadoGastoDescripcion = estadoGastoDescripcion;
	}

	public Long getNumTrabajosPrefactura() {
		return numTrabajosPrefactura;
	}

	public void setNumTrabajosPrefactura(Long numTrabajosPrefactura) {
		this.numTrabajosPrefactura = numTrabajosPrefactura;
	}

	public Double getImporteTotalPrefactura() {
		return importeTotalPrefactura;
	}

	public void setImporteTotalPrefactura(Double importeTotalPrefactura) {
		this.importeTotalPrefactura = importeTotalPrefactura;
	}

	public Double getImporteTotalClientePrefactura() {
		return importeTotalClientePrefactura;
	}

	public void setImporteTotalClientePrefactura(Double importeTotalClientePrefactura) {
		this.importeTotalClientePrefactura = importeTotalClientePrefactura;
	}

	public Long getNumTrabajo() {
		return numTrabajo;
	}

	public void setNumTrabajo(Long numTrabajo) {
		this.numTrabajo = numTrabajo;
	}

	public String getTipoTrabajoCodigo() {
		return tipoTrabajoCodigo;
	}

	public void setTipoTrabajoCodigo(String tipoTrabajoCodigo) {
		this.tipoTrabajoCodigo = tipoTrabajoCodigo;
	}

	public String getTipoTrabajoDescripcion() {
		return tipoTrabajoDescripcion;
	}

	public void setTipoTrabajoDescripcion(String tipoTrabajoDescripcion) {
		this.tipoTrabajoDescripcion = tipoTrabajoDescripcion;
	}

	public String getSubtipoTrabajoCodigo() {
		return subtipoTrabajoCodigo;
	}

	public void setSubtipoTrabajoCodigo(String subtipoTrabajoCodigo) {
		this.subtipoTrabajoCodigo = subtipoTrabajoCodigo;
	}

	public String getSubtipoTrabajoDescripcion() {
		return subtipoTrabajoDescripcion;
	}

	public void setSubtipoTrabajoDescripcion(String subtipoTrabajoDescripcion) {
		this.subtipoTrabajoDescripcion = subtipoTrabajoDescripcion;
	}

	public String getDescripcionTrabajo() {
		return descripcionTrabajo;
	}

	public void setDescripcionTrabajo(String descripcionTrabajo) {
		this.descripcionTrabajo = descripcionTrabajo;
	}

	public String getAnyoTrabajo() {
		return anyoTrabajo;
	}

	public void setAnyoTrabajo(String anyoTrabajo) {
		this.anyoTrabajo = anyoTrabajo;
	}

	public String getEstadoTrabajoCodigo() {
		return estadoTrabajoCodigo;
	}

	public void setEstadoTrabajoCodigo(String estadoTrabajoCodigo) {
		this.estadoTrabajoCodigo = estadoTrabajoCodigo;
	}

	public String getEstadoTrabajoDescripcion() {
		return estadoTrabajoDescripcion;
	}

	public void setEstadoTrabajoDescripcion(String estadoTrabajoDescripcion) {
		this.estadoTrabajoDescripcion = estadoTrabajoDescripcion;
	}

	public Double getImporteTotalTrabajo() {
		return importeTotalTrabajo;
	}

	public void setImporteTotalTrabajo(Double importeTotalTrabajo) {
		this.importeTotalTrabajo = importeTotalTrabajo;
	}

	public Double getImporteTotalClienteTrabajo() {
		return importeTotalClienteTrabajo;
	}

	public void setImporteTotalClienteTrabajo(Double importeTotalClienteTrabajo) {
		this.importeTotalClienteTrabajo = importeTotalClienteTrabajo;
	}

	public String getAreaPeticionariaCodigo() {
		return areaPeticionariaCodigo;
	}

	public void setAreaPeticionariaCodigo(String areaPeticionariaCodigo) {
		this.areaPeticionariaCodigo = areaPeticionariaCodigo;
	}

	public String getAreaPeticionariaDescripcion() {
		return areaPeticionariaDescripcion;
	}

	public void setAreaPeticionariaDescripcion(String areaPeticionariaDescripcion) {
		this.areaPeticionariaDescripcion = areaPeticionariaDescripcion;
	}

	public String getCarteraPropietarioCodigo() {
		return carteraPropietarioCodigo;
	}

	public void setCarteraPropietarioCodigo(String subcarteraActivoCodigo) {
		this.carteraPropietarioCodigo = subcarteraActivoCodigo;
	}

	public String getCarteraPropietarioDescripcion() {
		return carteraPropietarioDescripcion;
	}

	public void setCarteraPropietarioDescripcion(String carteraActivoDescripcion) {
		this.carteraPropietarioDescripcion = carteraActivoDescripcion;
	}

}
