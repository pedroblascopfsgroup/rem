package es.capgemini.pfs.procesosJudiciales.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * Clase que representa la entidad TEX_TAREA_EXTERNA.
 *
 * @author jpbosnjak
 *
 */
@Entity
@Table(name = "TEX_TAREA_EXTERNA", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class TareaExterna implements Serializable, Auditable {

    private static final long serialVersionUID = -3753995353825072584L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TareaExternaGenerator")
    @SequenceGenerator(name = "TareaExternaGenerator", sequenceName = "S_TEX_TAREA_EXTERNA")
    @Column(name = "TEX_ID")
    private Long id;

    @OneToOne
    @JoinColumn(name = "TAR_ID")
    private TareaNotificacion tareaPadre;

    @ManyToOne
    @JoinColumn(name = "TAP_ID")
    private TareaProcedimiento tareaProcedimiento;

    @Column(name = "TEX_TOKEN_ID_BPM")
    private Long tokenIdBpm;

    @Column(name = "TEX_DETENIDA")
    private Boolean detenida;

    @Column(name = "TEX_CANCELADA")
    private Boolean cancelada;

    @OneToMany(mappedBy = "tareaExterna")
    @JoinColumn(name = "TEX_ID")
    private List<TareaExternaValor> valores;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * Variable que indica si la tarea tiene o no transición de vuelta atrás.
     * Se debe setear desde fuera.
     * Se ha usado una formula porque no encuentro otra forma de poner una variable que no tenga que ver con la tabla
     */
    @Transient
    //@Formula(value = "(SELECT 0 FROM DUAL)")
    private Boolean vueltaAtras;

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
     * @return the tareaPadre
     */
    public TareaNotificacion getTareaPadre() {
        return tareaPadre;
    }

    /**
     * @param tareaPadre the tareaPadre to set
     */
    public void setTareaPadre(TareaNotificacion tareaPadre) {
        this.tareaPadre = tareaPadre;
    }

    /**
     * @return the tareaProcedimiento
     */
    public TareaProcedimiento getTareaProcedimiento() {
        return tareaProcedimiento;
    }

    /**
     * @param tareaProcedimiento the tareaProcedimiento to set
     */
    public void setTareaProcedimiento(TareaProcedimiento tareaProcedimiento) {
        this.tareaProcedimiento = tareaProcedimiento;
    }

    /**
     * @return the tokenIdBpm
     */
    public Long getTokenIdBpm() {
        return tokenIdBpm;
    }

    /**
     * @param tokenIdBpm the tokenIdBpm to set
     */
    public void setTokenIdBpm(Long tokenIdBpm) {
        this.tokenIdBpm = tokenIdBpm;
    }

    /**
     * @return the detenida
     */
    public Boolean getDetenida() {
        return detenida;
    }

    /**
     * @param detenida the detenida to set
     */
    public void setDetenida(Boolean detenida) {
        this.detenida = detenida;
    }

    /**
     * @return the valores
     */
    public List<TareaExternaValor> getValores() {
        return valores;
    }

    /**
     * @param valores the valores to set
     */
    public void setValores(List<TareaExternaValor> valores) {
        this.valores = valores;
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
     * @return the vueltaAtras
     */
    public Boolean getVueltaAtras() {
        return vueltaAtras;
    }

    /**
     * @param vueltaAtras the vueltaAtras to set
     */
    public void setVueltaAtras(Boolean vueltaAtras) {
        this.vueltaAtras = vueltaAtras;
    }

    /**
     * @return the cancelada
     */
    public Boolean getCancelada() {
        return cancelada;
    }

    /**
     * @param cancelada the cancelada to set
     */
    public void setCancelada(Boolean cancelada) {
        this.cancelada = cancelada;
    }
}
