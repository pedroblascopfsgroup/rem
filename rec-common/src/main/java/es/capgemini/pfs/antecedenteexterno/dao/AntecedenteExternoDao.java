package es.capgemini.pfs.antecedenteexterno.dao;

import java.util.List;

import es.capgemini.pfs.antecedenteexterno.model.AntecedenteExterno;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * @author Mariano Ruiz
 */
public interface AntecedenteExternoDao extends AbstractDao<AntecedenteExterno, Long> {

    /**
     * Retorna los antecedentes externos de la persona.
     * @param id Long: el id de la Persona
     * @return List
     */
    List<AntecedenteExterno> findByPersonaId(Long id);
}
