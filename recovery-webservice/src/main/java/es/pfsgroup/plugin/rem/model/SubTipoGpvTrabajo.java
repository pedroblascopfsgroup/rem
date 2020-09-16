package es.pfsgroup.plugin.rem.model;

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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;

/**
 * Modelo que gestiona la relacion de un gestor con su director de equipo.
 * 
 * @author Juanjo Arbona
 */
@Entity
@Table(name = "ACT_SGT_SUBTIPO_GPV_TBJ", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class SubTipoGpvTrabajo implements Auditable, Serializable {

	private static final long serialVersionUID = 7594603536051797805L;

	@Id
    @Column(name = "SGT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "SubTipoGpvTrabajoGenerator")
    @SequenceGenerator(name = "SubTipoGpvTrabajoGenerator", sequenceName = "S_ACT_SGT_SUBTIPO_GPV_TBJ")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name = "DD_STG_ID")
	private DDSubtipoGasto subtipoGasto;

	@ManyToOne
	@JoinColumn(name = "DD_STR_ID")
    private DDSubtipoTrabajo subtipoTrabajo;
	
	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public DDSubtipoGasto getSubtipoGasto() {
		return subtipoGasto;
	}

	public void setSubtipoGasto(DDSubtipoGasto subtipoGasto) {
		this.subtipoGasto = subtipoGasto;
	}

	public DDSubtipoTrabajo getSubtipoTrabajo() {
		return subtipoTrabajo;
	}

	public void setSubtipoTrabajo(DDSubtipoTrabajo subtipoTrabajo) {
		this.subtipoTrabajo = subtipoTrabajo;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}