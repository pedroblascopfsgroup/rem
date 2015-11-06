package es.capgemini.pfs.contrato.model;

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
 * Tipos de intervención de la personas en los contratos.
 */
@Entity
@Table(name = "DD_TIN_TIPO_INTERVENCION", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDTipoIntervencion implements Dictionary, Auditable {

    private static final long serialVersionUID = 1L;

    /*public static final String CODIGO_TITULAR = "Tit";
    public static final String CODIGO_AVALISTA = "03";
    public static final String CODIGO_AVALISTA_NO_SOLIDARIO = "04";
    public static final String CODIGO_AVALISTA_SUBSIDIARIO = "19";*/
    public static final String CODIGO_TITULAR_REGISTRAL = "205";

    @Id
    @Column(name = "DD_TIN_ID")
    private Long id;

    @Column(name = "DD_TIN_CODIGO")
    private String codigo;
    @Column(name = "DD_TIN_TITULAR")
    private Boolean titular;
    @Column(name = "DD_TIN_AVALISTA")
    private Boolean avalista;
    @Column(name = "DD_TIN_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TIN_DESCRIPCION_LARGA")
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
     * @param version
     *            the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

	/**
	 * @return the titular
	 */
	public Boolean getTitular() {
		return titular;
	}

	/**
	 * @param titular the titular to set
	 */
	public void setTitular(Boolean titular) {
		this.titular = titular;
	}

	/**
	 * @return the avalista
	 */
	public Boolean getAvalista() {
		return avalista;
	}

	/**
	 * @param avalista the avalista to set
	 */
	public void setAvalista(Boolean avalista) {
		this.avalista = avalista;
	}
}
