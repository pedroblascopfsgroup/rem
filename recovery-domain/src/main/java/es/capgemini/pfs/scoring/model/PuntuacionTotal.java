package es.capgemini.pfs.scoring.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.persona.model.Persona;

/**
 * Modelo de la tabla PTO_PUNTUACION_TOTAL.
 * Representa el total de scoring para cada persona.
 * @author Andrés Esteban
 *
 */
@Entity
@Table(name = "PTO_PUNTUACION_TOTAL", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class PuntuacionTotal implements Serializable, Auditable {

	private static final long serialVersionUID = 4972630396878565006L;

	@Id
    @Column(name = "PTO_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "PTOGenerator")
    @SequenceGenerator(name = "PTOGenerator", sequenceName = "S_PTO_PUNTUACION_TOTAL")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PER_ID")
    private Persona persona;

    @Column(name = "PTO_VRC")
    private Float volumenRiesgoCliente;

    @Column(name = "PTO_PUNTUACION")
    private Long puntuacion;

    @Column(name = "PTO_RATING")
    private Integer rating;

    @Column(name = "PTO_RANGO_INTERVALO")
    private Integer rangoIntervalo;

    @Column(name = "PTO_INTERVALO")
    private String intervalo;

    @Column(name = "PTO_FECHA_PROCESADO")
    private Date fechaProcesado;

    @Column(name = "PTO_ACTIVO")
    private boolean activo;

    @OneToMany
    @JoinColumn(name="PTO_ID")
    private List<PuntuacionParcial> puntuacionesParciales;

    /**
	 * @return the puntuacionesParciales
	 */
	public List<PuntuacionParcial> getPuntuacionesParciales() {
		return puntuacionesParciales;
	}

	/**
	 * @param puntuacionesParciales the puntuacionesParciales to set
	 */
	public void setPuntuacionesParciales(
			List<PuntuacionParcial> puntuacionesParciales) {
		this.puntuacionesParciales = puntuacionesParciales;
	}

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
     * @return the volumenRiesgoCliente
     */
    public Float getVolumenRiesgoCliente() {
        return volumenRiesgoCliente;
    }

    /**
     * @param volumenRiesgoCliente the volumenRiesgoCliente to set
     */
    public void setVolumenRiesgoCliente(Float volumenRiesgoCliente) {
        this.volumenRiesgoCliente = volumenRiesgoCliente;
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
     * @return the rating
     */
    public Integer getRating() {
        return rating;
    }

    /**
     * @param rating the rating to set
     */
    public void setRating(Integer rating) {
        this.rating = rating;
    }

    /**
     * @return the rangoIntervalo
     */
    public Integer getRangoIntervalo() {
        return rangoIntervalo;
    }

    /**
     * @param rangoIntervalo the rangoIntervalo to set
     */
    public void setRangoIntervalo(Integer rangoIntervalo) {
        this.rangoIntervalo = rangoIntervalo;
    }

    /**
     * @return the intervalo
     */
    public String getIntervalo() {
        return intervalo;
    }

    /**
     * @param intervalo the intervalo to set
     */
    public void setIntervalo(String intervalo) {
        this.intervalo = intervalo;
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

}
