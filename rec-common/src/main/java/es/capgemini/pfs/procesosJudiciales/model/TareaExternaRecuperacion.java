package es.capgemini.pfs.procesosJudiciales.model;

import java.io.Serializable;
import java.util.Date;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.recuperacion.model.Recuperacion;

/**
 * Clase que representa la entidad TEX_TAREA_EXTERNA.
 *
 * @author jpbosnjak
 *
 */
@Entity
@Table(name = "TER_TAREA_EXTERNA_RECUPERACION", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class TareaExternaRecuperacion implements Serializable, Auditable {

    private static final long serialVersionUID = -3753995353825072584L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TareaExternaRecuperacionGenerator")
    @SequenceGenerator(name = "TareaExternaRecuperacionGenerator", sequenceName = "S_TER_TAREA_EXTERNA_REC")
    @Column(name = "TER_ID")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "TEX_ID")
    private TareaExterna tareaExterna;

    @OneToOne
    @JoinColumn(name = "REC_ID")
    private Recuperacion recuperacionAsociada;

    @Column(name = "TER_FECHA_REG_CNT")
    private Date fechaRegistroRecuperacion;

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
     * Setea la recuperación asociada en el momento de crear la tarea externa.
     * @param recuperacionAsociada Recuperacion
     */
    public void setRecuperacionAsociada(Recuperacion recuperacionAsociada) {
        this.recuperacionAsociada = recuperacionAsociada;
    }

    /**
     * Recupera la recuperación asociada en el momento de crear la tarea externa.
     * @return Recuperacion
     */
    public Recuperacion getRecuperacionAsociada() {
        return recuperacionAsociada;
    }

    /**
     * Setea la fecha de registro de la recuperación asociada.
     * @param fechaRegistroRecuperacion Date
     */
    public void setFechaRegistroRecuperacion(Date fechaRegistroRecuperacion) {
        this.fechaRegistroRecuperacion = fechaRegistroRecuperacion;
    }

    /**
     * Recupera la fecha de registro de la recuperación asociada.
     * @return Date
     */
    public Date getFechaRegistroRecuperacion() {
        return fechaRegistroRecuperacion;
    }

    /**
     * @param tareaExterna the tareaExterna to set
     */
    public void setTareaExterna(TareaExterna tareaExterna) {
        this.tareaExterna = tareaExterna;
    }

    /**
     * @return the tareaExterna
     */
    public TareaExterna getTareaExterna() {
        return tareaExterna;
    }

}
