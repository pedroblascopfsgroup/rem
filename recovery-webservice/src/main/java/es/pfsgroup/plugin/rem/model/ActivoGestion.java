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
import es.pfsgroup.plugin.rem.model.dd.DDEstadoLocalizacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubestadoGestion;



/**
 * Modelo que gestiona los datos de activo gestion
 * 
 * @author Bender
 */
@Entity
@Table(name = "ACT_AGE_ACTIVO_GESTION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoGestion implements Serializable, Auditable {

	
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "AGE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoGestionGenerator")
    @SequenceGenerator(name = "ActivoGestionGenerator", sequenceName = "S_ACT_AGE_ACTIVO_GESTION")
    private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ELO_ID")
    private DDEstadoLocalizacion estadoLocalizacion;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SEG_ID")
    private DDSubestadoGestion subestadoGestion;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USU_ID")
	Usuario usuario;
	
	@Column(name = "AGE_FECHA_INICIO")
    private Date fechaInicio;
	
	@Column(name = "AGE_FECHA_FIN")
    private Date fechaFin;
	
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

	public DDEstadoLocalizacion getEstadoLocalizacion() {
		return estadoLocalizacion;
	}

	public void setEstadoLocalizacion(DDEstadoLocalizacion estadoLocalizacion) {
		this.estadoLocalizacion = estadoLocalizacion;
	}

	public DDSubestadoGestion getSubestadoGestion() {
		return subestadoGestion;
	}

	public void setSubestadoGestion(DDSubestadoGestion subestadoGestion) {
		this.subestadoGestion = subestadoGestion;
	}

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
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
