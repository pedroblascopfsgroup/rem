package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDTipoBulkAdvisoryNote;

/**
 * Modelo que gestiona la tabla de configuracion de subpartidas presupuestarias
 * @author Cristian Montoya
 *
 */
@Entity
@Table(name = "BLK_BULK_ADVISORY_NOTE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class BulkAdvisoryNote implements Auditable, Serializable {
		    
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "BLK_ID")
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;    
	 
	@Column(name = "BLK_NUM_BULK_AN")   
	private String numeroBulkAdvisoryNote;	    	    

	@ManyToOne
	@JoinColumn(name = "DD_TBK_ID")
	private DDTipoBulkAdvisoryNote tipoBulkAdvisoryNote;
	   
	@OneToMany(mappedBy = "bulkAdvisoryNote", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "BLK_ID")
	private List<BulkOferta> bulkOfertas;

	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNumeroBulkAdvisoryNote() {
		return numeroBulkAdvisoryNote;
	}

	public void setNumeroBulkAdvisoryNote(String numeroBulkAdvisoryNote) {
		this.numeroBulkAdvisoryNote = numeroBulkAdvisoryNote;
	}
	
	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public DDTipoBulkAdvisoryNote getTipoBulkAdvisoryNote() {
		return tipoBulkAdvisoryNote;
	}

	public void setTipoBulkAdvisoryNote(DDTipoBulkAdvisoryNote tipoBulkAdvisoryNote) {
		this.tipoBulkAdvisoryNote = tipoBulkAdvisoryNote;
	}

	public List<BulkOferta> getBulkOferta() {
		return bulkOfertas;
	}

	public void setBulkOferta(List<BulkOferta> bulkOfertas) {
		this.bulkOfertas = bulkOfertas;
	}
	

}
