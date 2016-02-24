package es.capgemini.pfs.contrato.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.Persona;

/**
 * Clase que representa las entradas de las tabla CPE_CONTRATOS_PERSONAS.
 */
@Entity
@Table(name = "CPE_CONTRATOS_PERSONAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ContratoPersona implements Serializable, Auditable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "CPE_ID")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "PER_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Persona persona;

    @ManyToOne
    @JoinColumn(name = "CNT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Contrato contrato;

    @OneToOne
    @JoinColumn(name = "DD_TIN_ID")
    private DDTipoIntervencion tipoIntervencion;

    @Column(name = "CPE_ORDEN")
    private Long orden;

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
     * @return the persona
     */
    public Persona getPersona() {
        return persona;
    }

    /**
     * @param persona the persona to set
     */
    public void setPersona(Persona persona) {
        this.persona = persona;
    }

    /**
     * @return the contrato
     */
    public Contrato getContrato() {
        return contrato;
    }

    /**
     * @param contrato the contrato to set
     */
    public void setContrato(Contrato contrato) {
        this.contrato = contrato;
    }

    /**
     * @return the tipoIntervencion
     */
    public DDTipoIntervencion getTipoIntervencion() {
        return tipoIntervencion;
    }

    /**
     * @param tipoIntervencion the tipoIntervencion to set
     */
    public void setTipoIntervencion(DDTipoIntervencion tipoIntervencion) {
        this.tipoIntervencion = tipoIntervencion;
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
     * Retorna el atributo orden.
     * @return orden
     */
    public Long getOrden() {
        return orden;
    }

    /**
    * Setea el atributo orden.
    * @param orden Long
    */
    public void setOrden(Long orden) {
        this.orden = orden;
    }

    /**
     * retorna si el par contrato persona es titular en el tipo de intervercion.
     * @return titular o no
     */
    public boolean isTitular() {
        return tipoIntervencion.getTitular();
    }

    /**
     * Devuelve si para el contrato persona es avalista
     * @return
     */
    public boolean isAvalista() {
        return tipoIntervencion.getAvalista();
    }

}
