package es.pfsgroup.plugin.precontencioso.procedimientoJudicial.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;

@Entity
@Table(name = "PCO_PRC_PROCEDIMIENTOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ProcedimentoPCO implements Serializable, Auditable {

	private static final long serialVersionUID = 8036714975464886725L;

	@Id
	@Column(name = "PCO_PRC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ProcedimientoPCOGenerator")
	@SequenceGenerator(name = "ProcedimientoPCOGenerator", sequenceName = "S_PCO_PRC_PROCEDIMIENTOS")
	private Long id;

	@OneToOne
	@JoinColumn(name = "PCO_PRC_PRC_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private Procedimiento procedimiento;

	@ManyToOne
	@JoinColumn(name = "PCO_PRC_PREPARACION_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDEstadoPreparacionPCO estadoPreparacion;

	@ManyToOne
	@JoinColumn(name = "PCO_PRC_PTP_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDTipoPreparacionPCO tipoPreparacion;

	@Column(name = "PCO_PRC_TIPO_PRC_PROP")
	private String tipoProcPropuesto;

	@Column(name = "PCO_PRC_TIPO_PRC_INICIADO")
	private String tipoProcIniciado;

	@Column(name = "PCO_PRC_PRETURNADO")
	private Boolean preturnado;

	@Column(name = "PCO_PRC_NOM_EXP_JUD")
	private String nombreExpJudicial;

	@Column(name = "PCO_PRC_NUM_EXP_INT")
	private String numExpInterno;

	@Column(name = "PCO_PRC_CNT_PRINCIPAL")
	private String cntPrincipal;

	@Column(name = "PCO_PRC_FECHA_INICIO")
	private Date fechaInicio;

	@Column(name = "PCO_PRC_FECHA_PREPARADO")
	private Date fechaPreparado;

	@Column(name = "PCO_PRC_FECHA_ENVIO_LETRADO")
	private Date fechaEnvioLetrado;

	@Column(name = "PCO_PRC_FECHA_FINALIZADO")
	private Date fechaFinalizado;

	@Column(name = "PCO_PRC_FECHA_ULTIMA_SUBSANA")
	private Date fechaUltimaSubsanacion;

	@Column(name = "PCO_PRC_FECHA_CANCELADO")
	private Date fechaCancelado;

	@Column(name = "PCO_PRC_FECHA_PARALIZACION")
	private Date fechaParalizacion;

	@OneToMany(mappedBy = "procedimientoPCO", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "PCO_PRC_PRC_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<LiquidacionPCO> liquidaciones;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	/*
	 * GETTERS & SETTERS
	 */

	public Long getId() {
		return id;
	}

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public DDEstadoPreparacionPCO getEstadoPreparacion() {
		return estadoPreparacion;
	}

	public void setEstadoPreparacion(DDEstadoPreparacionPCO estadoPreparacion) {
		this.estadoPreparacion = estadoPreparacion;
	}

	public DDTipoPreparacionPCO getTipoPreparacion() {
		return tipoPreparacion;
	}

	public void setTipoPreparacion(DDTipoPreparacionPCO tipoPreparacion) {
		this.tipoPreparacion = tipoPreparacion;
	}

	public String getTipoProcPropuesto() {
		return tipoProcPropuesto;
	}

	public void setTipoProcPropuesto(String tipoProcPropuesto) {
		this.tipoProcPropuesto = tipoProcPropuesto;
	}

	public String getTipoProcIniciado() {
		return tipoProcIniciado;
	}

	public void setTipoProcIniciado(String tipoProcIniciado) {
		this.tipoProcIniciado = tipoProcIniciado;
	}

	public Boolean getPreturnado() {
		return preturnado;
	}

	public void setPreturnado(Boolean preturnado) {
		this.preturnado = preturnado;
	}

	public String getNombreExpJudicial() {
		return nombreExpJudicial;
	}

	public void setNombreExpJudicial(String nombreExpJudicial) {
		this.nombreExpJudicial = nombreExpJudicial;
	}

	public String getNumExpInterno() {
		return numExpInterno;
	}

	public void setNumExpInterno(String numExpInterno) {
		this.numExpInterno = numExpInterno;
	}

	public String getCntPrincipal() {
		return cntPrincipal;
	}

	public void setCntPrincipal(String cntPrincipal) {
		this.cntPrincipal = cntPrincipal;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaPreparado() {
		return fechaPreparado;
	}

	public void setFechaPreparado(Date fechaPreparado) {
		this.fechaPreparado = fechaPreparado;
	}

	public Date getFechaEnvioLetrado() {
		return fechaEnvioLetrado;
	}

	public void setFechaEnvioLetrado(Date fechaEnvioLetrado) {
		this.fechaEnvioLetrado = fechaEnvioLetrado;
	}

	public Date getFechaFinalizado() {
		return fechaFinalizado;
	}

	public void setFechaFinalizado(Date fechaFinalizado) {
		this.fechaFinalizado = fechaFinalizado;
	}

	public Date getFechaUltimaSubsanacion() {
		return fechaUltimaSubsanacion;
	}

	public void setFechaUltimaSubsanacion(Date fechaUltimaSubsanacion) {
		this.fechaUltimaSubsanacion = fechaUltimaSubsanacion;
	}

	public Date getFechaCancelado() {
		return fechaCancelado;
	}

	public void setFechaCancelado(Date fechaCancelado) {
		this.fechaCancelado = fechaCancelado;
	}

	public Date getFechaParalizacion() {
		return fechaParalizacion;
	}

	public void setFechaParalizacion(Date fechaParalizacion) {
		this.fechaParalizacion = fechaParalizacion;
	}

	public List<LiquidacionPCO> getLiquidaciones() {
		return liquidaciones;
	}

	public void setLiquidaciones(List<LiquidacionPCO> liquidaciones) {
		this.liquidaciones = liquidaciones;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
}
