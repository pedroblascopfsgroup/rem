package es.capgemini.pfs.antecedenteexterno.model;

import java.io.Serializable;
import java.util.Date;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * @author Mariano Ruiz
 *
 */
@Entity
@Table(name = "AEX_ANTECEDENTESEXTERNOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class AntecedenteExterno implements Serializable, Auditable {

    private static final long serialVersionUID = -3466328222948672534L;


    @Id
    @Column(name = "AEX_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AntecedenteExternoGenerator")
    @SequenceGenerator(name = "AntecedenteExternoGenerator", sequenceName = "S_AEX_ANTECEDENTESEXTERNOS")
    private Long id;

    @Column(name = "AEX_N_INC_JUDICIALES")
    private Integer numIncidenciasJudiciales;

    @Column(name = "AEX_FECHA_INC_JUDICIALES")
    private Date fechaIncidenciaJudicial;

    @Column(name = "AEX_N_IMPAGOS")
    private Integer numImpagos;

    @Column(name = "AEX_FECHA_IMPAGOS")
    private Date fechaImpagos;


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
     * @param version
     *            the version to set
     */
    public void setVersion(Integer version) {
       this.version = version;
    }

    /**
     * @return the numIncidenciasJudiciales
     */
    public Integer getNumIncidenciasJudiciales() {
        return numIncidenciasJudiciales;
    }

    /**
     * @param numIncidenciasJudiciales the numIncidenciasJudiciales to set
     */
    public void setNumIncidenciasJudiciales(Integer numIncidenciasJudiciales) {
        this.numIncidenciasJudiciales = numIncidenciasJudiciales;
    }

    /**
     * @return the fechaIncidenciaJudicial
     */
    public Date getFechaIncidenciaJudicial() {
        return fechaIncidenciaJudicial;
    }

    /**
     * @param fechaIncidenciaJudicial the fechaIncidenciaJudicial to set
     */
    public void setFechaIncidenciaJudicial(Date fechaIncidenciaJudicial) {
        this.fechaIncidenciaJudicial = fechaIncidenciaJudicial;
    }

    /**
     * @return the numImpagos
     */
    public Integer getNumImpagos() {
        return numImpagos;
    }

    /**
     * @param numImpagos the numImpagos to set
     */
    public void setNumImpagos(Integer numImpagos) {
        this.numImpagos = numImpagos;
    }

    /**
     * @return the fechaImpagos
     */
    public Date getFechaImpagos() {
        return fechaImpagos;
    }

    /**
     * @param fechaImpagos the fechaImpagos to set
     */
    public void setFechaImpagos(Date fechaImpagos) {
        this.fechaImpagos = fechaImpagos;
    }
}
