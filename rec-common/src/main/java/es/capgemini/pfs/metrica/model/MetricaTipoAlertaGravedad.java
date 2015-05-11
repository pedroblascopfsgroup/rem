package es.capgemini.pfs.metrica.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.alerta.model.NivelGravedad;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Modelo de la tabla donde se terminan relacionando la metrica,
 * el tipo de alerta y el nivel de gravedad, asignandole un peso correspondiente.
 * @author Andrés Esteban
 *
 */
@Entity
@Table(name = "MTG_METRICAS_TIPO_GRAVEDAD", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class MetricaTipoAlertaGravedad implements Serializable, Auditable {

    private static final long serialVersionUID = -4876535526202170886L;

    @Id
    @Column(name = "MTG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MTGGenerator")
    @SequenceGenerator(name = "MTGGenerator", sequenceName = "S_MTG_METRICAS_TIPO_GRAVEDAD")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "MTT_ID")
    private MetricaTipoAlerta metricaTipoAlerta;

    @OneToOne
    @JoinColumn(name = "NGR_ID")
    private NivelGravedad nivelGravedad;

    @Column(name = "MTG_PESO")
    private Integer peso;

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
     * @return the metricaTipoAlerta
     */
    public MetricaTipoAlerta getMetricaTipoAlerta() {
        return metricaTipoAlerta;
    }

    /**
     * @param metricaTipoAlerta the metricaTipoAlerta to set
     */
    public void setMetricaTipoAlerta(MetricaTipoAlerta metricaTipoAlerta) {
        this.metricaTipoAlerta = metricaTipoAlerta;
    }

    /**
     * @return the nivelGravedad
     */
    public NivelGravedad getNivelGravedad() {
        return nivelGravedad;
    }

    /**
     * @param nivelGravedad the nivelGravedad to set
     */
    public void setNivelGravedad(NivelGravedad nivelGravedad) {
        this.nivelGravedad = nivelGravedad;
    }

    /**
     * @return the peso
     */
    public Integer getPeso() {
        return peso;
    }

    /**
     * @param peso the peso to set
     */
    public void setPeso(Integer peso) {
        this.peso = peso;
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
}
