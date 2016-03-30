package es.capgemini.pfs.expediente.dao.impl;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.dao.EventoDao;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

@Repository("EventoDao")
public class EventoDaoImpl extends AbstractEntityDao<TareaNotificacion, Long> implements EventoDao {

    @SuppressWarnings("unchecked")
    /**
     * {@inheritDoc}
     */
    public List<TareaNotificacion> getTareasExpediente(Long idExpediente) {
        DetachedCriteria crit = DetachedCriteria.forClass(TareaNotificacion.class);

        Object[] subtipos = new Object[] { SubtipoTarea.CODIGO_COMPLETAR_EXPEDIENTE, SubtipoTarea.CODIGO_REVISAR_EXPEDIENE,
                SubtipoTarea.CODIGO_DECISION_COMITE,SubtipoTarea.CODIGO_TAREA_EN_SANCION, SubtipoTarea.CODIGO_TAREA_SANCIONADO,
                SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_CE, SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_RE, SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_ENSAN,
                SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_SANC,SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR, SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR,
                SubtipoTarea.CODIGO_SOLICITUD_CANCELACION_EXPEDIENTE_DE_SUPERVISOR, SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_CE,
                SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_RE, SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR,SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_ENSAN,
                SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_SANC,SubtipoTarea.CODIGO_NOTIFICACION_EXPEDIENTE_DECISION_TOMADA, SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR,
                SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR, SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR,
                SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL, SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_CANCELAC_EXPEDIENTE,
                SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_DC, SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_DC,
                SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL_SEG ,
                SubtipoTarea.CODIGO_TAREA_EXP_RECOBRO_MARCADO, SubtipoTarea.CODIGO_TAREA_EXP_RECOBRO_META_VOLANTE_KO, 
                SubtipoTarea.CODIGO_TAREA_EXP_RECOBRO_META_VOLANTE_OK};

        crit.createCriteria("subtipoTarea").add(Restrictions.in("codigoSubtarea", subtipos));
        crit.add(Restrictions.eq("expediente.id", idExpediente));
        crit.addOrder(Order.asc("auditoria.fechaCrear"));
        return getHibernateTemplate().findByCriteria(crit);

    }

    @SuppressWarnings("unchecked")
    /**
     * {@inheritDoc}
     */
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

    @SuppressWarnings("unchecked")
    /**
     * {@inheritDoc}
     */
    public List<TareaNotificacion> getTareasAsunto(Long idAsunto) {
        DetachedCriteria crit = DetachedCriteria.forClass(TareaNotificacion.class);

        Object[] subtipos = new Object[] { SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR,
                SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR, SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR,
                SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR, SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR,
                SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR };

        crit.createCriteria("subtipoTarea").add(Restrictions.in("codigoSubtarea", subtipos));
        crit.add(Restrictions.eq("asunto.id", idAsunto));
        crit.add(Restrictions.isNull("procedimiento"));
        crit.addOrder(Order.asc("auditoria.fechaCrear"));
        return getHibernateTemplate().findByCriteria(crit);
    }
}
