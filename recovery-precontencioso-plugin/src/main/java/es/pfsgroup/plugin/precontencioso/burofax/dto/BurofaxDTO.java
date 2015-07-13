package es.pfsgroup.plugin.precontencioso.burofax.dto;

import java.io.Serializable;

public class BurofaxDTO implements Serializable{

	
	private static final long serialVersionUID = 4065164471137337436L;
	
	private Long id;
	private Long idCliente;
	private Long idDireccion;
	private Long idTipoBurofax;
	private String cliente;
	private String estado;
	private String direccion;
	private String tipo;
	private String fechaSolicitud;
	private String fechaEnvio;
	private String fechaAcuse;
	private String resultado;
	
	
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
	public String getFechaSolicitud() {
		return fechaSolicitud;
	}
	public void setFechaSolicitud(String fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}
	public String getFechaEnvio() {
		return fechaEnvio;
	}
	public void setFechaEnvio(String fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}
	public String getFechaAcuse() {
		return fechaAcuse;
	}
	public void setFechaAcuse(String fechaAcuse) {
		this.fechaAcuse = fechaAcuse;
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
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
	
	
	

}
