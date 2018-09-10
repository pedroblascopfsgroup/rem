package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.gestorEntidad.model.GestorEntidad;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Modelo que gestiona la relacion de un gestor con su director de equipo.
 * 
 * @author Juanjo Arbona
 */
@Entity
@Table(name = "DUS_DIRECTOR_USUARIO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@PrimaryKeyJoinColumn(name="dus")
public class Directorusuario extends GestorEntidad implements Serializable {

	private static final long serialVersionUID = 7594603536051797805L;

	@Id
    @Column(name = "DUS_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DirectorGenerator")
    @SequenceGenerator(name = "DirectorGenerator", sequenceName = "S_DUS_DIRECTOR_USUARIO")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name = "USU_ID")
	private Usuario gestor;

	@ManyToOne
	@JoinColumn(name = "USU_DIR_ID")
	private Usuario directorEquipo;
	
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

	public Usuario getGestor() {
		return gestor;
	}

	public void setGestor(Usuario gestor) {
		this.gestor = gestor;
	}

	public Usuario getDirectorEquipo() {
		return directorEquipo;
	}

	public void setDirectorEquipo(Usuario directorEquipo) {
		this.directorEquipo = directorEquipo;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}