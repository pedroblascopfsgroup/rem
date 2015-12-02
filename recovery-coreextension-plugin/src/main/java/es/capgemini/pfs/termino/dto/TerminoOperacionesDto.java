package es.capgemini.pfs.termino.dto;


import java.util.Date;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;

public class TerminoOperacionesDto extends WebDto{
	

	private static final long serialVersionUID = -3746399692512887715L;

    private Long id;
	private TerminoAcuerdo termino;	
    private Float pagoPrevioFormalizacion;	
    private Integer plazosPagosPrevioFormalizacion;	
    private Float carencia;	
    private Float cuotaAsumible;	
    private Float cargasPosteriores;
    private Float garantiasExtras;
    private String numExpediente;	
    private Integer solicitarAlquiler;	
    private Float liquidez;
    private Float tasacion;
    private Float importeQuita;
    private Integer porcentajeQuita;
    private Float importeVencido;
    private Float importeNoVencido;
    private Float interesesMoratorios;
    private Float interesesOrdinarios;
    private Float comision;
    private Float gastos;
    private String nombreCesionario;
    private String relacionCesionarioTitular;
    private Float solvenciaCesionario;
    private Float importeCesion;
    private String fechaPago;
    private String fechaPlanPago;
    private String frecuenciaPlanpago;
    private Integer numeroPagosPlanpago;
    private Integer importePlanpago;
    private String analisiSolvencia;
    private String descripcionAcuerdo;
    private Integer version;
    private Auditoria auditoria;

    public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public TerminoAcuerdo getTermino() {
		return termino;
	}

	public void setTermino(TerminoAcuerdo termino) {
		this.termino = termino;
	}

	public Float getPagoPrevioFormalizacion() {
		return pagoPrevioFormalizacion;
	}

	public void setPagoPrevioFormalizacion(Float pagoPrevioFormalizacion) {
		this.pagoPrevioFormalizacion = pagoPrevioFormalizacion;
	}

	public Integer getPlazosPagosPrevioFormalizacion() {
		return plazosPagosPrevioFormalizacion;
	}

	public void setPlazosPagosPrevioFormalizacion(
			Integer plazosPagosPrevioFormalizacion) {
		this.plazosPagosPrevioFormalizacion = plazosPagosPrevioFormalizacion;
	}

	public Float getCarencia() {
		return carencia;
	}

	public void setCarencia(Float carencia) {
		this.carencia = carencia;
	}

	public Float getCuotaAsumible() {
		return cuotaAsumible;
	}

	public void setCuotaAsumible(Float cuotaAsumible) {
		this.cuotaAsumible = cuotaAsumible;
	}

	public Float getCargasPosteriores() {
		return cargasPosteriores;
	}

	public void setCargasPosteriores(Float cargasPosteriores) {
		this.cargasPosteriores = cargasPosteriores;
	}

	public Float getGarantiasExtras() {
		return garantiasExtras;
	}

	public void setGarantiasExtras(Float garantiasExtras) {
		this.garantiasExtras = garantiasExtras;
	}

	public String getNumExpediente() {
		return numExpediente;
	}

	public void setNumExpediente(String numExpediente) {
		this.numExpediente = numExpediente;
	}

	public Integer getSolicitarAlquiler() {
		return solicitarAlquiler;
	}

	public void setSolicitarAlquiler(Integer solicitarAlquiler) {
		this.solicitarAlquiler = solicitarAlquiler;
	}

	public Float getLiquidez() {
		return liquidez;
	}

	public void setLiquidez(Float liquidez) {
		this.liquidez = liquidez;
	}

	public Float getTasacion() {
		return tasacion;
	}

	public void setTasacion(Float tasacion) {
		this.tasacion = tasacion;
	}

	public Float getImporteQuita() {
		return importeQuita;
	}

	public void setImporteQuita(Float importeQuita) {
		this.importeQuita = importeQuita;
	}

	public Integer getPorcentajeQuita() {
		return porcentajeQuita;
	}

	public void setPorcentajeQuita(Integer porcentajeQuita) {
		this.porcentajeQuita = porcentajeQuita;
	}

	public Float getImporteVencido() {
		return importeVencido;
	}

	public void setImporteVencido(Float importeVencido) {
		this.importeVencido = importeVencido;
	}

	public Float getImporteNoVencido() {
		return importeNoVencido;
	}

	public void setImporteNoVencido(Float importeNoVencido) {
		this.importeNoVencido = importeNoVencido;
	}

	public Float getInteresesMoratorios() {
		return interesesMoratorios;
	}

	public void setInteresesMoratorios(Float interesesMoratorios) {
		this.interesesMoratorios = interesesMoratorios;
	}

	public Float getInteresesOrdinarios() {
		return interesesOrdinarios;
	}

	public void setInteresesOrdinarios(Float interesesOrdinarios) {
		this.interesesOrdinarios = interesesOrdinarios;
	}

	public Float getComision() {
		return comision;
	}

	public void setComision(Float comision) {
		this.comision = comision;
	}

	public Float getGastos() {
		return gastos;
	}

	public void setGastos(Float gastos) {
		this.gastos = gastos;
	}

	public String getNombreCesionario() {
		return nombreCesionario;
	}

	public void setNombreCesionario(String nombreCesionario) {
		this.nombreCesionario = nombreCesionario;
	}

	public String getRelacionCesionarioTitular() {
		return relacionCesionarioTitular;
	}

	public void setRelacionCesionarioTitular(String relacionCesionarioTitular) {
		this.relacionCesionarioTitular = relacionCesionarioTitular;
	}

	public Float getSolvenciaCesionario() {
		return solvenciaCesionario;
	}

	public void setSolvenciaCesionario(Float solvenciaCesionario) {
		this.solvenciaCesionario = solvenciaCesionario;
	}

	public Float getImporteCesion() {
		return importeCesion;
	}

	public void setImporteCesion(Float importeCesion) {
		this.importeCesion = importeCesion;
	}

	public String getFechaPago() {
		return fechaPago;
	}

	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
	}

	public String getFechaPlanPago() {
		return fechaPlanPago;
	}

	public void setFechaPlanPago(String fechaPlanPago) {
		this.fechaPlanPago = fechaPlanPago;
	}

	public String getFrecuenciaPlanpago() {
		return frecuenciaPlanpago;
	}

	public void setFrecuenciaPlanpago(String frecuenciaPlanpago) {
		this.frecuenciaPlanpago = frecuenciaPlanpago;
	}

	public Integer getNumeroPagosPlanpago() {
		return numeroPagosPlanpago;
	}

	public void setNumeroPagosPlanpago(Integer numeroPagosPlanpago) {
		this.numeroPagosPlanpago = numeroPagosPlanpago;
	}

	public Integer getImportePlanpago() {
		return importePlanpago;
	}

	public void setImportePlanpago(Integer importePlanpago) {
		this.importePlanpago = importePlanpago;
	}

	public String getAnalisiSolvencia() {
		return analisiSolvencia;
	}

	public void setAnalisiSolvencia(String analisiSolvencia) {
		this.analisiSolvencia = analisiSolvencia;
	}

	public String getDescripcionAcuerdo() {
		return descripcionAcuerdo;
	}

	public void setDescripcionAcuerdo(String descripcionAcuerdo) {
		this.descripcionAcuerdo = descripcionAcuerdo;
	}

	public Auditoria getAuditoria() {
		return this.auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
		
	}
	
    public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}
}
