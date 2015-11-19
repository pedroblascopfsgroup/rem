package es.pfsgroup.plugin.precontencioso.burofax.dao;

import java.util.Collection;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxPCO;

public interface BurofaxDao extends AbstractDao<BurofaxPCO, Long> {
	
	Collection<? extends Persona> getPersonasConDireccion(String query);
	
	Collection<? extends Persona> getPersonas(String query);
	
	Collection<? extends Persona> getPersonasConContrato(String query);
	
	Long obtenerSecuenciaFicheroDocBurofax();

}
