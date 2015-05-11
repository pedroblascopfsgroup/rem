package es.capgemini.pfs.despachoExterno.model;

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
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Clase que mapea la realci�n entre Usuario y DespachoExterno.
 * @author pamuller
 *
 */
@Entity
@Table(name = "usd_usuarios_despachos", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class GestorDespacho implements Serializable, Auditable {

    private static final long serialVersionUID = 2046380682420896252L;

    @Id
    @Column(name = "USD_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "GestorDespachoGenerator")
    @SequenceGenerator(name = "GestorDespachoGenerator", sequenceName = "S_USD_USUARIOS_DESPACHOS")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "USU_ID")
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "DES_ID")
    private DespachoExterno despachoExterno;

    @Column(name = "USD_GESTOR_DEFECTO")
    private Boolean gestorPorDefecto;

    @Column(name = "USD_SUPERVISOR")
    private Boolean supervisor;

    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;

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
     * @return the despachoExterno
     */
    public DespachoExterno getDespachoExterno() {
        return despachoExterno;
    }

    /**
     * @param despachoExterno the despachoExterno to set
     */
    public void setDespachoExterno(DespachoExterno despachoExterno) {
        this.despachoExterno = despachoExterno;
    }

    /**
     * @return the gestorPorDefecto
     */
    public Boolean getGestorPorDefecto() {
        return gestorPorDefecto;
    }

    /**
     * @param gestorPorDefecto the gestorPorDefecto to set
     */
    public void setGestorPorDefecto(Boolean gestorPorDefecto) {
        this.gestorPorDefecto = gestorPorDefecto;
    }

    /**
     * @return the supervisor
     */
    public Boolean getSupervisor() {
        return supervisor;
    }

    /**
     * @param supervisor the supervisor to set
     */
    public void setSupervisor(Boolean supervisor) {
        this.supervisor = supervisor;
    }

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
}
