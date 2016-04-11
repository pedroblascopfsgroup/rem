package es.pfsgroup.plugin.recovery.liquidaciones.model;

import java.io.Serializable;
import java.sql.Date;

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

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.recovery.hrebcc.model.DDAdjContableConceptoEntrega;
import es.pfsgroup.recovery.hrebcc.model.DDAdjContableTipoEntrega;

@Entity
@Table(name = "CCO_CONTABILIDAD_COBROS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ContabilidadCobros implements Auditable, Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4502479621786306745L;
	
	@Id
    @Column(name = "CCO_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ContabilidadCobrosGenerator")
    @SequenceGenerator(name = "ContabilidadCobrosGenerator", sequenceName = "S_CCO_CONTABILIDAD_COBROS")
	private Long id;
	
	@Column(name = "CCO_FECHA_ENTREGA")
	private Date fechaEntrega;
	
	@Column(name = "CCO_FECHA_VALOR")
	private Date fechaValor;
	
	@Column(name = "CCO_IMPORTE")
	private Float importe;
	
	@ManyToOne
	@JoinColumn(name = "DD_ATE_ID")
	private DDAdjContableTipoEntrega tipoEntrega;
	
	@ManyToOne
	@JoinColumn(name = "DD_ACE_ID")
	private DDAdjContableConceptoEntrega conceptoEntrega;
	
	@Column(name = "CCO_NOMINAL")
	private Float nominal;
	
	@Column(name = "CCO_INTERESES")
	private Float intereses;
	
	@Column(name = "CCO_DEMORAS")
	private Float demoras;
	
	@Column(name = "CCO_IMPUESTOS")
	private Float impuestos;
	
	@Column(name = "CCO_GASTOS_PROCURADOR")
	private Float gastosProcurador;
	
	@Column(name = "CCO_GASTOS_LETRADO")
	private Float gastosLetrado;
	
	@Column(name = "CCO_OTROS_GASTOS")
	private Float otrosGastos;
	
	@Column(name = "CCO_QUITA_NOMINAL")
	private Float quitaNominal;
	
	@Column(name = "CCO_QUITA_INTERESES")
	private Float quitaIntereses;
	
	@Column(name = "CCO_QUITA_DEMORAS")
	private Float quitaDemoras;
	
	@Column(name = "CCO_QUITA_IMPUESTOS")
	private Float quitaImpuestos;
	
	@Column(name = "CCO_QUITA_GASTOS_PROCURADOR")
	private Float quitaGastosProcurador;
	
	@Column(name = "CCO_QUITA_GASTOS_LETRADO")
	private Float quitaGastosLetrado;
	
	@Column(name = "CCO_QUITA_OTROS_GASTOS")
	private Float quitaOtrosGastos;
	
	@Column(name = "CCO_TOTAL_ENTREGA")
	private Float totalEntrega;
	
	@Column(name = "CCO_NUM_ENLACE")
	private String numEnlace;
	
	@Column(name = "CCO_NUM_MANDAMIENTO")
	private String numMandamiento;
	
	@Column(name = "CCO_CHEQUE")
	private String numCheque;
	
	@Column(name = "CCO_OBSERVACIONES")
	private String observaciones;
	
	@Column(name = "CCO_OPERACIONES_TRAMITE")
	private Boolean operacionesTramite;
	
	@ManyToOne
	@JoinColumn(name = "ASU_ID")
	private Asunto asunto;
	
	@Embedded
	private Auditoria auditoria;
	
	@Version
    private Integer version;
	

	public ContabilidadCobros() {
	}


	public Long getId() {
		return id;
	}


	public void setId(Long id) {
		this.id = id;
	}


	public Date getFechaEntrega() {
		return fechaEntrega;
	}


	public void setFechaEntrega(Date fechaEntrega) {
		this.fechaEntrega = fechaEntrega;
	}


	public Date getFechaValor() {
		return fechaValor;
	}


	public void setFechaValor(Date fechaValor) {
		this.fechaValor = fechaValor;
	}


	public DDAdjContableTipoEntrega getTipoEntrega() {
		return tipoEntrega;
	}


	public void setTipoEntrega(DDAdjContableTipoEntrega tipoEntrega) {
		this.tipoEntrega = tipoEntrega;
	}


	public DDAdjContableConceptoEntrega getConceptoEntrega() {
		return conceptoEntrega;
	}


	public void setConceptoEntrega(DDAdjContableConceptoEntrega conceptoEntrega) {
		this.conceptoEntrega = conceptoEntrega;
	}


	public Float getNominal() {
		return nominal;
	}


	public void setNominal(Float nominal) {
		this.nominal = nominal;
	}


	public Float getIntereses() {
		return intereses;
	}


	public void setIntereses(Float intereses) {
		this.intereses = intereses;
	}


	public Float getDemoras() {
		return demoras;
	}


	public void setDemoras(Float demoras) {
		this.demoras = demoras;
	}


	public Float getImpuestos() {
		return impuestos;
	}


	public void setImpuestos(Float impuestos) {
		this.impuestos = impuestos;
	}


	public Float getGastosProcurador() {
		return gastosProcurador;
	}


	public void setGastosProcurador(Float gastosProcurador) {
		this.gastosProcurador = gastosProcurador;
	}


	public Float getGastosLetrado() {
		return gastosLetrado;
	}


	public void setGastosLetrado(Float gastosLetrado) {
		this.gastosLetrado = gastosLetrado;
	}


	public Float getOtrosGastos() {
		return otrosGastos;
	}


	public void setOtrosGastos(Float otrosGastos) {
		this.otrosGastos = otrosGastos;
	}


	public Float getQuitaNominal() {
		return quitaNominal;
	}


	public void setQuitaNominal(Float quitaNominal) {
		this.quitaNominal = quitaNominal;
	}


	public Float getQuitaIntereses() {
		return quitaIntereses;
	}


	public void setQuitaIntereses(Float quitaIntereses) {
		this.quitaIntereses = quitaIntereses;
	}


	public Float getQuitaDemoras() {
		return quitaDemoras;
	}


	public void setQuitaDemoras(Float quitaDemoras) {
		this.quitaDemoras = quitaDemoras;
	}


	public Float getQuitaImpuestos() {
		return quitaImpuestos;
	}


	public void setQuitaImpuestos(Float quitaImpuestos) {
		this.quitaImpuestos = quitaImpuestos;
	}


	public Float getQuitaGastosProcurador() {
		return quitaGastosProcurador;
	}


	public void setQuitaGastosProcurador(Float quitaGastosProcurador) {
		this.quitaGastosProcurador = quitaGastosProcurador;
	}


	public Float getQuitaGastosLEtrado() {
		return quitaGastosLetrado;
	}


	public void setQuitaGastosLEtrado(Float quitaGastosLEtrado) {
		this.quitaGastosLetrado = quitaGastosLEtrado;
	}


	public Float getQuitaOtrosGastos() {
		return quitaOtrosGastos;
	}


	public void setQuitaOtrosGastos(Float quitaOtrosGastos) {
		this.quitaOtrosGastos = quitaOtrosGastos;
	}


	public Float getTotalEntrega() {
		return totalEntrega;
	}


	public void setTotalEntrega(Float totalEntrega) {
		this.totalEntrega = totalEntrega;
	}


	public String getNumEnlace() {
		return numEnlace;
	}


	public void setNumEnlace(String numEnlace) {
		this.numEnlace = numEnlace;
	}


	public String getNumMandamiento() {
		return numMandamiento;
	}


	public void setNumMandamiento(String numMandamiento) {
		this.numMandamiento = numMandamiento;
	}


	public String getNumCheque() {
		return numCheque;
	}


	public void setNumCheque(String numCheque) {
		this.numCheque = numCheque;
	}


	public String getObservaciones() {
		return observaciones;
	}


	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}


	public Float getImporte() {
		return importe;
	}


	public void setImporte(Float importe) {
		this.importe = importe;
	}


	public Float getQuitaGastosLetrado() {
		return quitaGastosLetrado;
	}


	public void setQuitaGastosLetrado(Float quitaGastosLetrado) {
		this.quitaGastosLetrado = quitaGastosLetrado;
	}


	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}


	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}


	public Asunto getAsunto() {
		return asunto;
	}


	public void setAsunto(Asunto asunto) {
		this.asunto = asunto;
	}


	public Integer getVersion() {
		return version;
	}


	public void setVersion(Integer version) {
		this.version = version;
	}


	public Integer getSerialversionuid() {
		return version;
	}


	public Boolean getOperacionesTramite() {
		return operacionesTramite;
	}


	public void setOperacionesTramite(Boolean operacionesTramite) {
		this.operacionesTramite = operacionesTramite;
	}

}
