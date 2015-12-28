package es.pfsgroup.plugin.recovery.mejoras.expediente.dao.impl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.plugin.recovery.mejoras.expediente.dao.MEJEventoDao;

@Repository("MEJEventoDao")
public class MEJEventoDaoImpl extends AbstractEntityDao<TareaNotificacion, Long> implements MEJEventoDao{

	@SuppressWarnings("unchecked")
	@Override
	public List<TareaNotificacion> getTareasAsunto(Long idAsunto) {
		DetachedCriteria crit = DetachedCriteria.forClass(TareaNotificacion.class);

        Object[] subtipos = new Object[] { SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR,
                SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR, SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR,
                SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR, SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR,
                SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR, EXTSubtipoTarea.CODIGO_ACUERDO_CERRADO_POR_GESTOR, 
                EXTSubtipoTarea.CODIGO_ACUERDO_CERRADO_POR_SUPERVISOR, SubtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO, 
                SubtipoTarea.CODIGO_ACUERDO_PROPUESTO, SubtipoTarea.CODIGO_ACUERDO_RECHAZADO,
               };

        crit.createCriteria("subtipoTarea").add(Restrictions.in("codigoSubtarea", subtipos));
        crit.add(Restrictions.eq("asunto.id", idAsunto));
        crit.add(Restrictions.isNull("procedimiento"));
        crit.addOrder(Order.asc("auditoria.fechaCrear"));
        return getHibernateTemplate().findByCriteria(crit);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<TareaNotificacion> getComunicacionesAsunto(Long idAsunto) {
		DetachedCriteria crit = DetachedCriteria.forClass(TareaNotificacion.class);

        Object[] subtipos = new Object[] { SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR,
                SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR, SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR,
                SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR, SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR,
                SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR,
                //FIXME
                //UGAS-193 Revisar si hay que a�adir m�s tipos
                EXTSubtipoTarea.CODIGO_ANOTACION_TAREA, EXTSubtipoTarea.CODIGO_ANOTACION_NOTIFICACION};

        crit.createCriteria("subtipoTarea").add(Restrictions.in("codigoSubtarea", subtipos));
        crit.add(Restrictions.eq("asunto.id", idAsunto));
        // Las comunicaciones pueden estar borradas por eso quitamos este filtro
        // crit.add(Restrictions.eq("auditoria.borrado", false));
        crit.add(Restrictions.isNull("procedimiento"));
        crit.addOrder(Order.asc("auditoria.fechaCrear"));
        return getHibernateTemplate().findByCriteria(crit);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<TareaNotificacion> getComunicacionesProcedimiento(Long idProcedimiento) {
		DetachedCriteria crit = DetachedCriteria.forClass(TareaNotificacion.class);

        Object[] subtipos = new Object[] { SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR,
                SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR, SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR,
                SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR, SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR,
                SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR};

        crit.createCriteria("subtipoTarea").add(Restrictions.in("codigoSubtarea", subtipos));
        crit.add(Restrictions.eq("procedimiento.id", idProcedimiento));
        crit.add(Restrictions.eq("auditoria.borrado", false));
        crit.addOrder(Order.asc("auditoria.fechaCrear"));
        return getHibernateTemplate().findByCriteria(crit);
	}

	@Override
	public List<TareaNotificacion> getTareasPersona(Long idPersona) {
        DetachedCriteria crit = DetachedCriteria.forClass(TareaNotificacion.class);

        Object[] subtipos = new Object[] { SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR,
                SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR, SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR,
                SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR, SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR,
                SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR };

        crit.createCriteria("subtipoTarea").add(Restrictions.in("codigoSubtarea", subtipos));
        crit.createCriteria("cliente").add(Restrictions.eq("persona.id", idPersona));
        crit.addOrder(Order.asc("auditoria.fechaCrear"));
        return getHibernateTemplate().findByCriteria(crit);
	}
	@Override
	public List<TareaNotificacion> getTareasExpediente(Long idExpediente) {
        DetachedCriteria crit = DetachedCriteria.forClass(TareaNotificacion.class);

        Object[] subtipos = new Object[] { SubtipoTarea.CODIGO_COMPLETAR_EXPEDIENTE, SubtipoTarea.CODIGO_REVISAR_EXPEDIENE,
                SubtipoTarea.CODIGO_DECISION_COMITE, SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_CE, SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_RE,
                SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR, SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR,
                SubtipoTarea.CODIGO_SOLICITUD_CANCELACION_EXPEDIENTE_DE_SUPERVISOR, SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_CE,
                SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_RE, SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR,
                SubtipoTarea.CODIGO_NOTIFICACION_EXPEDIENTE_DECISION_TOMADA, SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR,
                SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR, SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR,
                SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL, SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_CANCELAC_EXPEDIENTE,
                SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_DC, SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_DC,
                EXTSubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL_SEG ,
                SubtipoTarea.CODIGO_TAREA_EXP_RECOBRO_MARCADO, SubtipoTarea.CODIGO_TAREA_EXP_RECOBRO_META_VOLANTE_KO, 
                SubtipoTarea.CODIGO_TAREA_EXP_RECOBRO_META_VOLANTE_OK, SubtipoTarea.CODIGO_EVENTO_PROPUESTA,
                SubtipoTarea.CODIGO_FORMALIZAR_PROPUESTA};

        crit.createCriteria("subtipoTarea").add(Restrictions.in("codigoSubtarea", subtipos));
        crit.add(Restrictions.eq("expediente.id", idExpediente));
        crit.addOrder(Order.asc("auditoria.fechaCrear"));
        return getHibernateTemplate().findByCriteria(crit);

    }

	@Override
	public void deletePersonaExpediente(Long idExpediente, Long idPersona) {
        String sql = "DELETE FROM pex_personas_expediente WHERE EXP_ID = " + idExpediente + " AND PER_ID = " + idPersona;

        Session sesion = getSession();

        try {
            sesion.createSQLQuery(sql).executeUpdate();
        } finally {
            releaseSession(sesion);
        }
		
	}

}
