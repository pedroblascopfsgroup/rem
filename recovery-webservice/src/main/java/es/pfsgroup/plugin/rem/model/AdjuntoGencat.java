package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
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

@Entity
@Table(name = "CMG_ADC_ADJUNTO_COM_GENCAT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class AdjuntoGencat implements Serializable, Auditable {

	private static final long serialVersionUID = -3961312179799978250L;

	@Id
    @Column(name = "ADC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AdjuntoGencatGenerator")
    @SequenceGenerator(name = "AdjuntoGencatGenerator", sequenceName = "S_CMG_ADC_ADJUNTO_COM_GENCAT")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CMG_ID")
	private ComunicacionGencat comunicacion;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ADA_ID")
	private ActivoAdjuntoActivo activoAdjuntoActivo;
	
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

	public ComunicacionGencat getComunicacion() {
		return comunicacion;
	}

	public void setComunicacion(ComunicacionGencat comunicacion) {
		this.comunicacion = comunicacion;
	}

	public ActivoAdjuntoActivo getActivoAdjuntoActivo() {
		return activoAdjuntoActivo;
	}

	public void setActivoAdjuntoActivo(ActivoAdjuntoActivo activoAdjuntoActivo) {
		this.activoAdjuntoActivo = activoAdjuntoActivo;
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
