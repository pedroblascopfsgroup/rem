package es.capgemini.pfs.multigestor.model;

import java.io.Serializable;
import java.util.Date;

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

/**
 * Entidad que representa el histórico de cambios de la entidad {@link EXTGestorAdicionalAsunto}
 * 
 * @author manuel
 *
 */
@Entity
@Table(name = "GAH_GESTOR_ADICIONAL_HISTORICO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class EXTGestorAdicionalAsuntoHistorico implements Auditable, Serializable{

	private static final long serialVersionUID = 2298768934823600672L;

	@Id
    @Column(name = "GAH_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "EXTGestorAdicionalAsuntoHistoricoGenerator")
    @SequenceGenerator(name = "EXTGestorAdicionalAsuntoHistoricoGenerator", sequenceName = "S_GAH_GESTOR_ADIC_HISTORICO")
    private Long id;
    
	@ManyToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "GAH_ASU_ID")
	private Asunto asunto;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "GAH_GESTOR_ID")
	private GestorDespacho gestor;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "GAH_TIPO_GESTOR_ID")
	private EXTDDTipoGestor tipoGestor;

	@Column(name = "GAH_FECHA_DESDE")
	private Date fechaDesde;

	@Column(name = "GAH_FECHA_HASTA")
	private Date fechaHasta;
	
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
		
	public Date getFechaDesde() {
		return fechaDesde;
	}

	public void setFechaDesde(Date fechaDesde) {
		this.fechaDesde = fechaDesde;
	}

	public Date getFechaHasta() {
		return fechaHasta;
	}

	public void setFechaHasta(Date fechaHasta) {
		this.fechaHasta = fechaHasta;
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
