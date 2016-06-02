package es.capgemini.pfs.users.domain;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;
import org.hibernate.annotations.WhereJoinTable;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.comite.model.PuestosComite;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Model de Perfil.
 *
 * @author Juan Pablo Bosnjak
 */
@Entity
@Table(name = "pef_perfiles", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Perfil implements Dictionary, Auditable {

    private static final long serialVersionUID = 1446031467303826093L;

    @Id
    @Column(name = "PEF_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "PerfilGenerator")
    @SequenceGenerator(name = "PerfilGenerator", sequenceName = "S_PEF_PERFILES")
    private Long id;

    @Column(name = "PEF_CODIGO")
    private String codigo;

    @Column(name = "PEF_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Column(name = "PEF_DESCRIPCION")
    private String descripcion;

    @OneToMany(cascade = CascadeType.ALL)
    @JoinColumn(name = "PEF_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<FuncionPerfil> funcionesPerfil;

    @OneToMany(mappedBy = "perfil", cascade = CascadeType.ALL)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Set<PuestosComite> puestosComites;

    @OneToMany(cascade = CascadeType.ALL)
    @JoinTable(name = "ZON_PEF_USU", schema = "${entity.schema}", joinColumns = { @JoinColumn(name = "PEF_ID") }, inverseJoinColumns = @JoinColumn(name = "USU_ID"))
    @WhereJoinTable(clause = Auditoria.UNDELETED_RESTICTION)
    private Set<Usuario> usuarios = null;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the descripcionLarga
     */
    public String getDescripcionLarga() {
        return descripcionLarga;
    }

    /**
     * @param descripcionLarga the descripcionLarga to set
     */
    public void setDescripcionLarga(String descripcionLarga) {
        this.descripcionLarga = descripcionLarga;
    }

    /**
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * {@inheritDoc}
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * {@inheritDoc}
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

    /**
     * @return the funciones
     */
    public Set<Funcion> getFunciones() {
        Set<Funcion> funciones = new HashSet<Funcion>();

        for (FuncionPerfil fp : funcionesPerfil) {
            funciones.add(fp.getFuncion());
        }

        return funciones;
    }

    /**
     * @return the puestosComites
     */
    public Set<PuestosComite> getPuestosComites() {
        return puestosComites;
    }

    /**
     * @param puestosComites the puestosComites to set
     */
    public void setPuestosComites(Set<PuestosComite> puestosComites) {
        this.puestosComites = puestosComites;
    }

    /**
     * @return the usuarios
     */
    public Set<Usuario> getUsuarios() {
        return usuarios;
    }

    /**
     * @param usuarios the usuarios to set
     */
    public void setUsuarios(Set<Usuario> usuarios) {
        this.usuarios = usuarios;
    }

    /**
     * @return the codigo
     */
    public String getCodigo() {
        return codigo;
    }

    /**
     * @param codigo the codigo to set
     */
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    /**
     * @param funcionesPerfil the funcionesPerfil to set
     */
    public void setFuncionesPerfil(List<FuncionPerfil> funcionesPerfil) {
        this.funcionesPerfil = funcionesPerfil;
    }

    /**
     * @return the funcionesPerfil
     */
    public List<FuncionPerfil> getFuncionesPerfil() {
        return funcionesPerfil;
    }

    /* (non-Javadoc)
     * @see java.lang.Object#equals(java.lang.Object)
     */
    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof Perfil)) return false;
        return getId().equals(((Perfil) obj).getId()) ? true : false;
    }
}
