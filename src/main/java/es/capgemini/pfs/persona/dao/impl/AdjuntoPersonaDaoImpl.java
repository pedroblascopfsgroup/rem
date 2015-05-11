package es.capgemini.pfs.persona.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.dao.AdjuntoPersonaDao;
import es.capgemini.pfs.persona.model.AdjuntoPersona;

/**
 * Implementación del dao de adjuntos de Persona.
 * @author marruiz
 */
@Repository("AdjuntoPersonaDao")
public class AdjuntoPersonaDaoImpl extends AbstractEntityDao<AdjuntoPersona, Long> implements AdjuntoPersonaDao {

}
