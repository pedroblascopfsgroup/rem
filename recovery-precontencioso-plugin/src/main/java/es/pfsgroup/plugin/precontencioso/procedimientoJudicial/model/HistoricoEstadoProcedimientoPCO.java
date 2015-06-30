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
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;

@Entity
@Table(name = "PCO_PRC_HEP_HISTOR_EST_PREP", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class HistoricoEstadoProcedimientoPCO implements Serializable, Auditable {

	private static final long serialVersionUID = 8036714975464886725L;

	@Id
	@Column(name = "PCO_PRC_HEP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoEstadoProcedimientoPCOGenerator")
	@SequenceGenerator(name = "HistoricoEstadoProcedimientoPCOGenerator", sequenceName = "S_PCO_PRC_HEP_HIST_EST_PREP")
	private Long id;

	@OneToOne
	@JoinColumn(name = "PRC_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private Procedimiento procedimiento;

	@ManyToOne
	@JoinColumn(name = "DD_PCO_PEP_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDEstadoPreparacionPCO estadoPreparacion;

	@ManyToOne
	@JoinColumn(name = "DD_PCO_PTP_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDTipoPreparacionPCO tipoPreparacion;


	@Column(name = "PCO_PRC_HEP_FECHA_INCIO")
	private Date fechaInicio;

	@Column(name = "PCO_PRC_HEP_FECHA_FIN")
	private Date fechaFin;

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

}
