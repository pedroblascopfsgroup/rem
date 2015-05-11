package es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;

@Entity
@Table(name = "ANC_ANALISIS_CONTRATOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class AnalisisContratos implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8301071265466471974L;

	@Id
	@Column(name = "ANC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "AnalisisContratosGenerator")
	@SequenceGenerator(name = "AnalisisContratosGenerator", sequenceName = "S_ANC_ANALISIS_CONTRATOS")
	private Long id;

	@OneToOne
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "CNT_ID")
	private Contrato contrato;

	@ManyToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "ASU_ID")
	private Asunto asunto;

	@Transient
	private Boolean ejecucionIniciada;	

	@Column(name="ANC_REVISADO_A")
	private Boolean revisadoA;	

	@Column(name="ANC_PROPUESTA_EJECUCION")
	private Boolean propuestaEjecucion;

	@Column(name="ANC_INICIAR_EJECUCION")
	private Boolean iniciarEjecucion;

	@Column(name="ANC_REVISADO_B")
	private Boolean revisadoB;	
	
	@Column(name="ANC_SOLICITAR_SOLVENCIA")
	private Boolean solicitarSolvencia;

	@Column(name="ANC_F_SOLICITAR_SOLVENCIA")
	private Date fechaSolicitarSolvencia;

	@Column(name="ANC_F_RECEPCION")
	private Date fechaRecepcion;

	@Column(name="ANC_RESULTADO")
	private Boolean resultado;

	@Column(name="ANC_DECISION_B")
	private Boolean decisionB;

	@Column(name="ANC_REVISADO_C")
	private Boolean revisadoC;

	@Column(name="ANC_DECISION_C")
	private Boolean decisionC;

	@Column(name="ANC_F_PROX_REVISION")
	private Date fechaProximaRevision;

	@Column(name="ANC_DECISION_REV")
	private Boolean decisionRevision;

	
	@Embedded
	private Auditoria auditoria;

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public Asunto getAsunto() {
		return asunto;
	}

	public void setAsunto(Asunto asunto) {
		this.asunto = asunto;
	}

	public Boolean getRevisadoA() {
		return revisadoA;
	}

	public void setRevisadoA(Boolean revisadoA) {
		this.revisadoA = revisadoA;
	}

	public Boolean getPropuestaEjecucion() {
		return propuestaEjecucion;
	}

	public void setPropuestaEjecucion(Boolean propuestaEjecucion) {
		this.propuestaEjecucion = propuestaEjecucion;
	}

	public Boolean getIniciarEjecucion() {
		return iniciarEjecucion;
	}

	public void setIniciarEjecucion(Boolean iniciarEjecucion) {
		this.iniciarEjecucion = iniciarEjecucion;
	}

	public Boolean getRevisadoB() {
		return revisadoB;
	}

	public void setRevisadoB(Boolean revisadoB) {
		this.revisadoB = revisadoB;
	}

	public Boolean getSolicitarSolvencia() {
		return solicitarSolvencia;
	}

	public void setSolicitarSolvencia(Boolean solicitarSolvencia) {
		this.solicitarSolvencia = solicitarSolvencia;
	}

	public Date getFechaSolicitarSolvencia() {
		return fechaSolicitarSolvencia;
	}

	public void setFechaSolicitarSolvencia(Date fechaSolicitarSolvencia) {
		this.fechaSolicitarSolvencia = fechaSolicitarSolvencia;
	}

	public Date getFechaRecepcion() {
		return fechaRecepcion;
	}

	public void setFechaRecepcion(Date fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}

	public Boolean getResultado() {
		return resultado;
	}

	public void setResultado(Boolean resultado) {
		this.resultado = resultado;
	}

	public Boolean getDecisionB() {
		return decisionB;
	}

	public void setDecisionB(Boolean decisionB) {
		this.decisionB = decisionB;
	}

	public Boolean getRevisadoC() {
		return revisadoC;
	}

	public void setRevisadoC(Boolean revisadoC) {
		this.revisadoC = revisadoC;
	}

	public Boolean getDecisionC() {
		return decisionC;
	}

	public void setDecisionC(Boolean decisionC) {
		this.decisionC = decisionC;
	}

	public Date getFechaProximaRevision() {
		return fechaProximaRevision;
	}

	public void setFechaProximaRevision(Date fechaProximaRevision) {
		this.fechaProximaRevision = fechaProximaRevision;
	}

	public Boolean getDecisionRevision() {
		return decisionRevision;
	}

	public void setDecisionRevision(Boolean decisionRevision) {
		this.decisionRevision = decisionRevision;
	}

	public Boolean getEjecucionIniciada() {
		return ejecucionIniciada;
	}

	public void setEjecucionIniciada(Boolean ejecucionIniciada) {
		this.ejecucionIniciada = ejecucionIniciada;
	}
}
