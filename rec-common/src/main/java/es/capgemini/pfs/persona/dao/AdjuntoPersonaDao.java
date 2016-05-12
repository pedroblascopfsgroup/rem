package es.capgemini.pfs.persona.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.persona.model.AdjuntoPersona;

/**
 * Interfaz dao para los Adjuntos de Persona.
 * @author marruiz
 */
public interface AdjuntoPersonaDao extends AbstractDao<AdjuntoPersona, Long> {
	
	public List<AdjuntoPersona> getAdjuntoPersonaByIdDocumento(List<Integer> idsDocumento);

}
