package es.capgemini.pfs.procesosJudiciales.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;

/**
 * Clase que representa la entidad TAP_TAREA_PROCEDIMIENTO.
 * @author jpbosnjak
 *
 */
@Entity
@Table(name = "TAP_TAREA_PROCEDIMIENTO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class TareaProcedimiento implements Serializable, Auditable, TareasProcesosJudicialesConstants {

    /**
     * serialVersionUID.
     */
    private static final long serialVersionUID = -8961132998182577279L;

    @Id
    @Column(name = "TAP_ID")
    private Long id;

    //VOLAR
    @Transient
    private SubtipoTarea subtipoTarea;

    @Column(name = "TAP_CODIGO")
    private String codigo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPO_ID")
    private TipoProcedimiento tipoProcedimiento;

    @Column(name = "TAP_SCRIPT_VALIDACION")
    private String scriptValidacion;

    @Column(name = "TAP_SCRIPT_VALIDACION_JBPM")
    private String scriptValidacionJBPM;

    @Column(name = "TAP_SCRIPT_DECISION")
    private String scriptDecision;

    @Column(name = "TAP_DESCRIPCION")
    private String descripcion;

    @Column(name = "TAP_ALERT_NO_RETORNO")
    private String alertNoRetorno;

    @Column(name = "TAP_ALERT_VUELTA_ATRAS")
    private String alertVueltaAtras;

    @Column(name = "TAP_VIEW")
    private String view;

    @Column(name = "TAP_SUPERVISOR")
    private Boolean supervisor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPO_ID_BPM")
    private TipoProcedimiento tipoProcedimientoBPMHijo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_FAP_ID")
    private DDFaseProcesal faseProcesal;

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
     * @return the subtipoTarea
     */
    public SubtipoTarea getSubtipoTarea() {
        return subtipoTarea;
    }

    /**
     * @param subtipoTarea the subtipoTarea to set
     */
    public void setSubtipoTarea(SubtipoTarea subtipoTarea) {
        this.subtipoTarea = subtipoTarea;
    }

    /**
     * @return the tipoProcedimiento
     */
    public TipoProcedimiento getTipoProcedimiento() {
        return tipoProcedimiento;
    }

    /**
     * @param tipoProcedimiento the tipoProcedimiento to set
     */
    public void setTipoProcedimiento(TipoProcedimiento tipoProcedimiento) {
        this.tipoProcedimiento = tipoProcedimiento;
    }

    /**
     * @return Devuelve el script groovy de validaci�n de la pantalla
     */
    public String getScriptValidacion() {
        return scriptValidacion;
    }

    /**
     * Define el script groovy de validaci�n de la pantalla.
     * @param scriptValidacion script groovy de validaci�n
     */
    public void setScriptValidacion(String scriptValidacion) {
        this.scriptValidacion = scriptValidacion;
    }

    /**
     * @return Devuelve el script groovy de decisiónde la pantalla
     */
    public String getScriptDecision() {
        return scriptDecision;
    }

    /**
     * Define el script groovy de decisiónde la pantalla.
     * @param scriptDecision script groovy de decisi�n
     */
    public void setScriptDecision(String scriptDecision) {
        this.scriptDecision = scriptDecision;
    }

    /**
     * @return Devuelve el JSP que se encarga de generar la vista
     */
    public String getView() {
        return view;
    }

    /**
     * Setea el JSP que se encarga de generar la vista.
     * @param view JSP de la vista
     */
    public void setView(String view) {
        this.view = view;
    }

    /**
     * @return Devuelve un booleano que indica si se trata de una tarea para un supervisor (true) o para un gestor (false)
     */
    public Boolean getSupervisor() {
        return supervisor;
    }

    /**
     * Define si la tarea está definida para un supervisor (true) o para un gestor (false).
     * @param supervisor Si la visibilidad de la tarea es para un supervisor
     */
    public void setSupervisor(Boolean supervisor) {
        this.supervisor = supervisor;
    }

    /**
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
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
     * @return the codigo
     */
    public String getCodigo() {
        return codigo;
    }

    /**
     * @param codigo the codigo to set
     */
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    /**
     * tostring.
     * @return tostrring
     */
    @Override
    public String toString() {
        if (this.descripcion != null && this.descripcion.equals("")) { return this.descripcion; }
        return super.toString();
    }

    /**
     * @return the scriptValidacionJBPM
     */
    public String getScriptValidacionJBPM() {
        return scriptValidacionJBPM;
    }

    /**
     * @param scriptValidacionJBPM the scriptValidacionJBPM to set
     */
    public void setScriptValidacionJBPM(String scriptValidacionJBPM) {
        this.scriptValidacionJBPM = scriptValidacionJBPM;
    }

    /**
     * @return the tipoProcedimientoBPMHijo
     */
    public TipoProcedimiento getTipoProcedimientoBPMHijo() {
        return tipoProcedimientoBPMHijo;
    }

    /**
     * @param tipoProcedimientoBPMHijo the tipoProcedimientoBPMHijo to set
     */
    public void setTipoProcedimientoBPMHijo(TipoProcedimiento tipoProcedimientoBPMHijo) {
        this.tipoProcedimientoBPMHijo = tipoProcedimientoBPMHijo;
    }

    /**
     * @return the alertNoRetorno
     */
    public String getAlertNoRetorno() {
        return alertNoRetorno;
    }

    /**
     * @param alertNoRetorno the alertNoRetorno to set
     */
    public void setAlertNoRetorno(String alertNoRetorno) {
        this.alertNoRetorno = alertNoRetorno;
    }

    /**
     * @return the alertVueltaAtras
     */
    public String getAlertVueltaAtras() {
        return alertVueltaAtras;
    }

    /**
     * @param alertVueltaAtras the alertVueltaAtras to set
     */
    public void setAlertVueltaAtras(String alertVueltaAtras) {
        this.alertVueltaAtras = alertVueltaAtras;
    }

    /**
     * @param faseProcesal the faseProcesal to set
     */
    public void setFaseProcesal(DDFaseProcesal faseProcesal) {
        this.faseProcesal = faseProcesal;
    }

    /**
     * @return the faseProcesal
     */
    public DDFaseProcesal getFaseProcesal() {
        return faseProcesal;
    }

}
