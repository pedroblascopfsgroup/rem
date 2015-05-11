package es.pfsgroup.plugin.recovery.busquedaProcedimientos.procedimiento.dto;

import java.math.BigDecimal;

import es.capgemini.devon.dto.WebDto;

public class BPRDtoBusquedaProcedimientos extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5762123191324733115L;
	
	private Long id;
	
	// DATOS REFERENTES AL ASUNTO
	private String asunto;
	private Long despacho;
	private String gestor;
	private Long supervisor;
	private Long procurador;
	private Long comite;
	private Long estadoAsunto;
	private String tipoGestor;
	private String fechaConformacionAsuntoDesde;
	private String fehcaConformacionAsuntoHasta;
	private String fechaAceptacionInicialDesde;
	private String fechaAceptacionInicialHasta;
	private Double importeTotalMin;
	private Double importeTotalMax;
	
	//DATOS REFERENTEES AL PROCEDIMIENTO
	private String estadoProcedimiento;
	private String codigoProcedimientoEnJuzgado; 
	private String numeroProcedimientoEnJuzgado;
	private String anyoProcedimientoEnJuzgado;
	private Long tipoActuacion;
	private String tipoProcedimiento;
	private Long tipoActuacionPadre;
	private String tipoProcedimientoPadre;
	private String plaza;
	private String juzgado;
	private BigDecimal saldoTotalContratosMin;
	private BigDecimal saldoTotalContratoMax;
	private Integer porcentajeRecupMin;
	private Integer porcentajeRecupMax;
	private Long tipoReclamacion;
	private String fechaCrearDesde;
	private String fechaCrearHasta;
	private Long demandado;
	
	//DATOS REFERENTES A LAS TAREAS
	private String fechaFinPrimeraTareaDesde;
	private String fechaFinPrimeraTareaHasta;
	
	private String fechaFinUltimaTareaDesde;
	private String fechaFinUltimaTareaHasta;
	
	//PESTAÑA DE CÓDIGOS
	private Long codigoInterno; // esto será el id del procedimiento 
	private String codigoContrato;
	private Long codigoCliente;
	private String nifCliente;
	private Long codigoAsunto;
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getCodigoProcedimientoEnJuzgado() {
		return codigoProcedimientoEnJuzgado;
	}
	public void setCodigoProcedimientoEnJuzgado(String codigoProcedimientoEnJuzgado) {
		this.codigoProcedimientoEnJuzgado = codigoProcedimientoEnJuzgado;
	}
	public String getTipoProcedimiento() {
		return tipoProcedimiento;
	}
	public void setTipoProcedimiento(String tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}
	public Long getTipoActuacion() {
		return tipoActuacion;
	}
	public void setTipoActuacion(Long tipoActuacion) {
		this.tipoActuacion = tipoActuacion;
	}
	public String getEstadoProcedimiento() {
		return estadoProcedimiento;
	}
	public void setEstadoProcedimiento(String estadoProcedimiento) {
		this.estadoProcedimiento = estadoProcedimiento;
	}
	public Long getTipoReclamacion() {
		return tipoReclamacion;
	}
	public void setTipoReclamacion(Long tipoReclamacion) {
		this.tipoReclamacion = tipoReclamacion;
	}
	
	public String getJuzgado() {
		return juzgado;
	}
	public void setJuzgado(String juzgado) {
		this.juzgado = juzgado;
	}
	public String getPlaza() {
		return plaza;
	}
	public void setPlaza(String plaza) {
		this.plaza = plaza;
	}
	public String getAsunto() {
		return asunto;
	}
	public void setAsunto(String asunto) {
		this.asunto = asunto;
	}
	public Long getDespacho() {
		return despacho;
	}
	public void setDespacho(Long despacho) {
		this.despacho = despacho;
	}
	public String getGestor() {
		return gestor;
	}
	public void setGestor(String gestor) {
		this.gestor = gestor;
	}
	public Long getSupervisor() {
		return supervisor;
	}
	public void setSupervisor(Long supervisor) {
		this.supervisor = supervisor;
	}
	public Long getProcurador() {
		return procurador;
	}
	public void setProcurador(Long procurador) {
		this.procurador = procurador;
	}
	public Long getComite() {
		return comite;
	}
	public void setComite(Long comite) {
		this.comite = comite;
	}
	public Long getEstadoAsunto() {
		return estadoAsunto;
	}
	public void setEstadoAsunto(Long estadoAsunto) {
		this.estadoAsunto = estadoAsunto;
	}
	public String getFechaAceptacionInicialDesde() {
		return fechaAceptacionInicialDesde;
	}
	public void setFechaAceptacionInicialDesde(String fechaAceptacionInicialDesde) {
		this.fechaAceptacionInicialDesde = fechaAceptacionInicialDesde;
	}
	public String getFechaAceptacionInicialHasta() {
		return fechaAceptacionInicialHasta;
	}
	public void setFechaAceptacionInicialHasta(String fechaAceptacionInicialHasta) {
		this.fechaAceptacionInicialHasta = fechaAceptacionInicialHasta;
	}
	public Double getImporteTotalMin() {
		return importeTotalMin;
	}
	public void setImporteTotalMin(Double importeTotalMin) {
		this.importeTotalMin = importeTotalMin;
	}
	public Double getImporteTotalMax() {
		return importeTotalMax;
	}
	public void setImporteTotalMax(Double importeTotalMax) {
		this.importeTotalMax = importeTotalMax;
	}
//	public String getNumeroAutos() {
//		return numeroAutos;
//	}
//	public void setNumeroAutos(String numeroAutos) {
//		this.numeroAutos = numeroAutos;
//	}
	public Long getTipoActuacionPadre() {
		return tipoActuacionPadre;
	}
	public void setTipoActuacionPadre(Long tipoActuacionPadre) {
		this.tipoActuacionPadre = tipoActuacionPadre;
	}
	public String getTipoProcedimientoPadre() {
		return tipoProcedimientoPadre;
	}
	public void setTipoProcedimientoPadre(String tipoProcedimientoPadre) {
		this.tipoProcedimientoPadre = tipoProcedimientoPadre;
	}
	public BigDecimal getSaldoTotalContratosMin() {
		return saldoTotalContratosMin;
	}
	public void setSaldoTotalContratosMin(BigDecimal saldoTotalContratosMin) {
		this.saldoTotalContratosMin = saldoTotalContratosMin;
	}
	public BigDecimal getSaldoTotalContratoMax() {
		return saldoTotalContratoMax;
	}
	public void setSaldoTotalContratoMax(BigDecimal saldoTotalContratoMax) {
		this.saldoTotalContratoMax = saldoTotalContratoMax;
	}
	public Integer getPorcentajeRecupMin() {
		return porcentajeRecupMin;
	}
	public void setPorcentajeRecupMin(Integer porcentajeRecupMin) {
		this.porcentajeRecupMin = porcentajeRecupMin;
	}
	public Integer getPorcentajeRecupMax() {
		return porcentajeRecupMax;
	}
	public void setPorcentajeRecupMax(Integer porcentajeRecupMax) {
		this.porcentajeRecupMax = porcentajeRecupMax;
	}
	
	public String getFechaFinPrimeraTareaDesde() {
		return fechaFinPrimeraTareaDesde;
	}
	public void setFechaFinPrimeraTareaDesde(String fechaFinPrimeraTareaDesde) {
		this.fechaFinPrimeraTareaDesde = fechaFinPrimeraTareaDesde;
	}
	public String getFechaFinPrimeraTareaHasta() {
		return fechaFinPrimeraTareaHasta;
	}
	public void setFechaFinPrimeraTareaHasta(String fechaFinPrimeraTareaHasta) {
		this.fechaFinPrimeraTareaHasta = fechaFinPrimeraTareaHasta;
	}
	public String getFechaFinUltimaTareaDesde() {
		return fechaFinUltimaTareaDesde;
	}
	public void setFechaFinUltimaTareaDesde(String fechaFinUltimaTareaDesde) {
		this.fechaFinUltimaTareaDesde = fechaFinUltimaTareaDesde;
	}
	public String getFechaFinUltimaTareaHasta() {
		return fechaFinUltimaTareaHasta;
	}
	public void setFechaFinUltimaTareaHasta(String fechaFinUltimaTareaHasta) {
		this.fechaFinUltimaTareaHasta = fechaFinUltimaTareaHasta;
	}
	public String getCodigoContrato() {
		return codigoContrato;
	}
	public void setCodigoContrato(String codigoContrato) {
		this.codigoContrato = codigoContrato;
	}
	public Long getCodigoCliente() {
		return codigoCliente;
	}
	public void setCodigoCliente(Long codigoCliente) {
		this.codigoCliente = codigoCliente;
	}
	public String getNifCliente() {
		return nifCliente;
	}
	public void setNifCliente(String nifCliente) {
		this.nifCliente = nifCliente;
	}
	public Long getCodigoAsunto() {
		return codigoAsunto;
	}
	public void setCodigoAsunto(Long codigoAsunto) {
		this.codigoAsunto = codigoAsunto;
	}
	public void setFechaConformacionAsuntoDesde(
			String fechaConformacionAsuntoDesde) {
		this.fechaConformacionAsuntoDesde = fechaConformacionAsuntoDesde;
	}
	public String getFechaConformacionAsuntoDesde() {
		return fechaConformacionAsuntoDesde;
	}
	public void setFehcaConformacionAsuntoHasta(
			String fehcaConformacionAsuntoHasta) {
		this.fehcaConformacionAsuntoHasta = fehcaConformacionAsuntoHasta;
	}
	public String getFehcaConformacionAsuntoHasta() {
		return fehcaConformacionAsuntoHasta;
	}
	public void setFechaCrearDesde(String fechaCrearDesde) {
		this.fechaCrearDesde = fechaCrearDesde;
	}
	public String getFechaCrearDesde() {
		return fechaCrearDesde;
	}
	public void setFechaCrearHasta(String fechaCrearHasta) {
		this.fechaCrearHasta = fechaCrearHasta;
	}
	public String getFechaCrearHasta() {
		return fechaCrearHasta;
	}
	public void setCodigoInterno(Long codigoInterno) {
		this.codigoInterno = codigoInterno;
	}
	public Long getCodigoInterno() {
		return codigoInterno;
	}
	public void setTipoGestor(String tipoGestor) {
		this.tipoGestor = tipoGestor;
	}
	public String getTipoGestor() {
		return tipoGestor;
	}
	public String getNumeroProcedimientoEnJuzgado() {
		return numeroProcedimientoEnJuzgado;
	}
	public void setNumeroProcedimientoEnJuzgado(
			String numeroProcedimientoEnJuzgado) {
		this.numeroProcedimientoEnJuzgado = numeroProcedimientoEnJuzgado;
	}
	public String getAnyoProcedimientoEnJuzgado() {
		return anyoProcedimientoEnJuzgado;
	}
	public void setAnyoProcedimientoEnJuzgado(String anyoProcedimientoEnJuzgado) {
		this.anyoProcedimientoEnJuzgado = anyoProcedimientoEnJuzgado;
	}
	public Long getDemandado() {
		return demandado;
	}
	public void setDemandado(Long demandado) {
		this.demandado = demandado;
	}
	
	

}
