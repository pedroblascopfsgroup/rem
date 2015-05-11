package es.capgemini.pfs.bien.model;

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
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Diccionario de tipos bienes.
 */
@Entity
@Table(name = "DD_TBI_TIPO_BIEN", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDTipoBien implements Dictionary, Auditable {

    private static final long serialVersionUID = 1L;

    public static final String CODIGO_TIPOBIEN_PISO = "1";
    public static final String CODIGO_TIPOBIEN_FINCA = "2";
    public static final String CODIGO_TIPOBIEN_COCHE = "3";
    public static final String CODIGO_TIPOBIEN_MOTO = "4";
    // Nuevos constantes de tipos se deben también agregar en el shared!!

    @Id
    @Column(name = "DD_TBI_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoBienGenerator")
    @SequenceGenerator(name = "DDTipoBienGenerator", sequenceName = "S_DD_TBI_TIPO_BIEN")
    private Long id;

    @Column(name = "DD_TBI_CODIGO")
    private String codigo;

    @Column(name = "DD_TBI_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TBI_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @OneToOne(mappedBy = "tipoBien")
    @JoinColumn(name = "DD_TBI_ID")
    private ConfiguracionMailTipoBien configuracionMailTipoBien;

    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;

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

    /**
     * @return the serialVersionUID
     */
    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        return this.descripcion;
    }

    /**
     * @return the configuracionMailTipoBien
     */
    public ConfiguracionMailTipoBien getConfiguracionMailTipoBien() {
        return configuracionMailTipoBien;
    }

    /**
     * @param configuracionMailTipoBien the configuracionMailTipoBien to set
     */
    public void setConfiguracionMailTipoBien(ConfiguracionMailTipoBien configuracionMailTipoBien) {
        this.configuracionMailTipoBien = configuracionMailTipoBien;
    }
}
