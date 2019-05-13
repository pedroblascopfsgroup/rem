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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Modelo que relaciona el histórico con la comunicación GENCAT.
 * 
 * @author Daniel Algaba
 */
@Entity
@Table(name = "HCG_CMG", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class RelacionHistoricoComunicacion implements Serializable, Auditable {

	private static final long serialVersionUID = -3664785355514894637L;
	
	@Id
    @Column(name = "HCG_CMG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "RelacionHistoricoComunicacionGenerator")
    @SequenceGenerator(name = "RelacionHistoricoComunicacionGenerator", sequenceName = "S_HCG_CMG")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "HCG_ID")
	private HistoricoComunicacionGencat historicoComunicacionGencat;

	@Column(name = "CMG_ID")
	private Long idComunicacionGencat;
    
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

	public HistoricoComunicacionGencat getHistoricoComunicacionGencat() {
		return historicoComunicacionGencat;
	}

	public void setHistoricoComunicacionGencat(HistoricoComunicacionGencat historicoComunicacionGencat) {
		this.historicoComunicacionGencat = historicoComunicacionGencat;
	}

	public Long getIdComunicacionGencat() {
		return idComunicacionGencat;
	}

	public void setIdComunicacionGencat(Long idComunicacionGencat) {
		this.idComunicacionGencat = idComunicacionGencat;
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
}
