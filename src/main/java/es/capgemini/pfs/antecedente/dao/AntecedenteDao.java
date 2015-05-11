package es.capgemini.pfs.antecedente.dao;

import es.capgemini.pfs.antecedente.model.Antecedente;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author Andrés Esteban / Mariano Ruiz
 *
 */
public interface AntecedenteDao extends AbstractDao<Antecedente, Long> {
    /**
     * Retorna el antecedente de la persona.
     * @param id Long: el id de la Persona
     * @return Antecedente
     */
    Antecedente findByPersonaId(Long id);
}
