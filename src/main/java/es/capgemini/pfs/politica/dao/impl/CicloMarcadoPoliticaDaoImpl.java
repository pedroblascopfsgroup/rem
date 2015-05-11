package es.capgemini.pfs.politica.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.politica.dao.CicloMarcadoPoliticaDao;
import es.capgemini.pfs.politica.model.CicloMarcadoPolitica;

/**
 * Implementación de CicloMarcadoPoliticaDao.
 * @author pajimene
 *
 */
@Repository("CicloMarcadoPoliticaDao")
public class CicloMarcadoPoliticaDaoImpl extends AbstractEntityDao<CicloMarcadoPolitica, Long> implements CicloMarcadoPoliticaDao {

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    @Override
    public List<CicloMarcadoPolitica> getCiclosMarcadoExpediente(Long idExpediente) {
        StringBuffer hql = new StringBuffer();
        hql.append("Select cmp from CicloMarcadoPolitica cmp ");
        hql.append("where cmp.expediente.id = ? ");
        List<CicloMarcadoPolitica> lista = getHibernateTemplate().find(hql.toString(), idExpediente);
        return lista;
    }

}
