package es.capgemini.pfs.gestorEntidad.model;

import java.io.Serializable;

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
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;

@Entity
@Table(name = "GEE_GESTOR_ENTIDAD", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Inheritance(strategy=InheritanceType.JOINED)
public abstract class GestorEntidad implements Auditable, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5826097714081255272L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "geeGenerator")
    @SequenceGenerator(name = "geeGenerator", sequenceName = "S_GEE_GESTOR_ENTIDAD")
	@Column(name = "GEE_ID")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "USU_ID")
	private Usuario usuario;

	@ManyToOne
	@JoinColumn(name = "DD_TGE_ID")
	private EXTDDTipoGestor tipoGestor;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
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

	

}
