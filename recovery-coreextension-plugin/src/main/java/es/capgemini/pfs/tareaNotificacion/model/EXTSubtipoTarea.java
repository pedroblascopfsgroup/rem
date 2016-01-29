package es.capgemini.pfs.tareaNotificacion.model;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;

@Entity
public class EXTSubtipoTarea extends SubtipoTarea {

    private static final long serialVersionUID = 8638975817191955510L;

    public static final String CODIGO_TAREA_GESTOR_CONFECCION_EXPTE = "600";
    public static final String CODIGO_TAREA_SUPERVISOR_CONFECCION_EXPTE = "601";
    public static final String CODIGO_TAREA_GESTOR_ADMINISTRATIVO = "TCGA";
    public static final String CODIGO_TAREA_RESPONSABLE_CONCURSAL = "TCRC";
    
    public static final String CODIGO_TAREA_RESPONSABLE_GESTOR_ADJUDICACION = "100";
    public static final String CODIGO_TAREA_RESPONSABLE_GESTOR_SANEAMIENTO = "101";
    public static final String CODIGO_TAREA_RESPONSABLE_SUPERVISOR_ADJUDICACION = "102";
    public static final String CODIGO_TAREA_RESPONSABLE_SUPERVISOR_SANEAMIENTO = "103";
    public static final String CODIGO_TAREA_RESPONSABLE_GESTOR_LLAVES = "104";
    public static final String CODIGO_TAREA_RESPONSABLE_GESTOR_DEPOSITARIO_LLAVES = "105";
    
    public static final String CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL_SEG = "501";
    public static final String CODIGO_TAREA_PRORROGA_TOMA_DECISION = "503";
    public static final String CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR_EXPTE = "583";
    public static final String CODIGO_TAREA_COMUNICACION_DE_GESTOR_EXPTE = "584";

    public static final String CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR_EXPTE = "585";
    public static final String CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR_EXPTE = "586";
    public static final String CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR_EXPTE = "587";
    public static final String CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR_EXPTE = "588";
    public static final String CODIGO_NOTIFICACION_GESTOR_PROPUESTA_SUBASTA = "NTGPS";
    
    //INTERCOMUNICACIONES
    public static final String CODIGO_NOTIFICACION_INTERCOMUNICACION = "589";
    public static final String CODIGO_TAREA_COMUNICACION_INTERCOMUNICACION = "590";

    //TAREAS ANOTACIONES
    public static final String CODIGO_ANOTACION_TAREA = "700";
    public static final String CODIGO_ANOTACION_NOTIFICACION = "701";
    
    //PREVISIONES
    public static final String CODIGO_PREVISION_ANOTACION_TAREA = "750";
    
    public static final String CODIGO_ANOTACION_GENERICA_TAREA = "99700";
    public static final String CODIGO_ANOTACION_GENERICA_NOTIFICACION = "99701";
    
    //COMUNICACIONES GESTOR Y SUPERVISOR CONFECCI�N DE EXPEDIENTES
    public static final String CODIGO_TAREA_COMUNICACION_GESTOR_CONFECCION_EXPTE = "602";
    public static final String CODIGO_TAREA_COMUNICACION_SUPERVISOR_CONFECCION_EXPTE = "603";
    public static final String CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_GESTOR_CONFECCION_EXPTE = "606";
    public static final String CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_SUPERVISOR_CONFECCION_EXPTE = "607";
    public static final String CODIGO_NOTIFICACION_COMUNICACION_GESTOR_CONFECCION_EXPTE = "604";
    public static final String CODIGO_NOTIFICACION_COMUNICACION_SUPERVISOR_CONFECCION_EXPTE = "605";
    public static final String CODIGO_PROPUESTA_DECISION_SUPERVISOR_CONFECCION_EXPTE = "608";
    public static final String CODIGO_ACEPTACION_DECISION_PROCEDIMIENTO_GESTOR_CONFECCION_EXPTE = "609";
    public static final String CODIGO_ACEPTACION_DECISION_PROCEDIMIENTO_GESTOR_2_CONFECCION_EXPTE = "610";    
    
    ///NOTIFICACIONES DE ACUERDOS
    public static final String CODIGO_NOTIFICACION_ACUERDOS = "NOTIF_ACU";

    public static final String CODIGO_ACEPTACION_DECISION_PROCEDIMIENTO_GESTOR = "9999999999";
    
    //ACUERDO CERRADO 
    public static final String CODIGO_ACUERDO_CERRADO_POR_GESTOR = "52";
    public static final String CODIGO_ACUERDO_CERRADO_POR_SUPERVISOR = "56";
    
    // PRECONTENCIOSO
    public static final String CODIGO_PRECONTENCIOSO_SUPERVISOR = "PCO_SUP";
    public static final String CODIGO_PRECONTENCIOSO_TAREA_GESTORIA = "PCO_GEST";
    public static final String CODIGO_PRECONTENCIOSO_TAREA_GESTOR = "PCO_PREDOC";
    public static final String CODIGO_PRECONTENCIOSO_TAREA_LETRADO = "PCO_LET";
    public static final String CODIGO_PRECONTENCIOSO_TAREA_GESTOR_LIQUIDACIONES = "PCO_CM_GL";
    public static final String CODIGO_PRECONTENCIOSO_TAREA_GESTOR_DOCUMENTOS = "PCO_CM_GD";
    public static final String CODIGO_PRECONTENCIOSO_TAREA_GESTOR_ESTUDIO = "PCO_CM_GE";

    @ManyToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DD_TGE_ID")
    private EXTDDTipoGestor tipoGestor;

    public void setTipoGestor(EXTDDTipoGestor tipoGestor) {
        this.tipoGestor = tipoGestor;
    }

    public EXTDDTipoGestor getTipoGestor() {
        return tipoGestor;
    }

    //	@Override
    //	public Boolean getGestor() {
    //		if (!Checks.esNulo(super.getGestor())) {
    //			return super.getGestor();
    //		} else if ((tipoGestor != null)
    //				&& (tipoGestor.getCodigo()
    //						.equals(EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR))) {
    //			return false;
    //		} else {
    //			return true;
    //		}
    //	}

}
