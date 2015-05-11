package es.capgemini.pfs.politica.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.politica.dao.AnalisisPersonaOperacionDao;
import es.capgemini.pfs.politica.model.AnalisisPersonaOperacion;

/**
 * Implementacion de AnalisisPersonaOperacionDao.
 * @author Pablo Müller
 *
 */
@Repository("AnalisisPersonaOperacionDao")
public class AnalisisPersonaOperacionDaoImpl extends AbstractEntityDao<AnalisisPersonaOperacion, Long> implements AnalisisPersonaOperacionDao {

    /**
     * devuelve las operaciones para la persona.
     * @param idPersona la persona para la que se buscan las operaciones.
     * @return las operaciones de la persona.
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<AnalisisPersonaOperacion> buscarOperaciones(Long idPersona) {
        StringBuffer hql = new StringBuffer();
        hql.append("Select apo from AnalisisPersonaOperacion apo, ContratoPersona cpe ");
        hql.append("where apo.contrato = cpe.contrato ");
        hql.append("and cpe.persona.id = ? ");
        hql.append("and apo.contrato.auditoria.borrado = 0");
        List<AnalisisPersonaOperacion> apos = getHibernateTemplate().find(hql.toString(), idPersona);
        return apos;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    @SuppressWarnings("unchecked")
    public List<Contrato> getOperacionesSinCompletar(Long idPersona, Long idExpediente) {
        StringBuilder hql = new StringBuilder();

        hql.append("select cpe.contrato  ");
        hql.append("from ContratoPersona cpe, CicloMarcadoPolitica cmp ");
        hql.append("where cpe.persona.id = :idPersona and cmp.expediente.id = :idExpediente and cpe.persona.id = cmp.persona.id ");
        hql.append("and cpe.contrato.id not in (select apo.contrato.id FROM AnalisisPersonaOperacion apo, AnalisisPersonaPolitica app  ");
        hql.append("where apo.analisisPersonaPolitica.id = app.id and app.cicloMarcadoPolitica.id = cmp.id) ");

        Query query = getSession().createQuery(hql.toString());
        query.setParameter("idPersona", idPersona);
        query.setParameter("idExpediente", idExpediente);
        List<Contrato> lista = query.list();
        return lista;
    }

}
