package es.capgemini.pfs.zona.model;

import java.io.Serializable;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * clase modelo de zona_pef_usu.
 *
 * @author jbosnjak
 *
 */
@Entity
@Table(name = "ZON_PEF_USU", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ZonaUsuarioPerfil implements Serializable, Auditable {

    private static final long serialVersionUID = -7110519259093871099L;

    @Id
    @Column(name = "ZPU_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ZonaUsuarioPerfilGenerator")
    @SequenceGenerator(name = "ZonaUsuarioPerfilGenerator", sequenceName = "S_ZON_PEF_USU")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "USU_ID")
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "PEF_ID")
    private Perfil perfil;

    @ManyToOne
    @JoinColumn(name = "ZON_ID")
    private DDZona zona;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @return the usuario
     */
    public Usuario getUsuario() {
        return usuario;
    }

    /**
     * @param usuario the usuario to set
     */
    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    /**
     * @return the perfil
     */
    public Perfil getPerfil() {
        return perfil;
    }

    /**
     * @param perfil the perfil to set
     */
    public void setPerfil(Perfil perfil) {
        this.perfil = perfil;
    }

    /**
     * @return the zona
     */
    public DDZona getZona() {
        return zona;
    }

    /**
     * @param zona the zona to set
     */
    public void setZona(DDZona zona) {
        this.zona = zona;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

}
