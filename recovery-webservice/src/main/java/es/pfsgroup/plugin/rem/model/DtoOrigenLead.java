package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;


/**
 * @author Lara
 *
 */
public class DtoOrigenLead extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private String id;
	private String origenCompradorLead;
	private String proveedorPrescriptorLead;
	private String proveedorRealizadorLead;
	private String fechaAltaLead;
	private String fechaAsignacionRealizadorLead;
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getOrigenCompradorLead() {
		return origenCompradorLead;
	}
	public void setOrigenCompradorLead(String origenCompradorLead) {
		this.origenCompradorLead = origenCompradorLead;
	}
	public String getProveedorPrescriptorLead() {
		return proveedorPrescriptorLead;
	}
	public void setProveedorPrescriptorLead(String proveedorPrescriptorLead) {
		this.proveedorPrescriptorLead = proveedorPrescriptorLead;
	}
	public String getProveedorRealizadorLead() {
		return proveedorRealizadorLead;
	}
	public void setProveedorRealizadorLead(String proveedorRealizadorLead) {
		this.proveedorRealizadorLead = proveedorRealizadorLead;
	}
	public String getFechaAltaLead() {
		return fechaAltaLead;
	}
	public void setFechaAltaLead(String fechaAltaLead) {
		this.fechaAltaLead = fechaAltaLead;
	}
	public String getFechaAsignacionRealizadorLead() {
		return fechaAsignacionRealizadorLead;
	}
	public void setFechaAsignacionRealizadorLead(String fechaAsignacionRealizadorLead) {
		this.fechaAsignacionRealizadorLead = fechaAsignacionRealizadorLead;
	}

	
}
