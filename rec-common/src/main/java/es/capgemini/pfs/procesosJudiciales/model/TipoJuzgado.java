package es.capgemini.pfs.procesosJudiciales.model;

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
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Clase que representa la entidad DD_JUZ_JUZGADOS_PLAZA.
 * @author marruiz
 *
 */
@Entity
@Table(name = "DD_JUZ_JUZGADOS_PLAZA", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class TipoJuzgado implements Serializable, Auditable, Dictionary {

    private static final long serialVersionUID = -8961132998182577279L;

    @Id
    @Column(name = "DD_JUZ_ID")
    private Long id;

    @Column(name = "DD_JUZ_CODIGO")
    private String codigo;

    @Column(name = "DD_JUZ_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_JUZ_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @ManyToOne
    @JoinColumn(name = "DD_PLA_ID")
    private TipoPlaza plaza;

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
     * @return the plaza
     */
    public TipoPlaza getPlaza() {
        return plaza;
    }

    /**
     * @param plaza the plaza to set
     */
    public void setPlaza(TipoPlaza plaza) {
        this.plaza = plaza;
    }
}
