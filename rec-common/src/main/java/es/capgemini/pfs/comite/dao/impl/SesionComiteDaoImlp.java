package es.capgemini.pfs.comite.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.comite.dao.SesionComiteDao;
import es.capgemini.pfs.comite.model.Asistente;
import es.capgemini.pfs.comite.model.SesionComite;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.politica.model.CicloMarcadoPolitica;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Maneja las accesos a BBDD de las entidades SesionComite.
 * @author aesteban
 *
 */
@Repository("SesionComiteDao")
public class SesionComiteDaoImlp extends AbstractEntityDao<SesionComite, Long> implements SesionComiteDao {

    /**
    * {@inheritDoc}
    */
    @SuppressWarnings("unchecked")
    @Override
    public List<Asunto> buscarAsuntos(Long idSesion) {
        String hsql = "SELECT asu FROM Asunto asu LEFT JOIN asu.decisionComite dco LEFT JOIN asu.expediente.decisionComite expDco "
                + "WHERE dco.sesion.id = ? OR expDco.sesion.id= ?";

        return getHibernateTemplate().find(hsql, new Object[] {idSesion, idSesion});
    }

    /**
     * Devuelve el usuario supervisor de una sesión de comité.
     * @param sesionId el id de la sesion
     * @return el usuario supervisor
     */
    @SuppressWarnings("unchecked")
    public Usuario getSupervisorSesion(Long sesionId) {
        String hql = "from Asistente where supervisor=true and sesionComite.id = ?";
        List<Asistente> asistentes = getHibernateTemplate().find(hql, new Object[] { sesionId });
        if (asistentes == null || asistentes.size() == 0) {
            return null;
        }
        return asistentes.get(0).getUsuario();
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Expediente> buscarExpedientes(Long idSesion) {
        String hql = "SELECT distinct e FROM Expediente e, DecisionComite d";
        hql += " WHERE d.sesion.id = ?";
        hql += " AND d.id = e.decisionComite.id";
        hql += " AND d.auditoria." + Auditoria.UNDELETED_RESTICTION + " AND e.auditoria." + Auditoria.UNDELETED_RESTICTION;
        return getHibernateTemplate().find(hql, new Object[] {idSesion});
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<CicloMarcadoPolitica> buscarMarcadosPoliticaExpedientes(Long idSesion) {
    	String hql = "select cmp from CicloMarcadoPolitica cmp";
    	hql += " where cmp.expediente in";
        hql += "  (SELECT distinct e FROM Expediente e, DecisionComite d";
        hql += "   WHERE d.sesion.id = ?";
        hql += "   AND d.id = e.decisionComite.id";
        hql += "   AND d.auditoria." + Auditoria.UNDELETED_RESTICTION + " AND e.auditoria." + Auditoria.UNDELETED_RESTICTION;
        hql += "  )";
        hql += " and cmp.auditoria." + Auditoria.UNDELETED_RESTICTION;
        return getHibernateTemplate().find(hql, new Object[] {idSesion});
    }


    /**
     * {@inheritDoc}
     */
    @Override
    public void saveOrUpdate(SesionComite t) {
        super.saveOrUpdate(t);
        getHibernateTemplate().flush();
    }
}
