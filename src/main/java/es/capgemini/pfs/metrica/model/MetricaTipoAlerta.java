package es.capgemini.pfs.metrica.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.alerta.model.TipoAlerta;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Modelo de la tabla que relaciona las metricas con los tipos de alertas.
 * En la misma se guarda un valor de 'preocupación'.
 * @author Andrés Esteban
 *
 */
@Entity
@Table(name = "MTT_METRICAS_TIPO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class MetricaTipoAlerta implements Serializable, Auditable {

    private static final long serialVersionUID = 1101622461531540087L;

    @Id
    @Column(name = "MTT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MTTGenerator")
    @SequenceGenerator(name = "MTTGenerator", sequenceName = "S_MTT_METRICAS_TIPO")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "MTR_ID")
    private Metrica metrica;

    @OneToOne
    @JoinColumn(name = "TAL_ID")
    private TipoAlerta tipoAlerta;

    @Column(name = "MTT_PREOCUPACION")
    private Integer preocupacion;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    @OneToMany(mappedBy = "metricaTipoAlerta", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "MTT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<MetricaTipoAlertaGravedad> metricasTipoAlertaGravedad;

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
     * @return the tipoAlerta
     */
    public TipoAlerta getTipoAlerta() {
        return tipoAlerta;
    }

    /**
     * @param tipoAlerta the tipoAlerta to set
     */
    public void setTipoAlerta(TipoAlerta tipoAlerta) {
        this.tipoAlerta = tipoAlerta;
    }

    /**
     * @return the preocupacion
     */
    public Integer getPreocupacion() {
        return preocupacion;
    }

    /**
     * @param preocupacion the preocupacion to set
     */
    public void setPreocupacion(Integer preocupacion) {
        this.preocupacion = preocupacion;
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
     * @return the metrica
     */
    public Metrica getMetrica() {
        return metrica;
    }

    /**
     * @param metrica the metrica to set
     */
    public void setMetrica(Metrica metrica) {
        this.metrica = metrica;
    }

    /**
     * @return the metricasTipoAlertaGravedad
     */
    public List<MetricaTipoAlertaGravedad> getMetricasTipoAlertaGravedad() {
        return metricasTipoAlertaGravedad;
    }

    /**
     * @param metricasTipoAlertaGravedad the metricasTipoAlertaGravedad to set
     */
    public void setMetricasTipoAlertaGravedad(List<MetricaTipoAlertaGravedad> metricasTipoAlertaGravedad) {
        this.metricasTipoAlertaGravedad = metricasTipoAlertaGravedad;
    }
}
