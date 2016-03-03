package es.capgemini.pfs.tareaNotificacion.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Representa un subtipo de tarea.
 *
 * @author pamuller
 */
@Entity
@Table(name = "dd_sta_subtipo_tarea_base", schema = "${master.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class SubtipoTarea implements Serializable, Auditable {

    public static final String CODIGO_GESTION_SEGUIMIENTO_SISTEMATICO = "98";
    public static final String CODIGO_GESTION_SEGUIMIENTO_SINTOMATICO = "99";
    public static final String CODIGO_GESTION_VENCIDOS = "1";
    public static final String CODIGO_COMPLETAR_EXPEDIENTE = "2";
    public static final String CODIGO_REVISAR_EXPEDIENE = "3";
    public static final String CODIGO_DECISION_COMITE = "4";
    public static final String CODIGO_FORMALIZAR_PROPUESTA = "FZAR_PPUESTA";
    public static final String CODIGO_SOLICITAR_PRORROGA_CE = "5";
    public static final String CODIGO_SOLICITAR_PRORROGA_RE = "6";
    public static final String CODIGO_NOTIFICACION_CONTRATO_CANCELADO = "7";
    public static final String CODIGO_NOTIFICACION_SALDO_REDUCIDO = "8";
    public static final String CODIGO_NOTIFICACION_CLIENTE_CANCELADO = "9";
    public static final String CODIGO_NOTIFICACION_EXPEDIENTE_CERRADO = "10";
    public static final String CODIGO_NOTIFICACION_CONTRATO_PAGADO = "11";
    public static final String CODIGO_NOTIFICACION_CE_VENCIDA = "12";
    public static final String CODIGO_NOTIFICACION_RE_VENCIDA = "13";
    public static final String CODIGO_NOTIFICACION_DC_VENCIDA = "14";
    public static final String CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR = "15";
    public static final String CODIGO_TAREA_COMUNICACION_DE_GESTOR = "16";
    public static final String CODIGO_SOLICITUD_CANCELACION_EXPEDIENTE_DE_SUPERVISOR = "17";
    public static final String CODIGO_NOTIFICACION_SOLICITUD_CANCELACION_EXPEDIENTE_RECHAZADA = "18";
    public static final String CODIGO_TAREA_CE_COMPLETADA = "19";
    public static final String CODIGO_TAREA_RE_COMPLETADA = "20";
    public static final String CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_CE = "21";
    public static final String CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_RE = "22";
    public static final String CODIGO_NOTIFICACION_CIERRA_SESION = "23";
    public static final String CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR = "24";
    public static final String CODIGO_NOTIFICACION_EXPEDIENTE_DECISION_TOMADA = "25";
    public static final String CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR = "26";
    public static final String CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR = "27";
    public static final String CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR = "28";
    public static final String CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL = "29";
    public static final String CODIGO_TAREA_SOLICITUD_PREASUNTO = "30";
    public static final String CODIGO_TAREA_VERIFICAR_TELECOBRO = "31";
    public static final String CODIGO_TAREA_SOLICITUD_EXCLUSION_TELECOBRO = "32";
    public static final String CODIGO_TAREA_RESPUESTA_SOLICITUD_EXCLUSION_TELECOBRO = "33";
    public static final String CODIGO_NOTIFICACION_RECHAZAR_CANCELAC_EXPEDIENTE = "34";

    public static final String CODIGO_RECOPILAR_DOCUMENTACION_PROCEDIMIENTO = "35";
    public static final String CODIGO_ACEPTAR_ASUNTO_GESTOR = "36";
    public static final String CODIGO_ACEPTAR_ASUNTO_SUPERVISOR = "37";
    public static final String CODIGO_ASUNTO_PROPUESTO = "38";

    public static final String CODIGO_PROCEDIMIENTO_EXTERNO_GESTOR = "39";
    public static final String CODIGO_PROCEDIMIENTO_EXTERNO_SUPERVISOR = "40";
    public static final String CODIGO_SOLICITAR_PRORROGA_PROCEDIMIENTO = "41";
    public static final String CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_PROCEDIMIENTO = "42";

    public static final String CODIGO_ACTUALIZAR_ESTADO_RECURSO_GESTOR = "43";
    public static final String CODIGO_ACTUALIZAR_ESTADO_RECURSO_SUPERVISOR = "44";
    public static final String CODIGO_NOTIFICACION_RECURSO = "45";

    public static final String CODIGO_TOMA_DECISION_BPM = "46";
    public static final String CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO = "47";
    public static final String CODIGO_ACEPTACION_DECISION_PROCEDIMIENTO = "48";

    public static final String CODIGO_ACUERDO_PROPUESTO = "49";
    public static final String CODIGO_ACUERDO_RECHAZADO = "50";
    public static final String CODIGO_GESTIONES_CERRAR_ACUERDO = "51";
    public static final String CODIGO_ACUERDO_CERRADO = "52";

    public static final String CODIGO_EVENTO_PROPUESTA = "PROP_EVENT";
    
    public static final String CODIGO_ACEPTACION_ACUERDO = "ACP_ACU";
    public static final String CODIGO_REVISION_ACUERDO_ACEPTADO = "REV_ACU";
    public static final String CODIGO_ACUERDO_GESTIONES_CIERRE = "GST_CIE_ACU";
    public static final String CODIGO_CUMPLIMIENTO_ACUERDO = "CUMPLI_ACU";

    public static final String CODIGO_TAREA_UMBRAL = "53";

    public static final String CODIGO_SOLICITAR_PRORROGA_DC = "54";
    public static final String CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_DC = "55";

    public static final String CODIGO_TAREA_PROPUESTA_BORRADO_OBJETIVO = "57";
    public static final String CODIGO_ACEPTACION_PROPUESTA_BORRADO_OBJETIVO = "58";
    public static final String CODIGO_RECHAZO_PROPUESTA_BORRADO_OBJETIVO = "59";

    public static final String CODIGO_TAREA_PROPUESTA_OBJETIVO = "60";
    public static final String CODIGO_ACEPTACION_PROPUESTA_OBJETIVO = "61";
    public static final String CODIGO_RECHAZO_PROPUESTA_OBJETIVO = "62";
    public static final String CODIGO_NOTIF_PROPUESTA_OBJETIVO_ACEPTADO = "66";
    public static final String CODIGO_NOTIF_PROPUESTA_OBJETIVO_RECHAZADO = "67";

    public static final String CODIGO_TAREA_PROPUESTA_CUMPLIMIENTO_OBJETIVO = "63";
    public static final String CODIGO_ACEPTACION_PROPUESTA_CUMPLIMIENTO_OBJETIVO = "64";
    public static final String CODIGO_TAREA_JUSTIFICAR_INCUMPLIMIENTO_OBJETIVO = "65";
    
    public static final String CODIGO_NOTIFICACION_GESTOR_PROPUESTA_SUBASTA = "NTGPS";

    public static final String CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL_SEG = "501";
    public static final String CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL_GESTION_DEUDA = "SOLEXPMGDEUDA";
    
    // nuevos tipos para tareas de expediente de recobro
    public static final String CODIGO_TAREA_EXP_RECOBRO_MARCADO="REC_MARCADO_EXP";
    public static final String CODIGO_TAREA_EXP_RECOBRO_META_VOLANTE_OK="REC_META_VOL_OK";
    public static final String CODIGO_TAREA_EXP_RECOBRO_META_VOLANTE_KO="REC_META_VOL_KO";
    
    public static final String CODIGO_TAREA_EN_SANCION="ENSAN";
    public static final String CODIGO_TAREA_SANCIONADO="SANC";

    public static final String CODIGO_NOTIFICACION_EXPEDIENTE_NUEVO_RIESGO = "1000";

    // OJO: Todas los c�digos de tareas deben estar en shared.js.jsp, y
    // tenerlo en cuenta tambien en listadoTareas.jsp

    private static final long serialVersionUID = -1929265807024971783L;

    @Id
    @Column(name = "DD_STA_ID")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "DD_TAR_ID")
    private TipoTarea tipoTarea;

    @Column(name = "DD_STA_CODIGO")
    private String codigoSubtarea;

    @Column(name = "DD_STA_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_STA_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @Column(name = "DD_STA_GESTOR")
    private Boolean gestor;

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
     * @param id
     *            the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the codigoSubtarea
     */
    public String getCodigoSubtarea() {
        return codigoSubtarea;
    }

    /**
     * @param codigoSubtarea
     *            the codigoSubtarea to set
     */
    public void setCodigoSubtarea(String codigoSubtarea) {
        this.codigoSubtarea = codigoSubtarea;
    }

    /**
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion
     *            the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * @return the descripcionLarga
     */
    public String getDescripcionLarga() {
        return descripcionLarga;
    }

    /**
     * @param descripcionLarga
     *            the descripcionLarga to set
     */
    public void setDescripcionLarga(String descripcionLarga) {
        this.descripcionLarga = descripcionLarga;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria
     *            the auditoria to set
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
     * @param version
     *            the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @return the tipoTarea
     */
    public TipoTarea getTipoTarea() {
        return tipoTarea;
    }

    /**
     * @param tipoTarea
     *            the tipoTarea to set
     */
    public void setTipoTarea(TipoTarea tipoTarea) {
        this.tipoTarea = tipoTarea;
    }

    /**
     * @return the gestor
     */
    public Boolean getGestor() {
        return gestor;
    }

    /**
     * @param gestor
     *            the gestor to set
     */
    public void setGestor(Boolean gestor) {
        this.gestor = gestor;
    }
}
