package es.pfsgroup.plugin.rem.model;

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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Modelo que gestiona los activos de BBVA
 * 
 * @author Javier Esbrí
 */
@Entity
@Table(name = "ACT_BBVA_UIC", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoBbvaUic implements Serializable, Auditable {


	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "UIC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoBbvaUicGenerator")
    @SequenceGenerator(name = "ActivoBbvaUicGenerator", sequenceName = "S_ACT_BBVA_UIC")
    private Long id;

	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;

	@Column(name = "BBVA_UIC")
  	private String uicBbva;
    
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;	
	
	public Auditoria getAuditoria() {
		return auditoria;
	}

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

	public String getUicBbva() {
		return uicBbva;
	}

	public void setUicBbva(String uicBbva) {
		this.uicBbva = uicBbva;
	}

	
	
}
