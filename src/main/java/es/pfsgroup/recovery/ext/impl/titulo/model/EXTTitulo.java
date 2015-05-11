package es.pfsgroup.recovery.ext.impl.titulo.model;

import javax.persistence.Column;
import javax.persistence.Entity;

import es.capgemini.pfs.titulo.model.Titulo;

@Entity
public class EXTTitulo extends Titulo{

	/**
	 * 
	 */
	private static final long serialVersionUID = -7853746311795193104L;
	
	@Column(name="TIT_NOMBRE_NOTARIO")
	private String nombreNotario;
	
	@Column(name="TIT_CALLE_NOTARIO")
	private String calleNotario;
	
	@Column(name="TIT_CODIGOPOSTAL_NOTARIO")
	private String codigoPostalNotario;
	
	@Column(name="TIT_NUMERO_NOTARIO")
	private String numeroNotario;
	
	@Column(name="TIT_LOCALIDAD_NOTARIO")
	private String localidadNotario;
	
	@Column(name="TIT_PROVINCIA_NOTARIO")
	private String provinciaNotario;
	
	@Column(name="TIT_TELEFONO1_NOTARIO")
	private String telefono1Notario;
	
	@Column(name="TIT_TELEFONO2_NOTARIO")
	private String telefono2Notario;

	public String getNombreNotario() {
		return nombreNotario;
	}

	public void setNombreNotario(String nombreNotario) {
		this.nombreNotario = nombreNotario;
	}

	public String getCalleNotario() {
		return calleNotario;
	}

	public void setCalleNotario(String calleNotario) {
		this.calleNotario = calleNotario;
	}

	public String getCodigoPostalNotario() {
		return codigoPostalNotario;
	}

	public void setCodigoPostalNotario(String codigoPostalNotario) {
		this.codigoPostalNotario = codigoPostalNotario;
	}

	public String getNumeroNotario() {
		return numeroNotario;
	}

	public void setNumeroNotario(String numeroNotario) {
		this.numeroNotario = numeroNotario;
	}

	public String getLocalidadNotario() {
		return localidadNotario;
	}

	public void setLocalidadNotario(String localidadNotario) {
		this.localidadNotario = localidadNotario;
	}

	public String getProvinciaNotario() {
		return provinciaNotario;
	}

	public void setProvinciaNotario(String provinciaNotario) {
		this.provinciaNotario = provinciaNotario;
	}

	public String getTelefono1Notario() {
		return telefono1Notario;
	}

	public void setTelefono1Notario(String telefono1Notario) {
		this.telefono1Notario = telefono1Notario;
	}

	public String getTelefono2Notario() {
		return telefono2Notario;
	}

	public void setTelefono2Notario(String telefono2Notario) {
		this.telefono2Notario = telefono2Notario;
	}
	
	

}
