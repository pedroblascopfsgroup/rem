package es.capgemini.pfs.politica.model;


import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Diccionario de datos de los estados de cumplimiento que puede tener un objetivo.
 * @author Andrés Esteban
 */
@Entity
@Table(name = "DD_ESC_ESTADO_CUMPLIMIENTO", schema = "${master.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDEstadoCumplimiento implements Auditable, Dictionary {

    private static final long serialVersionUID = 3286878558375331183L;

    public static final String ESTADO_CANCELADO = "CANC";
    public static final String ESTADO_PENDIENTE = "PEND";
    public static final String ESTADO_CUMPLIDO = "CUMP";
    public static final String ESTADO_INCUMPLIDO = "INCU";
    public static final String ESTADO_JUSTIFICADO = "JUST";

    @Id
    @Column(name = "DD_ESC_ID")
    private Long id;

    @Column(name = "DD_ESC_CODIGO")
    private String codigo;

    @Column(name = "DD_ESC_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_ESC_DESCRIPCION_LARGA")
    private String descripcionLarga;

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

}
