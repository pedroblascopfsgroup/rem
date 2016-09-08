package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de las resoluciones del expediente.
 *  
 * @author Luis Caballero
 *
 */
public class DtoFormalizacionResolucion extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Long idFormalizacion;
	private Long idExpediente;
	private String nombreNotario;
	private String personaContacto;
	private String peticionario;
	private Date fechaPeticion;
	private Date fechaResolucion;
	private Date fechaPago;
	private String formaPago;
	private String gastosCargo;
	private String docIdentificativo;
	private String motivoResolucion;
	private Double importe;
	
	
	public Long getIdFormalizacion() {
		return idFormalizacion;
	}
	public void setIdFormalizacion(Long idFormalizacion) {
		this.idFormalizacion = idFormalizacion;
	}
	public Long getIdExpediente() {
		return idExpediente;
	}
	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}
	public String getNombreNotario() {
		return nombreNotario;
	}
	public void setNombreNotario(String nombreNotario) {
		this.nombreNotario = nombreNotario;
	}
	public String getPersonaContacto() {
		return personaContacto;
	}
	public void setPersonaContacto(String personaContacto) {
		this.personaContacto = personaContacto;
	}
	public String getPeticionario() {
		return peticionario;
	}
	public void setPeticionario(String peticionario) {
		this.peticionario = peticionario;
	}
	public Date getFechaPeticion() {
		return fechaPeticion;
	}
	public void setFechaPeticion(Date fechaPeticion) {
		this.fechaPeticion = fechaPeticion;
	}
	public Date getFechaResolucion() {
		return fechaResolucion;
	}
	public void setFechaResolucion(Date fechaResolucion) {
		this.fechaResolucion = fechaResolucion;
	}
	public Date getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(Date fechaPago) {
		this.fechaPago = fechaPago;
	}
	public String getFormaPago() {
		return formaPago;
	}
	public void setFormaPago(String formaPago) {
		this.formaPago = formaPago;
	}
	public String getGastosCargo() {
		return gastosCargo;
	}
	public void setGastosCargo(String gastosCargo) {
		this.gastosCargo = gastosCargo;
	}
	public String getDocIdentificativo() {
		return docIdentificativo;
	}
	public void setDocIdentificativo(String docIdentificativo) {
		this.docIdentificativo = docIdentificativo;
	}
	public String getMotivoResolucion() {
		return motivoResolucion;
	}
	public void setMotivoResolucion(String motivoResolucion) {
		this.motivoResolucion = motivoResolucion;
	}
	public Double getImporte() {
		return importe;
	}
	public void setImporte(Double importe) {
		this.importe = importe;
	}
	
	

   		
}
