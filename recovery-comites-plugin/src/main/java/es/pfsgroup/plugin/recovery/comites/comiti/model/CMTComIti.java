package es.pfsgroup.plugin.recovery.comites.comiti.model;

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

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.pfsgroup.plugin.recovery.comites.comite.model.CMTComite;

@Entity
@Table(name = "COM_ITI", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class CMTComIti implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7179809440234488879L;

	@Id
    @Column(name = "CI_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ComItiGenerator")
    @SequenceGenerator(name = "ComItiGenerator", sequenceName = "S_COM_ITI")
    private Long id;

	@ManyToOne
    @JoinColumn(name = "COM_ID")
    private CMTComite comite;

	@ManyToOne
    @JoinColumn(name = "ITI_ID")
    private Itinerario itinerario;

	@Embedded
	private Auditoria auditoria;
	
	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria=auditoria;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setComite(CMTComite comite) {
		this.comite = comite;
	}

	public CMTComite getComite() {
		return comite;
	}

	public void setItinerario(Itinerario itinerario) {
		this.itinerario = itinerario;
	}

	public Itinerario getItinerario() {
		return itinerario;
	}

	

}
