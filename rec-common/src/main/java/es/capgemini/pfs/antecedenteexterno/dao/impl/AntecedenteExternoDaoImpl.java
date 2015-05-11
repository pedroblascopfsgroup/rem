package es.capgemini.pfs.antecedenteexterno.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.antecedenteexterno.dao.AntecedenteExternoDao;
import es.capgemini.pfs.antecedenteexterno.model.AntecedenteExterno;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Mariano Ruiz
 */
@Repository("AntecedenteExternoDao")
public class AntecedenteExternoDaoImpl extends AbstractEntityDao<AntecedenteExterno, Long> implements AntecedenteExternoDao {

    /**
     * Retorna los antecedentes externos de la persona.
     * @param id Long: el id de la Persona
     * @return List
     */
    @SuppressWarnings("unchecked")
    public List<AntecedenteExterno> findByPersonaId(Long id) {
        String hql = "select p.antecedente.antecedenteExterno from Persona p where p.id = ?";
        List<AntecedenteExterno> externos =  getHibernateTemplate().find(hql, new Object[] {id});
        return externos;
    }

}
