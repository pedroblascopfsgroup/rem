package es.capgemini.pfs.exceptuar.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "EXC_EXCEPTUACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class Exceptuacion implements Auditable, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5826097714081255272L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "excGenerator")
	@SequenceGenerator(name = "excGenerator", sequenceName = "S_EXC_EXCEPTUACION")
	@Column(name = "EXC_ID")
	private Long id;

	@Column(name = "EXC_FECHA_HASTA")
	private Date fechaHasta;

	@ManyToOne
	@JoinColumn(name = "DD_MOE_ID")
	private ExceptuacionMotivo motivo;

	@Column(name = "EXC_COMENTARIO")
	private String comentario;

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

	public Date getFechaHasta() {
		return fechaHasta;
	}

	public void setFechaHasta(Date fechaHasta) {
		this.fechaHasta = fechaHasta;
	}

	public ExceptuacionMotivo getMotivo() {
		return motivo;
	}

	public void setMotivo(ExceptuacionMotivo motivo) {
		this.motivo = motivo;
	}

	public String getComentario() {
		return comentario;
	}

	public void setComentario(String comentario) {
		this.comentario = comentario;
	}

	public Auditoria getAuditoria() {
		return auditoria;
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
