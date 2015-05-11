package es.pfsgroup.plugin.recovery.coreextension.subasta.model;

import java.io.Serializable;

import javax.persistence.AssociationOverride;
import javax.persistence.AssociationOverrides;
import javax.persistence.Embedded;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;
import javax.persistence.JoinColumn;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.ProcedimientoPersonaId;

@Entity
@Table(name = "PRC_PER", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class ProcedimientoPersona implements Serializable, Auditable {

	private static final long serialVersionUID = 5987488870796403973L;

	@EmbeddedId
	private ProcedimientoPersonaId id;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	@ManyToOne
	@JoinColumn(name = "PRC_ID")
	private Procedimiento procedimiento;

	@ManyToOne
	@JoinColumn(name = "PER_ID")
	private Persona persona;

	@Override
	public Auditoria getAuditoria() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		// TODO Auto-generated method stub

	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Procedimiento getProcedimiento() {
		return procedimiento;
	}

	public void setProcedimiento(Procedimiento procedimiento) {
		this.procedimiento = procedimiento;
	}

	public Persona getPersona() {
		return persona;
	}

	public void setPersona(Persona persona) {
		this.persona = persona;
	}

}
