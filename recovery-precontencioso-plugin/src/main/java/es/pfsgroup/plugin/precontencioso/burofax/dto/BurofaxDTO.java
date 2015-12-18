package es.pfsgroup.plugin.precontencioso.burofax.dto;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class BurofaxDTO extends WebDto{

	
	private static final long serialVersionUID = 4065164471137337436L;
	
	private Long id;
	private Long idBurofax;
	private Long idEnvio;
	private Long idCliente;
	private Long idDireccion;
	private Long idTipoBurofax;
	private String cliente;
	private String tipoIntervencion;
	private String contrato;
	private String estado;
	private String direccion;
	private String tipo;
	private String tipoDescripcion;
	private Date fechaSolicitud;
	private Date fechaEnvio;
	private Date fechaAcuse;
	private String resultado;

	// id ADJ_ADJUNTOS
	private Long acuseRecibo;
	
	
	public String getCliente() {
		return cliente;
	}
	public void setCliente(String cliente) {
		this.cliente = cliente;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	
	public String getResultado() {
		return resultado;
	}
	public void setResultado(String resultado) {
		this.resultado = resultado;
	}
	public Long getIdCliente() {
		return idCliente;
	}
	public void setIdCliente(Long idCliente) {
		this.idCliente = idCliente;
	}
	public Long getIdDireccion() {
		return idDireccion;
	}
	public void setIdDireccion(Long idDireccion) {
		this.idDireccion = idDireccion;
	}
	public Long getIdTipoBurofax() {
		return idTipoBurofax;
	}
	public void setIdTipoBurofax(Long idTipoBurofax) {
		this.idTipoBurofax = idTipoBurofax;
	}
	
	public String getContrato() {
		return contrato;
	}
	public void setContrato(String contrato) {
		this.contrato = contrato;
	}
	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}
	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}
	public Date getFechaEnvio() {
		return fechaEnvio;
	}
	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}
	public Date getFechaAcuse() {
		return fechaAcuse;
	}
	public void setFechaAcuse(Date fechaAcuse) {
		this.fechaAcuse = fechaAcuse;
	}
	
	public Long getIdBurofax() {
		return idBurofax;
	}
	public void setIdBurofax(Long idBurofax) {
		this.idBurofax = idBurofax;
	}
	public Long getIdEnvio() {
		return idEnvio;
	}
	public void setIdEnvio(Long idEnvio) {
		this.idEnvio = idEnvio;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
	public String getTipoIntervencion() {
		return tipoIntervencion;
	}
	public void setTipoIntervencion(String tipoIntervencion) {
		this.tipoIntervencion = tipoIntervencion;
	}
	public String getTipoDescripcion() {
		return tipoDescripcion;
	}
	public void setTipoDescripcion(String tipoDescripcion) {
		this.tipoDescripcion = tipoDescripcion;
	}
	public Long getAcuseRecibo() {
		return acuseRecibo;
	}
	public void setAcuseRecibo(Long acuseRecibo) {
		this.acuseRecibo = acuseRecibo;
	}

	

}
