package es.capgemini.pfs.actitudAptitudActuacion.model;

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
 * Clase que representa al un tipo de ayuda actuación.
 * @author pamuller
 *
 */
@Entity
@Table(name = "DD_TAA_TIPO_AYUDA_ACTUACION", schema = "${entity.schema}")
public class DDTipoAyudaActuacion implements Auditable, Dictionary {

    private static final long serialVersionUID = -825222614850629228L;

    @Id
    @Column(name = "DD_TAA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoAyudaActuacionGenerator")
    @SequenceGenerator(name = "DDTipoAyudaActuacionGenerator", sequenceName = "S_DD_TAA_TIP_AYUDA_ACT")
    private Long id;

    @Column(name = "DD_TAA_CODIGO")
    private String codigo;

    @Column(name = "DD_TAA_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TAA_DESCRIPCION_LARGA")
    private String descripcionLarga;

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

}
