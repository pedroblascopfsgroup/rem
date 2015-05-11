package es.capgemini.pfs.persona.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
import es.capgemini.pfs.politica.model.DDTipoPolitica;

/**
 * Entidad que representa un histórico de prepolíticas de la persona
 * @author pajimene
 *
 */
@Entity
@Table(name = "H_PRP_PREPOLITICA_PERSONA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class HistoricoPrepoliticaPersona implements Serializable, Auditable {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "PRP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistPrepoliticaGenerator")
    @SequenceGenerator(name = "HistPrepoliticaGenerator", sequenceName = "S_H_PRP_PREPOLITICA_PERSONA")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "PER_ID")
    private Persona persona;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TPL_ID")
    private DDTipoPolitica politica;

    @Column(name = "PRP_FECHA_INICIO")
    private Date fechaInicio;

    @Column(name = "PRP_FECHA_FIN")
    private Date fechaFin;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param persona the persona to set
     */
    public void setPersona(Persona persona) {
        this.persona = persona;
    }

    /**
     * @return the persona
     */
    public Persona getPersona() {
        return persona;
    }

    /**
     * @param politica the politica to set
     */
    public void setPolitica(DDTipoPolitica politica) {
        this.politica = politica;
    }

    /**
     * @return the politica
     */
    public DDTipoPolitica getPolitica() {
        return politica;
    }

    /**
     * @param fechaInicio the fechaInicio to set
     */
    public void setFechaInicio(Date fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    /**
     * @return the fechaInicio
     */
    public Date getFechaInicio() {
        return fechaInicio;
    }

    /**
     * @param fechaFin the fechaFin to set
     */
    public void setFechaFin(Date fechaFin) {
        this.fechaFin = fechaFin;
    }

    /**
     * @return the fechaFin
     */
    public Date getFechaFin() {
        return fechaFin;
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
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

}
