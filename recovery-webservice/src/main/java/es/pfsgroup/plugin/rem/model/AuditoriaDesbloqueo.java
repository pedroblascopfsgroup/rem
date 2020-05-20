package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;



/**
 * Modelo que gestiona la informacion de una oferta
 *
 * @author 
 *
 */
@Entity
@Table(name = "ECO_BGE_BLOQUEO_GEX", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class AuditoriaDesbloqueo implements Serializable, Auditable{

	@Id
    @Column(name = "BGE_ID")
    private Long id;
	
	@Column(name = "BGE_FECHA_DESBLOQUEO")
    private Date fechaDesbloqueo;
	
	@Column(name = "BGE_MOTIVO_DESBLOQUEO")
    private String motivoDesbloqueo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expediente;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USU_ID")
    private Usuario usuario;

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

	public Date getFechaDesbloqueo() {
		return fechaDesbloqueo;
	}

	public void setFechaDesbloqueo(Date fechaDesbloqueo) {
		this.fechaDesbloqueo = fechaDesbloqueo;
	}

	public String getMotivoDesbloqueo() {
		return motivoDesbloqueo;
	}

	public void setMotivoDesbloqueo(String motivoDesbloqueo) {
		this.motivoDesbloqueo = motivoDesbloqueo;
	}

	public ExpedienteComercial getExpediente() {
		return expediente;
	}

	public void setExpediente(ExpedienteComercial expediente) {
		this.expediente = expediente;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
		
	}
	
	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}
	
}
