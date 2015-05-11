package es.capgemini.pfs.metrica.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.segmento.model.DDSegmento;

/**
 * Modelo de la tabla de métricas.
 * La misma es por tipo de persona y segmento de cliente si lo hay.
 * @author Andrés Esteban
 *
 */
@Entity
@Table(name = "MTR_METRICAS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class Metrica implements Serializable, Auditable {

    private static final long serialVersionUID = 1623783046526468045L;

    @Id
    @Column(name = "MTR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MTRGenerator")
    @SequenceGenerator(name = "MTRGenerator", sequenceName = "S_MTR_METRICAS")
    private Long id;

    @OneToOne
    @JoinColumn(name = "DD_TPE_ID")
    private DDTipoPersona tipoPersona;

    @OneToOne
    @JoinColumn(name = "DD_SCE_ID")
    private DDSegmento segmento;

    @OneToOne
    @JoinColumn(name = "FME_ID")
    private FicheroMetrica fichero;

    @Column(name = "MTR_FECHA_ACTIVACION")
    private Date fechaActivacion;

    // Este campo es para ahorrar accesos a la tabla de FicheroMetrica para recuperar solo el nombre del archivo
    @Column(name = "MTR_FICHERO_CARGA")
    private String nombreFichero;

    @Column(name = "MTR_ACTIVO")
    private boolean activo;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    @OneToMany(mappedBy = "metrica", cascade = CascadeType.ALL)
    @JoinColumn(name = "MTR_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<MetricaTipoAlerta> metricasTipoAlerta;

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
     * @return the segmento
     */
    public DDSegmento getSegmento() {
        return segmento;
    }

    /**
     * @param segmento the segmento to set
     */
    public void setSegmento(DDSegmento segmento) {
        this.segmento = segmento;
    }

    /**
     * @return the fichero
     */
    public FicheroMetrica getFichero() {
        return fichero;
    }

    /**
     * @param fichero the fichero to set
     */
    public void setFichero(FicheroMetrica fichero) {
        this.fichero = fichero;
    }

    /**
     * @return the fechaActivacion
     */
    public Date getFechaActivacion() {
        return fechaActivacion;
    }

    /**
     * @param fechaActivacion the fechaActivacion to set
     */
    public void setFechaActivacion(Date fechaActivacion) {
        this.fechaActivacion = fechaActivacion;
    }

    /**
     * @return the nombreFichero
     */
    public String getNombreFichero() {
        return nombreFichero;
    }

    /**
     * @param nombreFichero the nombreFichero to set
     */
    public void setNombreFichero(String nombreFichero) {
        this.nombreFichero = nombreFichero;
    }

    /**
     * @return the activo
     */
    public boolean isActivo() {
        return activo;
    }

    /**
     * @param activo the activo to set
     */
    public void setActivo(boolean activo) {
        this.activo = activo;
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
     * @return the metricasTipoAlerta
     */
    public List<MetricaTipoAlerta> getMetricasTipoAlerta() {
        return metricasTipoAlerta;
    }

    /**
     * @param metricasTipoAlerta the metricasTipoAlerta to set
     */
    public void setMetricasTipoAlerta(List<MetricaTipoAlerta> metricasTipoAlerta) {
        this.metricasTipoAlerta = metricasTipoAlerta;
    }
}
