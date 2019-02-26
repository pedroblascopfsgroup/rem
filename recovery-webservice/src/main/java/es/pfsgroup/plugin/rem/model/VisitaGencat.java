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
@Table(name = "ACT_VIG_VISITA_GENCAT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class VisitaGencat implements Serializable, Auditable {

	private static final long serialVersionUID = 9174226588205693764L;
	
	@Id
    @Column(name = "VIG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "VisitaGencatGenerator")
    @SequenceGenerator(name = "VisitaGencatGenerator", sequenceName = "S_ACT_VIG_VISITA_GENCAT")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CMG_ID")
	private ComunicacionGencat comunicacion;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "VIS_ID")
	private Visita visita;
	
	@Version   
	private Long version;
    
    @Embedded
	private Auditoria auditoria;
    
    @Column(name = "ID_LEAD_SF")
	private String idLeadSF;
    
    @Column(name = "FECHA_ENVIO_SOLICITUD")
	private Date fechaEnvioSolicitud;
    
    @Column(name = "FECHA_RECEPCION_ALTA")
	private Date fechaRecepcionSolicitud;

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

	public Visita getVisita() {
		return visita;
	}

	public void setVisita(Visita visita) {
		this.visita = visita;
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

	public String getIdLeadSF() {
		return idLeadSF;
	}

	public void setIdLeadSF(String idLeadSF) {
		this.idLeadSF = idLeadSF;
	}

	public Date getFechaEnvioSolicitud() {
		return fechaEnvioSolicitud;
	}

	public void setFechaEnvioSolicitud(Date fechaEnvioSolicitud) {
		this.fechaEnvioSolicitud = fechaEnvioSolicitud;
	}

	public Date getFechaRecepcionSolicitud() {
		return fechaRecepcionSolicitud;
	}

	public void setFechaRecepcionSolicitud(Date fechaRecepcionSolicitud) {
		this.fechaRecepcionSolicitud = fechaRecepcionSolicitud;
	}

}
