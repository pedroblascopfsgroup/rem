package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;




/**
 * Dto para el listado de ocupantes legales del activo
 * @author Carlos Feliu
 *
 */
public class DtoActivoOcupanteLegal extends WebDto {

	private static final long serialVersionUID = 0L;

	private String numeroActivo;
	private String nombreOcupante;
	private String nifOcupante;
	private String telefonoOcupante;
	private String emailOcupante;
	private String observacionesOcupante;
	private String idActivoOcupanteLegal;
	
	public String getNumeroActivo() {
		return numeroActivo;
	}
	public void setNumeroActivo(String numeroActivo) {
		this.numeroActivo = numeroActivo;
	}
	public String getNombreOcupante() {
		return nombreOcupante;
	}
	public void setNombreOcupante(String nombreOcupante) {
		this.nombreOcupante = nombreOcupante;
	}
	public String getNifOcupante() {
		return nifOcupante;
	}
	public void setNifOcupante(String nifOcupante) {
		this.nifOcupante = nifOcupante;
	}
	public String getTelefonoOcupante() {
		return telefonoOcupante;
	}
	public void setTelefonoOcupante(String telefonoOcupante) {
		this.telefonoOcupante = telefonoOcupante;
	}
	public String getEmailOcupante() {
		return emailOcupante;
	}
	public void setEmailOcupante(String emailOcupante) {
		this.emailOcupante = emailOcupante;
	}
	public String getObservacionesOcupante() {
		return observacionesOcupante;
	}
	public void setObservacionesOcupante(String observacionesOcupante) {
		this.observacionesOcupante = observacionesOcupante;
	}
	public String getIdActivoOcupanteLegal() {
		return idActivoOcupanteLegal;
	}
	public void setIdActivoOcupanteLegal(String idActivoOcupanteLegal) {
		this.idActivoOcupanteLegal = idActivoOcupanteLegal;
	}
}