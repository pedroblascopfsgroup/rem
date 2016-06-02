package es.capgemini.pfs.termino.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * 
 * @author Carlos Gil 
 *
 */
@Entity
@Table(name = "ACU_OPERACIONES_TERMINOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class TerminoOperaciones implements Serializable, Auditable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1958131562516043847L;

	@Id
    @Column(name = "OP_TERM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TerminoOperacionesGenerator")
    @SequenceGenerator(name = "TerminoOperacionesGenerator", sequenceName = "S_ACU_OPERACIONES_TERMINOS")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name = "TEA_ID")
	private TerminoAcuerdo termino;	
	
	@Column(name = "OP_IMP_PAG_PREV_FORM")
    private Float pagoPrevioFormalizacion;	
	
    @Column(name = "OP_PLZ_PAG_PREV_FORM")
    private Integer plazosPagosPrevioFormalizacion;	
    
    @Column(name = "OP_CARENCIA")
    private Float carencia;	
    
    @Column(name = "OP_CUOTA_ASUMIBLE")
    private Float cuotaAsumible;	
    
    @Column(name = "OP_CARGAS_POSTERIORES")
    private Float cargasPosteriores;
    
    @Column(name = "OP_GARANTIAS_EXTRAS")
    private Float garantiasExtras;
    
    @Column(name = "OP_NUM_EXPEDIENTE")
    private String numExpediente;	

    @Column(name = "OP_SOLICITAR_ALQUILER")
    private Integer solicitarAlquiler;	
    
    @Column(name = "OP_LIQUIDEZ")
    private Float liquidez;
    
    @Column(name = "OP_TASACION")
    private Float tasacion;
    
    @Column(name = "OP_IMPORTE_PAGAR_QUITA")
    private Float importeQuita;
	       
    @Column(name = "OP_PORCENTAJE_QUITA")
    private Integer porcentajeQuita;
    
    @Column(name = "OP_IMPORTE_VENCIDO")
    private Float importeVencido;
	      
    @Column(name = "OP_IMPORTE_NO_VENCIDO")
    private Float importeNoVencido;
	       
    @Column(name = "OP_IMP_INTERESES_MORATORIOS")
    private Float interesesMoratorios;
    
    @Column(name = "OP_IMP_INTERESES_ORDINARIOS")
    private Float interesesOrdinarios;
    
    @Column(name = "OP_COMISION")
    private Float comision;

    @Column(name = "OP_GASTOS")
    private Float gastos;
    
    @Column(name = "OP_NOM_CESIONARIO")
    private String nombreCesionario;
    
    @Column(name = "OP_REL_CES_TIT")
    private String relacionCesionarioTitular;
    
    @Column(name = "OP_SOLVENCIA_CESIONARIO")
    private Float solvenciaCesionario;
    
    @Column(name = "OP_IMPORTE_CESION")
    private Float importeCesion;

    @Column(name = "OP_FECHA_PAGO")
    private Date fechaPago;
    
    @Column(name = "OP_PLAN_PGS_FECHA")
    private Date fechaPlanPago;
    
    @Column(name = "OP_PLAN_PGS_FRECUENCIA")
    private String frecuenciaPlanpago;
    
    @Column(name = "OP_PLAN_PGS_NUM_PAGOS")
    private Integer numeroPagosPlanpago;
    
    @Column(name = "OP_PLAN_PGS_IMPORTE")
    private Integer importePlanpago;
    
    @Column(name = "OP_ANALISIS_SOLVENCIA")
    private String analisiSolvencia;
    
    @Column(name = "OP_DESC_ACUERDO")
    private String descripcionAcuerdo;
    
    @Column(name = "OP_FECHA_SOL_PREVISTA")
    private Date fechaSolucionPrevista;

    @Column(name = "OP_NUM_CONTRATO_DESCUENTO")
    private String numContratoDescuento;
    
    @Column(name = "OP_NUM_CONTRATO_PTMO_PROMOTOR")
    private String numeroContratoPtmoPromotor;
    
    @Column(name = "OP_COD_PERSONA_AFECTADA")
    private String codigoPersonaAfectada;
    
	@Version
    private Integer version;

	@Embedded
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

	public Date getFechaPago() {
		return fechaPago;
	}

	public void setFechaPago(Date fechaPago) {
		this.fechaPago = fechaPago;
	}

	public Date getFechaPlanPago() {
		return fechaPlanPago;
	}

	public void setFechaPlanPago(Date fechaPlanPago) {
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
    
	public Date getFechaSolucionPrevista() {
		return fechaSolucionPrevista;
	}

	public void setFechaSolucionPrevista(Date fechaSolucionPrevista) {
		this.fechaSolucionPrevista = fechaSolucionPrevista;
	}

	public String getNumContratoDescuento() {
		return numContratoDescuento;
	}

	public void setNumContratoDescuento(String numContratoDescuento) {
		this.numContratoDescuento = numContratoDescuento;
	}

	public String getNumeroContratoPtmoPromotor() {
		return numeroContratoPtmoPromotor;
	}

	public void setNumeroContratoPtmoPromotor(String numeroContratoPtmoPromotor) {
		this.numeroContratoPtmoPromotor = numeroContratoPtmoPromotor;
	}

	public String getCodigoPersonaAfectada() {
		return codigoPersonaAfectada;
	}

	public void setCodigoPersonaAfectada(String codigoPersonaAfectada) {
		this.codigoPersonaAfectada = codigoPersonaAfectada;
	}

}
