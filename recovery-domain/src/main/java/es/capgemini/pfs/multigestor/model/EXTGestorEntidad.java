package es.capgemini.pfs.multigestor.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;

@Entity
@Table(name = "GE_GESTOR_ENTIDAD", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class EXTGestorEntidad implements Auditable, Serializable {

	/**
	 * s_ge_gestor_entidad
	 */
	private static final long serialVersionUID = -8649094470707294356L;

	@Id
	@Column(name = "GE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "EXTGestorEntidadGenerator")
    @SequenceGenerator(name = "EXTGestorEntidadGenerator", sequenceName = "s_ge_gestor_entidad")
	private Long id;

	@Column(name = "UG_ID")
	private Long unidadGestionId;

	@ManyToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "DD_EIN_ID")
	private DDTipoEntidad tipoEntidad;
	

	@ManyToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "USU_ID")
	private Usuario gestor;

	@ManyToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "DD_TGE_ID")
	private EXTDDTipoGestor tipoGestor;

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

	

	public EXTDDTipoGestor getTipoGestor() {
		return tipoGestor;
	}

	public void setTipoGestor(EXTDDTipoGestor tipoGestor) {
		this.tipoGestor = tipoGestor;
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

	public void setUnidadGestionId(Long unidadGestionId) {
		this.unidadGestionId = unidadGestionId;
	}

	public Long getUnidadGestionId() {
		return unidadGestionId;
	}

	public void setTipoEntidad(DDTipoEntidad tipoEntidad) {
		this.tipoEntidad = tipoEntidad;
	}

	public DDTipoEntidad getTipoEntidad() {
		return tipoEntidad;
	}

	public void setGestor(Usuario gestor) {
		this.gestor = gestor;
	}

	public Usuario getGestor() {
		return gestor;
	}
}
