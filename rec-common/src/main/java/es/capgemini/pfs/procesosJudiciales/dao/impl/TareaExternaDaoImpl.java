package es.capgemini.pfs.procesosJudiciales.dao.impl;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;

/**
 * Implementaci�n del dao de TareaExternaDao para Hibenate.
 *
 * @author pamuller
 *
 */
@Repository("TareaExternaDao")
public class TareaExternaDaoImpl extends AbstractEntityDao<TareaExterna, Long> implements TareaExternaDao {

    private final Log logger = LogFactory.getLog(getClass());

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public TareaExterna getByIdTareaNotificacion(Long id) {
        String hql = "from TareaExterna where tareaPadre.id= ?";

        List<TareaExterna> list = getHibernateTemplate().find(hql, new Object[] { id });
        if (list.size() > 0) { return list.get(0); }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public TareaExterna obtenerTareaPorToken(Long idToken) {
        List<TareaExterna> ls = null;
        try {
            ls = getHibernateTemplate().find("from TareaExterna where tokenIdBpm= ? order by id desc", new Object[] { idToken });
        } catch (DataAccessException e) {
            logger.error(e);
        }
        if (ls.size() > 0) { return ls.get(0); }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<TareaExterna> obtenerTareasGestorPorProcedimiento(Long idProcedimiento) {
        List<TareaExterna> ls = null;
        try {
            ls = getHibernateTemplate()
                    .find(
                            "from TareaExterna where tareaPadre.procedimiento.id = ? AND tareaPadre.subtipoTarea.codigoSubtarea = ? AND detenida = 0 AND auditoria.borrado = 0 ORDER BY tareaPadre.auditoria.fechaCrear DESC",
                            new Object[] { idProcedimiento, SubtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_GESTOR });
        } catch (DataAccessException e) {
            logger.error(e);
        }
        return ls;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<TareaExterna> obtenerTareasSupervisorPorProcedimiento(Long idProcedimiento) {
        List<TareaExterna> ls = null;
        try {

            String hql = "from TareaExterna where tareaPadre.procedimiento.id = ? AND detenida = 0 AND auditoria.borrado = 0 AND "
                    + "("
                    + "(tareaPadre.subtipoTarea.codigoSubtarea = ?) "
                    + "OR "
                    + "(tareaPadre.subtipoTarea.codigoSubtarea = ? AND tareaPadre.id IN (SELECT tareaAsociada.id FROM Prorroga Where respuestaProrroga is null)) "
                    + ")" + "ORDER BY tareaPadre.auditoria.fechaCrear DESC";

            ls = getHibernateTemplate().find(
                    hql,
                    new Object[] { idProcedimiento, SubtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_SUPERVISOR,
                            SubtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_GESTOR });
        } catch (DataAccessException e) {
            logger.error(e);
        }
        return ls;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<TareaExterna> obtenerTareasPorProcedimiento(Long idProcedimiento) {
        List<TareaExterna> ls = null;
        try {
            ls = getHibernateTemplate().find(
                    "from TareaExterna where tareaPadre.procedimiento.id = ? and detenida = 0 ORDER BY tareaPadre.auditoria.fechaCrear DESC",
                    new Object[] { idProcedimiento });
        } catch (DataAccessException e) {
            logger.error(e);
        }
        return ls;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<TareaExterna> getByIdTareaProcedimientoIdProcedimiento(Long idProcedimiento, Long idTareaProcedimiento) {
        String hql = "from TareaExterna where tareaPadre.procedimiento.id = ? and tareaProcedimiento.id = ? ";
        return getHibernateTemplate().find(hql, new Object[] { idProcedimiento, idTareaProcedimiento });
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<TareaExterna> getActivasByIdProcedimiento(Long idProcedimiento) {
        String hql = "from TareaExterna where tareaPadre.procedimiento.id = ? and tareaPadre.fechaFin is null";
        return getHibernateTemplate().find(hql, new Object[] { idProcedimiento });
    }
}
