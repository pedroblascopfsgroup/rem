package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;
import javax.validation.constraints.NotNull;

import org.apache.commons.lang.builder.ReflectionToStringBuilder;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Hibernate;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;
import org.hibernate.validator.constraints.Length;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.ZonaUsuarioPerfil;


@Entity
@Table(name = "GRU_GRUPOS_USUARIOS", schema = "${master.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class GrupoUsuario implements Serializable{
    private static final long serialVersionUID = 1L;
    
    public static final String GRUPO_MANZANA = "gruproman";

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
