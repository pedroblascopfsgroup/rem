package es.pfsgroup.plugin.rem.rest.model;

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

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.Activo;

/**
 * 
 * @author rllinares
 *
 */

@Entity
@Table(name = "ACT_AMO_ACTIVOS_MOD", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivosModificados implements Serializable, Auditable{

	
	private static final long serialVersionUID = -2174816655546231032L;
	
	@Embedded
	private Auditoria auditoria;
	
	@Id
    @Column(name = "AMO_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "amoGenerator")
    @SequenceGenerator(name = "amoGenerator", sequenceName = "S_ACT_AMO_ACTIVOS_MOD")
	private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_ID")
	private Activo activo;
		

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
		
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}
	
	

}
