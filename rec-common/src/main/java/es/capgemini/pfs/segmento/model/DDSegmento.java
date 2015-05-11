package es.capgemini.pfs.segmento.model;

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
 * Entidad Segmento.
 * @author Lisandro Medrano
 *
 */
@Entity
@Table(name = "DD_SCL_SEGTO_CLI", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDSegmento implements Dictionary, Auditable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "DD_SCL_ID")
    private Long id;

    @Column(name = "DD_SCL_CODIGO")
    private String codigo;

    @Column(name = "DD_SCL_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_SCL_DESCRIPCION_LARGA")
	private String descripcionLarga;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;



    /**
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        return this.descripcion;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version
     *            the version to set
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
     * @param descripcion the descripcion to set
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
    * Devuelve el codigo.
    * @return el codigo
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

}
