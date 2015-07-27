package es.capgemini.pfs.direccion.model;


import javax.persistence.Column;
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
 * Clase que representa un tipo de via.
 * @author pamuller
 *
 */
@Entity
@Table(name = "DD_TVI_TIPO_VIA", schema = "${master.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDTipoVia implements Auditable, Dictionary  {

    private static final long serialVersionUID = 7040011404300088295L;

    @Id
    @Column(name = "DD_TVI_ID")
    private Long id;

    @Column(name = "DD_TVI_CODIGO")
    private String codigo;

    @Column(name = "DD_TVI_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TVI_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Column(name = "DD_TVI_CODIGO_UVEM")
    private String codigoUvem;

	@Version
    private Integer version;

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

    public String getCodigoUvem() {
		return codigoUvem;
	}

	public void setCodigoUvem(String codigoUvem) {
		this.codigoUvem = codigoUvem;
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
