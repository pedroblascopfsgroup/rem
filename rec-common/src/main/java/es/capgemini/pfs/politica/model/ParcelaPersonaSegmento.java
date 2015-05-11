package es.capgemini.pfs.politica.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.segmento.model.DDSegmento;

/**
 * Clase que junta las parcelas con las personas y los segmentos.
 * @author pamuller
 *
 */
@Entity
@Table(name = "PPS_PARCELA_PERSONA_SGTO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ParcelaPersonaSegmento implements Serializable, Auditable {

    private static final long serialVersionUID = -3032376345596006263L;

    @Id
    @Column(name = "PPS_ID")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "DD_PAR_ID")
    private DDParcelasPersonas parcela;

    @ManyToOne
    @JoinColumn(name = "DD_TPE_ID")
    private DDTipoPersona tipoPersona;

    @ManyToOne
    @JoinColumn(name = "DD_SCL_ID")
    private DDSegmento segmentoCliente;

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
     * @return the tipoPersona
     */
    public DDTipoPersona getTipoPersona() {
        return tipoPersona;
    }

    /**
     * @param tipoPersona the tipoPersona to set
     */
    public void setTipoPersona(DDTipoPersona tipoPersona) {
        this.tipoPersona = tipoPersona;
    }

    /**
     * @return the segmentoCliente
     */
    public DDSegmento getSegmentoCliente() {
        return segmentoCliente;
    }

    /**
     * @param segmentoCliente the segmentoCliente to set
     */
    public void setSegmentoCliente(DDSegmento segmentoCliente) {
        this.segmentoCliente = segmentoCliente;
    }

    /**
     * @return the parcela
     */
    public DDParcelasPersonas getParcela() {
        return parcela;
    }

    /**
     * @param parcela the parcela to set
     */
    public void setParcela(DDParcelasPersonas parcela) {
        this.parcela = parcela;
    }

}
