package es.pfsgroup.plugin.recovery.config.despachoExterno.dto;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotEmpty;

import es.capgemini.devon.dto.WebDto;

public class ADMDtoDespachoExterno extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 6922962720608272619L;


	private Long id;
	

	@NotNull(message="plugin.config.despachoExterno.altadespacho.error.despacho.notnull")
	@NotEmpty(message="plugin.config.despachoExterno.altadespacho.error.despacho.notnull")
	private String despacho;

    private String tipoVia;

    private String domicilio;

    private String domicilioPlaza;
   
	private Integer codigoPostal;

    private String personaContacto;

    private String telefono1;

    private String telefono2;
    
    @NotNull(message="plugin.config.despachoExterno.altadespacho.error.tipodespacho.notnull")
    private Long tipoDespacho;
    
    private String tipoGestor;
        
    private String fax;
    
    private String correoElectronico;
    
    private String tipoDocumento;
    
    private String documentoCif;
    
    private String fechaAlta;
    
    public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}


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

	public void setTelefono1(String telefono1) {
		this.telefono1 = telefono1;
	}

	public String getTelefono1() {
		return telefono1;
	}

	public void setTelefono2(String telefono2) {
		this.telefono2 = telefono2;
	}

	public String getTelefono2() {
		return telefono2;
	}

	public void setTipoDespacho(Long tipoDespacho) {
		this.tipoDespacho = tipoDespacho;
	}

	public Long getTipoDespacho() {
		return tipoDespacho;
	}

	public String getTipoGestor() {
		return tipoGestor;
	}

	public void setTipoGestor(String tipoGestor) {
		this.tipoGestor = tipoGestor;
	}

	public String getFax() {
		return fax;
	}

	public void setFax(String fax) {
		this.fax = fax;
	}

	public String getCorreoElectronico() {
		return correoElectronico;
	}

	public void setCorreoElectronico(String correoElectronico) {
		this.correoElectronico = correoElectronico;
	}

	public String getTipoDocumento() {
		return tipoDocumento;
	}

	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}

	public String getDocumentoCif() {
		return documentoCif;
	}

	public void setDocumentoCif(String documentoCif) {
		this.documentoCif = documentoCif;
	}

	public String getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(String fechaAlta) {
		fechaAlta = fechaAlta.substring(0, 10).replace("-", "/");
		this.fechaAlta = fechaAlta;
	}

}
