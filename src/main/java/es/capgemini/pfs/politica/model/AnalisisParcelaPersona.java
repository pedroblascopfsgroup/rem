package es.capgemini.pfs.politica.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Clase que representa un registro de analisis de persona.
 * @author pamuller
 *
 */
@Entity
@Table(name = "APA_ANALISIS_PARCELA_PERSONA", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class AnalisisParcelaPersona implements Serializable, Auditable {

    private static final long serialVersionUID = 5018166315489403240L;

    @Id
    @Column(name = "APA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AnalisisParcelaPersona")
    @SequenceGenerator(name = "AnalisisParcelaPersona", sequenceName = "S_APA_ANALISIS_PAR_PER")
    private Long id;

    @Column(name = "APA_COMENTARIO")
    private String comentario;

    @ManyToOne
    @JoinColumn(name = "DD_PAR_ID")
    private DDParcelasPersonas parcela;

    @ManyToOne
    @JoinColumn(name = "APP_ID")
    private AnalisisPersonaPolitica analisisPersonaPolitica;

    @ManyToOne
    @JoinColumn(name = "DD_IMP_ID")
    private DDImpacto impacto;

    @ManyToOne
    @JoinColumn(name = "DD_VAL_ID")
    private DDValoracion valoracion;

    @Version
    private Integer version;

    @Embedded
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
     * @return the comentario
     */
    public String getComentario() {
        return comentario;
    }

    /**
     * @param comentario the comentario to set
     */
    public void setComentario(String comentario) {
        this.comentario = comentario;
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

    /**
     * @return the analisisPersonaPolitica
     */
    public AnalisisPersonaPolitica getAnalisisPersonaPolitica() {
        return analisisPersonaPolitica;
    }

    /**
     * @param analisisPersonaPolitica the analisisPersonaPolitica to set
     */
    public void setAnalisisPersonaPolitica(AnalisisPersonaPolitica analisisPersonaPolitica) {
        this.analisisPersonaPolitica = analisisPersonaPolitica;
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

    /**
     * @return the impacto
     */
    public DDImpacto getImpacto() {
        return impacto;
    }

    /**
     * @param impacto the impacto to set
     */
    public void setImpacto(DDImpacto impacto) {
        this.impacto = impacto;
    }

    /**
     * @return the valoracion
     */
    public DDValoracion getValoracion() {
        return valoracion;
    }

    /**
     * @param valoracion the valoracion to set
     */
    public void setValoracion(DDValoracion valoracion) {
        this.valoracion = valoracion;
    }

}
