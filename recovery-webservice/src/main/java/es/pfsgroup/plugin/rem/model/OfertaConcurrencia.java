package es.pfsgroup.plugin.rem.model;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import org.hibernate.annotations.Where;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

/**
 * Modelo que gestiona las concurrencias.
 */
@Entity
@Table(name = "OFC_OFERTAS_CONCURRENCIA", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class OfertaConcurrencia implements Serializable, Auditable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "OFC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "OfertaConcurrenciaGenerator")
    @SequenceGenerator(name = "OfertaConcurrenciaGenerator", sequenceName = "S_OFC_OFERTAS_CONCURRENCIA")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFR_ID")
    private Oferta oferta;

    @Column(name = "OFC_FECHA_DOC")
	private Date fechaDocumentacion;

	@Column(name = "OFC_FECHA_DEPOSITO")
	private Date fechaDeposito;

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

	public Oferta getOferta() {
		return oferta;
	}

	public void setOferta(Oferta oferta) {
		this.oferta = oferta;
	}

	public Date getFechaDocumentacion() {
		return fechaDocumentacion;
	}

	public void setFechaDocumentacion(Date fechaDocumentacion) {
		this.fechaDocumentacion = fechaDocumentacion;
	}

	public Date getFechaDeposito() {
		return fechaDeposito;
	}

	public void setFechaDeposito(Date fechaDeposito) {
		this.fechaDeposito = fechaDeposito;
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