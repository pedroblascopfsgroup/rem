package es.pfsgroup.plugin.precontencioso.expedienteJudicial.model;

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

@Entity
@Table(name = "PCO_PRC_HEP_HISTOR_EST_PREP", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class HistoricoEstadoProcedimientoPCO implements Serializable, Auditable {

	private static final long serialVersionUID = -3879749137192675255L;

	@Id
	@Column(name = "PCO_PRC_HEP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoEstadoProcedimientoPCOGenerator")
	@SequenceGenerator(name = "HistoricoEstadoProcedimientoPCOGenerator", sequenceName = "S_PCO_PRC_HEP_HIST_EST_PREP")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "PCO_PRC_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private ProcedimientoPCO procedimientoPCO;

	@ManyToOne
	@JoinColumn(name = "DD_PCO_PEP_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDEstadoPreparacionPCO estadoPreparacion;

	@Column(name = "PCO_PRC_HEP_FECHA_INCIO")
	private Date fechaInicio;

	@Column(name = "PCO_PRC_HEP_FECHA_FIN")
	private Date fechaFin;

	@Column(name = "SYS_GUID")
	private String sysGuid;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	/*
	 * GETTERS & SETTERS
	 */

	public ProcedimientoPCO getProcedimientoPCO() {
		return procedimientoPCO;
	}

	public void setProcedimientoPCO(ProcedimientoPCO procedimientoPCO) {
		this.procedimientoPCO = procedimientoPCO;
	}

	public DDEstadoPreparacionPCO getEstadoPreparacion() {
		return estadoPreparacion;
	}

	public void setEstadoPreparacion(DDEstadoPreparacionPCO estadoPreparacion) {
		this.estadoPreparacion = estadoPreparacion;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
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

	public Long getId() {
		return id;
	}

	public String getSysGuid() {
		return sysGuid;
	}

	public void setSysGuid(String sysGuid) {
		this.sysGuid = sysGuid;
	}

}
