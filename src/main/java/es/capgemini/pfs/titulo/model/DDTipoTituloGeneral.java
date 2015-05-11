package es.capgemini.pfs.titulo.model;

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
 * Clase que representa la entidad tipo titulo generales, es decir tipos de tipos de titulo.
 */

@Entity
@Table(name = "DD_TTG_TIPO_TIT_GEN", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDTipoTituloGeneral implements Dictionary, Auditable {

    private static final long serialVersionUID = -6637787816506547316L;

    @Id
    @Column(name = "DD_TTG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoTituloGeneralGenerator")
    @SequenceGenerator(name = "DDTipoTituloGeneralGenerator", sequenceName = "S_DD_TTG_TIPO_TIT_GEN")
    private Long id;

    @Column(name = "DD_TTG_CODIGO")
    private String codigo;

    @Column(name = "DD_TTG_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TTG_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * Retorna el atributo id.
     * @return id
     */
    public Long getId() {
        return id;
    }

    /**
     * Setea el atributo id.
     * @param id Long
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * Retorna el atributo codigo.
     * @return codigo
     */
    public String getCodigo() {
        return codigo;
    }

    /**
     * Setea el atributo codigo.
     * @param codigo String
     */
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    /**
     * Retorna el atributo descripcion.
     * @return descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * Setea el atributo descripcion.
     * @param descripcion String
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * Retorna el atributo descripcionLarga.
     * @return descripcionLarga
     */
    public String getDescripcionLarga() {
        return descripcionLarga;
    }

    /**
     * Setea el atributo descripcionLarga.
     * @param descripcionLarga String
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
