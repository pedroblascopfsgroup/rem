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
@Table(name = "ACT_HNG_HIST_NOTIF_GENCAT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class HistoricoNotificacionGencat implements Serializable, Auditable {

	private static final long serialVersionUID = 5388008905603872293L;
	
	@Id
    @Column(name = "HNG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "NotificacionGencatGenerator")
    @SequenceGenerator(name = "NotificacionGencatGenerator", sequenceName = "S_ACT_NOG_NOTIFICACION_GENCAT")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "HCG_ID")
	private HistoricoComunicacionGencat historicoComunicacion;
	
	@Column(name = "HNG_CHECK_NOTIFICACION")
	private Boolean checkNotificacion;
	
	@Column(name = "HNG_FECHA_NOTIFICACION")
	private Date fechaNotificacion;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_NOG_ID")
    private DDTipoNotificacionGencat tipoNotificacion;
	
	@Column(name = "HNG_FECHA_SANCION_NOTIFICACION")
	private Date fechaSancionNotificacion;
	
	@Column(name = "HNG_FECHA_CIERRE_NOTIFICACION")
	private Date cierreNotificacion;
	
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

	public HistoricoComunicacionGencat getHistoricoComunicacion() {
		return historicoComunicacion;
	}

	public void setHistoricoComunicacion(HistoricoComunicacionGencat historicoComunicacion) {
		this.historicoComunicacion = historicoComunicacion;
	}

	public Boolean getCheckNotificacion() {
		return checkNotificacion;
	}

	public void setCheckNotificacion(Boolean checkNotificacion) {
		this.checkNotificacion = checkNotificacion;
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

	public void setFechaSancionNotificacion(Date fechaSancionNotificacion) {
		this.fechaSancionNotificacion = fechaSancionNotificacion;
	}

	public Date getCierreNotificacion() {
		return cierreNotificacion;
	}

	public void setCierreNotificacion(Date cierreNotificacion) {
		this.cierreNotificacion = cierreNotificacion;
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
