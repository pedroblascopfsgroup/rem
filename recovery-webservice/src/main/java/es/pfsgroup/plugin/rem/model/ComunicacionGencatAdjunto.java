package es.pfsgroup.plugin.rem.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Modelo que gestiona la informacion de los adjuntos de las comunicaciones de GENCAT
 * 
 * @author Isidro Sotoca
 *
 */
@Entity
@Table(name = "CMG_ACG_ADJUNTO_COM_GENCAT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ComunicacionGencatAdjunto implements Serializable, Auditable {

	private static final long serialVersionUID = 467244568707940683L;
	
	@Id
    @Column(name = "ACG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ComunicacionGencatAdjuntoGenerator")
    @SequenceGenerator(name = "ComunicacionGencatAdjuntoGenerator", sequenceName = "S_CMG_ACG_ADJUNTO_COM_GENCAT")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "CMG_ID")
	private ComunicacionGencat comunicacionGencat;
	
	@ManyToOne
    @JoinColumn(name = "ADC_ID")
	private AdjuntoComunicacion adjuntoComunicacion;
	
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

	public ComunicacionGencat getComunicacionGencat() {
		return comunicacionGencat;
	}

	public void setComunicacionGencat(ComunicacionGencat comunicacionGencat) {
		this.comunicacionGencat = comunicacionGencat;
	}

	public AdjuntoComunicacion getAdjuntoComunicacion() {
		return adjuntoComunicacion;
	}

	public void setAdjuntoComunicacion(AdjuntoComunicacion adjuntoComunicacion) {
		this.adjuntoComunicacion = adjuntoComunicacion;
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
