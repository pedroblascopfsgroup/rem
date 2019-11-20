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
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAutorizacionTramitacion;


/**
 * Modelo que gestiona la Autorizacion tramitacion ofertas.
 * 
 * @author MIGUEL LOPEZ
 * 
 */
@Entity
@Table(name = "ACT_ATR_AUTO_TRAM_OFERTAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoAutorizacionTramitacionOfertas implements Serializable, Auditable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "ATR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AutorizacionTramitacionGenerator")
    @SequenceGenerator(name = "AutorizacionTramitacionGenerator", sequenceName = "S_ACT_ATR_AUTO_TRAM_OFERTAS")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_ID")
	private Activo activo; 

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "AGR_ID")
	private ActivoAgrupacion activoAgrupacion;  
    
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MAT_ID")
   	private DDMotivoAutorizacionTramitacion motivoAutorizacionTramitacion;
    
    @Column(name = "OBSERVACIONES")
   	private String observacionesAutoTram;
    
    @Column(name = "FECHA_INI_BLOQUEO")
   	private Date fechIniBloq;
    
    @Column(name = "FECHA_AUTO_TRAM")
   	private Date fechAutoTram;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USU_ID")
    private Usuario usuario;
    
	@Version   
	private Long version;

    @Embedded
	private Auditoria auditoria;
    
    
    
    
    
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

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public ActivoAgrupacion getActivoAgrupacion() {
		return activoAgrupacion;
	}

	public void setActivoAgrupacion(ActivoAgrupacion activoAgrupacion) {
		this.activoAgrupacion = activoAgrupacion;
	}

	public DDMotivoAutorizacionTramitacion getMotivoAutorizacionTramitacion() {
		return motivoAutorizacionTramitacion;
	}

	public void setMotivoAutorizacionTramitacion(DDMotivoAutorizacionTramitacion motivoAutorizacionTramitacion) {
		this.motivoAutorizacionTramitacion = motivoAutorizacionTramitacion;
	}

	public String getObservacionesAutoTram() {
		return observacionesAutoTram;
	}

	public void setObservacionesAutoTram(String observacionesAutoTram) {
		this.observacionesAutoTram = observacionesAutoTram;
	}

	public Date getFechIniBloq() {
		return fechIniBloq;
	}

	public void setFechIniBloq(Date fechIniBloq) {
		this.fechIniBloq = fechIniBloq;
	}

	public Date getFechAutoTram() {
		return fechAutoTram;
	}

	public void setFechAutoTram(Date fechAutoTram) {
		this.fechAutoTram = fechAutoTram;
	}

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

}
