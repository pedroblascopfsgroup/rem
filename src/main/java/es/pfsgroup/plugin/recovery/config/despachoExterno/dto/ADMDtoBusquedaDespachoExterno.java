package es.pfsgroup.plugin.recovery.config.despachoExterno.dto;

import es.capgemini.devon.dto.WebDto;

public class ADMDtoBusquedaDespachoExterno extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 5512851228362081855L;

	private String despacho;

    private String tipoVia;

    private String domicilio;

    private String domicilioPlaza;
   
	private Integer codigoPostal;

    private String personaContacto;
    
    private String username;
    
    private String nombre;
    
    private String apellido1;
    
    private String apellido2;
    
    private Long supervisor;

    private Long tipoDespacho;
    
	public void setDespacho(String despacho) {
		this.despacho = despacho;
	}

	public String getDespacho() {
		return despacho;
	}

	public void setTipoVia(String tipoVia) {
		this.tipoVia = tipoVia;
	}

	public String getTipoVia() {
		return tipoVia;
	}

	public void setDomicilio(String domicilio) {
		this.domicilio = domicilio;
	}

	public String getDomicilio() {
		return domicilio;
	}

	public void setDomicilioPlaza(String domicilioPlaza) {
		this.domicilioPlaza = domicilioPlaza;
	}

	public String getDomicilioPlaza() {
		return domicilioPlaza;
	}

	public void setCodigoPostal(Integer codigoPostal) {
		this.codigoPostal = codigoPostal;
	}

	public Integer getCodigoPostal() {
		return codigoPostal;
	}

	public void setPersonaContacto(String personaContacto) {
		this.personaContacto = personaContacto;
	}

	public String getPersonaContacto() {
		return personaContacto;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getUsername() {
		return username;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getNombre() {
		return nombre;
	}

	public void setApellido1(String apellido1) {
		this.apellido1 = apellido1;
	}

	public String getApellido1() {
		return apellido1;
	}

	public void setApellido2(String apellido2) {
		this.apellido2 = apellido2;
	}

	public String getApellido2() {
		return apellido2;
	}

	public void setSupervisor(Long supervisor) {
		this.supervisor = supervisor;
	}

	public Long getSupervisor() {
		return supervisor;
	}

	public void setTipoDespacho(Long tipoDespacho) {
		this.tipoDespacho = tipoDespacho;
	}

	public Long getTipoDespacho() {
		return tipoDespacho;
	}
    

}
