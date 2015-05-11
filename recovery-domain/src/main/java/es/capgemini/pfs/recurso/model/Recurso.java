package es.capgemini.pfs.recurso.model;

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
import javax.validation.constraints.NotNull;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDResultadoResolucion;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * poner javadoc FO.
 * @author FO
 *
 */
@Entity
@Table(name = "RCR_RECURSOS_PROCEDIMIENTOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Recurso implements Serializable, Auditable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "RCR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "RecursoProcedimientoGenerator")
    @SequenceGenerator(name = "RecursoProcedimientoGenerator", sequenceName = "S_RCR_RECURSOS_PROCEDIMIENTOS")
    private Long id;

    @OneToOne
    @JoinColumn(name = "PRC_ID")
    private Procedimiento procedimiento;

    @ManyToOne
    @JoinColumn(name = "DD_ACT_ID")
    @NotNull(message = "recursos.error.actorNulo")
    private DDActor actor;

    @ManyToOne
    @JoinColumn(name = "DD_DTR_ID")
    @NotNull(message = "recursos.error.tipoNulo")
    private DDTipoRecurso tipoRecurso;

    @ManyToOne
    @JoinColumn(name = "DD_CRE_ID")
    @NotNull(message = "recursos.error.causaNula")
    private DDCausaRecurso causaRecurso;

    @ManyToOne
    @JoinColumn(name = "DD_DRR_ID")
    private DDResultadoResolucion resultadoResolucion;

    @OneToOne
    @JoinColumn(name = "TAR_ID")
    private TareaNotificacion tareaNotificacion;

    @Column(name = "RCR_FECHA_RECURSO")
    @NotNull(message = "recursos.error.fechaRecursoNula")
    private Date fechaRecurso;

    @Column(name = "RCR_FECHA_IMPUGNACION")
    private Date fechaImpugnacion;

    @Column(name = "RCR_FECHA_VISTA")
    private Date fechaVista;

    @Column(name = "RCR_FECHA_RESOLUCION")
    private Date fechaResolucion;

    @Column(name = "RCR_OBSERVACIONES")
    //@NotNull(errorCode = "recursos.error.observacionNula")
    private String observaciones;

    @Column(name = "RCR_CONFIRM_IMPUGNACION")
    private Boolean confirmarImpugnacion;

    @Column(name = "RCR_CONFIRM_VISTA")
    private Boolean confirmarVista;

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
     * @return the procedimiento
     */
    public Procedimiento getProcedimiento() {
        return procedimiento;
    }

    /**
     * @param procedimiento the procedimiento to set
     */
    public void setProcedimiento(Procedimiento procedimiento) {
        this.procedimiento = procedimiento;
    }

    /**
     * @return the actor
     */
    public DDActor getActor() {
        return actor;
    }

    /**
     * @param actor the actor to set
     */
    public void setActor(DDActor actor) {
        this.actor = actor;
    }

    /**
     * @return the tipoRecurso
     */
    public DDTipoRecurso getTipoRecurso() {
        return tipoRecurso;
    }

    /**
     * @param tipoRecurso the tipoRecurso to set
     */
    public void setTipoRecurso(DDTipoRecurso tipoRecurso) {
        this.tipoRecurso = tipoRecurso;
    }

    /**
     * @return the causaRecurso
     */
    public DDCausaRecurso getCausaRecurso() {
        return causaRecurso;
    }

    /**
     * @param causaRecurso the causaRecurso to set
     */
    public void setCausaRecurso(DDCausaRecurso causaRecurso) {
        this.causaRecurso = causaRecurso;
    }

    /**
     * @return the resultadoResolucion
     */
    public DDResultadoResolucion getResultadoResolucion() {
        return resultadoResolucion;
    }

    /**
     * @param resultadoResolucion the resultadoResolucion to set
     */
    public void setResultadoResolucion(DDResultadoResolucion resultadoResolucion) {
        this.resultadoResolucion = resultadoResolucion;
    }

    /**
     * @return the tareaNotificacion
     */
    public TareaNotificacion getTareaNotificacion() {
        return tareaNotificacion;
    }

    /**
     * @param tareaNotificacion the tareaNotificacion to set
     */
    public void setTareaNotificacion(TareaNotificacion tareaNotificacion) {
        this.tareaNotificacion = tareaNotificacion;
    }

    /**
     * @return the fechaRecurso
     */
    public Date getFechaRecurso() {
        return fechaRecurso;
    }

    /**
     * @param fechaRecurso the fechaRecurso to set
     */
    public void setFechaRecurso(Date fechaRecurso) {
        this.fechaRecurso = fechaRecurso;
    }

    /**
     * @return the fechaImpugnacion
     */
    public Date getFechaImpugnacion() {
        return fechaImpugnacion;
    }

    /**
     * @param fechaImpugnacion the fechaImpugnacion to set
     */
    public void setFechaImpugnacion(Date fechaImpugnacion) {
        this.fechaImpugnacion = fechaImpugnacion;
    }

    /**
     * @return the fechaVista
     */
    public Date getFechaVista() {
        return fechaVista;
    }

    /**
     * @param fechaVista the fechaVista to set
     */
    public void setFechaVista(Date fechaVista) {
        this.fechaVista = fechaVista;
    }

    /**
     * @return the fechaResolucion
     */
    public Date getFechaResolucion() {
        return fechaResolucion;
    }

    /**
     * @param fechaResolucion the fechaResolucion to set
     */
    public void setFechaResolucion(Date fechaResolucion) {
        this.fechaResolucion = fechaResolucion;
    }

    /**
     * @return the observaciones
     */
    public String getObservaciones() {
        return observaciones;
    }

    /**
     * @param observaciones the observaciones to set
     */
    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    /**
     * @return the confirmarImpugnacion
     */
    public Boolean getConfirmarImpugnacion() {
        return confirmarImpugnacion;
    }

    /**
     * @param confirmarImpugnacion the confirmarImpugnacion to set
     */
    public void setConfirmarImpugnacion(Boolean confirmarImpugnacion) {
        this.confirmarImpugnacion = confirmarImpugnacion;
    }

    /**
     * @return the confirmarVista
     */
    public Boolean getConfirmarVista() {
        return confirmarVista;
    }

    /**
     * @param confirmarVista the confirmarVista to set
     */
    public void setConfirmarVista(Boolean confirmarVista) {
        this.confirmarVista = confirmarVista;
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
