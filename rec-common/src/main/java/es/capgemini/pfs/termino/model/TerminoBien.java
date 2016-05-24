package es.capgemini.pfs.termino.model;

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
import es.capgemini.pfs.bien.model.Bien;

/**
 * 
 * @author AMQ
 *
 */
@Entity
@Table(name = "BIE_TEA", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class TerminoBien implements Serializable, Auditable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1958131562516043847L;

	@Id
    @Column(name = "BIE_TEA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TerminoBienGenerator")
    @SequenceGenerator(name = "TerminoBienGenerator", sequenceName = "S_TEA_CNT")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "BIE_ID")
	private Bien bien;
	
	@ManyToOne
    @JoinColumn(name = "TEA_ID")
	private TerminoAcuerdo termino;
	
	@Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;
    
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}


	public Bien getBien() {
		return bien;
	}

	public void setBien(Bien bien) {
		this.bien = bien;
	}

	public TerminoAcuerdo getTermino() {
		return termino;
	}

	public void setTermino(TerminoAcuerdo termino) {
		this.termino = termino;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
