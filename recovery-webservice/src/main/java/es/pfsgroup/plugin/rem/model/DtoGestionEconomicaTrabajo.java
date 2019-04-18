package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * DTO que gestiona la pestaña de gestión económica de un trabajo
 *  
 * @author Carlos Feliu
 *
 */
public class DtoGestionEconomicaTrabajo extends WebDto {
	

	private static final long serialVersionUID = 1L;

	private Long idTrabajo;
	
	private String numTrabajo;
	
	private String tipoTrabajoCodigo;
	
	private String subtipoTrabajoCodigo;
	
	private String tipoTrabajoDescripcion;
	
	private String subtipoTrabajoDescripcion;
	
	private String carteraCodigo;
	
	private Boolean esTarificado;
	
	private Date fechaCompromisoEjecucion;
	
	private Date fechaEjecucionReal;
	
	private Date fechaFin;
	
	private Integer diasRetrasoOrigen;
	
	private Integer diasRetrasoMesCurso;
	
	private Double importePenalizacionDiario;
	
	private String nombreProveedor;
	
	private Long idProveedor;
	
	private String usuarioProveedorContacto;
	
	private String emailProveedorContacto;
	
	private String telefonoProveedorContacto;
	
	private Double importeTotal;
	
	private Long idProveedorContacto;
	
	private String codigoTipoProveedor;
	
	private String codigoTarifaTrabajo;
	
	private String descripcionTarifaTrabajo;
	
	private String subcarteraCodigo;

	public Long getIdTrabajo() {
		return idTrabajo;
	}

	public void setIdTrabajo(Long idTrabajo) {
		this.idTrabajo = idTrabajo;
	}

	public String getNumTrabajo() {
		return numTrabajo;
	}

	public void setNumTrabajo(String numTrabajo) {
		this.numTrabajo = numTrabajo;
	}

	public String getTipoTrabajoCodigo() {
		return tipoTrabajoCodigo;
	}

	public void setTipoTrabajoCodigo(String tipoTrabajoCodigo) {
		this.tipoTrabajoCodigo = tipoTrabajoCodigo;
	}

	public String getSubtipoTrabajoCodigo() {
		return subtipoTrabajoCodigo;
	}

	public void setSubtipoTrabajoCodigo(String subtipoTrabajoCodigo) {
		this.subtipoTrabajoCodigo = subtipoTrabajoCodigo;
	}

	public String getTipoTrabajoDescripcion() {
		return tipoTrabajoDescripcion;
	}

	public void setTipoTrabajoDescripcion(String tipoTrabajoDescripcion) {
		this.tipoTrabajoDescripcion = tipoTrabajoDescripcion;
	}

	public String getSubtipoTrabajoDescripcion() {
		return subtipoTrabajoDescripcion;
	}

	public void setSubtipoTrabajoDescripcion(String subtipoTrabajoDescripcion) {
		this.subtipoTrabajoDescripcion = subtipoTrabajoDescripcion;
	}

	public String getCarteraCodigo() {
		return carteraCodigo;
	}

	public void setCarteraCodigo(String carteraCodigo) {
		this.carteraCodigo = carteraCodigo;
	}

	public Boolean getEsTarificado() {
		return esTarificado;
	}

	public void setEsTarificado(Boolean esTarificado) {
		this.esTarificado = esTarificado;
	}

	public Date getFechaCompromisoEjecucion() {
		return fechaCompromisoEjecucion;
	}

	public void setFechaCompromisoEjecucion(Date fechaCompromisoEjecucion) {
		this.fechaCompromisoEjecucion = fechaCompromisoEjecucion;
	}

	public Date getFechaEjecucionReal() {
		return fechaEjecucionReal;
	}

	public void setFechaEjecucionReal(Date fechaEjecucionReal) {
		this.fechaEjecucionReal = fechaEjecucionReal;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public Integer getDiasRetrasoOrigen() {
		return diasRetrasoOrigen;
	}

	public void setDiasRetrasoOrigen(Integer diasRetrasoOrigen) {
		this.diasRetrasoOrigen = diasRetrasoOrigen;
	}

	public Integer getDiasRetrasoMesCurso() {
		return diasRetrasoMesCurso;
	}

	public void setDiasRetrasoMesCurso(Integer diasRetrasoMesCurso) {
		this.diasRetrasoMesCurso = diasRetrasoMesCurso;
	}

	public Double getImportePenalizacionDiario() {
		return importePenalizacionDiario;
	}

	public void setImportePenalizacionDiario(Double importePenalizacionDiario) {
		this.importePenalizacionDiario = importePenalizacionDiario;
	}

	public String getNombreProveedor() {
		return nombreProveedor;
	}

	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}

	public Long getIdProveedor() {
		return idProveedor;
	}

	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
	}

	public String getUsuarioProveedorContacto() {
		return usuarioProveedorContacto;
	}

	public void setUsuarioProveedorContacto(String usuarioProveedorContacto) {
		this.usuarioProveedorContacto = usuarioProveedorContacto;
	}

	public String getEmailProveedorContacto() {
		return emailProveedorContacto;
	}

	public void setEmailProveedorContacto(String emailProveedorContacto) {
		this.emailProveedorContacto = emailProveedorContacto;
	}

	public String getTelefonoProveedorContacto() {
		return telefonoProveedorContacto;
	}

	public void setTelefonoProveedorContacto(String telefonoProveedorContacto) {
		this.telefonoProveedorContacto = telefonoProveedorContacto;
	}

	public Double getImporteTotal() {
		return importeTotal;
	}

	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}

	public Long getIdProveedorContacto() {
		return idProveedorContacto;
	}

	public void setIdProveedorContacto(Long idProveedorContacto) {
		this.idProveedorContacto = idProveedorContacto;
	}

	public String getCodigoTipoProveedor() {
		return codigoTipoProveedor;
	}

	public void setCodigoTipoProveedor(String codigoTipoProveedor) {
		this.codigoTipoProveedor = codigoTipoProveedor;
	}

	public String getCodigoTarifaTrabajo() {
		return codigoTarifaTrabajo;
	}

	public void setCodigoTarifaTrabajo(String codigoTarifaTrabajo) {
		this.codigoTarifaTrabajo = codigoTarifaTrabajo;
	}

	public String getDescripcionTarifaTrabajo() {
		return descripcionTarifaTrabajo;
	}

	public void setDescripcionTarifaTrabajo(String descripcionTarifaTrabajo) {
		this.descripcionTarifaTrabajo = descripcionTarifaTrabajo;
	}
	

	public String getSubcarteraCodigo() {
		return subcarteraCodigo;
	}

	public void setSubcarteraCodigo(String subcarteraCodigo) {
		this.subcarteraCodigo = subcarteraCodigo;
	}
}
