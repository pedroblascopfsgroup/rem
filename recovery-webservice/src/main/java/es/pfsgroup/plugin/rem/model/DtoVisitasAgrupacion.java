package es.pfsgroup.plugin.rem.model;

import java.util.Date;




/**
 * Dto para la pestaña Comercial/visitas de la ficha de Agrupacion
 * @author Luis Caballero
 *
 */
public class DtoVisitasAgrupacion {

	private static final long serialVersionUID = 0L;

	
	
	private String idVisita;
	private Date fechaSolicitud;
	private String nombre;
	private String numDocumento;
	private Date fechaVisita;
	
	public String getIdVisita() {
		return idVisita;
	}
	public void setIdVisita(String idVisita) {
		this.idVisita = idVisita;
	}
	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}
	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getNumDocumento() {
		return numDocumento;
	}
	public void setNumDocumento(String numDocumento) {
		this.numDocumento = numDocumento;
	}
	public Date getFechaVisita() {
		return fechaVisita;
	}
	public void setFechaVisita(Date fechaVisita) {
		this.fechaVisita = fechaVisita;
	}

	
	
	
	
	

	
}