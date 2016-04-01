package es.pfsgroup.plugin.gestorDocumental.model.servicios;

import java.util.Date;

public class EntidadMetadatos extends ExpedientesServicios {

	/**
	 * CIF/NIF del expediente
	 */
	private String cifNif;
	
	/**
	 * Fecha caducidad del expediente
	 */
	private Date fechaCaducidad;
	
	
	public String getCifNif() {
		return cifNif;
	}

	public void setCifNif(String cifNif) {
		this.cifNif = cifNif;
	}

	public Date getFechaCaducidad() {
		return fechaCaducidad;
	}

	public void setFechaCaducidad(Date fechaCaducidad) {
		this.fechaCaducidad = fechaCaducidad;
	}

}