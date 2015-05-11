package es.pfsgroup.plugin.recovery.nuevoModeloBienes.contratos.dto;

import java.util.Date;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;

public class DtoNMBBien extends WebDto {

    /**
     * serial.
     */
    private static final long serialVersionUID = -6637787116506547314L;

    private NMBBien bien;
    
    /* Datos registrales */
    private String referenciaCatastralBien;   
	
    private Float superficie;
	
    private Float superficieConstruida;
	
	private String tomo;
	
	private String libro;
	
	private String folio;

	private String inscripcion;
	
	private Date fechaInscripcion;
	
	private String numRegistro;
	
	private String municipoLibro;
	
	private String codigoRegistro;
    
	/* Datos Localizacion */
    private String poblacion;
	
    private String direccion;
	
    private String codPostal;
	
    private String numFinca;
	
    /* Datos Valoracion */
    private Date fechaValorSubjetivo;
	
    private Float importeValorSubjetivo;
	
    private Date fechaValorApreciacion;
	
    private Float importeValorApreciacion;
	
    private Date fechaValorTasacion;
	
    private Float importeValorTasacion;
    
    public void validateFormulario(MessageContext messageContext) {
        messageContext.clearMessages();
        if (bien.getParticipacion() == null) {
            messageContext.addMessage(new MessageBuilder().code("bienes.error.participacionnula").error().source("").defaultText(
                    "**Ingrese el porcentaje de 'Participaci�n'.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }
        final int participacion = 100;
        if (bien.getParticipacion() != null && (bien.getParticipacion() < 1 || bien.getParticipacion() > participacion)) {
            messageContext.addMessage(new MessageBuilder().code("bienes.error.participacion").error().source("").defaultText(
                    "**El porcentaje en 'Participaci�n' debe ser entre 1 y 100.").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }
        addValidation(bien, messageContext, "bien").addValidation(this, messageContext).validate();
    }    
    
    /**
     * @return the bien
     */
    public NMBBien getBien() {
        return bien;
    }

    /**
     * @param bien the bien to set
     */
    public void setBien(NMBBien bien) {
        this.bien = bien;
    }

	public String getReferenciaCatastralBien() {
		return referenciaCatastralBien;
	}

	public void setReferenciaCatastralBien(String referenciaCatastralBien) {
		this.referenciaCatastralBien = referenciaCatastralBien;
	}

	public Float getSuperficie() {
		return superficie;
	}

	public void setSuperficie(Float superficie) {
		this.superficie = superficie;
	}

	public Float getSuperficieConstruida() {
		return superficieConstruida;
	}

	public void setSuperficieConstruida(Float superficieConstruida) {
		this.superficieConstruida = superficieConstruida;
	}

	public String getTomo() {
		return tomo;
	}

	public void setTomo(String tomo) {
		this.tomo = tomo;
	}

	public String getLibro() {
		return libro;
	}

	public void setLibro(String libro) {
		this.libro = libro;
	}

	public String getFolio() {
		return folio;
	}

	public void setFolio(String folio) {
		this.folio = folio;
	}

	public String getInscripcion() {
		return inscripcion;
	}

	public void setInscripcion(String inscripcion) {
		this.inscripcion = inscripcion;
	}

	public Date getFechaInscripcion() {
		return fechaInscripcion;
	}

	public void setFechaInscripcion(Date fechaInscripcion) {
		this.fechaInscripcion = fechaInscripcion;
	}

	public String getNumRegistro() {
		return numRegistro;
	}

	public void setNumRegistro(String numRegistro) {
		this.numRegistro = numRegistro;
	}

	public String getMunicipoLibro() {
		return municipoLibro;
	}

	public void setMunicipoLibro(String municipoLibro) {
		this.municipoLibro = municipoLibro;
	}

	public String getCodigoRegistro() {
		return codigoRegistro;
	}

	public void setCodigoRegistro(String codigoRegistro) {
		this.codigoRegistro = codigoRegistro;
	}

	public String getPoblacion() {
		return poblacion;
	}

	public void setPoblacion(String poblacion) {
		this.poblacion = poblacion;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getCodPostal() {
		return codPostal;
	}

	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
	}

	public String getNumFinca() {
		return numFinca;
	}

	public void setNumFinca(String numFinca) {
		this.numFinca = numFinca;
	}

	public Date getFechaValorSubjetivo() {
		return fechaValorSubjetivo;
	}

	public void setFechaValorSubjetivo(Date fechaValorSubjetivo) {
		this.fechaValorSubjetivo = fechaValorSubjetivo;
	}

	public Float getImporteValorSubjetivo() {
		return importeValorSubjetivo;
	}

	public void setImporteValorSubjetivo(Float importeValorSubjetivo) {
		this.importeValorSubjetivo = importeValorSubjetivo;
	}

	public Date getFechaValorApreciacion() {
		return fechaValorApreciacion;
	}

	public void setFechaValorApreciacion(Date fechaValorApreciacion) {
		this.fechaValorApreciacion = fechaValorApreciacion;
	}

	public Float getImporteValorApreciacion() {
		return importeValorApreciacion;
	}

	public void setImporteValorApreciacion(Float importeValorApreciacion) {
		this.importeValorApreciacion = importeValorApreciacion;
	}

	public Date getFechaValorTasacion() {
		return fechaValorTasacion;
	}

	public void setFechaValorTasacion(Date fechaValorTasacion) {
		this.fechaValorTasacion = fechaValorTasacion;
	}

	public Float getImporteValorTasacion() {
		return importeValorTasacion;
	}

	public void setImporteValorTasacion(Float importeValorTasacion) {
		this.importeValorTasacion = importeValorTasacion;
	}

    
}
