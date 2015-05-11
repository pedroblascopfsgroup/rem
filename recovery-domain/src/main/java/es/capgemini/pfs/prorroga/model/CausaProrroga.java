package es.capgemini.pfs.prorroga.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Entidad de la tabla DD_CPR_CAUSA_PRORROGA.
 * @author jbosnjak
 *
 */
@Entity
@Table(name = "DD_CPR_CAUSA_PRORROGA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class CausaProrroga implements Serializable, Auditable {

    /**
     * serialVersionUID.
     */
    private static final long serialVersionUID = 9068319087880716598L;

    @Id
    @Column(name = "DD_CPR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CausaProrrogaGenerator")
    @SequenceGenerator(name = "CausaProrrogaGenerator", sequenceName = "S_DD_CPR_CAUSA_PRORROGA")
    private Long id;

    @Column(name = "DD_CPR_CODIGO")
    private String codigo;

    @Column(name = "DD_CPR_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_CPR_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @OneToOne(targetEntity = DDTipoProrroga.class)
    @JoinColumn(name = "DD_TPR_ID")
    private DDTipoProrroga tipoProrroga;

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
     * @param tipoProrroga the tipoProrroga to set
     */
    public void setTipoProrroga(DDTipoProrroga tipoProrroga) {
        this.tipoProrroga = tipoProrroga;
    }

    /**
     * @return the tipoProrroga
     */
    public DDTipoProrroga getTipoProrroga() {
        return tipoProrroga;
    }
}
