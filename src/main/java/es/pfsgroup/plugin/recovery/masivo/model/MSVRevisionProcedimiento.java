package es.pfsgroup.plugin.recovery.masivo.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.pfsgroup.plugin.recovery.mejoras.revisionProcedimiento.model.RevisionProcedimiento;

@Entity
//@Table(name = "RPR_REVISION_PROCEDIMIENTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class MSVRevisionProcedimiento extends RevisionProcedimiento {

	private static final long serialVersionUID = -4366262744365849942L;

	@Column(name = "PRM_ID")
	private Long procMasivoId;

	public Long getProcMasivoId() {
		return procMasivoId;
	}

	public void setProcMasivoId(Long procMasivoId) {
		this.procMasivoId = procMasivoId;
	}

	
}

// Esta clase no se puede mover a masivo-common porque depende de mejoras.
