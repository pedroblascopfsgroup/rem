package es.capgemini.pfs.politica.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.politica.dao.AnalisisPersonaPoliticaDao;
import es.capgemini.pfs.politica.model.AnalisisPersonaPolitica;
import es.capgemini.pfs.politica.model.DDParcelasPersonas;

/**
 * Implementacion de AnalisisPersonaPoliticaDao.
 * @author Pablo Müller
 *
 */
@Repository("AnalisisPersonaPoliticaDao")
public class AnalisisPersonaPoliticaDaoImpl extends AbstractEntityDao<AnalisisPersonaPolitica, Long> implements AnalisisPersonaPoliticaDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<DDParcelasPersonas> getParcelasSinCompletar(Long idPersona, Long idExpediente) {
        StringBuilder hql = new StringBuilder();

        hql.append("select distinct pps ");
        hql.append("from Persona per, CicloMarcadoPolitica cmp, ParcelaPersonaSegmento pps ");
        hql.append("where per.id = :idPersona and cmp.expediente.id = :idExpediente and per.id = cmp.persona.id and ");
        hql.append("( ");
        hql.append("per.tipoPersona.id = pps.tipoPersona.id and (per.segmento.id = pps.segmentoCliente.id or pps.segmentoCliente = null) ");
        hql.append(") ");
        hql.append("and pps.parcela.id not in (select distinct apa.parcela.id from AnalisisParcelaPersona apa, AnalisisPersonaPolitica app ");
        hql.append(" where apa.analisisPersonaPolitica.id = app.id and app.cicloMarcadoPolitica.id = cmp.id) ");

        Query query = getSession().createQuery(hql.toString());
        query.setParameter("idPersona", idPersona);
        query.setParameter("idExpediente", idExpediente);
        List<DDParcelasPersonas> lista = query.list();
        return lista;
    }

}
