package es.capgemini.pfs.alerta.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.Persona;

/**
 * Entidad Alertas.
 * @author Andrés Esteban
 *
 */
@Entity
@Table(name = "ALE_ALERTAS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class Alerta implements Serializable, Auditable {

    private static final long serialVersionUID = -1720925594973372705L;

    @Id
    @Column(name = "ALE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AlertaGenerator")
    @SequenceGenerator(name = "AlertaGenerator", sequenceName = "S_ALE_ALERTAS")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PER_ID")
    private Persona persona;

    @OneToOne
    @JoinColumn(name = "TAL_ID")
    private TipoAlerta tipoAlerta;

    @OneToOne
    @JoinColumn(name = "NGR_ID")
    private NivelGravedad nivelGravedad;

    @Column(name = "ALE_FECHA_EXTRACCION")
    private Date fechaExtraccion;

    @Column(name = "ALE_FECHA_CARGA")
    private Date fechaCarga;

    @Column(name = "ALE_FICHERO_CARGA")
    private String ficheroCarga;

    @Column(name = "ALE_ACTIVO")
    private boolean activo;

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
     * @return the persona
     */
    public Persona getPersona() {
        return persona;
    }

    /**
     * @param persona the persona to set
     */
    public void setPersona(Persona persona) {
        this.persona = persona;
    }

    /**
     * @return the tipoAlerta
     */
    public TipoAlerta getTipoAlerta() {
        return tipoAlerta;
    }

    /**
     * @param tipoAlerta the tipoAlerta to set
     */
    public void setTipoAlerta(TipoAlerta tipoAlerta) {
        this.tipoAlerta = tipoAlerta;
    }

    /**
     * @return the nivelGravedad
     */
    public NivelGravedad getNivelGravedad() {
        return nivelGravedad;
    }

    /**
     * @param nivelGravedad the nivelGravedad to set
     */
    public void setNivelGravedad(NivelGravedad nivelGravedad) {
        this.nivelGravedad = nivelGravedad;
    }

    /**
     * @return the fechaExtraccion
     */
    public Date getFechaExtraccion() {
        return fechaExtraccion;
    }

    /**
     * @param fechaExtraccion the fechaExtraccion to set
     */
    public void setFechaExtraccion(Date fechaExtraccion) {
        this.fechaExtraccion = fechaExtraccion;
    }

    /**
     * @return the fechaCarga
     */
    public Date getFechaCarga() {
        return fechaCarga;
    }

    /**
     * @param fechaCarga the fechaCarga to set
     */
    public void setFechaCarga(Date fechaCarga) {
        this.fechaCarga = fechaCarga;
    }

    /**
     * @return the ficheroCarga
     */
    public String getFicheroCarga() {
        return ficheroCarga;
    }

    /**
     * @param ficheroCarga the ficheroCarga to set
     */
    public void setFicheroCarga(String ficheroCarga) {
        this.ficheroCarga = ficheroCarga;
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

    /**
     * @return the activo
     */
    public boolean isActivo() {
        return activo;
    }

    /**
     * @param activo the activo to set
     */
    public void setActivo(boolean activo) {
        this.activo = activo;
    }
}
