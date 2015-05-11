package es.capgemini.pfs.contrato.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo de DD_GCN_GARANTIA_CONTRATO.
 */
@Entity
@Table(name = "DD_GCN_GARANTIA_CONTRATO", schema = "${entity.schema}")
public class DDGarantiaContrato implements Auditable, Dictionary {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "DD_GCN_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDGarantiaContratoGenerator")
    @SequenceGenerator(name = "DDGarantiaContratoGenerator", sequenceName = "S_DD_GCN_GARANTIA_CONTRATO")
    private Long id;

    @Column(name = "DD_GCN_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_GCN_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Column(name = "DD_GCN_CODIGO")
    private String codigo;

    @Version
    private Long version;

    @Embedded
    private Auditoria auditoria;

    /**
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        return descripcion;
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
     * @return the version
     */
    public Long getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Long version) {
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
