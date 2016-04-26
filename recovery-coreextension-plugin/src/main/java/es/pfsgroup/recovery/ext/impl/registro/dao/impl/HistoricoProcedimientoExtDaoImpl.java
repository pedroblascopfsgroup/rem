package es.pfsgroup.recovery.ext.impl.registro.dao.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.hibernate.SQLQuery;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.decisionProcedimiento.model.DDEstadoDecision;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.registro.model.HistoricoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.pfsgroup.recovery.ext.api.asunto.EXTHistoricoProcedimiento;
import es.pfsgroup.recovery.ext.impl.registro.dao.HistoricoProcedimientoExtDao;

@Repository("HistoricoProcedimientoExtDao")
public class HistoricoProcedimientoExtDaoImpl extends AbstractEntityDao<EXTHistoricoProcedimiento, Long> implements HistoricoProcedimientoExtDao{

	@Override
	public List<EXTHistoricoProcedimiento> getListByProcedimiento(
			Long idProcedimiento) {
		List<EXTHistoricoProcedimiento> result = new ArrayList<EXTHistoricoProcedimiento>();

        try {
            String query = "SELECT TIPO_ENTIDAD, ID_ENTIDAD, RESPUESTA, NOMBRE, FECHA, FECHA_INI, FECHA_VENC, FECHA_FIN, USUARIO,"
            		+ "DECODE(USU_RES, null, (SELECT DISTINCT(USU_USERNAME) FROM  ${master.schema}.USU_USUARIOS, VTAR_TAREA_VS_USUARIO VTAR WHERE VTAR.USU_PENDIENTES = USU_ID AND VTAR.TAR_ID = TAREA), USU_RES) AS RESPONSABLE, "
            		+ "FECHA_VENC_REAL, STA_CODIGO, TAR_DESCRIPCION, TAP_CODIGO FROM ("
                    + getConsultaAgregada() + ") WHERE PRC_ID = " + idProcedimiento + " ORDER BY FECHA ASC";

            //System.out.println(query);

            SQLQuery sqlQuery = this.getSession().createSQLQuery(query);

            //Mapeamos el resultado
            @SuppressWarnings("unchecked")
			Iterator<Object[]> it = (sqlQuery.list().iterator());
            while (it.hasNext()) {
                Object[] vector = it.next();

                EXTHistoricoProcedimiento hProcedimiento = new EXTHistoricoProcedimiento();
                hProcedimiento.setTipoEntidad(Long.parseLong(((BigDecimal) vector[0]).toString()));
                hProcedimiento.setIdEntidad(Long.parseLong(((BigDecimal) vector[1]).toString()));
                hProcedimiento.setRespuesta(Boolean.parseBoolean(((BigDecimal) vector[2]).toString()));
                hProcedimiento.setNombreTarea((String) vector[3]);
                hProcedimiento.setFechaRegistro((Date) vector[4]);
                hProcedimiento.setFechaIni((Date) vector[5]);//FechaIni
                hProcedimiento.setFechaVencimiento((Date) vector[6]);//FechaVencimiento
                hProcedimiento.setFechaFin((Date) vector[7]);//FechaFin
                hProcedimiento.setNombreUsuario((String) vector[8]);//Usuario
                hProcedimiento.setUsuarioResponsable((String) vector[9]);//UsuarioResponsable
                hProcedimiento.setFechaVencReal((Date) vector[10]);//FechaVencReal                
                if(vector[11] != null){
                	hProcedimiento.setSubtipoTarea(vector[11].toString());//dd_sta_codigo
                }else{
                	hProcedimiento.setSubtipoTarea("");
                }
                hProcedimiento.setDescripcionTarea((String) vector[12]);
                hProcedimiento.setCodigoTarea((String) vector[13]); 
                result.add(hProcedimiento);
            }
        } catch (DataAccessException e) {
            logger.error("Error al consultar el histórico de tareas de un procedimiento", e);
        }
        return result;
	}
	
	private String getConsultaAgregada() {
        AbstractMessageSource ms = MessageUtils.getMessageSource();

        return "SELECT TIPO_ENTIDAD, ID_ENTIDAD, TAREA, RESPUESTA, PRC_ID, NOMBRE, FECHA, FECHA_INI, FECHA_VENC, FECHA_FIN, USUARIO, USU_RES, FECHA_VENC_REAL, STA_CODIGO, TAR_DESCRIPCION, TAP_CODIGO FROM "
        //Tareas externa
                + "( " + "    SELECT "
                + HistoricoProcedimiento.TIPO_ENTIDAD_TAREA
                //Tareas externas canceladas
                + " AS TIPO_ENTIDAD, TEX.TAR_ID AS ID_ENTIDAD, TEX.TAR_ID AS TAREA, 0 AS RESPUESTA, TAR.PRC_ID AS PRC_ID, TAR_TAREA AS NOMBRE, TEX.FECHACREAR AS FECHA"
                + ", TAR.TAR_FECHA_INI AS FECHA_INI, TAR.TAR_FECHA_VENC AS FECHA_VENC, TAR.TAR_FECHA_FIN AS FECHA_FIN, TAR.USUARIOCREAR AS USUARIO, TAR.USUARIOBORRAR AS USU_RES, TAR.TAR_FECHA_VENC_REAL AS FECHA_VENC_REAL, STA5.DD_STA_CODIGO AS STA_CODIGO, TAR.TAR_DESCRIPCION AS TAR_DESCRIPCION, TAP.TAP_CODIGO AS TAP_CODIGO "
                + "FROM TAR_TAREAS_NOTIFICACIONES TAR, TEX_TAREA_EXTERNA TEX, TAP_TAREA_PROCEDIMIENTO TAP, ${master.schema}.DD_STA_SUBTIPO_TAREA_BASE STA5 WHERE TEX.TAR_ID = TAR.TAR_ID "
                + "AND TAR.PRC_ID IS NOT NULL AND TAP.TAP_ID = TEX.TAP_ID AND (TEX_CANCELADA = 0 OR TEX_CANCELADA IS NULL) AND TAR.DD_STA_ID = STA5.DD_STA_ID "
                + "    UNION SELECT "
                + HistoricoProcedimiento.TIPO_ENTIDAD_TAREA_CANCELADA
                + " AS TIPO_ENTIDAD, TEX.TAR_ID AS ID_ENTIDAD, TEX.TAR_ID AS TAREA, 0 AS RESPUESTA, TAR.PRC_ID AS PRC_ID, TAR_TAREA AS NOMBRE, TEX.FECHACREAR AS FECHA"
                + ", TAR.TAR_FECHA_INI AS FECHA_INI, TAR.TAR_FECHA_VENC AS FECHA_VENC, TAR.TAR_FECHA_FIN AS FECHA_FIN, TAR.USUARIOCREAR AS USUARIO, TAR.USUARIOBORRAR AS USU_RES, TAR.TAR_FECHA_VENC_REAL AS FECHA_VENC_REAL, STA6.DD_STA_CODIGO AS STA_CODIGO, TAR.TAR_DESCRIPCION AS TAR_DESCRIPCION, TAP.TAP_CODIGO AS TAP_CODIGO "
                + "FROM TAR_TAREAS_NOTIFICACIONES TAR, TEX_TAREA_EXTERNA TEX, TAP_TAREA_PROCEDIMIENTO TAP, ${master.schema}.DD_STA_SUBTIPO_TAREA_BASE STA6 WHERE TEX.TAR_ID = TAR.TAR_ID AND TAP.TAP_ID = TEX.TAP_ID AND TAR.PRC_ID IS NOT NULL AND TEX_CANCELADA = 1 "
                + " AND TAR.DD_STA_ID = STA6.DD_STA_ID "
                + "    UNION SELECT "
                //Tareas comunicacion que no tengan ninguna tarea notificacion asociada (comunicaciones sin respuesta)
                + HistoricoProcedimiento.TIPO_ENTIDAD_COMUNICACION
                + ", TAR_ID, TAR_ID, 0, PRC.PRC_ID, TAR_TAREA, TAR.FECHACREAR, TAR.TAR_FECHA_INI, TAR.TAR_FECHA_VENC, TAR.TAR_FECHA_FIN, TAR.USUARIOCREAR, TAR.USUARIOBORRAR, TAR.TAR_FECHA_VENC_REAL AS FECHA_VENC_REAL, STA.DD_STA_CODIGO AS STA_CODIGO, TAR.TAR_DESCRIPCION AS TAR_DESCRIPCION, NULL "
                + "FROM TAR_TAREAS_NOTIFICACIONES TAR, ${master.schema}.DD_STA_SUBTIPO_TAREA_BASE STA, PRC_PROCEDIMIENTOS PRC, ASU_ASUNTOS ASU "
                + "WHERE TAR.DD_STA_ID = STA.DD_STA_ID AND STA.DD_STA_CODIGO IN ('"
                + SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR
                + "', '"
                + SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR
                + "', '"
                + SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR
                + "', '"
                + SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR
                + "', '"
                + EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_GESTOR_CONFECCION_EXPTE
                + "', '"
                + EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_SUPERVISOR_CONFECCION_EXPTE
                + "', '"
                + EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_GESTOR_CONFECCION_EXPTE
                + "', '"
                + EXTSubtipoTarea.CODIGO_TAREA_COMUNICACION_GESTOR_CONFECCION_EXPTE
                + "', '"
                + EXTSubtipoTarea.CODIGO_TAREA_COMUNICACION_SUPERVISOR_CONFECCION_EXPTE
                + "') AND TAR.ASU_ID = ASU.ASU_ID AND PRC.ASU_ID = ASU.ASU_ID "
                + " AND TAR_ID NOT IN (SELECT TAR2.TAR_TAR_ID FROM TAR_TAREAS_NOTIFICACIONES TAR2, ${master.schema}.DD_STA_SUBTIPO_TAREA_BASE STA2 "
                + "WHERE TAR2.DD_STA_ID = STA2.DD_STA_ID AND STA2.DD_STA_CODIGO IN ('"
                + SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR
                + "', '"
                + SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR
                + "') AND TAR2.ASU_ID = ASU.ASU_ID AND PRC.ASU_ID = ASU.ASU_ID) AND TAR.PRC_ID = PRC.PRC_ID "
                //Tareas comunicacion con notificacion (comunicaciones con respuesta)
                + "    UNION SELECT "
                + HistoricoProcedimiento.TIPO_ENTIDAD_COMUNICACION
                + ", TAR_ID, TAR_ID, 0, PRC.PRC_ID, TAR_TAREA, TAR.FECHACREAR, TAR.TAR_FECHA_INI, TAR.TAR_FECHA_VENC, TAR.TAR_FECHA_FIN, TAR.USUARIOCREAR, TAR.USUARIOBORRAR, TAR.TAR_FECHA_VENC_REAL AS FECHA_VENC_REAL, STA.DD_STA_CODIGO AS STA_CODIGO, TAR.TAR_DESCRIPCION AS TAR_DESCRIPCION, NULL "
                + "FROM TAR_TAREAS_NOTIFICACIONES TAR, ${master.schema}.DD_STA_SUBTIPO_TAREA_BASE STA, PRC_PROCEDIMIENTOS PRC, ASU_ASUNTOS ASU "
                + "WHERE TAR.DD_STA_ID = STA.DD_STA_ID AND STA.DD_STA_CODIGO IN ('"
                + SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR
                + "', '"
                + SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR
                + "', '"
                + EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_GESTOR_CONFECCION_EXPTE
                + "', '"
                + EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_SUPERVISOR_CONFECCION_EXPTE
                + "') AND TAR.ASU_ID = ASU.ASU_ID AND PRC.ASU_ID = ASU.ASU_ID AND TAR.PRC_ID = PRC.PRC_ID "
                + "    UNION SELECT "
                //Peticiones de recurso
                + HistoricoProcedimiento.TIPO_ENTIDAD_PETICION_RECURSO
                + ", REC.RCR_ID, TAR.TAR_ID, 0, TAR.PRC_ID, '"
                + ms.getMessage("historicoProcedimiento.recursoInterpuesto", new Object[] {}, "**Recurso interpuesto", MessageUtils.DEFAULT_LOCALE)
                + "', REC.FECHACREAR, REC.FECHACREAR, null, null, REC.USUARIOCREAR, TAR.USUARIOBORRAR, null, STA7.DD_STA_CODIGO AS STA_CODIGO, TAR.TAR_DESCRIPCION AS TAR_DESCRIPCION, NULL FROM TAR_TAREAS_NOTIFICACIONES TAR, RCR_RECURSOS_PROCEDIMIENTOS REC, ${master.schema}.DD_STA_SUBTIPO_TAREA_BASE STA7 "
                + "WHERE REC.TAR_ID = TAR.TAR_ID AND TAR.PRC_ID IS NOT NULL AND TAR.DD_STA_ID = STA7.DD_STA_ID "
                + "    UNION SELECT "
                //Respuestas de recurso
                + HistoricoProcedimiento.TIPO_ENTIDAD_RESPUESTA_RECURSO
                + ", REC.RCR_ID, TAR.TAR_ID, 1, TAR.PRC_ID, '"
                + ms.getMessage("historicoProcedimiento.recursoResuelto", new Object[] {}, "**Recurso resuelto", MessageUtils.DEFAULT_LOCALE)
                + "', REC.FECHAMODIFICAR, REC.FECHACREAR, null, REC.FECHAMODIFICAR, REC.USUARIOMODIFICAR, TAR.USUARIOBORRAR, null, STA8.DD_STA_CODIGO AS STA_CODIGO, TAR.TAR_DESCRIPCION AS TAR_DESCRIPCION, NULL FROM TAR_TAREAS_NOTIFICACIONES TAR, RCR_RECURSOS_PROCEDIMIENTOS REC, ${master.schema}.DD_STA_SUBTIPO_TAREA_BASE STA8 "
                + "WHERE REC.TAR_ID = TAR.TAR_ID AND TAR.PRC_ID IS NOT NULL AND REC.RCR_FECHA_RESOLUCION IS NOT NULL AND TAR.DD_STA_ID = STA8.DD_STA_ID"
                + "    UNION SELECT "
                //Peticiones de prorroga
                + HistoricoProcedimiento.TIPO_ENTIDAD_PETICION_PRORROGA
                + ", SPR.SPR_ID, TAR.TAR_ID, 0, TAR.PRC_ID, '"
                + ms.getMessage("historicoProcedimiento.peticionProrroga", new Object[] {}, "**Petición de prorroga", MessageUtils.DEFAULT_LOCALE)
                + "', SPR.FECHACREAR, SPR.FECHACREAR, null, null, SPR.USUARIOCREAR, TAR.USUARIOBORRAR, null, STA9.DD_STA_CODIGO AS STA_CODIGO, TAR.TAR_DESCRIPCION AS TAR_DESCRIPCION, NULL FROM TAR_TAREAS_NOTIFICACIONES TAR, SPR_SOLICITUD_PRORROGA SPR, ${master.schema}.DD_STA_SUBTIPO_TAREA_BASE STA9 "
                + "WHERE SPR.TAR_ID = TAR.TAR_ID AND TAR.PRC_ID IS NOT NULL AND TAR.DD_STA_ID = STA9.DD_STA_ID"
                + "    UNION SELECT "
                //Respuestas de prorroga
                + HistoricoProcedimiento.TIPO_ENTIDAD_RESPUESTA_PRORROGA
                + ", SPR.SPR_ID, TAR.TAR_ID, 1, TAR.PRC_ID, '"
                + ms.getMessage("historicoProcedimiento.respuestaProrroga", new Object[] {}, "**Respuesta de prorroga", MessageUtils.DEFAULT_LOCALE)
                + "', SPR.FECHAMODIFICAR, SPR.FECHACREAR, null, SPR.FECHAMODIFICAR, SPR.USUARIOMODIFICAR, TAR.USUARIOBORRAR, null, STA10.DD_STA_CODIGO AS STA_CODIGO, TAR.TAR_DESCRIPCION AS TAR_DESCRIPCION, NULL FROM TAR_TAREAS_NOTIFICACIONES TAR, SPR_SOLICITUD_PRORROGA SPR, ${master.schema}.DD_STA_SUBTIPO_TAREA_BASE STA10 "
                + "WHERE SPR.TAR_ID = TAR.TAR_ID AND TAR.PRC_ID IS NOT NULL AND SPR.DD_RPR_ID IS NOT NULL AND TAR.DD_STA_ID = STA10.DD_STA_ID"
                + "    UNION SELECT "
                //Peticiones de acuerdos
                + HistoricoProcedimiento.TIPO_ENTIDAD_PETICION_ACUERDO
                + ", ACU.ACU_ID, ACU.ACU_ID,0, PRC.PRC_ID, '"
                + ms.getMessage("historicoProcedimiento.propuestaAcuerdo", new Object[] {}, "**Propuesta de acuerdo", MessageUtils.DEFAULT_LOCALE)
                + "', ACU.FECHACREAR, ACU.FECHACREAR, null, null, ACU.USUARIOCREAR, ACU.USUARIOMODIFICAR, null, null, null, NULL FROM ACU_ACUERDO_PROCEDIMIENTOS ACU, PRC_PROCEDIMIENTOS PRC"
                + ", ASU_ASUNTOS ASU, ${master.schema}.DD_EAC_ESTADO_ACUERDO EAC "
                + "WHERE PRC.ASU_ID = ASU.ASU_ID AND ACU.ASU_ID = ASU.ASU_ID AND ACU.DD_EAC_ID = EAC.DD_EAC_ID " //AND EAC.DD_EAC_CODIGO IN ('"
                //+ DDEstadoAcuerdo.ACUERDO_PROPUESTO
                //+ "', '"
                //+ DDEstadoAcuerdo.ACUERDO_EN_CONFORMACION
                //+ "') "
                + "    UNION SELECT "
                //Respuestas de acuerdos
                + HistoricoProcedimiento.TIPO_ENTIDAD_RESPUESTA_ACUERDO
                + ", ACU.ACU_ID, ACU.ACU_ID, 1, PRC.PRC_ID, '"
                + ms.getMessage("historicoProcedimiento.respuestaAcuerdo", new Object[] {}, "**Acuerdo ", MessageUtils.DEFAULT_LOCALE)
                + "' || eac.dd_eac_descripcion_larga, ACU.FECHAMODIFICAR, ACU.FECHAMODIFICAR, null, ACU.FECHAMODIFICAR, ACU.USUARIOMODIFICAR, ACU.USUARIOMODIFICAR, null, null, ACU.ACU_MOTIVO, NULL "
                + "FROM ACU_ACUERDO_PROCEDIMIENTOS ACU, PRC_PROCEDIMIENTOS PRC, ASU_ASUNTOS ASU, ${master.schema}.DD_EAC_ESTADO_ACUERDO EAC "
                + "WHERE PRC.ASU_ID = ASU.ASU_ID AND ACU.ASU_ID = ASU.ASU_ID AND ACU.DD_EAC_ID = EAC.DD_EAC_ID AND EAC.DD_EAC_CODIGO NOT IN ('"
                + DDEstadoAcuerdo.ACUERDO_PROPUESTO
                + "', '"
                + DDEstadoAcuerdo.ACUERDO_EN_CONFORMACION
                + "') "
                + "    UNION SELECT "
                //Peticiones de decision
                + HistoricoProcedimiento.TIPO_ENTIDAD_PETICION_DECISION
                + ", DPR.DPR_ID, DPR.DPR_ID, 0, PRC.PRC_ID, '"
                + ms.getMessage("historicoProcedimiento.propuestaDecision", new Object[] {}, "**Propuesta de decisión", MessageUtils.DEFAULT_LOCALE)
                + "', DPR.FECHACREAR, DPR.FECHACREAR, null, null, CASE WHEN ASU.SUP_ID IS NOT NULL THEN (SELECT USU.USU_USERNAME FROM USD_USUARIOS_DESPACHOS USD, ${master.schema}.USU_USUARIOS USU WHERE ASU.SUP_ID = USD.USD_ID AND USD.USU_ID = USU.USU_ID) "
                + " ELSE (SELECT DISTINCT USU.USU_USERNAME FROM GAA_GESTOR_ADICIONAL_ASUNTO GAA, ${master.schema}.DD_TGE_TIPO_GESTOR TGE, USD_USUARIOS_DESPACHOS USD, ${master.schema}.USU_USUARIOS USU WHERE GAA.ASU_ID = PRC.ASU_ID AND GAA.DD_TGE_ID = TGE.DD_TGE_ID "
                + " AND TGE.DD_TGE_CODIGO = '" + EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR + "' AND GAA.USD_ID = USD.USD_ID AND USD.USU_ID = USU.USU_ID) END, CASE WHEN ASU.SUP_ID IS NOT NULL THEN (SELECT USU.USU_USERNAME FROM USD_USUARIOS_DESPACHOS USD, ${master.schema}.USU_USUARIOS USU WHERE ASU.SUP_ID = USD.USD_ID AND USD.USU_ID = USU.USU_ID) "
                + " ELSE (SELECT DISTINCT USU.USU_USERNAME FROM GAA_GESTOR_ADICIONAL_ASUNTO GAA, ${master.schema}.DD_TGE_TIPO_GESTOR TGE, USD_USUARIOS_DESPACHOS USD, ${master.schema}.USU_USUARIOS USU WHERE GAA.ASU_ID = PRC.ASU_ID AND GAA.DD_TGE_ID = TGE.DD_TGE_ID "
                + " AND TGE.DD_TGE_CODIGO = '" + EXTDDTipoGestor.CODIGO_TIPO_GESTOR_SUPERVISOR + "' AND GAA.USD_ID = USD.USD_ID AND USD.USU_ID = USU.USU_ID) END, null, null, null, NULL FROM DPR_DECISIONES_PROCEDIMIENTOS DPR, PRC_PROCEDIMIENTOS PRC"
                + ", ${master.schema}.DD_EDE_ESTADOS_DECISION EDE, ASU_ASUNTOS ASU "
                + "WHERE DPR.PRC_ID = PRC.PRC_ID AND DPR.DD_EDE_ID = EDE.DD_EDE_ID AND PRC.ASU_ID = ASU.ASU_ID"
                + "    UNION SELECT "
                //Respuestas de decision
                + HistoricoProcedimiento.TIPO_ENTIDAD_RESPUESTA_DECISION + ", DPR.DPR_ID, DPR.DPR_ID, 1, PRC.PRC_ID, '"
                + ms.getMessage("historicoProcedimiento.respuestaDecision", new Object[] {}, "**Respuesta de decisión", MessageUtils.DEFAULT_LOCALE)
                + "', DPR.FECHAMODIFICAR, DPR.FECHACREAR, null, DPR.FECHAMODIFICAR, DPR.USUARIOMODIFICAR, DPR.USUARIOMODIFICAR, null, null, null, NULL FROM DPR_DECISIONES_PROCEDIMIENTOS DPR"
                + ", PRC_PROCEDIMIENTOS PRC, ${master.schema}.DD_EDE_ESTADOS_DECISION EDE "
                + "WHERE DPR.PRC_ID = PRC.PRC_ID AND DPR.DD_EDE_ID = EDE.DD_EDE_ID AND EDE.DD_EDE_CODIGO <> '" + DDEstadoDecision.ESTADO_PROPUESTO
                + "')";
    }

}
