package es.pfsgroup.plugin.rem.model;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInterlocutor;
import es.pfsgroup.plugin.rem.model.dd.DDInterlocutorOferta;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import javax.persistence.*;
import java.io.Serializable;

/**
 * Modelo que gestiona la relacion entre los interlocutores y el Expediente Comiercial
 *  
 * @author Jesus Jativa
 *
 */
@Entity
@Table(name = "IEX_INTERLOCUTOR_EXPEDIENTE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class InterlocutorExpediente implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

		
	@Id
    @Column(name = "IEX_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "InterlocutorExpediente")
    @SequenceGenerator(name = "InterlocutorExpediente", sequenceName = "S_IEX_INTERLOCUTOR_EXPEDIENTE")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "IOC_ID")
    private InterlocutorPBCCaixa interlocutorPBCCaixa;
    
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expedienteComercial;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "IEX_OFR_ID")
	private Oferta oferta;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_FIO_ID")
	private DDInterlocutorOferta interlocutorOferta;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_EIC_ID")
	private DDEstadoInterlocutor estadoInterlocutor;

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

	public InterlocutorPBCCaixa getInterlocutorPBCCaixa() {
		return interlocutorPBCCaixa;
	}

	public void setInterlocutorPBCCaixa(InterlocutorPBCCaixa interlocutorPBCCaixa) {
		this.interlocutorPBCCaixa = interlocutorPBCCaixa;
	}

	public ExpedienteComercial getExpedienteComercial() {
		return expedienteComercial;
	}

	public void setExpedienteComercial(ExpedienteComercial expedienteComercial) {
		this.expedienteComercial = expedienteComercial;
	}

	public DDInterlocutorOferta getInterlocutorOferta() {
		return interlocutorOferta;
	}

	public void setInterlocutorOferta(DDInterlocutorOferta interlocutorOferta) {
		this.interlocutorOferta = interlocutorOferta;
	}

	public DDEstadoInterlocutor getEstadoInterlocutor() {
		return estadoInterlocutor;
	}

	public void setEstadoInterlocutor(DDEstadoInterlocutor estadoInterlocutor) {
		this.estadoInterlocutor = estadoInterlocutor;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Oferta getOferta() {
		return oferta;
	}

	public void setOferta(Oferta oferta) {
		this.oferta = oferta;
	}
}
