package es.pfsgroup.recovery.ext.impl.multigestor.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.ext.api.multigestor.model.EXTGrupoUsuariosInfo;

/**
 * Clase que muestra los usuarios y los grupos a los que pertenecen
 * @author Diana
 *
 */

@Entity
@Table(name = "GRU_GRUPOS_USUARIOS", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class EXTGrupoUsuarios implements Serializable, Auditable, EXTGrupoUsuariosInfo {
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 2095862929644946805L;

	@Id
    @Column(name = "GRU_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "GrupoUsuarioGenerator")
    @SequenceGenerator(name = "GrupoUsuarioGenerator", sequenceName = "${master.schema}.S_GRU_GRUPOS_USUARIOS")
    private Long id;
	
	@JoinColumn(name = "USU_ID_GRUPO")
    @ManyToOne(fetch = FetchType.EAGER)
	private Usuario grupo;
	
	@JoinColumn(name = "USU_ID_USUARIO")
    @ManyToOne(fetch = FetchType.EAGER)
	private Usuario usuario;
	
	@Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Usuario getGrupo() {
		return grupo;
	}

	public void setGrupo(Usuario grupo) {
		this.grupo = grupo;
	}

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}
    
    


}
