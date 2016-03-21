package es.capgemini.pfs.tareaNotificacion.model;

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
 * Clase que representa a un tipo de entidad.
 * @author pamuller
 *
 */
@Entity
@Table(name = "dd_ein_entidad_informacion", schema = "${master.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDTipoEntidad implements Dictionary, Auditable {

    public static final String CODIGO_ENTIDAD_CLIENTE = "1";
   
    public static final String CODIGO_ENTIDAD_TAREA = "4";
    public static final String CODIGO_ENTIDAD_ASUNTO = "3";
    public static final String CODIGO_ENTIDAD_EXPEDIENTE = "2";
    public static final String CODIGO_ENTIDAD_PROCEDIMIENTO = "5";
    public static final String CODIGO_ENTIDAD_CONTRATO = "6";
    public static final String CODIGO_ENTIDAD_OBJETIVO = "7";
    public static final String CODIGO_ENTIDAD_NOTIFICACION = "10";
    public static final String CODIGO_ENTIDAD_PERSONA = "9";

    /**
     * serial.
     */
    private static final long serialVersionUID = -4737933835175794252L;

    @Id
    @Column(name = "DD_EIN_ID")
    private Long id;
    @Column(name = "DD_EIN_CODIGO")
    private String codigo;
    @Column(name = "DD_EIN_DESCRIPCION")
    private String descripcion;
    @Column(name = "DD_EIN_DESCRIPCION_LARGA")
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
