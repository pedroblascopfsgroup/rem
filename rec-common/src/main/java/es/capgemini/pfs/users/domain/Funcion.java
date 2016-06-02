package es.capgemini.pfs.users.domain;

import java.io.Serializable;

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

import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Model de Funcion.
 *
 * @author Nicolás Cornaglia
 */
@Entity
@Table(name = "fun_funciones", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class Funcion implements Serializable {

    private static final long serialVersionUID = 1L;
    public static final String FUNCION_POLITICA_SUPERUSUARIO = "POLITICA_SUPER";
    public static final String FUNCION_SOLO_VER_TAREAS_PROPIAS = "VER_SOLO_TAREAS_PROPIAS";

    @Id
    @Column(name = "FUN_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "FuncionGenerator")
    @SequenceGenerator(name = "FuncionGenerator", sequenceName = "${master.schema}.S_FUN_FUNCIONES")
    private Long id;

    @Column(name = "FUN_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Column(name = "FUN_DESCRIPCION")
    private String descripcion;

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
