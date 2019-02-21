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
import es.pfsgroup.plugin.rem.model.dd.DDTipoNotificacionGencat;

@Entity
@Table(name = "ACT_NOG_NOTIFICACION_GENCAT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class NotificacionGencat implements Serializable, Auditable {

	private static final long serialVersionUID = 1044597921350764333L;
	
	@Id
    @Column(name = "NOG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "NotificacionGencatGenerator")
    @SequenceGenerator(name = "NotificacionGencatGenerator", sequenceName = "S_ACT_NOG_NOTIFICACION_GENCAT")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CMG_ID")
	private ComunicacionGencat comunicacion;
	
	@Column(name = "NOG_CHECK_NOTIFICATION")
	private Boolean checkNotificacion;
	
	@Column(name = "NOG_FECHA_NOTIFICATION")
	private Date fechaNotificacion;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_NOG_ID")
    private DDTipoNotificacionGencat tipoNotificacion;
	
	@Column(name = "NOG_FECHA_SANCION_NOTIFICATION")
	private Date fechaSancionNotificacion;
	
	@Column(name = "NOG_FECHA_CIERRE_NOTIFICATION")
	private Date cierreNotificacion;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ADC_ID")
	private AdjuntoComunicacion adcId;
	
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

	public Boolean getCheckNotificacion() {
		return checkNotificacion;
	}

	public void setCheckNotificacion(Boolean notificacion) {
		this.checkNotificacion = notificacion;
	}

	public Date getFechaNotificacion() {
		return fechaNotificacion;
	}

	public void setFechaNotificacion(Date fechaNotificacion) {
		this.fechaNotificacion = fechaNotificacion;
	}

	public DDTipoNotificacionGencat getTipoNotificacion() {
		return tipoNotificacion;
	}

	public void setTipoNotificacion(DDTipoNotificacionGencat tipoNotificacion) {
		this.tipoNotificacion = tipoNotificacion;
	}

	public Date getFechaSancionNotificacion() {
		return fechaSancionNotificacion;
	}

	public void setFechaSancionNotificacion(Date fechaSancion) {
		this.fechaSancionNotificacion = fechaSancion;
	}

	public Date getCierreNotificacion() {
		return cierreNotificacion;
	}

	public void setCierreNotificacion(Date fechaCierre) {
		this.cierreNotificacion = fechaCierre;
	}
	
	public AdjuntoComunicacion getDocumentoId() {
		return adcId;
	}

	public void setDocumentoId(AdjuntoComunicacion adcId) {
		this.adcId = adcId;
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
