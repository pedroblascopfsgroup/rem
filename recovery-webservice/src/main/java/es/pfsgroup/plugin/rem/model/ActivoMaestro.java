package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
/**
 *  Modelo que gestiona la tabla ACT_MAC_MAESTRO_ACTIVO
 * @author ivan.rubio@pfsgroup.es
 *
 */
@Entity
@Table(name = "ACT_MAC_MAESTRO_ACTIVO", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoMaestro implements Serializable, Auditable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "MAC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
	
	@OneToMany(mappedBy = "activo", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Activo activo;  
	
	@Column(name="ACT_REO")
	private boolean actReo;
	
	@Column(name="MAC_FECHA_ACTUALIZACION")
	private Date fechaActualizacion;

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

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public boolean isActReo() {
		return actReo;
	}

	public void setActReo(boolean actReo) {
		this.actReo = actReo;
	}

	public Date getFechaActualizacion() {
		return fechaActualizacion;
	}

	public void setFechaActualizacion(Date fechaActualizacion) {
		this.fechaActualizacion = fechaActualizacion;
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
