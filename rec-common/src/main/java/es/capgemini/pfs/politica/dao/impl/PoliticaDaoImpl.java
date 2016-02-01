package es.capgemini.pfs.politica.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.politica.dao.PoliticaDao;
import es.capgemini.pfs.politica.model.CicloMarcadoPolitica;
import es.capgemini.pfs.politica.model.DDEstadoItinerarioPolitica;
import es.capgemini.pfs.politica.model.DDEstadoPolitica;
import es.capgemini.pfs.politica.model.DDTipoPolitica;
import es.capgemini.pfs.politica.model.Politica;

/**
 * Implementacion de PoliticaDao.
 * @author aesteban
 *
 */
@Repository("PoliticaDao")
public class PoliticaDaoImpl extends AbstractEntityDao<Politica, Long> implements PoliticaDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<CicloMarcadoPolitica> buscarPoliticasParaPersona(Long idPersona) {
        String hql = "from CicloMarcadoPolitica c where c.persona.id = ? order by c.auditoria.fechaCrear desc";
        return getHibernateTemplate().find(hql, new Object[] { idPersona });
    }
    
    
    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<Politica> buscarPoliticasPorCmp(Long cmpId) {
        String hql = "from Politica p where p.cicloMarcadoPolitica.id = ?";
        return (List<Politica>) getHibernateTemplate().find(hql, new Object[] { cmpId });
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public Politica buscarPoliticaVigente(Long idPersona) {
        String hql = "select p from CicloMarcadoPolitica c, Politica p where c.auditoria.borrado=false and p.cicloMarcadoPolitica = c and p.estadoPolitica.codigo = '"
                + DDEstadoPolitica.ESTADO_VIGENTE + "' and c.persona.id = ? ";
        List<Politica> politicas = getHibernateTemplate().find(hql, idPersona);
        if (politicas.size() > 0) { return politicas.get(0); }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public Politica buscarUltimaPolitica(Long idPersona) {
        String hql = "select p from CicloMarcadoPolitica c, Politica p" + " where c.auditoria.borrado=false and p.auditoria.borrado=false"
                + " and p.cicloMarcadoPolitica = c" + " and p.estadoPolitica.codigo in ('" + DDEstadoPolitica.ESTADO_VIGENTE + "', '"
                + DDEstadoPolitica.ESTADO_PROPUESTA + "')" + " and c.persona.id = ? " + " order by p.auditoria.fechaCrear desc";
        List<Politica> politicas = getHibernateTemplate().find(hql, idPersona);
        if (politicas.size() > 0) { return politicas.get(0); }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public CicloMarcadoPolitica buscarPoliticasParaPersonaExpediente(Long idPersona, Long idExpediente) {
        String hql = "select c from CicloMarcadoPolitica c where c.auditoria.borrado=false " + " and c.persona.id = ? and c.expediente.id = ? ";
        List<CicloMarcadoPolitica> cmp = getHibernateTemplate().find(hql, new Object[] { idPersona, idExpediente });
        if (cmp != null && cmp.size() > 0) { return cmp.get(0); }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public Politica getPoliticaPropuestaExpedientePersonaEstadoItinerario(Persona persona, Expediente expediente, DDEstadoItinerario estadoItinerario) {
        String hql = "select p from Politica p, CicloMarcadoPolitica c where p.cicloMarcadoPolitica = c ";
        hql += " and p.auditoria.borrado=false and p.estadoPolitica.codigo = ? ";
        hql += " and c.persona.id = ? and c.expediente.id = ? and p.estadoItinerarioPolitica.estadoItinerario.codigo = ? ";

        List<Politica> politicas = getHibernateTemplate().find(hql,
                new Object[] { DDEstadoPolitica.ESTADO_PROPUESTA, persona.getId(), expediente.getId(), estadoItinerario.getCodigo() });

        if (politicas != null && politicas.size() > 0) { return politicas.get(0); }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    public Long getNumPoliticasGeneradas(Long idExpediente) {
        String hql = "select count(pol) " + "from CicloMarcadoPolitica cmp join cmp.politicas pol " + "where cmp.expediente.id = ?"
                + "  and pol.estadoItinerarioPolitica.codigo = '" + DDEstadoItinerarioPolitica.ESTADO_DECISION_COMITE + "'" + "  and pol.auditoria."
                + Auditoria.UNDELETED_RESTICTION;
        return ((Long) getHibernateTemplate().find(hql, idExpediente).get(0));
    }
}
