package es.capgemini.pfs.analisisExterna.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Mapeo de la tabla de tipos de plazos de aceptación 
 * @author pajimene
 *
 */
@Entity
@Table(name = "DD_CAE_CRIT_ANALISIS_EXT", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class DDCriterioAnalisisExterna implements Auditable, Dictionary {

    private static final long serialVersionUID = 1L;

    public static final String CODIGO_TIPO_PROCEDIMIENTO = "tproc";
    public static final String CODIGO_DESPACHO = "despacho";
    public static final String CODIGO_SUPERVISOR = "supervis";
    public static final String CODIGO_GESTOR = "gestor";
    public static final String CODIGO_FASE_PROCESAL = "fase";

    @Id
    @Column(name = "DD_CAE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDCriterioAnalisisExternaGenerator")
    @SequenceGenerator(name = "DDCriterioAnalisisExternaGenerator", sequenceName = "${master.schema}.S_DD_CAE_CRIT_ANALISIS_EXT")
    private Long id;

    @Column(name = "DD_CAE_CODIGO")
    private String codigo;

    @Column(name = "DD_CAE_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_CAE_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Version
    private Long version;

    @Embedded
    private Auditoria auditoria;

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param codigo the codigo to set
     */
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    /**
     * @return the codigo
     */
    public String getCodigo() {
        return codigo;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcionLarga the descripcionLarga to set
     */
    public void setDescripcionLarga(String descripcionLarga) {
        this.descripcionLarga = descripcionLarga;
    }

    /**
     * @return the descripcionLarga
     */
    public String getDescripcionLarga() {
        return descripcionLarga;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Long version) {
        this.version = version;
    }

    /**
     * @return the version
     */
    public Long getVersion() {
        return version;
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
