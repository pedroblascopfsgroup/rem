package es.capgemini.pfs.asunto.dao.impl;

import java.io.Serializable;
import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Expression;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.dao.AsuntoDao;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * Clase de acceso a datos para procedimientos.
 * @author pamuller
 *
 */
@Repository("ProcedimientoDao")
public class ProcedimientoDaoImpl extends AbstractEntityDao<Procedimiento, Long> implements ProcedimientoDao, Serializable {
    private static final long serialVersionUID = 1L;

    @Autowired
    private AsuntoDao asuntoDao;

    /**
     * Devuelve los procedimientos asociados a un expediente.
     * @param idExpediente el id del expediente
     * @return la lista de procedimientos.
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Procedimiento> getProcedimientosExpediente(Long idExpediente) {
        String hql = "from Procedimiento p where p.expedienteContrato.expediente.id = ? and p.auditoria.borrado=0";
        List<Procedimiento> procedimientos = getHibernateTemplate().find(hql, new Object[] { idExpediente });
        return procedimientos;
    }

    /**
     * Devuelve el expedienteContrato correspondiente al contrato.
     * @param idContrato el id del contrato.
     * @return el ExpedienteContrato.
     */
    @SuppressWarnings("unchecked")
    public ExpedienteContrato getContratoExpediente(Long idContrato) {
        String hql = "from ExpedienteContrato  where contrato.id = ? and auditoria.borrado=0";
        List<ExpedienteContrato> lista = getHibernateTemplate().find(hql, new Object[] { idContrato });
        if (lista.size() > 0) { return lista.get(0); }
        return null;

    }

    /**
     * Devuelve los procedimientos asociados a un asunto.
     * @param idAsunto el id del asunto
     * @return la lista de procedimientos
     */
    @SuppressWarnings("unchecked")
    public List<Procedimiento> getProcedimientosAsunto(Long idAsunto) {
        Asunto asunto = asuntoDao.get(idAsunto);
        DetachedCriteria crit = DetachedCriteria.forClass(Procedimiento.class);
        crit.add(Expression.eq("asunto", asunto));
        return getHibernateTemplate().findByCriteria(crit);
    }

    /**
     * Indica si el usuario logueado tiene que responder alguna comunicación.
     * @param idProcedimiento el id del procedimiento.
     * @param usuarioLogado el usuario logueado
     * @return true o false;
     */
    @SuppressWarnings("unchecked")
    public TareaNotificacion buscarTareaPendiente(Long idProcedimiento, Long usuarioLogado) {
        String hql = "Select t from TareaNotificacion t, Procedimiento p where " + "t.procedimiento = p " + "and p.id = ? "
                + "and ((p.asunto.gestor.usuario.id = ? " + "and t.subtipoTarea.codigoSubtarea = '"
                + SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR + "') " + "or " + "(p.asunto.supervisor.usuario.id = ? "
                + "and t.subtipoTarea.codigoSubtarea = '" + SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR + "')) " + "and t.auditoria.borrado = 0";
        List<TareaNotificacion> tareas = getHibernateTemplate().find(hql, new Object[] { idProcedimiento, usuarioLogado, usuarioLogado });
        if (tareas.size() > 0) { return tareas.get(0); }
        return null;
    }
}
