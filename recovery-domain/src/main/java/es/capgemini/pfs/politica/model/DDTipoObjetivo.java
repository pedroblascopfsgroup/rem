package es.capgemini.pfs.politica.model;


import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Diccionario de los tipos de objetivos.
 * @author Andrés Esteban
  */
@Entity
@Table(name = "TOB_TIPO_OBJETIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class DDTipoObjetivo implements Dictionary, Auditable {

    private static final long serialVersionUID = 1874444097813176638L;

    @Id
    @Column(name = "TOB_ID")
    private Long id;

    @Column(name = "TOB_CODIGO")
    private String codigo;

    @Column(name = "TOB_DESCRIPCION")
    private String descripcion;

    @Column(name = "TOB_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Column(name = "TOB_AUTOMATICO")
    private Boolean automatico;

    @ManyToOne
    @JoinColumn(name = "CDO_ID")
    private DDCampoDestinoObjetivo campoDestino;

    @Column(name = "TOB_CONTRATO")
    private Boolean contrato;

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
     * @return the automatico
     */
    public Boolean getAutomatico() {
        return automatico;
    }

    /**
     * @param automatico the automatico to set
     */
    public void setAutomatico(Boolean automatico) {
        this.automatico = automatico;
    }

    /**
     * @return <code>true</code> si el objetivo es de tipo contrato,
     * <code>false</code>: el objetivo es de tipo persona
     */
    public Boolean getContrato() {
        return contrato;
    }

    /**
     * @param contrato the contrato to set
     */
    public void setContrato(Boolean contrato) {
        this.contrato = contrato;
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

    /**
     * @return the campoDestino
     */
    public DDCampoDestinoObjetivo getCampoDestino() {
        return campoDestino;
    }

    /**
     * @param campoDestino the campoDestino to set
     */
    public void setCampoDestino(DDCampoDestinoObjetivo campoDestino) {
        this.campoDestino = campoDestino;
    }
}
