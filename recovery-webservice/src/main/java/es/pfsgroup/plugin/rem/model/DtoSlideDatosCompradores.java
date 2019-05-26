package es.pfsgroup.plugin.rem.model;

import java.util.ArrayList;
import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.plugin.rem.activo.ActivoPropagacionFieldTabMap;


/**
 * Dto para encapsular la información por pestaña de campos propagables a otros activos
 */
public class DtoSlideDatosCompradores extends WebDto  {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String codEstadoCivil; 
	private String codTipoDocumento; 
	private String codTipoDocumentoConyuge; 
	private String codTipoPersona;
	private String codigoRegimenMatrimonial; 
	private String descripcionEstadoCivil;
	private String descripcionRegimenMatrimonial; 
	private String descripcionTipoDocumento; 
	private String descripcionTipoDocumentoConyuge; 
	private String documentoConyuge; 
	private String esCarteraBankia; 
	private String estadoCivilURSUS;
	private Long id; 
	private Long idExpedienteComercial; 
	private Boolean mostrarUrsus; 
	private Boolean mostrarUrsusBh; 
	private String nombreConyugeURSUS; 
	private String numeroClienteUrsus; 
	private String numeroConyugeUrsus; 	
	private String regimenMatrimonialUrsus;
	
	private String numeroClienteUrsusConyuge;
	private String numeroClienteUrsusBhConyuge;

	
	public String getCodEstadoCivil() {
		return codEstadoCivil;
	}

	public void setCodEstadoCivil(String codEstadoCivil) {
		this.codEstadoCivil = codEstadoCivil;
	}

	public String getCodTipoDocumento() {
		return codTipoDocumento;
	}

	public void setCodTipoDocumento(String codTipoDocumento) {
		this.codTipoDocumento = codTipoDocumento;
	}

	public String getCodTipoDocumentoConyuge() {
		return codTipoDocumentoConyuge;
	}

	public void setCodTipoDocumentoConyuge(String codTipoDocumentoConyuge) {
		this.codTipoDocumentoConyuge = codTipoDocumentoConyuge;
	}

	public String getCodTipoPersona() {
		return codTipoPersona;
	}

	public void setCodTipoPersona(String codTipoPersona) {
		this.codTipoPersona = codTipoPersona;
	}

	public String getCodigoRegimenMatrimonial() {
		return codigoRegimenMatrimonial;
	}

	public void setCodigoRegimenMatrimonial(String codigoRegimenMatrimonial) {
		this.codigoRegimenMatrimonial = codigoRegimenMatrimonial;
	}

	public String getDescripcionEstadoCivil() {
		return descripcionEstadoCivil;
	}

	public void setDescripcionEstadoCivil(String descripcionEstadoCivil) {
		this.descripcionEstadoCivil = descripcionEstadoCivil;
	}

	public String getDescripcionRegimenMatrimonial() {
		return descripcionRegimenMatrimonial;
	}

	public void setDescripcionRegimenMatrimonial(String descripcionRegimenMatrimonial) {
		this.descripcionRegimenMatrimonial = descripcionRegimenMatrimonial;
	}

	public String getDescripcionTipoDocumento() {
		return descripcionTipoDocumento;
	}

	public void setDescripcionTipoDocumento(String descripcionTipoDocumento) {
		this.descripcionTipoDocumento = descripcionTipoDocumento;
	}

	public String getDescripcionTipoDocumentoConyuge() {
		return descripcionTipoDocumentoConyuge;
	}

	public void setDescripcionTipoDocumentoConyuge(String descripcionTipoDocumentoConyuge) {
		this.descripcionTipoDocumentoConyuge = descripcionTipoDocumentoConyuge;
	}

	public String getDocumentoConyuge() {
		return documentoConyuge;
	}

	public void setDocumentoConyuge(String documentoConyuge) {
		this.documentoConyuge = documentoConyuge;
	}

	public String getEsCarteraBankia() {
		return esCarteraBankia;
	}

	public void setEsCarteraBankia(String esCarteraBankia) {
		this.esCarteraBankia = esCarteraBankia;
	}

	public String getEstadoCivilURSUS() {
		return estadoCivilURSUS;
	}

	public void setEstadoCivilURSUS(String estadoCivilURSUS) {
		this.estadoCivilURSUS = estadoCivilURSUS;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdExpedienteComercial() {
		return idExpedienteComercial;
	}

	public void setIdExpedienteComercial(Long idExpedienteComercial) {
		this.idExpedienteComercial = idExpedienteComercial;
	}

	public Boolean getMostrarUrsus() {
		return mostrarUrsus;
	}

	public void setMostrarUrsus(Boolean mostrarUrsus) {
		this.mostrarUrsus = mostrarUrsus;
	}

	public Boolean getMostrarUrsusBh() {
		return mostrarUrsusBh;
	}

	public void setMostrarUrsusBh(Boolean mostrarUrsusBh) {
		this.mostrarUrsusBh = mostrarUrsusBh;
	}

	public String getNombreConyugeURSUS() {
		return nombreConyugeURSUS;
	}

	public void setNombreConyugeURSUS(String nombreConyugeURSUS) {
		this.nombreConyugeURSUS = nombreConyugeURSUS;
	}

	public String getNumeroClienteUrsus() {
		return numeroClienteUrsus;
	}

	public void setNumeroClienteUrsus(String numeroClienteUrsus) {
		this.numeroClienteUrsus = numeroClienteUrsus;
	}

	public String getNumeroConyugeUrsus() {
		return numeroConyugeUrsus;
	}

	public void setNumeroConyugeUrsus(String numeroConyugeUrsus) {
		this.numeroConyugeUrsus = numeroConyugeUrsus;
	}

	public String getRegimenMatrimonialUrsus() {
		return regimenMatrimonialUrsus;
	}

	public void setRegimenMatrimonialUrsus(String regimenMatrimonialUrsus) {
		this.regimenMatrimonialUrsus = regimenMatrimonialUrsus;
	}

	public String getNumeroClienteUrsusConyuge() {
		return numeroClienteUrsusConyuge;
	}

	public void setNumeroClienteUrsusConyuge(String numeroClienteUrsusConyuge) {
		this.numeroClienteUrsusConyuge = numeroClienteUrsusConyuge;
	}
	public String getNumeroClienteUrsusBhConyuge() {
		return numeroClienteUrsusBhConyuge;
	}

	public void setNumeroClienteUrsusBhConyuge(String numeroClienteUrsusBhConyuge) {
		this.numeroClienteUrsusBhConyuge = numeroClienteUrsusBhConyuge;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	} 
		
    
}