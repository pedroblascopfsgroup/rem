package es.capgemini.pfs.antecedente.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.antecedente.dao.AntecedenteDao;
import es.capgemini.pfs.antecedente.model.Antecedente;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Andrés Esteban / Mariano Ruiz
 *
 */
@Repository("AntecedenteDao")
public class AntecedenteDaoImpl extends AbstractEntityDao<Antecedente, Long> implements AntecedenteDao {

    /**
     * Retorna el antecedente de la persona.
     * @param id Long: el id de la Persona
     * @return Antecedente
     */
    public Antecedente findByPersonaId(Long id) {
        String hql = "select p.antecedente from Persona p where p.id = ?";
        try {
            Antecedente antecedente = (Antecedente) getHibernateTemplate().find(hql, new Object[] {id}).get(0);
            return antecedente;
        } catch(IndexOutOfBoundsException e) {
            return null;
        }
    }
}
