package es.capgemini.pfs.subfase.model;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Entidad fase.
 * @author Andrés Esteban
 */
@Entity
@Table(name = "DD_FMG_FASES_MAPA_GLOBAL", schema = "${master.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDFase implements Dictionary, Auditable {

    private static final long serialVersionUID = 1L;

    public static final String FASE_NORMAL = "NORMAL";
    public static final String FASE_PRIMARIA = "PRIMARIA";
    public static final String FASE_INTERNA = "INTERNA";
    public static final String FASE_EXTERNA = "EXTERNA";

    @Id
    @Column(name = "DD_FMG_ID")
    private Long id;

    @Column(name = "DD_FMG_CODIGO")
    private String codigo;

    @Column(name = "DD_FMG_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_FMG_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @OneToMany(mappedBy = "fase", fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<Subfase> subfases;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

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
     * @return the subfases
     */
    public List<Subfase> getSubfases() {
        return subfases;
    }

    /**
     * @param subfases the subfases to set
     */
    public void setSubfases(List<Subfase> subfases) {
        this.subfases = subfases;
    }
}
