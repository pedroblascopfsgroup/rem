package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "VI_BUSQUEDA_GASTOS_ACTIVOS", schema = "${entity.schema}")
public class VBusquedaGastoActivo implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "GPV_ACT_ID")
	private Long id;
		
	@Column(name = "GPV_ID")
	private Long idGasto;

	@Column(name = "ACT_ID")
	private Long idActivo;

	@Column(name = "ACT_NUM_ACTIVO")
	private Long numActivo;

	@Column(name = "DIRECCION")
	private String direccion;

	@Column(name = "GPV_PARTICIPACION_GASTO")
	private Double participacion;

	@Column(name = "IMPORTE_PROPORCIONAL_TOTAL")
	private Double importeProporcinalTotal;

	@Column(name = "REFERENCIAS")
	private String referenciasCatastrales;
	
	@Column(name="DD_SAC_CODIGO")
	private String subtipoCodigo;
	
	@Column(name="DD_SAC_DESCRIPCION")
	private String subtipoDescripcion;
	
	@Column(name="GPV_REFERENCIA_CATASTRAL")
	private String referenciaCatastral;
	
	///////
	
	@Column(name="PVE_ID_EMISOR")
	private Long idProveedor;

	@Column(name="DD_TGA_CODIGO")
	private String tipoGastoCodigo;
	
	@Column(name="DD_TGA_DESCRIPCION")
	private String tipoGastoDescripcion;
	
	@Column(name="DD_STG_CODIGO")
	private String subtipoGastoCodigo;
	
	@Column(name="DD_STG_DESCRIPCION")
	private String subtipoGastoDescripcion;
	
	@Column(name="GPV_CONCEPTO")
	private String conceptoGasto;
	
	@Column(name="DD_TPE_CODIGO")
	private String periodicidadGastoCodigo;
	
	@Column(name="DD_TPE_DESCRIPCION")
	private String periodicidadGastoDescripcion;
	
	@Column(name="GPV_FECHA_EMISION")
	private String fechaEmisionGasto;
	
	@Column(name="GPV_OBSERVACIONES")
	private String observacionesGastos;
	
	@Column(name="GPV_NUM_GASTO_HAYA")
	private Long numGasto;
	
	@Column(name="GDE_FECHA_PAGO")
	private Date fechaPagoGasto;
	
	@Column(name="GDE_IMPORTE_TOTAL")
	private Double importeTotalGasto;
	
	@Column(name="DD_EGA_CODIGO")
	private String estadoGastoCodigo;
	
	@Column(name="DD_EGA_DESCRIPCION")
	private String estadoGastoDescripcion;
	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdGasto() {
		return idGasto;
	}

	public void setIdGasto(Long idGasto) {
		this.idGasto = idGasto;
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
	
	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public Double getParticipacion() {
		return participacion;
	}

	public void setParticipacion(Double participacion) {
		this.participacion = participacion;
	}

	public Double getImporteProporcinalTotal() {
		return importeProporcinalTotal;
	}

	public void setImporteProporcinalTotal(Double importeProporcinalTotal) {
		this.importeProporcinalTotal = importeProporcinalTotal;
	}

	public String getReferenciasCatastrales() {
		return referenciasCatastrales;
	}

	public void setReferenciasCatastrales(String referenciasCatastrales) {
		this.referenciasCatastrales = referenciasCatastrales;
	}

	public String getSubtipoCodigo() {
		return subtipoCodigo;
	}

	public void setSubtipoCodigo(String subtipoCodigo) {
		this.subtipoCodigo = subtipoCodigo;
	}

	public String getSubtipoDescripcion() {
		return subtipoDescripcion;
	}

	public void setSubtipoDescripcion(String subtipoDescripcion) {
		this.subtipoDescripcion = subtipoDescripcion;
	}

	public String getReferenciaCatastral() {
		return referenciaCatastral;
	}

	public void setReferenciaCatastral(String referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
	}

	public Long getIdProveedor() {
		return idProveedor;
	}

	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
	}

	public String getTipoGastoCodigo() {
		return tipoGastoCodigo;
	}

	public void setTipoGastoCodigo(String tipoGastoCodigo) {
		this.tipoGastoCodigo = tipoGastoCodigo;
	}

	public String getTipoGastoDescripcion() {
		return tipoGastoDescripcion;
	}

	public void setTipoGastoDescripcion(String tipoGastoDescripcion) {
		this.tipoGastoDescripcion = tipoGastoDescripcion;
	}

	public String getSubtipoGastoCodigo() {
		return subtipoGastoCodigo;
	}

	public void setSubtipoGastoCodigo(String subtipoGastoCodigo) {
		this.subtipoGastoCodigo = subtipoGastoCodigo;
	}

	public String getSubtipoGastoDescripcion() {
		return subtipoGastoDescripcion;
	}

	public void setSubtipoGastoDescripcion(String subtipoGastoDescripcion) {
		this.subtipoGastoDescripcion = subtipoGastoDescripcion;
	}

	public String getConceptoGasto() {
		return conceptoGasto;
	}

	public void setConceptoGasto(String conceptoGasto) {
		this.conceptoGasto = conceptoGasto;
	}

	public String getPeriodicidadGastoCodigo() {
		return periodicidadGastoCodigo;
	}

	public void setPeriodicidadGastoCodigo(String periodicidadGastoCodigo) {
		this.periodicidadGastoCodigo = periodicidadGastoCodigo;
	}

	public String getPeriodicidadGastoDescripcion() {
		return periodicidadGastoDescripcion;
	}

	public void setPeriodicidadGastoDescripcion(String periodicidadGastoDescripcion) {
		this.periodicidadGastoDescripcion = periodicidadGastoDescripcion;
	}

	public String getFechaEmisionGasto() {
		return fechaEmisionGasto;
	}

	public void setFechaEmisionGasto(String fechaEmisionGasto) {
		this.fechaEmisionGasto = fechaEmisionGasto;
	}

	public String getObservacionesGastos() {
		return observacionesGastos;
	}

	public void setObservacionesGastos(String observacionesGastos) {
		this.observacionesGastos = observacionesGastos;
	}

	public Long getNumGasto() {
		return numGasto;
	}

	public void setNumGasto(Long numGasto) {
		this.numGasto = numGasto;
	}

	public Date getFechaPagoGasto() {
		return fechaPagoGasto;
	}

	public void setFechaPagoGasto(Date fechaPagoGasto) {
		this.fechaPagoGasto = fechaPagoGasto;
	}

	public Double getImporteTotalGasto() {
		return importeTotalGasto;
	}

	public void setImporteTotalGasto(Double importeTotalGasto) {
		this.importeTotalGasto = importeTotalGasto;
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
	

}