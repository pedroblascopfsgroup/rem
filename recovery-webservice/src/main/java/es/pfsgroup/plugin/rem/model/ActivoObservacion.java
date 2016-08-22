package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;


/**
 * Modelo que gestiona las observaciones especificas de los activos.
 *  
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_AOB_ACTIVO_OBS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoObservacion implements Serializable, Auditable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	
	@Id
    @Column(name = "AOB_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoObservacionGenerator")
    @SequenceGenerator(name = "ActivoObservacionGenerator", sequenceName = "S_ACT_AOB_ACTIVO_OBS")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
    
	@ManyToOne
	@JoinColumn(name = "USU_ID")
	private Usuario usuario;
    
	@Column(name = "AOB_OBSERVACION")
	private String observacion;

	@Column(name = "AOB_FECHA")
	private Date fecha;
	
	
	
	
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

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

	public String getObservacion() {
		return observacion;
	}

	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}

	public Date getFecha() {
		return fecha;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha;
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
