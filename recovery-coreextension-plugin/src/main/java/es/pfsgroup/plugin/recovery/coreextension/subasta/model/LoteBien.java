package es.pfsgroup.plugin.recovery.coreextension.subasta.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.prorroga.model.Prorroga;

/**
 * Clase que representa la entidad Subasta.
 * 
 * @author
 * 
 */
@Entity
@Table(name = "LOB_LOTE_BIEN", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Deprecated
public class LoteBien implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5987488870796403973L;

	@Id
	@Column(name = "LOB_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "LoteGenerator")
	@SequenceGenerator(name = "LoteGenerator", sequenceName = "S_LOB_LOTE_BIEN")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "LOS_ID")
	private LoteSubasta loteSubasta;
	
	@ManyToOne
	@JoinColumn(name = "BIE_ID")
	private Bien bien;

	@Override
	public Auditoria getAuditoria() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		// TODO Auto-generated method stub
		
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public LoteSubasta getLoteSubasta() {
		return loteSubasta;
	}

	public void setLoteSubasta(LoteSubasta loteSubasta) {
		this.loteSubasta = loteSubasta;
	}

	public Bien getBien() {
		return bien;
	}

	public void setBien(Bien bien) {
		this.bien = bien;
	}	
	
	
}
