package es.capgemini.pfs.multigestor.model;

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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;

@Entity
@Table(name = "GAA_GESTOR_ADICIONAL_ASUNTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class EXTGestorAdicionalAsunto implements Auditable, Serializable{
	
	private static final long serialVersionUID = 2058355640836148646L;

	@Id
    @Column(name = "GAA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "EXTGestorAdicionalAsuntoGenerator")
    @SequenceGenerator(name = "EXTGestorAdicionalAsuntoGenerator", sequenceName = "S_GAA_GESTOR_ADICIONAL_ASUNTO")
    private Long id;
    
	@ManyToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "ASU_ID")
	private Asunto asunto;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "USD_ID")
	private GestorDespacho gestor;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DD_TGE_ID")
	private EXTDDTipoGestor tipoGestor;

	
	@Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Asunto getAsunto() {
		return asunto;
	}

	public void setAsunto(Asunto asunto) {
		this.asunto = asunto;
	}

	public GestorDespacho getGestor() {
		return gestor;
	}

	public void setGestor(GestorDespacho gestor) {
		this.gestor = gestor;
	}

	public EXTDDTipoGestor getTipoGestor() {
		return tipoGestor;
	}

	public void setTipoGestor(EXTDDTipoGestor tipoGestor) {
		this.tipoGestor = tipoGestor;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}
	
}
