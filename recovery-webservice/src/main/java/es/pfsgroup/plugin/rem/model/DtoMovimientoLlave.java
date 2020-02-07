package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoMovimientoLlave extends WebDto {
	
	private static final long serialVersionUID = 1L;
	
	private String id; //id Movimiento
	private String idLlave;
	private String numLlave;
	private String codigoTipoTenedor;
	private String descripcionTipoTenedor;
	private String codTenedor;	
	private String nomTenedor;
	private Date fechaEntrega;
	private Date fechaDevolucion;
	private String codigoTipoTenedorPoseedor;
	private String descripcionTipoTenedorPoseedor;
	private String codigoTipoTenedorPedidor;
	private String descripcionTipoTenedorPedidor;
	private String nombrePoseedor;
	private String nombrePedidor;
	private String envio;
	private Date fechaEnvio;
	private Date fechaRecepcion;
	private String observaciones;
	private String estadoCodigo;
	private String estadoDescripcion;
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getIdLlave() {
		return idLlave;
	}
	public void setIdLlave(String idLlave) {
		this.idLlave = idLlave;
	}
	public String getNumLlave() {
		return numLlave;
	}
	public void setNumLlave(String numLlave) {
		this.numLlave = numLlave;
	}
	public String getCodigoTipoTenedor() {
		return codigoTipoTenedor;
	}
	public void setCodigoTipoTenedor(String codigoTipoTenedor) {
		this.codigoTipoTenedor = codigoTipoTenedor;
	}
	public String getDescripcionTipoTenedor() {
		return descripcionTipoTenedor;
	}
	public void setDescripcionTipoTenedor(String descripcionTipoTenedor) {
		this.descripcionTipoTenedor = descripcionTipoTenedor;
	}
	public String getCodTenedor() {
		return codTenedor;
	}
	public void setCodTenedor(String codTenedor) {
		this.codTenedor = codTenedor;
	}
	public String getNomTenedor() {
		return nomTenedor;
	}
	public void setNomTenedor(String nomTenedor) {
		this.nomTenedor = nomTenedor;
	}
	public Date getFechaEntrega() {
		return fechaEntrega;
	}
	public void setFechaEntrega(Date fechaEntrega) {
		this.fechaEntrega = fechaEntrega;
	}
	public Date getFechaDevolucion() {
		return fechaDevolucion;
	}
	public void setFechaDevolucion(Date fechaDevolucion) {
		this.fechaDevolucion = fechaDevolucion;
	}
	public String getCodigoTipoTenedorPoseedor() {
		return codigoTipoTenedorPoseedor;
	}
	public void setCodigoTipoTenedorPoseedor(String codigoTipoTenedorPoseedor) {
		this.codigoTipoTenedorPoseedor = codigoTipoTenedorPoseedor;
	}
	public String getDescripcionTipoTenedorPoseedor() {
		return descripcionTipoTenedorPoseedor;
	}
	public void setDescripcionTipoTenedorPoseedor(String descripcionTipoTenedorPoseedor) {
		this.descripcionTipoTenedorPoseedor = descripcionTipoTenedorPoseedor;
	}
	public String getCodigoTipoTenedorPedidor() {
		return codigoTipoTenedorPedidor;
	}
	public void setCodigoTipoTenedorPedidor(String codigoTipoTenedorPedidor) {
		this.codigoTipoTenedorPedidor = codigoTipoTenedorPedidor;
	}
	public String getDescripcionTipoTenedorPedidor() {
		return descripcionTipoTenedorPedidor;
	}
	public void setDescripcionTipoTenedorPedidor(String descripcionTipoTenedorPedidor) {
		this.descripcionTipoTenedorPedidor = descripcionTipoTenedorPedidor;
	}
	public String getNombrePoseedor() {
		return nombrePoseedor;
	}
	public void setNombrePoseedor(String nombrePoseedor) {
		this.nombrePoseedor = nombrePoseedor;
	}
	public String getNombrePedidor() {
		return nombrePedidor;
	}
	public void setNombrePedidor(String nombrePedidor) {
		this.nombrePedidor = nombrePedidor;
	}
	public String getEnvio() {
		return envio;
	}
	public void setEnvio(String envio) {
		this.envio = envio;
	}
	public Date getFechaEnvio() { 
		return fechaEnvio;
	}
	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}
	public Date getFechaRecepcion() {
		return fechaRecepcion;
	}
	public void setFechaRecepcion(Date fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getEstadoCodigo() {
		return estadoCodigo;
	}
	public void setEstadoCodigo(String estadoCodigo) {
		this.estadoCodigo = estadoCodigo;
	}
	public String getEstadoDescripcion() {
		return estadoDescripcion;
	}
	public void setEstadoDescripcion(String estadoDescripcion) {
		this.estadoDescripcion = estadoDescripcion;
	}

}
