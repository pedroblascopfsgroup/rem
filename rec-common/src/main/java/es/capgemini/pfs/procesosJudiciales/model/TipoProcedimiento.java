package es.capgemini.pfs.procesosJudiciales.model;

import java.io.Serializable;

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

import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Clase que representa la entidad TPO_TIPO_PROCEDIMIENTO.
 * @author jpbosnjak
 *
 */
@Entity
@Table(name = "DD_TPO_TIPO_PROCEDIMIENTO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class TipoProcedimiento implements Serializable, Auditable {

    /**
     * serialVersionUID.
     */
    private static final long serialVersionUID = -8961132998182577279L;

    public static final String TIPO_PRECONTENCIOSO = "PCO";    
    
    @Id
    @Column(name = "DD_TPO_ID")
    private Long id;

    @Column(name = "DD_TPO_CODIGO")
    private String codigo;

    @Column(name = "DD_TPO_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TPO_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Column(name = "DD_TPO_HTML")
    private String html;

    @Column(name = "DD_TPO_XML_JBPM")
    private String xmlJbpm;

    @ManyToOne
    @JoinColumn(name = "DD_TAC_ID")
    private DDTipoActuacion tipoActuacion;

    @Column(name = "DD_TPO_SALDO_MIN")
    private Float saldoMinimo;

    @Column(name = "DD_TPO_SALDO_MAX")
    private Float saldoMaximo;
    
    @Column(name = "FLAG_DERIVABLE")
    private Boolean isDerivable;
    
    @Column(name = "FLAG_UNICO_BIEN")
    private Boolean isUnicoBien;

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

    /**
     * @return the xmlJbpm
     */
    public String getXmlJbpm() {
        return xmlJbpm;
    }

    /**
     * @param xmlJbpm the xmlJbpm to set
     */
    public void setXmlJbpm(String xmlJbpm) {
        this.xmlJbpm = xmlJbpm;
    }

    /**
     * @return the html
     */
    public String getHtml() {
        return html;
    }

    /**
     * @param html the html to set
     */
    public void setHtml(String html) {
        this.html = html;
    }

    /**
     * @return the tipoActuacion
     */
    public DDTipoActuacion getTipoActuacion() {
        return tipoActuacion;
    }

    /**
     * @param tipoActuacion the tipoActuacion to set
     */
    public void setTipoActuacion(DDTipoActuacion tipoActuacion) {
        this.tipoActuacion = tipoActuacion;
    }

    /**
     * @return the saldoMinimo
     */
    public Float getSaldoMinimo() {
        return saldoMinimo;
    }

    /**
     * @param saldoMinimo the saldoMinimo to set
     */
    public void setSaldoMinimo(Float saldoMinimo) {
        this.saldoMinimo = saldoMinimo;
    }

    /**
     * @return the saldoMaximo
     */
    public Float getSaldoMaximo() {
        return saldoMaximo;
    }

    /**
     * @param saldoMaximo the saldoMaximo to set
     */
    public void setSaldoMaximo(Float saldoMaximo) {
        this.saldoMaximo = saldoMaximo;
    }
    
	public Boolean getIsDerivable() {
		return isDerivable;
	}

	public void setIsDerivable(Boolean isDerivable) {
		this.isDerivable = isDerivable;
	}

	public Boolean getIsUnicoBien() {
		return isUnicoBien;
	}

	public void setIsUnicoBien(Boolean isUnicoBien) {
		this.isUnicoBien = isUnicoBien;
	}
	
}
