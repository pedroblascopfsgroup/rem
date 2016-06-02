package es.capgemini.pfs.tareaNotificacion.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.politica.model.DDEstadoPolitica;
import es.capgemini.pfs.tareaNotificacion.dao.TareaNotificacionDao;
import es.capgemini.pfs.tareaNotificacion.dto.DtoBuscarTareaNotificacion;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.utils.StringUtils;
import es.capgemini.pfs.zona.model.DDZona;

/**
 * Implementación del dao de notificaciones para Hibenate.
 * @author pamuller
 *
 */
@Repository("TareaNotificacionDao")
public class TareaNotificacionDaoImpl extends AbstractEntityDao<TareaNotificacion, Long> implements TareaNotificacionDao {

    @Resource
    private PaginationManager paginationManager;

    private final Log logger = LogFactory.getLog(getClass());

    private static final String TRAER_TAREA_JUSTIFIACION_OBJETIVO = "select tn from TareaNotificacion tn where tn.auditoria.borrado = false and tn.objetivo.id = ? "
            + "and tn.subtipoTarea.codigoSubtarea = ? and tn.tipoEntidad.codigo =?";

    private static final String TRAER_TAREA_EXPEDIENTE = "select tn from TareaNotificacion tn left join  tn.expediente.estadoItinerario est where tn.estadoItinerario.codigo = est.codigo and tn.expediente = ? "
            + "and tn.subtipoTarea = ? and tn.tipoEntidad =?";
    private static final String TRAER_TODAS_TAREA_EXPEDIENTE = "from TareaNotificacion where expediente = ? ";
    private static final String TRAER_TODAS_TAREAS_CLIENTE = "from TareaNotificacion where cliente.id = ? ";
    private static final String TRAER_TAREA_CLIENTE = "select tn from TareaNotificacion tn left join  tn.cliente.estadoItinerario est where tn.estadoItinerario.codigo = est.codigo and tn.cliente = ? "
            + "and tn.subtipoTarea = ? and tn.tipoEntidad =?";
    private static final String TRAER_TAREAS_EXPEDIENTE_PENDIENTES = "select tn from TareaNotificacion tn left join  tn.expediente.estadoItinerario est left join tn.expediente.estadoItinerario.estados estados  where tn.estadoItinerario.codigo = est.codigo and tn.expediente.id = ? "
            + "and tn.auditoria.borrado = 0";
    private static final String TRAER_TAREAS_CLIENTE_PENDIENTES = "select tn from TareaNotificacion tn left join  tn.cliente.estadoItinerario est left join tn.cliente.estadoItinerario.estados estados where tn.estadoItinerario.codigo = est.codigo and tn.cliente.id = ? "
            + "and tn.auditoria.borrado = 0";
    private static final String TRAER_TAREAS_ASUNTO_PENDIENTES = "select tn from TareaNotificacion tn left join  tn.asunto.estadoItinerario est left join tn.asunto.estadoItinerario.estados estados where tn.estadoItinerario.codigo = est.codigo and tn.asunto.id = ? "
            + "and tn.auditoria.borrado = 0";

    private void cancelarTareas(List<TareaNotificacion> notificaciones) {
        for (TareaNotificacion notificacion : notificaciones) {
            logger.debug("CANCELANDO LA TAREA " + notificacion.getId());
            delete(notificacion);
        }
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public Integer getNumNotificaciones(String txtNotificacion, Long cliId, Long expId, Long asuId) {

        String consultaNumNotificaciones = "SELECT tn FROM TareaNotificacion tn WHERE tn.descripcionTarea like '" + txtNotificacion + "%' ";
        if (cliId != null) {
            consultaNumNotificaciones += " AND tn.cliente.id = " + cliId;
        }
        if (expId != null) {
            consultaNumNotificaciones += " AND tn.expediente.id = " + expId;
        }
        if (asuId != null) {
            consultaNumNotificaciones += " AND tn.asunto.id = " + asuId;
        }

        List<TareaNotificacion> notificaciones = getHibernateTemplate().find(consultaNumNotificaciones, null);

        Integer nNotificaciones = 0;
        if (notificaciones != null) {
            nNotificaciones = notificaciones.size();
        }

        return nNotificaciones;
    }

    /**
     * se hace override para que setee la fecha fin de la tarea.
     * @param tarea TareaNotificacion
     */
    @Override
    public void delete(TareaNotificacion tarea) {
        if (tarea == null) {
            logger.error("Error. Se ha intentado borrar una tarea nula");
            return;
        }
        tarea.setFechaFin(new Date());
        tarea.setTareaFinalizada(Boolean.TRUE);
        super.delete(tarea);
    }

    /**
     * Hace el borrado lï¿½gico de una tarea en base a un expediente.
     * @param expediente el expediente
     * @param subtipoTarea el subtipo de tarea
     * @param tipoEntidad el tipo de entidad
     */
    @SuppressWarnings("unchecked")
    public void borradoLogico(Expediente expediente, SubtipoTarea subtipoTarea, DDTipoEntidad tipoEntidad) {
        List<TareaNotificacion> notificaciones = getHibernateTemplate().find(TRAER_TAREA_EXPEDIENTE,
                new Object[] { expediente, subtipoTarea, tipoEntidad });
        cancelarTareas(notificaciones);
    }

    /**
     * Hace el borrado lï¿½gico de una tarea en base a un cliente.
     * @param cliente el cliente
     * @param subtipoTarea el subtipo de tarea
     * @param tipoEntidad el tipo de entidad
     */
    @SuppressWarnings("unchecked")
    public void borradoLogico(Cliente cliente, SubtipoTarea subtipoTarea, DDTipoEntidad tipoEntidad) {
        List<TareaNotificacion> notificaciones = getHibernateTemplate()
                .find(TRAER_TAREA_CLIENTE, new Object[] { cliente, subtipoTarea, tipoEntidad });
        cancelarTareas(notificaciones);
    }

    /**
     * borra todas las tareas asociadas a un expediente cancelado.
     * @param exp id del expediente
     */
    @SuppressWarnings("unchecked")
    public void borradoTareasExpediente(Expediente exp) {
        List<TareaNotificacion> notificaciones = getHibernateTemplate().find(TRAER_TODAS_TAREA_EXPEDIENTE, new Object[] { exp });
        cancelarTareas(notificaciones);
    }

    /**
     * Hace el borrado lï¿½gico de una tarea en base a un cliente.
     * @param idTareaNotificacion el id de la tarea a borrar
     */
    public void borradoLogico(Long idTareaNotificacion) {
        logger.debug("BORRANDO TAREA " + idTareaNotificacion);
        TareaNotificacion notificacion = get(idTareaNotificacion);
        delete(notificacion);
    }

    /**
      * {@inheritDoc}
      */
    @SuppressWarnings("unchecked")
    public List<TareaNotificacion> buscarTodasLasTareas(Long idEntidad, String tipoEntidad) {
        String hsql = "from TareaNotificacion where ";
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad)) {
            hsql += "asunto.id = ?";
        }
        if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(tipoEntidad)) {
            hsql += "cliente.id = ?";
        }

        if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad)) {
            hsql += "expediente.id = ?";
        }

        return getHibernateTemplate().find(hsql, new Object[] { idEntidad });
    }

    /**
     * Setea el flag de alerta a una tarea determinada.
     * @param idTarea el id de la tarea.
     */
    public void crearAlerta(Long idTarea) {
        logger.debug("CREANDO ALERTA " + idTarea);
        TareaNotificacion tarea = get(idTarea);
        tarea.setAlerta(true);
        save(tarea);
    }

    /**
     * Busca la tarea en curso de un expediente.
     * @param idExpediente el id del expediente.
     * @return la tarea.
     */
    @SuppressWarnings("unchecked")
    public Date buscarFechaFinEstadoExpediente(Long idExpediente) {
        List<Object> params = new ArrayList<Object>();
        String query = "select tn from TareaNotificacion tn left join  tn.expediente.estadoItinerario est where tn.estadoItinerario.codigo = est.codigo and tn.expediente.id = ? and tn.auditoria.borrado = 0";
        query += " and tn.subtipoTarea.codigoSubtarea in ( ?, ?, ?, ?, ?)";
        params.add(idExpediente);
        params.add(SubtipoTarea.CODIGO_COMPLETAR_EXPEDIENTE);
        params.add(SubtipoTarea.CODIGO_REVISAR_EXPEDIENE);
        params.add(SubtipoTarea.CODIGO_DECISION_COMITE);
        params.add(SubtipoTarea.CODIGO_TAREA_SANCIONADO);
        List<TareaNotificacion> tareas = getHibernateTemplate().find(query, params.toArray());
        if (tareas != null && tareas.size() > 0) { return tareas.get(0).getFechaVenc(); }
        return new Date();
    }

    /**
     * Busca las tareas o notificaciones para la entidad cliente.
     * @param dto dtoparametro
     * @return lista de tareas
     */
    @SuppressWarnings("unchecked")
    public List<TareaNotificacion> buscarTareasPendienteClienteDelUsuario(DtoBuscarTareaNotificacion dto) {
        List<String> listadoZonas = getListadoZonas(dto);
        String listadoPerfiles = getListadoPerfiles(dto);
        HashMap<String, Object> params = new HashMap<String, Object>();
        Query query = getSession().createQuery(construyeQueryTareasPendientesCliente(dto, listadoZonas, listadoPerfiles, params));
        setParameters(query, params);

        return query.list();
    }

    /**
     * Busca las tareas o notificaciones para la entidad expediente.
     * @param dto dtoparametro
     * @return lista de tareas
     */
    @SuppressWarnings("unchecked")
    public List<TareaNotificacion> buscarTareasPendienteExpedienteDelUsuario(DtoBuscarTareaNotificacion dto) {
        List<String> listadoZonas = getListadoZonas(dto);
        String listadoPerfiles = getListadoPerfiles(dto);

        HashMap<String, Object> params = new HashMap<String, Object>();
        Query query = getSession().createQuery(construyeQueryTareasPendienteExpedientes(dto, listadoZonas, listadoPerfiles, params));
        setParameters(query, params);

        return query.list();
    }

    /**
     * Busca las tareas relacionadas a un cliente.
     * @param idCliente el id del cliente
     * @return la lista de tareas asociadas al cliente
     */
    @SuppressWarnings("unchecked")
    public List<TareaNotificacion> buscarTareasAsociadasACliente(Long idCliente) {
        String hql = "from TareaNotificacion tn where tn.cliente.id = ? and tn.auditoria.borrado = 0";
        return getHibernateTemplate().find(hql, idCliente);
    }

    /**
     * Arma el sql para la busqueda de tareas.
     * @param dto DtoBuscarTareaNotificacion
     * @param params Hashmap
     * @return query
     */
    private StringBuffer armarFiltroBusquedaTareas(DtoBuscarTareaNotificacion dto, HashMap<String, Object> params) {
        StringBuffer hql = new StringBuffer();
        hql.append("select tn ");
        hql.append("from TareaNotificacion tn where 1=1 ");
        //Fecha Vto Desde

        if (!StringUtils.emtpyString(dto.getFechaVencimientoDesde()) && !StringUtils.emtpyString(dto.getFechaVencDesdeOperador())) {
            //Parsing fecha
            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
            Date fecha = null;
            try {
                fecha = sdf1.parse(dto.getFechaVencimientoDesde());
            } catch (ParseException e) {
                logger.error("Error parseando la fecha");
            }
            hql.append(" and trunc (tn.fechaVenc) " + dto.getFechaVencDesdeOperador() + " trunc (:fechaVencDesde) ");
            params.put("fechaVencDesde", fecha);

        }

        //Fecha Vto. Hasta
        if (!StringUtils.emtpyString(dto.getFechaVencimientoHasta()) && !StringUtils.emtpyString(dto.getFechaVencimientoHastaOperador())) {
            //Parsing fecha
            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
            Date fecha = null;
            try {
                fecha = sdf1.parse(dto.getFechaVencimientoHasta());
            } catch (ParseException e) {
                logger.error("Error parseando la fecha");
            }

            hql.append(" and trunc (tn.fechaVenc) " + dto.getFechaVencimientoHastaOperador() + " trunc (:fechaVencHasta) ");
            params.put("fechaVencHasta", fecha);

        }

        //Fecha Inicio Desde

        if (!StringUtils.emtpyString(dto.getFechaInicioDesde()) && !StringUtils.emtpyString(dto.getFechaInicioDesdeOperador())) {
            //Parsing fecha
            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
            Date fecha = null;
            try {
                fecha = sdf1.parse(dto.getFechaInicioDesde());
            } catch (ParseException e) {
                logger.error("Error parseando la fecha");
            }
            hql.append(" and trunc (tn.fechaInicio) " + dto.getFechaInicioDesdeOperador() + " trunc (:fechaInicioDesde) ");
            params.put("fechaInicioDesde", fecha);

        }

        //Fecha Inicio Hasta
        if (!StringUtils.emtpyString(dto.getFechaInicioHasta()) && !StringUtils.emtpyString(dto.getFechaInicioHastaOperador())) {
            //Parsing fecha
            SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
            Date fecha = null;
            try {
                fecha = sdf1.parse(dto.getFechaInicioHasta());
            } catch (ParseException e) {
                logger.error("Error parseando la fecha");
            }
            hql.append(" and trunc (tn.fechaInicio) " + dto.getFechaInicioHastaOperador() + " trunc (:fechaInicioHasta) ");
            params.put("fechaInicioHasta", fecha);

        }
        //Descripcion Entidad Informacion
        if (dto.getDescripcionTarea() != null && !"".equals(dto.getDescripcionTarea())) {
            String sql = " and (";

            //Asunto
            sql += " tn in (select tn from TareaNotificacion where (tn.tipoEntidad.codigo like " + DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO
                    + " and upper(tn.asunto.nombre) like upper('%" + dto.getDescripcionTarea() + "%'))) ";
            //Procedimiento
            sql += " or tn in (select tn from TareaNotificacion where (tn.tipoEntidad.codigo like " + DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO
                    + " and upper(tn.procedimiento.asunto.nombre||tn.procedimiento.tipoProcedimiento.descripcion) like upper('%"
                    + dto.getDescripcionTarea() + "%'))) ";

            //Cliente
            sql += " or tn in (select tn from TareaNotificacion where (tn.tipoEntidad.codigo like " + DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE
                    + " and upper(tn.cliente.persona.apellido1||tn.cliente.persona.apellido2||tn.cliente.persona.nombre) like upper('%"
                    + dto.getDescripcionTarea() + "%'))) ";

            //Expediente
            sql += " or tn in (select tn from TareaNotificacion where (tn.tipoEntidad.codigo like " + DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE
                    + " and upper(tn.expediente.descripcionExpediente) like upper('%" + dto.getDescripcionTarea() + "%'))) ";

            sql += ")";
            hql.append(sql);
        }
        //Nombre Tarea (TareaNotificacion.getDescripcionTarea)
        if (dto.getNombreTarea() != null && !"".equals(dto.getNombreTarea())) {
            hql.append(" and upper (tn.descripcionTarea) like '%" + dto.getNombreTarea().toUpperCase() + "%' ");
        }

        //Tipo Solicitud
        //Gestor
        //Supervisor
        //Emisor
        //Volumen total de riesgos de la entidad -- OJO!!!
        //Volumen total de riesgos VENCIDOS de la entidad -- OJO!!!

        return hql;
    }

    /**
     * insertar el supervisor correcto.
     * @return query
     */
    private StringBuffer insertarSupervisorCorrecto() {
        StringBuffer hql = new StringBuffer();
        hql.append(" case when ((tn.subtipoTarea.codigoSubtarea = " + SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_SUPERVISOR + ") or");
        hql.append(" (tn.subtipoTarea.codigoSubtarea = " + SubtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_SUPERVISOR + ") or");
        hql.append(" (tn.subtipoTarea.codigoSubtarea = " + SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_PROCEDIMIENTO + ") or");
        hql.append(" (tn.subtipoTarea.codigoSubtarea = " + SubtipoTarea.CODIGO_RECOPILAR_DOCUMENTACION_PROCEDIMIENTO + ") or");
        hql.append(" (tn.subtipoTarea.codigoSubtarea = " + SubtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_SUPERVISOR + ") or");
        hql.append(" (tn.subtipoTarea.codigoSubtarea = " + SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR + ") or");
        hql.append(" (tn.subtipoTarea.codigoSubtarea = " + SubtipoTarea.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO + "))");
        hql.append(" then asu.supervisorComite.id else asu.gestor.usuario.id end ");
        return hql;
    }

    /**
     * obtiene el count de todas las tareas pendientes.
     * @param dto dto
     * @return cuenta
     */
    public Long obtenerCantidadDeTareasPendientes(DtoBuscarTareaNotificacion dto) {
        HashMap<String, Object> params = new HashMap<String, Object>();
        String sb = construyeQueryTareasPendientes(dto, params).toString();
        sb = sb.replaceFirst("select tar ", "select count(tar) ");
        Query query = getSession().createQuery(sb);
        setParameters(query, params);
        Long total = (Long) query.uniqueResult();

        return total;
    }

    private void setParameters(Query query, HashMap<String, Object> params) {
        if (params == null) { return; }
        for (String key : params.keySet()) {
            Object param = params.get(key);
            query.setParameter(key, param);
        }
    }

    /**
     * Mï¿½todo encargado de buscar todas las tareas para un id de una entidad información determinada.
     * @param dtoBuscarTareaNotificacion DtoBuscarTareaNotificacion
     * @return List lista de tareas.
     */
    @SuppressWarnings("unchecked")
    public List<TareaNotificacion> buscarComunicaciones(DtoBuscarTareaNotificacion dtoBuscarTareaNotificacion) {

        String query = "";

        if (dtoBuscarTareaNotificacion.getIdTipoEntidadInformacion().equals(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE)) {
            query += TRAER_TAREAS_EXPEDIENTE_PENDIENTES;
        }

        if (dtoBuscarTareaNotificacion.getIdTipoEntidadInformacion().equals(DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE)) {
            query += TRAER_TAREAS_CLIENTE_PENDIENTES;
        }

        if (dtoBuscarTareaNotificacion.getIdTipoEntidadInformacion().equals(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO)) {
            query += TRAER_TAREAS_ASUNTO_PENDIENTES;
        }
        query += " and (tn.subtipoTarea.codigoSubtarea = '" + SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR + "' OR ";
        query += "  tn.subtipoTarea.codigoSubtarea = '" + SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR + "') ";
        int cantPer = 0;
        if (dtoBuscarTareaNotificacion.getPerfiles() != null) {
            cantPer = dtoBuscarTareaNotificacion.getPerfiles().size();
        }
        if (cantPer > 0) {
            query += " and ( ";
            for (Perfil p : dtoBuscarTareaNotificacion.getPerfiles()) {
                query += " ( case when tn.subtipoTarea.gestor = true then ";
                query += " estados.gestorPerfil.id else estados.supervisor.id end )= " + p.getId();
                query += " or";
            }
            query = query.substring(0, query.length() - 2);
            query += " ) ";
        }

        List<TareaNotificacion> notificaciones = getHibernateTemplate().find(query,
                new Object[] { dtoBuscarTareaNotificacion.getIdEntidadInformacion() });

        return notificaciones;
    }

    /**
     * obtiene si un expediente tiene una prorroga asociada.
     * @param idExpediente id del expediente
     * @return lista de tareas
     */
    @SuppressWarnings("unchecked")
    public List<TareaNotificacion> obtenerProrrogaExpediente(Long idExpediente) {
        List<Object> params = new ArrayList<Object>();
        String query = "select tn from TareaNotificacion tn where tn.expediente.id = ?";
        query += " and tn.auditoria.borrado = false ";
        query += " and tn.subtipoTarea.codigoSubtarea in (?, ?, ?, ?, ?, ?)";
        params.add(idExpediente);
        params.add(SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_CE);
        params.add(SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_RE);
        params.add(SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_DC);
        params.add(SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_FP);
        params.add(SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_ENSAN);
        params.add(SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_SANC);
        List<TareaNotificacion> notificaciones = getHibernateTemplate().find(query, params.toArray());

        return notificaciones;
    }

    /**
     * obtiene si un expediente tiene una solicitud de cancelacion asociada.
     * @param idExpediente id del expediente
     * @return lista de tareas
     */
    @SuppressWarnings("unchecked")
    public List<TareaNotificacion> obtenerSolicitudCancelacionExpediente(Long idExpediente) {
        List<Object> params = new ArrayList<Object>();
        String query = "select tn from TareaNotificacion tn where tn.expediente.id = ?";
        query += " and tn.auditoria.borrado = false ";
        query += " and tn.subtipoTarea.codigoSubtarea = ?";
        params.add(idExpediente);
        params.add(SubtipoTarea.CODIGO_SOLICITUD_CANCELACION_EXPEDIENTE_DE_SUPERVISOR);

        return getHibernateTemplate().find(query, params.toArray());
    }

    /**
     * obtiene las tareas de prorroga, comunicacion y cancelacion.
     * @param idExpediente expediente
     * @param estadoItinerario estadoItinerario
     * @return lista
     */
    @SuppressWarnings("unchecked")
    public List<TareaNotificacion> obtenerTareasInvalidasElevacionExpediente(Long idExpediente, String estadoItinerario) {
        List<Object> params = new ArrayList<Object>();
        String query = "select tn from TareaNotificacion tn where tn.expediente.id = ?";
        query += " and tn.auditoria.borrado = false ";
        query += " and tn.estadoItinerario.codigo =?";
        params.add(idExpediente);
        params.add(estadoItinerario);

        return getHibernateTemplate().find(query, params.toArray());
    }

    /**
    * Devuelve la tarea de acuerdo a la solicitud de cancelación y el expediente.
    * @param idSol el id de la solicitud de cancelación
    * @param idExp el id del expediente
    * @return la tarea o null si no existe.
    */
    @SuppressWarnings("unchecked")
    public TareaNotificacion buscarSolCancExp(Long idSol, Long idExp) {
        String hql = "from TareaNotificacion where solicitudCancelacion.id = ? and expediente.id = ?";
        List<TareaNotificacion> tareas = getHibernateTemplate().find(hql, new Object[] { idSol, idExp });
        if (tareas.size() > 0) { return tareas.get(0); }
        return null;
    }

    /**
     * Devuelve una lista de tareasNotificacion que cumplen que pertenecen a un ID de Procedimiento y son de un tipo determinado de tareas.
     * @param idProcedimiento ID del procedimiento al que pertenece la tarea
     * @param subtipoTarea ID del subtipo de tarea
     * @return Un listado de tareasNotificacion
     */
    @SuppressWarnings("unchecked")
    public List<TareaNotificacion> getListByProcedimientoSubtipo(Long idProcedimiento, String subtipoTarea) {
        String hql = "FROM TareaNotificacion t WHERE t.procedimiento.id = ? and t.subtipoTarea.codigoSubtarea = ?";

        return getHibernateTemplate().find(hql, new Object[] { idProcedimiento, subtipoTarea });
    }
    
    @SuppressWarnings("unchecked")
    public List<TareaNotificacion> getListByProcedimientoSubtipo(Long idProcedimiento, Set<String> subtipoTarea) {
    	String subTipos = "";
    	for (String string : subtipoTarea) {
			subTipos += "".equals(subTipos) ? "'"+string+"'" : ", '" + string + "'";
    	}    	
        String hql = "FROM TareaNotificacion t WHERE t.procedimiento.id = ? and t.subtipoTarea.codigoSubtarea ";
        hql += subtipoTarea.size() == 1 ? " = " + subTipos : " in ("+subTipos+")";

        return getHibernateTemplate().find(hql, new Object[] { idProcedimiento });
    }

    /**
     * Devuelve una lista de tareasNotificacion que cumplen que pertenecen a un ID de Procedimiento ordenadas por fecha de creacion.
     * @param idProcedimiento ID del procedimiento al que pertenece la tarea
     * @return Un listado de tareasNotificacion
     */
    @SuppressWarnings("unchecked")
    public List<TareaNotificacion> getListByProcedimiento(Long idProcedimiento) {
        String hql = "FROM TareaNotificacion t WHERE t.procedimiento.id = ? ORDER BY t.auditoria.fechaCrear ASC";

        return getHibernateTemplate().find(hql, new Object[] { idProcedimiento });
    }

    /**
     * {@inheritDoc}
     */
    @Override
    @SuppressWarnings("unchecked")
    public void borrarTareasAsociadasCliente(Long idCliente) {
        List<TareaNotificacion> notificaciones = getHibernateTemplate().find(TRAER_TODAS_TAREAS_CLIENTE, new Object[] { idCliente });
        cancelarTareas(notificaciones);
    }

    @Override
    public Page buscarTareasPendiente(DtoBuscarTareaNotificacion dto) {
        Page page = null;

        try {
            HashMap<String, Object> params = new HashMap<String, Object>();
            String hql = construyeQueryTareasPendientes(dto, params);
            if (dto.isBusqueda()) {
                hql += " AND tar in ( ";
                hql += armarFiltroBusquedaTareas(dto, params) + " ) ";
            }
            page = paginationManager.getHibernatePage(getHibernateTemplate(), hql, dto, params);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return page;
    }

    /**
     * Construye la query necesaria para recuperar las tareas pendientes de un usuario
     * @param dto
     * @return
     */
    private String construyeQueryTareasPendientes(DtoBuscarTareaNotificacion dto, HashMap<String, Object> params) {

        List<String> listadoZonas = getListadoZonas(dto);
        String listadoPerfiles = getListadoPerfiles(dto);

        StringBuilder sb = new StringBuilder();
        sb.append(" select tar from TareaNotificacion tar where ( ");

        sb.append(" tar in ( ").append(construyeQueryTareasPendientesCliente(dto, listadoZonas, listadoPerfiles, params)).append(" ) ");
        sb.append(" or tar in ( ").append(construyeQueryTareasPendienteExpedientes(dto, listadoZonas, listadoPerfiles, params)).append(" ) ");
        sb.append(" or tar in ( ").append(construyeQueryTareasPendienteAsuntos(dto, listadoPerfiles, params)).append(" ) ");
        sb.append(" or tar in ( ").append(contruirQueryTareasPendienteObjetivos(dto, listadoZonas, listadoPerfiles, params)).append(" ) ");
        sb.append(" ) ");

        //Filtros repetidos en todas las subconsultas
        sb.append(" and (tar.tareaFinalizada is null or tar.tareaFinalizada= 0)");
        sb.append(" and tar.auditoria.borrado = 0 ");

        if (dto.getCodigoTipoTarea() != null && dto.getCodigoTipoTarea().length() > 0) {
            sb.append(" and tar.subtipoTarea.tipoTarea.codigoTarea = :codigoTarea ");
            params.put("codigoTarea", dto.getCodigoTipoTarea());
        }

        if (dto.isEnEspera()) {
            sb.append(" and tar.espera = true ");
        }
        if (dto.isEsAlerta()) {
            sb.append(" and tar.alerta = true ");
        }

        return sb.toString();
    }

    /**
     * Devuelve la query necesaria para recuperar las tareas pendientes de la entidad cliente
     * @param dto
     * @return
     */
    private String construyeQueryTareasPendientesCliente(DtoBuscarTareaNotificacion dto, List<String> listadoZonas, String listadoPerfiles,
            HashMap<String, Object> params) {
        StringBuilder hql = new StringBuilder();
        hql.append("select tn ");
        hql.append("from TareaNotificacion tn ");
        hql.append("left join tn.cliente.estadoItinerario.estados est ");
        hql.append("where tn.auditoria.borrado = 0 ");

        hql.append(" and tn.cliente.estadoItinerario.codigo = tn.estadoItinerario.codigo ");
        hql.append(" and tn.cliente.arquetipo.itinerario = est.itinerario ");
        hql.append(" and (tn.tareaFinalizada is null or tn.tareaFinalizada= 0)");
        hql.append(" and tn.tipoEntidad.id = " + DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE);
        if (dto.getCodigoTipoTarea() != null && dto.getCodigoTipoTarea().length() > 0) {
            hql.append(" and tn.subtipoTarea.tipoTarea.codigoTarea = :codigoTarea ");
            params.put("codigoTarea", dto.getCodigoTipoTarea());
        }
        if (dto.isEnEspera()) {
            hql.append(" and tn.espera = true ");
        }
        if (dto.isEsAlerta()) {
            hql.append(" and tn.alerta = true ");
        }

        hql.append(" and ( ");
        for (String zonCodigo : listadoZonas) {
            hql.append(" tn.cliente.oficina.zona.codigo like '").append(zonCodigo).append("%' OR");
        }
        hql.deleteCharAt(hql.length() - 1);
        hql.deleteCharAt(hql.length() - 1);
        hql.append(" ) ");

        hql.append(construyeFiltroPerfiles(dto, listadoPerfiles, params));
        return hql.toString();
    }

    /**
     * arma la query de expedientes.
     * @param dto dto
     * @return query
     */
    private String construyeQueryTareasPendienteExpedientes(DtoBuscarTareaNotificacion dto, List<String> listadoZonas, String listadoPerfiles,
            HashMap<String, Object> params) {
        StringBuffer hql = new StringBuffer();
        hql.append("select tn ");
        hql.append("from TareaNotificacion tn ");
        hql.append("left join  tn.expediente.estadoItinerario.estados est ");
        hql.append("where tn.auditoria.borrado = 0 ");

        hql.append(" and tn.expediente.estadoItinerario.codigo = tn.estadoItinerario.codigo ");
        hql.append(" and tn.expediente.arquetipo.itinerario = est.itinerario ");
        hql.append(" and (tn.tareaFinalizada is null or tn.tareaFinalizada= 0) ");
        hql.append(" and tn.tipoEntidad.codigo = ").append(DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE).append(" ");
        if (dto.getCodigoTipoTarea() != null && dto.getCodigoTipoTarea().length() > 0) {
            hql.append(" and tn.subtipoTarea.tipoTarea.codigoTarea = :codigoTarea ");
            params.put("codigoTarea", dto.getCodigoTipoTarea());
        }
        if (dto.isEnEspera()) {
            hql.append(" and tn.espera = true ");
        }
        if (dto.isEsAlerta()) {
            hql.append(" and tn.alerta = true ");
        } else {
            //No se debe mostrar la tarea de DC, se accederï¿½ atraves del menu de comite.
            hql.append(" and tn.subtipoTarea.codigoSubtarea != ").append(SubtipoTarea.CODIGO_DECISION_COMITE).append(" ");
        }
        hql.append(" and ( ");
        for (String zonCodigo : listadoZonas) {
            hql.append(" tn.expediente.oficina.zona.codigo like '").append(zonCodigo).append("%' OR");
        }
        hql.deleteCharAt(hql.length() - 1);
        hql.deleteCharAt(hql.length() - 1);
        hql.append(" ) ");

        hql.append(construyeFiltroPerfiles(dto, listadoPerfiles, params));

        return hql.toString();
    }

    /**
     * arma la query de asuntos.
     * @param dto dto
     * @return query
     */
    private String construyeQueryTareasPendienteAsuntos(DtoBuscarTareaNotificacion dto, String listadoPerfiles, HashMap<String, Object> params) {
        StringBuffer hql = new StringBuffer();
        hql.append("select tn ");
        hql.append("from TareaNotificacion tn ");
        hql.append("left join  tn.asunto asu ");
        hql.append("where tn.auditoria.borrado = 0 ");

        hql.append(" and (tn.tareaFinalizada is null or tn.tareaFinalizada= 0) ");
        hql.append(" and tn.tipoEntidad.codigo in (").append(DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO).append(",").append(
                DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO).append(") ");

        if (dto.getCodigoTipoTarea() != null && dto.getCodigoTipoTarea().length() > 0) {
            hql.append(" and tn.subtipoTarea.tipoTarea.codigoTarea = :codigoTarea ");
            params.put("codigoTarea", dto.getCodigoTipoTarea());

        }
        if (dto.isEnEspera()) {
            hql.append(" and tn.espera = true ");
        }
        if (dto.isEsAlerta()) {
            hql.append(" and tn.alerta = true ");
        }

        //Filtros de perfil
        hql.append(" and ");
        hql.append(" ( case when tn.subtipoTarea.gestor = true then ");

        //Si no es una tarea en espera ni una alerta, es una tarea normal, se tiene en cuenta el tipo de tarea
        if (!dto.isEnEspera() && !dto.isEsAlerta()) {
            hql.append(" asu.gestor.usuario.id else asu.supervisor.usuario.id end )= :usuarioLogado ");
            params.put("usuarioLogado", dto.getUsuarioLogado().getId());
        }
        //Si es una tarea en espera pero no una alerta
        else if ((dto.isEnEspera() && !dto.isEsAlerta())) {
            //hql.append(" asu.supervisor.usuario.id else " + insertarSupervisorCorrecto() + " end )= " + dto.getUsuarioLogado().getId());
            hql.append(" asu.supervisor.usuario.id else asu.gestor.usuario.id end )= :usuarioLogado ");
            params.put("usuarioLogado", dto.getUsuarioLogado().getId());
        }

        //Si es una tarea en alerta pero no una espera
        else if ((!dto.isEnEspera() && dto.isEsAlerta())) {
            hql.append(" asu.supervisor.usuario.id else " + insertarSupervisorCorrecto() + " end )= :usuarioLogado ");
            params.put("usuarioLogado", dto.getUsuarioLogado().getId());
        }

        //Si no es una alerta y una espera
        else {
            hql.append(" asu.gestor.usuario.id else " + insertarSupervisorCorrecto() + " end )= :usuarioLogado ");
            params.put("usuarioLogado", dto.getUsuarioLogado().getId());
        }

        return hql.toString();
    }

    /**
     * arma la query de objetivos.
     * @param dto dto 
     * @return query
     */
    private String contruirQueryTareasPendienteObjetivos(DtoBuscarTareaNotificacion dto, List<String> listadoZonas, String listadoPerfiles,
            HashMap<String, Object> params) {
        StringBuffer hql = new StringBuffer();
        hql.append("select tn ");
        hql.append(" from TareaNotificacion tn ");
        hql.append(" left join tn.objetivo.politica pol ");
        hql.append(" where tn.auditoria.borrado = 0 ");

        hql.append(" and (tn.tareaFinalizada is null or tn.tareaFinalizada= 0) ");
        hql.append(" and tn.tipoEntidad.codigo = ").append(DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO).append(" ");
        hql.append(" and pol.estadoPolitica.codigo = '").append(DDEstadoPolitica.ESTADO_VIGENTE).append("' ");

        if (dto.getCodigoTipoTarea() != null && dto.getCodigoTipoTarea().length() > 0) {
            hql.append("and tn.subtipoTarea.tipoTarea.codigoTarea = :codigoTarea ");
            params.put("codigoTarea", dto.getCodigoTipoTarea());
        }

        if (dto.isEnEspera()) {
            hql.append(" and tn.espera = true ");
        }
        if (dto.isEsAlerta()) {
            hql.append(" and tn.alerta = true ");
        }

        StringBuilder sb = new StringBuilder();
        for (String zona : listadoZonas) {
            sb.append("'" + zona + "',");
        }
        String sListadoZonas = sb.toString();
        sListadoZonas = sListadoZonas.substring(0, sListadoZonas.length() - 1);

        //Perfiles y zonas de supervisor de objetivos
        hql.append(construyeFiltroPerfilesObjetivos(dto, listadoPerfiles, sListadoZonas, params));

        return hql.toString();
    }

    /**
     * Genera un listado List de zonas del usuario
     * @param dto
     */
    private List<String> getListadoZonas(DtoBuscarTareaNotificacion dto) {
        List<String> listadoZonas = new ArrayList<String>();
        HashMap<String, String> controlZonas = new HashMap<String, String>();
        for (DDZona zona : dto.getZonas()) {
            String zonCodigo = zona.getCodigo();
            if (controlZonas.get(zonCodigo) == null) {
                listadoZonas.add(zonCodigo);
                controlZonas.put(zonCodigo, zonCodigo);
            }
        }
        return listadoZonas;
    }

    /**
     * Genera un listado de perfiles del usuario
     * @param dto
     * @return
     */
    private String getListadoPerfiles(DtoBuscarTareaNotificacion dto) {
        HashMap<Long, Long> controlPerfiles = new HashMap<Long, Long>();

        for (Perfil p : dto.getPerfiles()) {
            Long idPerfil = p.getId();
            if (!controlPerfiles.containsKey(idPerfil)) controlPerfiles.put(idPerfil, idPerfil);
        }

        String listado = controlPerfiles.keySet().toString();
        listado = listado.substring(1, listado.length() - 1);
        return listado;
    }

    /**
     * arma el filtro para los perfiles.
     * @param dto dto
     * @return query
     */
    private String construyeFiltroPerfiles(DtoBuscarTareaNotificacion dto, String listadoPerfiles, HashMap<String, Object> params) {
        StringBuilder hql = new StringBuilder();

        if (dto.getPerfiles() != null && dto.getPerfiles().size() > 0) {
            hql.append(" and ");
            hql.append(" ( case when tn.subtipoTarea.gestor = true then ");

            //Si no es una tarea en espera ni una alerta, es una tarea normal, se tiene en cuenta el tipo de tarea
            if (!dto.isEnEspera() && !dto.isEsAlerta()) {
                hql.append(" est.gestorPerfil.id else est.supervisor.id end ) IN (" + listadoPerfiles + ") ");
            }

            //Si es una tarea en espera o es una alerta pero nunca a la vez
            else if ((dto.isEnEspera() && !dto.isEsAlerta()) || (!dto.isEnEspera() && dto.isEsAlerta())) {
                hql.append(" est.supervisor.id else est.gestorPerfil.id end ) IN (" + listadoPerfiles + ") ");
            }

            //En caso contrario (es espera y es alerta a la vez)
            else {
                hql.append(" est.gestorPerfil.id else est.supervisor.id end ) IN (" + listadoPerfiles + ") ");
            }

        }

        return hql.toString();
    }

    /**
     * arma el filtro para los perfiles.
     * @param dto dto
     * @return query
     */
    private String construyeFiltroPerfilesObjetivos(DtoBuscarTareaNotificacion dto, String listadoPerfiles, String sListadoZonas,
            HashMap<String, Object> params) {
        StringBuilder hql = new StringBuilder();

        String filtrosGestor = "pol.perfilGestor.codigo in (" + listadoPerfiles + ") and pol.zonaGestor.codigo in (" + sListadoZonas + ")";
        String filtrosSupervisor = "pol.perfilSupervisor.codigo in (" + listadoPerfiles + ") and pol.zonaSupervisor.codigo in (" + sListadoZonas
                + ")";

        if (dto.getPerfiles() != null && dto.getPerfiles().size() > 0) {
            hql.append(" and ( ");

            //Si no es una tarea en espera ni una alerta, es una tarea normal, se tiene en cuenta el tipo de tarea
            if (!dto.isEnEspera() && !dto.isEsAlerta()) {
                hql.append("(tn.subtipoTarea.gestor = true and ").append(filtrosGestor).append(") ");
                hql.append(" or (tn.subtipoTarea.gestor = false and ").append(filtrosSupervisor).append(") ");
            }

            //Si es una tarea en espera o es una alerta pero nunca a la vez
            else if ((dto.isEnEspera() && !dto.isEsAlerta()) || (!dto.isEnEspera() && dto.isEsAlerta())) {
                hql.append("(tn.subtipoTarea.gestor = true and ").append(filtrosSupervisor).append(") ");
                hql.append(" or (tn.subtipoTarea.gestor = false and ").append(filtrosGestor).append(") ");
            }

            //En caso contrario (es espera y es alerta a la vez)
            else {
                hql.append("(tn.subtipoTarea.gestor = true and ").append(filtrosGestor).append(") ");
                hql.append(" or (tn.subtipoTarea.gestor = false and ").append(filtrosSupervisor).append(") ");
            }

            hql.append(" ) ");
        }

        return hql.toString();
    }

    @SuppressWarnings("unchecked")
    @Override
    public void borrarTareaJustificacionObjetivo(Long idObjetivo) {
        List<TareaNotificacion> notificaciones = getHibernateTemplate().find(TRAER_TAREA_JUSTIFIACION_OBJETIVO,
                new Object[] { idObjetivo, SubtipoTarea.CODIGO_TAREA_JUSTIFICAR_INCUMPLIMIENTO_OBJETIVO, DDTipoEntidad.CODIGO_ENTIDAD_OBJETIVO });

        cancelarTareas(notificaciones);
    }

    @Override
    public List<TareaNotificacion> getListByAsunto(Long idAsunto) {
        String hql = "FROM TareaNotificacion t WHERE t.asunto.id = ?";

        return getHibernateTemplate().find(hql, new Object[] { idAsunto });
    }
}
