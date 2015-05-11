package es.capgemini.pfs.direccion.dao;

import java.util.Collection;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.model.Persona;

public interface DireccionDao  extends AbstractDao<Direccion, Long> {

    Collection<? extends Persona> getPersonas(String query, Long idAsunto);
	
	public Long getLastId(String entity);

	public Long getNextIdDireccion();
	
	public Long getNextCodDireccionManual();
	
//	public int saveOrUpdatePersonaDireccion(Long idPersona, Long idDireccion, String usuario);
	
}
