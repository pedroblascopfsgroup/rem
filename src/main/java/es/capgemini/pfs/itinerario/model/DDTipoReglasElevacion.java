package es.capgemini.pfs.itinerario.model;

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
 * Define un tipo de reglas de elevacion.
 *
 * @author pjimenez
 */
@Entity
@Table(name = "DD_TRE_TIPO_REGLAS_ELEVACION", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDTipoReglasElevacion implements Dictionary, Auditable {

    private static final long serialVersionUID = 1L;

    public static final String MARCADO_POLITICAS = "POLITICA";
    public static final String MARCADO_GESTION_SINTESIS_ANALISIS = "GESTION_SINTESIS";
    public static final String MARCADO_SOLVENCIA = "SOLVENCIA";
    public static final String MARCADO_ANTECEDENTES = "ANTECEDENTES";
    public static final String MARCADO_GESTION_ANALISIS = "GESTION_ANALISIS";
    public static final String MARCADO_DOCUMENTOS = "DOCUMENTOS";

    @Id
    @Column(name = "DD_TRE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoReglasElevacion")
    @SequenceGenerator(name = "DDTipoReglasElevacion", sequenceName = "${master.schema}.S_DD_TRE_TIPO_REGLAS_ELEVACION")
    private Long id;

    @Column(name = "DD_TRE_CODIGO")
    private String codigo;

    @Column(name = "DD_TRE_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TRE_DESCRIPCION_LARGA")
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
     * Retorna el atributo auditoria.
     * @return auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * Setea el atributo auditoria.
     * @param auditoria Auditoria
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * Retorna el atributo version.
     * @return version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * Setea el atributo version.
     * @param version Integer
     */
    public void setVersion(Integer version) {
        this.version = version;
    }
}
