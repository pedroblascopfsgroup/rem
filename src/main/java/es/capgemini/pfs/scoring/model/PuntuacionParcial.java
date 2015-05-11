package es.capgemini.pfs.scoring.model;

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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.alerta.model.Alerta;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.Persona;

/**
 * Modelo de la tabla PPA_PUNTUACION_PARCIAL.
 * Representa la valoración de una alerta particular en base a la métrica del momento.
 * @author Andrés Esteban
 *
 */
@Entity
@Table(name = "PPA_PUNTUACION_PARCIAL", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class PuntuacionParcial implements Serializable, Auditable {

    private static final long serialVersionUID = 710012410147051655L;

    @Id
    @Column(name = "PPA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "PPAGenerator")
    @SequenceGenerator(name = "PPAGenerator", sequenceName = "S_PPA_PUNTUACION_PARCIAL")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "ALE_ID")
    private Alerta alerta;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PER_ID")
    private Persona persona;

    @OneToOne
    @JoinColumn(name = "PTO_ID")
    private PuntuacionTotal puntuacionTotal;

    @Column(name = "PPA_PREOCUPACION")
    private Long preocupacion;

    @Column(name = "PPA_PESO_NVL_GRAVEDAD")
    private Long pesoNivelGravedad;

    @Column(name = "PPA_PUNTUACION")
    private Long puntuacion;

    @Column(name = "PPA_FECHA_EXTRACCION")
    private Date fechaExtraccion;

    @Column(name = "PPA_FECHA_METRICA")
    private Date fechaMetrica;

    @Column(name = "PPA_FECHA_PROCESADO")
    private Date fechaProcesado;

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
     * @return the alerta
     */
    public Alerta getAlerta() {
        return alerta;
    }

    /**
     * @param alerta the alerta to set
     */
    public void setAlerta(Alerta alerta) {
        this.alerta = alerta;
    }

    /**
     * @return the pesoNivelGravedad
     */
    public Long getPesoNivelGravedad() {
        return pesoNivelGravedad;
    }

    /**
     * @param pesoNivelGravedad the pesoNivelGravedad to set
     */
    public void setPesoNivelGravedad(Long pesoNivelGravedad) {
        this.pesoNivelGravedad = pesoNivelGravedad;
    }

    /**
     * @return the puntuacion
     */
    public Long getPuntuacion() {
        return puntuacion;
    }

    /**
     * @param puntuacion the puntuacion to set
     */
    public void setPuntuacion(Long puntuacion) {
        this.puntuacion = puntuacion;
    }

    /**
     * @return the fechaExtraccion
     */
    public Date getFechaExtraccion() {
        return fechaExtraccion;
    }

    /**
     * @param fechaExtraccion the fechaExtraccion to set
     */
    public void setFechaExtraccion(Date fechaExtraccion) {
        this.fechaExtraccion = fechaExtraccion;
    }

    /**
     * @return the fechaMetrica
     */
    public Date getFechaMetrica() {
        return fechaMetrica;
    }

    /**
     * @param fechaMetrica the fechaMetrica to set
     */
    public void setFechaMetrica(Date fechaMetrica) {
        this.fechaMetrica = fechaMetrica;
    }

    /**
     * @return the fechaProcesado
     */
    public Date getFechaProcesado() {
        return fechaProcesado;
    }

    /**
     * @param fechaProcesado the fechaProcesado to set
     */
    public void setFechaProcesado(Date fechaProcesado) {
        this.fechaProcesado = fechaProcesado;
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
     * @return the puntuacionTotal
     */
    public PuntuacionTotal getPuntuacionTotal() {
        return puntuacionTotal;
    }

    /**
     * @param puntuacionTotal the puntuacionTotal to set
     */
    public void setPuntuacionTotal(PuntuacionTotal puntuacionTotal) {
        this.puntuacionTotal = puntuacionTotal;
    }

    /**
     * @return the preocupacion
     */
    public Long getPreocupacion() {
        return preocupacion;
    }

    /**
     * @param preocupacion the preocupacion to set
     */
    public void setPreocupacion(Long preocupacion) {
        this.preocupacion = preocupacion;
    }
}
