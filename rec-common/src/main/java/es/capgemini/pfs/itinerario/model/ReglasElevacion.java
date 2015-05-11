package es.capgemini.pfs.itinerario.model;

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
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.expediente.model.DDAmbitoExpediente;

/**
 * Las reglas de elevación de los estados.
 *
 * @author pjimenez
 */
@Entity
@Table(name = "REE_REGLAS_ELEVACION_ESTADO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ReglasElevacion implements Serializable, Auditable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "REE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ReglasElevacion")
    @SequenceGenerator(name = "ReglasElevacion", sequenceName = "S_REE_REGLAS_ELEVACION_ESTADO")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "DD_TRE_ID")
    private DDTipoReglasElevacion tipoReglaElevacion;

    @ManyToOne
    @JoinColumn(name = "DD_AEX_ID ")
    private DDAmbitoExpediente ambitoExpediente;

    @ManyToOne
    @JoinColumn(name = "EST_ID")
    private Estado estadoItinerario;

    @Transient
    private Boolean cumple;

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
     * Retorna el atributo auditoria.
     * @return auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * Setea el atributo auditoria.
     * @param auditoria Auditoria
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * Retorna el atributo version.
     * @return version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * Setea el atributo version.
     * @param version Integer
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @param tipoReglaElevacion the tipoReglaElevacion to set
     */
    public void setTipoReglaElevacion(DDTipoReglasElevacion tipoReglaElevacion) {
        this.tipoReglaElevacion = tipoReglaElevacion;
    }

    /**
     * @return the tipoReglaElevacion
     */
    public DDTipoReglasElevacion getTipoReglaElevacion() {
        return tipoReglaElevacion;
    }

    /**
     * @param ambitoExpediente the ambitoExpediente to set
     */
    public void setAmbitoExpediente(DDAmbitoExpediente ambitoExpediente) {
        this.ambitoExpediente = ambitoExpediente;
    }

    /**
     * @return the ambitoExpediente
     */
    public DDAmbitoExpediente getAmbitoExpediente() {
        return ambitoExpediente;
    }

    /**
     * @param estadoItinerario the estadoItinerario to set
     */
    public void setEstadoItinerario(Estado estadoItinerario) {
        this.estadoItinerario = estadoItinerario;
    }

    /**
     * @return the estadoItinerario
     */
    public Estado getEstadoItinerario() {
        return estadoItinerario;
    }

    /**
     * @param cumple the cumple to set
     */
    public void setCumple(Boolean cumple) {
        this.cumple = cumple;
    }

    /**
     * @return the cumple
     */
    public Boolean getCumple() {
        return cumple;
    }
}
