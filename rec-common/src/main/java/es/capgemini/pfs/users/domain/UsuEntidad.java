package es.capgemini.pfs.users.domain;

import java.io.Serializable;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dsm.model.Entidad;

@Entity
@Table(name = "USU_ENTIDADES", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class UsuEntidad implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6354449073849717470L;

	@Id
	@Column(name = "UE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "UsuEntidadGenerator")
	@SequenceGenerator(name = "UsuEntidadGenerator", sequenceName = "${master.schema}.S_USU_ENTIDADES")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "USU_ID")
	private Usuario usuario;

	@ManyToOne
	@JoinColumn(name = "ENTIDAD_ID")
	private Entidad entidad;

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

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

	public Entidad getEntidad() {
		return entidad;
	}

	public void setEntidad(Entidad entidad) {
		this.entidad = entidad;
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
