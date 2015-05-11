package es.capgemini.pfs.alerta.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Tipos de alertas.
 */
@Entity
@Table(name = "TAL_TIPO_ALERTA", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class TipoAlerta implements Serializable, Auditable {

    private static final long serialVersionUID = -619953681126956466L;

    @Id
    @Column(name = "TAL_ID")
    private Long id;

    @Column(name = "TAL_CODIGO")
    private String codigo;

    @ManyToOne
    @JoinColumn(name = "GAL_ID")
    private GrupoAlerta grupoAlerta;

    @ManyToOne
    @JoinColumn(name = "GRC_ID")
    private GrupoCarga grupoCarga;

    @Column(name = "TAL_DESCRIPCION")
    private String descripcion;

    @Column(name = "TAL_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Column(name = "TAL_PLAZO_VISIBILIDAD")
    private Long plazoVisibilidad;

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
     * @return the grupoAlerta
     */
    public GrupoAlerta getGrupoAlerta() {
        return grupoAlerta;
    }

    /**
     * @param grupoAlerta the grupoAlerta to set
     */
    public void setGrupoAlerta(GrupoAlerta grupoAlerta) {
        this.grupoAlerta = grupoAlerta;
    }

    /**
     * @return the grupoCarga
     */
    public GrupoCarga getGrupoCarga() {
        return grupoCarga;
    }

    /**
     * @param grupoCarga the grupoCarga to set
     */
    public void setGrupoCarga(GrupoCarga grupoCarga) {
        this.grupoCarga = grupoCarga;
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
     * @return the serialVersionUID
     */
    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    /**
     * @return the plazoVisibilidad
     */
    public Long getPlazoVisibilidad() {
        return plazoVisibilidad;
    }

    /**
     * @param plazoVisibilidad the plazoVisibilidad to set
     */
    public void setPlazoVisibilidad(Long plazoVisibilidad) {
        this.plazoVisibilidad = plazoVisibilidad;
    }
}
