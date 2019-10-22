package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;

@Entity
@Table(name = "CAG_CONFIG_ACCESO_GESTORIAS", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class ConfiguracionAccesoGestoria implements Serializable, Auditable {

	private static final long serialVersionUID = 4477763412715784465L;

	@Id
    @Column(name = "CAG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfAccesoGestoriaGenerator")
    @SequenceGenerator(name = "ConfAccesoGestoriaGenerator", sequenceName = "S_CAG_CONFIG_ACCESO_GESTORIAS")
    private Long id;
	
    @Column(name = "CAG_NOMBRE_GESTORIA")
    private String nombreGestoria;
    

    @OneToOne
    @JoinColumn(name="CAG_USU_GRUPO_ADMISION", referencedColumnName="USU_ID")
    private Usuario usuarioGrupoAdmision;
    
	@Column(name = "CAG_USU_USERNAME_ADMISION")
	private String usernameGestoriaAdmision;

    @OneToOne
    @JoinColumn(name="CAG_USU_GRUPO_ADMINISTRACION", referencedColumnName="USU_ID")
    private Usuario usuarioGrupoAdministracion;
    
	@Column(name = "CAG_USU_USERNAME_ADMINISTRACION")
	private String usernameGestoriaAdministracion;


    @OneToOne
    @JoinColumn(name="CAG_USU_GRUPO_FORMALIZACION", referencedColumnName="USU_ID")
    private Usuario usuarioGrupoFormalizacion;
    
	@Column(name = "CAG_USU_USERNAME_FORMALIZACION")
	private String usernameGestoriaFormalizacion;

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

	public String getNombreGestoria() {
		return nombreGestoria;
	}

	public void setNombreGestoria(String nombreGestoria) {
		this.nombreGestoria = nombreGestoria;
	}

	public Usuario getUsuarioGrupoAdmision() {
		return usuarioGrupoAdmision;
	}

	public void setUsuarioGrupoAdmision(Usuario usuarioGrupoAdmision) {
		this.usuarioGrupoAdmision = usuarioGrupoAdmision;
	}

	public String getUsernameGestoriaAdmision() {
		return usernameGestoriaAdmision;
	}

	public void setUsernameGestoriaAdmision(String usernameGestoriaAdmision) {
		this.usernameGestoriaAdmision = usernameGestoriaAdmision;
	}

	public Usuario getUsuarioGrupoAdministracion() {
		return usuarioGrupoAdministracion;
	}

	public void setUsuarioGrupoAdministracion(Usuario usuarioGrupoAdministracion) {
		this.usuarioGrupoAdministracion = usuarioGrupoAdministracion;
	}

	public String getUsernameGestoriaAdministracion() {
		return usernameGestoriaAdministracion;
	}

	public void setUsernameGestoriaAdministracion(String usernameGestoriaAdministracion) {
		this.usernameGestoriaAdministracion = usernameGestoriaAdministracion;
	}

	public Usuario getUsuarioGrupoFormalizacion() {
		return usuarioGrupoFormalizacion;
	}

	public void setUsuarioGrupoFormalizacion(Usuario usuarioGrupoFormalizacion) {
		this.usuarioGrupoFormalizacion = usuarioGrupoFormalizacion;
	}

	public String getUsernameGestoriaFormalizacion() {
		return usernameGestoriaFormalizacion;
	}

	public void setUsernameGestoriaFormalizacion(String usernameGestoriaFormalizacion) {
		this.usernameGestoriaFormalizacion = usernameGestoriaFormalizacion;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
