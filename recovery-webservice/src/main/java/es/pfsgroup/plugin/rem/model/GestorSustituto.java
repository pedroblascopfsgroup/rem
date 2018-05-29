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
import es.capgemini.pfs.users.domain.Usuario;

@Entity
@Table(name = "SGS_GESTOR_SUSTITUTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class GestorSustituto implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "SGS_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "GestorSustitutoGenerator")
    @SequenceGenerator(name = "GestorSustitutoGenerator", sequenceName = "S_SGS_GESTOR_SUSTITUTO")
    private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USU_ID_ORI", referencedColumnName="USU_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Usuario usuarioGestorOriginal;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USU_ID_SUS", referencedColumnName="USU_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Usuario usuarioGestorSustituto;
    
    @Column(name = "FECHA_INICIO")
    private Date fechaInicio;
    
    @Column(name = "FECHA_FIN")
    private Date fechaFin;

    @Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Usuario getUsuarioGestorOriginal() {
		return usuarioGestorOriginal;
	}

	public void setUsuarioGestorOriginal(Usuario usuarioGestorOriginal) {
		this.usuarioGestorOriginal = usuarioGestorOriginal;
	}

	public Usuario getUsuarioGestorSustituto() {
		return usuarioGestorSustituto;
	}

	public void setUsuarioGestorSustituto(Usuario usuarioGestorSustituto) {
		this.usuarioGestorSustituto = usuarioGestorSustituto;
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
    
}
