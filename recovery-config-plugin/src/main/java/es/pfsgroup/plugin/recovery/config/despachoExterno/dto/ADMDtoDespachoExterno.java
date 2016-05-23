package es.pfsgroup.plugin.recovery.config.despachoExterno.dto;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.NotEmpty;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;

public class ADMDtoDespachoExterno extends WebDto {
	
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
    
    private String[] listaProvincias;
    
    private String clasificacionPerfil;
    
    private String clasificacionConcursos;
    
    private String codEstAse;
    
    private String contratoVigor;
    
    private String servicioIntegral;
    
    private String fechaServicioIntegral;
    
    private String relacionBankia;
    
	private String	oficinaContacto;
	
	private String entidadContacto;
		
	private String entidadLiquidacion;
	
	private String oficinaLiquidacion;
	
	private String digconLiquidacion;
	
	private String cuentaLiquidacion;
	
	private String entidadProvisiones;
	
	private String oficinaProvisiones;
	
	private String digconProvisiones;
	
	private String cuentaProvisiones;
	
	private String entidadEntregas;
	
	private String oficinaEntregas;
	
	private String digconEntregas;
	
	private String cuentaEntregas;
	
	private String centroRecuperacion;
	
	private String asesoria;
    
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
		fechaAlta = fechaAlta.replace("-", "/");
		this.fechaAlta = fechaAlta;
	}

	public String[] getListaProvincias() {
		return listaProvincias;
	}

	public void setListaProvincias(String[] listaProvincias) {
		if(!Checks.esNulo(listaProvincias))
			this.listaProvincias = listaProvincias[0].split(",");
	}

	public String getClasificacionPerfil() {
		return clasificacionPerfil;
	}

	public void setClasificacionPerfil(String clasificacionPerfil) {
		this.clasificacionPerfil = clasificacionPerfil;
	}

	public String getClasificacionConcursos() {
		return clasificacionConcursos;
	}

	public void setClasificacionConcursos(String clasificacionConcursos) {
		if(clasificacionConcursos.equals("01")) {
			this.clasificacionConcursos = "true";
		}
		if(clasificacionConcursos.equals("02")) {
			this.clasificacionConcursos = "false";
		}
	}

	public String getCodEstAse() {
		return codEstAse;
	}

	public void setCodEstAse(String codEstAse) {
		this.codEstAse = codEstAse;
	}

	public String getContratoVigor() {
		return contratoVigor;
	}

	public void setContratoVigor(String contratoVigor) {
		this.contratoVigor = contratoVigor;
	}

	public String getServicioIntegral() {
		return servicioIntegral;
	}

	public void setServicioIntegral(String servicioIntegral) {
		if(servicioIntegral.equals("01")) {
			this.servicioIntegral = "true";
		}
		if(servicioIntegral.equals("02")) {
			this.servicioIntegral = "false";
		}
	}

	public String getFechaServicioIntegral() {
		return fechaServicioIntegral;
	}

	public void setFechaServicioIntegral(String fechaServicioIntegral) {
		this.fechaServicioIntegral = fechaServicioIntegral;
	}

	public String getRelacionBankia() {
		return relacionBankia;
	}

	public void setRelacionBankia(String relacionBankia) {
		this.relacionBankia = relacionBankia;
	}

	public String getOficinaContacto() {
		return oficinaContacto;
	}

	public void setOficinaContacto(String oficinaContacto) {
		this.oficinaContacto = oficinaContacto;
	}

	public String getEntidadContacto() {
		return entidadContacto;
	}

	public void setEntidadContacto(String entidadContacto) {
		this.entidadContacto = entidadContacto;
	}

	public String getEntidadLiquidacion() {
		return entidadLiquidacion;
	}

	public void setEntidadLiquidacion(String entidadLiquidacion) {
		this.entidadLiquidacion = entidadLiquidacion;
	}

	public String getOficinaLiquidacion() {
		return oficinaLiquidacion;
	}

	public void setOficinaLiquidacion(String oficinaLiquidacion) {
		this.oficinaLiquidacion = oficinaLiquidacion;
	}

	public String getDigconLiquidacion() {
		return digconLiquidacion;
	}

	public void setDigconLiquidacion(String digconLiquidacion) {
		this.digconLiquidacion = digconLiquidacion;
	}

	public String getCuentaLiquidacion() {
		return cuentaLiquidacion;
	}

	public void setCuentaLiquidacion(String cuentaLiquidacion) {
		this.cuentaLiquidacion = cuentaLiquidacion;
	}

	public String getEntidadProvisiones() {
		return entidadProvisiones;
	}

	public void setEntidadProvisiones(String entidadProvisiones) {
		this.entidadProvisiones = entidadProvisiones;
	}

	public String getOficinaProvisiones() {
		return oficinaProvisiones;
	}

	public void setOficinaProvisiones(String oficinaProvisiones) {
		this.oficinaProvisiones = oficinaProvisiones;
	}

	public String getDigconProvisiones() {
		return digconProvisiones;
	}

	public void setDigconProvisiones(String digconProvisiones) {
		this.digconProvisiones = digconProvisiones;
	}

	public String getCuentaProvisiones() {
		return cuentaProvisiones;
	}

	public void setCuentaProvisiones(String cuentaProvisiones) {
		this.cuentaProvisiones = cuentaProvisiones;
	}

	public String getEntidadEntregas() {
		return entidadEntregas;
	}

	public void setEntidadEntregas(String entidadEntregas) {
		this.entidadEntregas = entidadEntregas;
	}

	public String getOficinaEntregas() {
		return oficinaEntregas;
	}

	public void setOficinaEntregas(String oficinaEntregas) {
		this.oficinaEntregas = oficinaEntregas;
	}

	public String getDigconEntregas() {
		return digconEntregas;
	}

	public void setDigconEntregas(String digconEntregas) {
		this.digconEntregas = digconEntregas;
	}

	public String getCuentaEntregas() {
		return cuentaEntregas;
	}

	public void setCuentaEntregas(String cuentaEntregas) {
		this.cuentaEntregas = cuentaEntregas;
	}

	public String getCentroRecuperacion() {
		return centroRecuperacion;
	}

	public void setCentroRecuperacion(String centroRecuperacion) {
		this.centroRecuperacion = centroRecuperacion;
	}

	public String getAsesoria() {
		return asesoria;
	}

	public void setAsesoria(String asesoria) {
		if(asesoria.equals("01")) {
			this.asesoria = "true";
		}
		if(asesoria.equals("02")) {
			this.asesoria = "false";
		}
	}

}
