package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_BUSQUEDA_TRABAJOS_PREFACTURAS", schema = "${entity.schema}")
public class VbusquedaTrabajosPrefactura implements Serializable{

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "tbj_id")
	private Long id;
	
	@Column(name = "pfa_id")
	private Long prefacturaID;
	
	@Column(name = "tbj_num_trabajo")
	private Long numTrabajo;
	
	@Column(name = "importe_cliente")
	private Double importeTotalClientePrefactura;
	
	@Column(name = "importe_total")
	private Double importeTotalPrefactura;
	
	@Column(name = "tbj_descripcion")
	private String descripcion;
	
	@Column(name = "tbj_fecha_solicitud")
	private Date fechaAlta; 
	
	@Column(name = "ANYO_TRABAJO")
	private String anyoTrabajo;
	
	@Column(name = "dd_ttr_descripcion")
	private String tipologiaTrabajo;
	
	@Column(name = "dd_ttr_codigo")
	private String tipologiaTrabajoCodigo;
	
	@Column(name = "dd_str_descripcion")
	private String subtipologiaTrabajo;
	
	@Column(name = "dd_str_codigo")
	private String subtipologiaTrabajoCodigo;
	
	@Column(name = "dd_est_descripcion")
	private String estadoTrabajo;
	
	@Column(name = "dd_est_codigo")
	private String estadoTrabajoCodigo;
	
	@Column(name = "CHECK_TBJ")
	private Boolean checkIncluirTrabajo;
	
	@Column(name = "PRO_NOMBRE")
	private String nombrePropietario;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getNumTrabajo() {
		return numTrabajo;
	}

	public void setNumTrabajo(Long numTrabajo) {
		this.numTrabajo = numTrabajo;
	}

	public Double getImporteTotalClientePrefactura() {
		return importeTotalClientePrefactura;
	}

	public void setImporteTotalClientePrefactura(Double importeTotalClientePrefactura) {
		this.importeTotalClientePrefactura = importeTotalClientePrefactura;
	}

	public Double getImporteTotalPrefactura() {
		return importeTotalPrefactura;
	}

	public void setImporteTotalPrefactura(Double importeTotalPrefactura) {
		this.importeTotalPrefactura = importeTotalPrefactura;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	
	public String getAnyoTrabajo() {
		return anyoTrabajo;
	}

	public void setAnyoTrabajo(String anyoTrabajo) {
		this.anyoTrabajo = anyoTrabajo;
	}

	public String getTipologiaTrabajo() {
		return tipologiaTrabajo;
	}

	public void setTipologiaTrabajo(String tipologiaTrabajo) {
		this.tipologiaTrabajo = tipologiaTrabajo;
	}

	public String getSubtipologiaTrabajo() {
		return subtipologiaTrabajo;
	}

	public void setSubtipologiaTrabajo(String subtipologiaTrabajo) {
		this.subtipologiaTrabajo = subtipologiaTrabajo;
	}

	public String getEstadoTrabajo() {
		return estadoTrabajo;
	}

	public void setEstadoTrabajo(String estadoTrabajo) {
		this.estadoTrabajo = estadoTrabajo;
	}

	public Long getPrefacturaID() {
		return prefacturaID;
	}

	public void setPrefacturaID(Long prefacturaID) {
		this.prefacturaID = prefacturaID;
	}

	public Boolean getCheckIncluirTrabajo() {
		return checkIncluirTrabajo;
	}

	public void setCheckIncluirTrabajo(Boolean checkIncluirTrabajo) {
		this.checkIncluirTrabajo = checkIncluirTrabajo;
	}

	public String getTipologiaTrabajoCodigo() {
		return tipologiaTrabajoCodigo;
	}

	public void setTipologiaTrabajoCodigo(String tipologiaTrabajoCodigo) {
		this.tipologiaTrabajoCodigo = tipologiaTrabajoCodigo;
	}

	public String getSubtipologiaTrabajoCodigo() {
		return subtipologiaTrabajoCodigo;
	}

	public void setSubtipologiaTrabajoCodigo(String subtipologiaTrabajoCodigo) {
		this.subtipologiaTrabajoCodigo = subtipologiaTrabajoCodigo;
	}

	public String getEstadoTrabajoCodigo() {
		return estadoTrabajoCodigo;
	}

	public void setEstadoTrabajoCodigo(String estadoTrabajoCodigo) {
		this.estadoTrabajoCodigo = estadoTrabajoCodigo;
	}

	public String getNombrePropietario() {
		return nombrePropietario;
	}

	public void setNombrePropietario(String nombrePropietario) {
		this.nombrePropietario = nombrePropietario;
	}	
	
}
