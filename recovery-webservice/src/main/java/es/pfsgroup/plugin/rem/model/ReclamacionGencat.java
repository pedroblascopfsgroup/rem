package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

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
@Table(name = "ACT_RCG_RECLAMACION_GENCAT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class ReclamacionGencat implements Serializable, Auditable {

	private static final long serialVersionUID = -466013681538653222L;
	
	@Id
    @Column(name = "RCG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ReclamacionGencatGenerator")
    @SequenceGenerator(name = "ReclamacionGencatGenerator", sequenceName = "S_ACT_RCG_RECLAMACION_GENCAT")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CMG_ID")
	private ComunicacionGencat comunicacion;
	
	@Column(name = "RCG_FECHA_AVISO")
	private Date fechaAviso;
	
	@Column(name = "RCG_FECHA_RECLAMACION")
	private Date fechaReclamacion;
	
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

	public Date getFechaAviso() {
		return fechaAviso;
	}

	public void setFechaAviso(Date fechaAviso) {
		this.fechaAviso = fechaAviso;
	}

	public Date getFechaReclamacion() {
		return fechaReclamacion;
	}

	public void setFechaReclamacion(Date fechaReclamacion) {
		this.fechaReclamacion = fechaReclamacion;
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
