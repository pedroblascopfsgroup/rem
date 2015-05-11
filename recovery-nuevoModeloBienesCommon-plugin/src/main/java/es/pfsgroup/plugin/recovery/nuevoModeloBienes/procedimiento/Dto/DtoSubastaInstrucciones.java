package es.pfsgroup.plugin.recovery.nuevoModeloBienes.procedimiento.Dto;

import java.math.BigDecimal;
import java.util.Date;

import es.capgemini.devon.dto.WebDto;

public class DtoSubastaInstrucciones extends WebDto {

	private static final long serialVersionUID = 620416004242574408L;

	private Long idInstrucciones;
	
	private Long idBien;

	private Long idProcedimiento;
	
	private String codigoTipoSubasta;

	private Date primeraSubasta;

	private Date segundaSubasta;

	private Date terceraSubasta;

	private Long notario;

	private Float valorSubasta;

	private Float totalDeuda;

	private BigDecimal principal;

	private Float cargasAnteriores;

	private Float peritacionActual;

	private Float tipoSegundaSubasta;

	private Float importeSegundaSubasta;

	private Float tipoTerceraSubasta;

	private Float importeTerceraSubasta;

	private Float responsabilidadCapital;

	private Float responsabilidadIntereses;

	private Float responsabilidadDemoras;

	private Float responsabilidadCostas;

	private Float propuestaCapital;

	private Float propuestaIntereses;

	private Float propuestaDemoras;

	private Float propuestaCostas;

	private Date fechaInscripcion;

	private Date fechaLlaves;
	
	private String Observaciones;
	
	private Float costasProcurador;
	
	private Float costasLetrado;
	
	private Float limiteConPostores;

	private Long idPostores;
	
	public Long getIdBien() {
		return idBien;
	}

	public void setIdBien(Long idBien) {
		this.idBien = idBien;
	}

	public String getCodigoTipoSubasta() {
		return codigoTipoSubasta;
	}

	public void setCodigoTipoSubasta(String codigoTipoSubasta) {
		this.codigoTipoSubasta = codigoTipoSubasta;
	}

	public Date getPrimeraSubasta() {
		return primeraSubasta;
	}

	public void setPrimeraSubasta(Date primeraSubasta) {
		this.primeraSubasta = primeraSubasta;
	}

	public Date getSegundaSubasta() {
		return segundaSubasta;
	}

	public void setSegundaSubasta(Date segundaSubasta) {
		this.segundaSubasta = segundaSubasta;
	}

	public Date getTerceraSubasta() {
		return terceraSubasta;
	}

	public void setTerceraSubasta(Date terceraSubasta) {
		this.terceraSubasta = terceraSubasta;
	}

	public Long getNotario() {
		return notario;
	}

	public void setNotario(Long notario) {
		this.notario = notario;
	}

	public Float getValorSubasta() {
		return valorSubasta;
	}

	public void setValorSubasta(Float valorSubasta) {
		this.valorSubasta = valorSubasta;
	}

	public Float getTotalDeuda() {
		return totalDeuda;
	}

	public void setTotalDeuda(Float totalDeuda) {
		this.totalDeuda = totalDeuda;
	}

	public BigDecimal getPrincipal() {
		return principal;
	}

	public void setPrincipal(BigDecimal bigDecimal) {
		this.principal = bigDecimal;
	}

	public Float getCargasAnteriores() {
		return cargasAnteriores;
	}

	public void setCargasAnteriores(Float cargasAnteriores) {
		this.cargasAnteriores = cargasAnteriores;
	}

	public Float getPeritacionActual() {
		return peritacionActual;
	}

	public void setPeritacionActual(Float peritacionActual) {
		this.peritacionActual = peritacionActual;
	}

	public Float getTipoSegundaSubasta() {
		return tipoSegundaSubasta;
	}

	public void setTipoSegundaSubasta(Float tipoSegundaSubasta) {
		this.tipoSegundaSubasta = tipoSegundaSubasta;
	}

	public Float getImporteSegundaSubasta() {
		return importeSegundaSubasta;
	}

	public void setImporteSegundaSubasta(Float importeSegundaSubasta) {
		this.importeSegundaSubasta = importeSegundaSubasta;
	}

	public Float getTipoTerceraSubasta() {
		return tipoTerceraSubasta;
	}

	public void setTipoTerceraSubasta(Float tipoTerceraSubasta) {
		this.tipoTerceraSubasta = tipoTerceraSubasta;
	}

	public Float getImporteTerceraSubasta() {
		return importeTerceraSubasta;
	}

	public void setImporteTerceraSubasta(Float importeTerceraSubasta) {
		this.importeTerceraSubasta = importeTerceraSubasta;
	}

	public Float getResponsabilidadCapital() {
		return responsabilidadCapital;
	}

	public void setResponsabilidadCapital(Float responsabilidadCapital) {
		this.responsabilidadCapital = responsabilidadCapital;
	}

	public Float getResponsabilidadIntereses() {
		return responsabilidadIntereses;
	}

	public void setResponsabilidadIntereses(Float responsabilidadIntereses) {
		this.responsabilidadIntereses = responsabilidadIntereses;
	}

	public Float getResponsabilidadDemoras() {
		return responsabilidadDemoras;
	}

	public void setResponsabilidadDemoras(Float responsabilidadDemoras) {
		this.responsabilidadDemoras = responsabilidadDemoras;
	}

	public Float getResponsabilidadCostas() {
		return responsabilidadCostas;
	}

	public void setResponsabilidadCostas(Float responsabilidadCostas) {
		this.responsabilidadCostas = responsabilidadCostas;
	}

	public Float getPropuestaCapital() {
		return propuestaCapital;
	}

	public void setPropuestaCapital(Float propuestaCapital) {
		this.propuestaCapital = propuestaCapital;
	}

	public Float getPropuestaIntereses() {
		return propuestaIntereses;
	}

	public void setPropuestaIntereses(Float propuestaIntereses) {
		this.propuestaIntereses = propuestaIntereses;
	}

	public Float getPropuestaDemoras() {
		return propuestaDemoras;
	}

	public void setPropuestaDemoras(Float propuestaDemoras) {
		this.propuestaDemoras = propuestaDemoras;
	}

	public Float getPropuestaCostas() {
		return propuestaCostas;
	}

	public void setPropuestaCostas(Float propuestaCostas) {
		this.propuestaCostas = propuestaCostas;
	}

	public Date getFechaInscripcion() {
		return fechaInscripcion;
	}

	public void setFechaInscripcion(Date fechaInscripcion) {
		this.fechaInscripcion = fechaInscripcion;
	}

	public Date getFechaLlaves() {
		return fechaLlaves;
	}

	public void setFechaLlaves(Date fechaLlaves) {
		this.fechaLlaves = fechaLlaves;
	}

	/**
	 * @param idProcedimiento the idProcedimiento to set
	 */
	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}

	/**
	 * @return the idProcedimiento
	 */
	public Long getIdProcedimiento() {
		return idProcedimiento;
	}

	/**
	 * @param idInstrucciones the idInstrucciones to set
	 */
	public void setIdInstrucciones(Long idInstrucciones) {
		this.idInstrucciones = idInstrucciones;
	}

	/**
	 * @return the idInstrucciones
	 */
	public Long getIdInstrucciones() {
		return idInstrucciones;
	}

	/**
	 * @param observaciones the observaciones to set
	 */
	public void setObservaciones(String observaciones) {
		Observaciones = observaciones;
	}

	/**
	 * @return the observaciones
	 */
	public String getObservaciones() {
		return Observaciones;
	}

	public Float getCostasProcurador() {
		return costasProcurador;
	}

	public void setCostasProcurador(Float costasProcurador) {
		this.costasProcurador = costasProcurador;
	}

	public Float getCostasLetrado() {
		return costasLetrado;
	}

	public void setCostasLetrado(Float costasLetrado) {
		this.costasLetrado = costasLetrado;
	}

	public Float getLimiteConPostores() {
		return limiteConPostores;
	}

	public void setLimiteConPostores(Float limiteConPostores) {
		this.limiteConPostores = limiteConPostores;
	}

	public Long getIdPostores() {
		return idPostores;
	}

	public void setIdPostores(Long idPostores) {
		this.idPostores = idPostores;
	}

	
}
