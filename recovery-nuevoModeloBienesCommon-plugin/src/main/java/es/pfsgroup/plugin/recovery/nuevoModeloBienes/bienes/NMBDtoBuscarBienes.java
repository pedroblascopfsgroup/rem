package es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes;

import es.capgemini.devon.dto.WebDto;

/**
 * Clase que transfiere informaci�n desde la vista hacia el modelo.
 * @author Sergio Alarc�n
 *
 */
public class NMBDtoBuscarBienes extends WebDto {

    private static final long serialVersionUID = 6015680735564006220L;

    private Long id;
    
    private String poblacion;
    
    private String codPostal;
    
    private String idTipoBien;

	private Long valorDesde;
    
    private Long totalCargasDesde;
    
    private Long valorHasta;
    
    private Long totalCargasHasta;
    
    private String fechaVerificacion;
    
    private String numContrato;
    
    private String codCliente;
    
    private String nifPrimerTitular;

    private String nifCliente;
    
    private boolean solvenciaNoEncontrada;
    

	private Long numActivo;
	private Long numRegistro;
	private String referenciaCatastral;
	private Long subtipoBien;
	private Long tasacionDesde;
	private Long tasacionHasta;
	private Long tipoSubastaDesde;
	private Long tipoSubastaHasta;
	
	private String direccion;
	private String provincia;
	private String localidad;
	private String codigoPostal;
	
	private String numFinca;

	public String getNifPrimerTitular() {
		return nifPrimerTitular;
	}

	public void setNifPrimerTitular(String nifPrimerTitular) {
		this.nifPrimerTitular = nifPrimerTitular;
	}

	public String getNifCliente() {
		return nifCliente;
	}

	public void setNifCliente(String nifCliente) {
		this.nifCliente = nifCliente;
	}

	public String getPoblacion() {
		return poblacion;
	}

	public void setPoblacion(String poblacion) {
		this.poblacion = poblacion;
	}

	public String getCodPostal() {
		return codPostal;
	}

	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
	}

	public String getIdTipoBien() {
		return idTipoBien;
	}

	public void setIdTipoBien(String idTipoBien) {
		this.idTipoBien = idTipoBien;
	}
	
	public Long getValorDesde() {
		return valorDesde;
	}

	public void setValorDesde(Long valorDesde) {
		this.valorDesde = valorDesde;
	}

	public Long getTotalCargasDesde() {
		return totalCargasDesde;
	}

	public void setTotalCargasDesde(Long totalCargasDesde) {
		this.totalCargasDesde = totalCargasDesde;
	}

	public Long getValorHasta() {
		return valorHasta;
	}

	public void setValorHasta(Long valorHasta) {
		this.valorHasta = valorHasta;
	}

	public Long getTotalCargasHasta() {
		return totalCargasHasta;
	}

	public void setTotalCargasHasta(Long totalCargasHasta) {
		this.totalCargasHasta = totalCargasHasta;
	}

	public String getFechaVerificacion() {
		return fechaVerificacion;
	}

	public void setFechaVerificacion(String fechaVerificacion) {
		this.fechaVerificacion = fechaVerificacion;
	}
    
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @param numContrato the numContrato to set
	 */
	public void setNumContrato(String numContrato) {
		this.numContrato = numContrato;
	}

	/**
	 * @return the numContrato
	 */
	public String getNumContrato() {
		return numContrato;
	}

	/**
	 * @param codCliente the codCliente to set
	 */
	public void setCodCliente(String codCliente) {
		this.codCliente = codCliente;
	}

	/**
	 * @return the codCliente
	 */
	public String getCodCliente() {
		return codCliente;
	}

	public void setSolvenciaNoEncontrada(boolean solvenciaNoEncontrada) {
		this.solvenciaNoEncontrada = solvenciaNoEncontrada;
	}

	public boolean isSolvenciaNoEncontrada() {
		return solvenciaNoEncontrada;
	}
	
	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public Long getNumRegistro() {
		return numRegistro;
	}

	public void setNumRegistro(Long numRegistro) {
		this.numRegistro = numRegistro;
	}

	public String getReferenciaCatastral() {
		return referenciaCatastral;
	}

	public void setReferenciaCatastral(String referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
	}

	public Long getSubtipoBien() {
		return subtipoBien;
	}

	public void setSubtipoBien(Long subtipoBien) {
		this.subtipoBien = subtipoBien;
	}

	public Long getTasacionDesde() {
		return tasacionDesde;
	}

	public void setTasacionDesde(Long tasacionDesde) {
		this.tasacionDesde = tasacionDesde;
	}

	public Long getTasacionHasta() {
		return tasacionHasta;
	}

	public void setTasacionHasta(Long tasacionHasta) {
		this.tasacionHasta = tasacionHasta;
	}

	public Long getTipoSubastaDesde() {
		return tipoSubastaDesde;
	}

	public void setTipoSubastaDesde(Long tipoSubastaDesde) {
		this.tipoSubastaDesde = tipoSubastaDesde;
	}

	public Long getTipoSubastaHasta() {
		return tipoSubastaHasta;
	}

	public void setTipoSubastaHasta(Long tipoSubastaHasta) {
		this.tipoSubastaHasta = tipoSubastaHasta;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getProvincia() {
		return provincia;
	}

	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}

	public String getLocalidad() {
		return localidad;
	}

	public void setLocalidad(String localidad) {
		this.localidad = localidad;
	}

	public String getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}

	public String getNumFinca() {
		return numFinca;
	}

	public void setNumFinca(String numFinca) {
		this.numFinca = numFinca;
	}
	
	
    	
}