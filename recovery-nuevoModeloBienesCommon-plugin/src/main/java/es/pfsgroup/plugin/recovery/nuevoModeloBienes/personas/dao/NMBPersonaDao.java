package es.pfsgroup.plugin.recovery.nuevoModeloBienes.personas.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.persona.model.Persona;

public interface NMBPersonaDao extends AbstractDao<Persona, Long>{

	public Long getListaProcedimientosDePersona(Long idPersona);
}
