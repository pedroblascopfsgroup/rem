package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de los posicionamientos de un expediente.
 *  
 * @author Luis Caballero
 *
 */
public class DtoPosicionamiento extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Long idPosicionamiento;
	private Date fechaAviso;
	private Long idProveedorNotario;
	private Date fechaPosicionamiento;
	private String motivoAplazamiento;
	
	
	public Long getIdPosicionamiento() {
		return idPosicionamiento;
	}
	public void setIdPosicionamiento(Long idPosicionamiento) {
		this.idPosicionamiento = idPosicionamiento;
	}
	public Date getFechaAviso() {
		return fechaAviso;
	}
	public void setFechaAviso(Date fechaAviso) {
		this.fechaAviso = fechaAviso;
	}
	public Date getFechaPosicionamiento() {
		return fechaPosicionamiento;
	}
	public void setFechaPosicionamiento(Date fechaPosicionamiento) {
		this.fechaPosicionamiento = fechaPosicionamiento;
	}
	public String getMotivoAplazamiento() {
		return motivoAplazamiento;
	}
	public void setMotivoAplazamiento(String motivoAplazamiento) {
		this.motivoAplazamiento = motivoAplazamiento;
	}
	public Long getIdProveedorNotario() {
		return idProveedorNotario;
	}
	public void setIdProveedorNotario(Long idProveedorNotario) {
		this.idProveedorNotario = idProveedorNotario;
	}
	
	
	
	
   	
   	
}
