package es.pfsgroup.plugin.recovery.masivo.model;

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

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Clase que representa un objeto para la resituación (cambio de la tarea activa)
 *  de un procedimiento.
 * 
 * @author pblasco
 * 
 */
@Entity
@Table(name = "RSP_RESITUAR_PROCEDIMIENTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class MSVResituarProcedimiento implements Serializable, Auditable {

	private static final long serialVersionUID = -3745056486147306300L;

	@Id
	@Column(name = "RSP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ResituarProcedimientoGenerator")
	@SequenceGenerator(name = "ResituarProcedimientoGenerator", sequenceName = "S_RSP_RESITUAR_PROCEDIMIENTO")
	private Long id;

	@Column(name = "ASU_ID")
	private Long asuId;

	@Column(name = "DD_TAC_ID")
	private Long tacId;

	@Column(name = "DD_TPO_ID")
	private Long tpoId;

	@Column(name = "TAR_ID")
	private Long tarId;

	@Column(name = "RSP_INSTRUCCIONES")
	private String instrucciones;

	@JoinColumn(name = "PRC_ID")
	@ManyToOne
	private Procedimiento procedimiento;
	
	@Column(name = "RSP_FECHA_REVISADO")
	private Date fechaRevisado;

	@Column(name = "PRM_ID")
	private Long procMasivoId;

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;


	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getAsuId() {
		return asuId;
	}

	public void setAsuId(Long asuId) {
		this.asuId = asuId;
	}

	public Long getTacId() {
		return tacId;
	}

	public void setTacId(Long tacId) {
		this.tacId = tacId;
	}

	public Long getTpoId() {
		return tpoId;
	}

	public void setTpoId(Long tpoId) {
		this.tpoId = tpoId;
	}

	public Long getTarId() {
		return tarId;
	}

	public void setTarId(Long tarId) {
		this.tarId = tarId;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public String getInstrucciones() {
		return instrucciones;
	}

	public void setInstrucciones(String instrucciones) {
		this.instrucciones = instrucciones;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}
	
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public Date getFechaRevisado() {
		return fechaRevisado != null ? ((Date) fechaRevisado.clone()) : null;
	}

	public void setFechaRevisado(Date fechaRevisado) {
		this.fechaRevisado = fechaRevisado != null ? ((Date) fechaRevisado.clone()) : null;
	}

	public Long getProcMasivoId() {
		return procMasivoId;
	}

	public void setProcMasivoId(Long procMasivoId) {
		this.procMasivoId = procMasivoId;
	}

	
}
