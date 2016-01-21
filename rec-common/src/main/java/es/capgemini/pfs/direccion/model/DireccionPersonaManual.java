package es.capgemini.pfs.direccion.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.Embedded;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Clase que representa una direccion.
 */

@Entity
@Table(name = "DIR_PEM", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DireccionPersonaManual implements Serializable, Auditable {

	private static final long serialVersionUID = 4897000609905358593L;

	@EmbeddedId
	private DireccionPersonaManualId id;
	
	@Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

	@Override
	public Auditoria getAuditoria() {
		return this.auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public DireccionPersonaManualId getId() {
		return id;
	}

	public void setId(DireccionPersonaManualId id) {
		this.id = id;
	}
	
}
