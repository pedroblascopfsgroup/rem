package es.pfsgroup.plugin.precontencioso.burofax.dao;

import java.util.Collection;
import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.persona.dto.DtoPersonaManual;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.plugin.precontencioso.burofax.dto.ContratosPCODto;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxPCO;

public interface BurofaxDao extends AbstractDao<BurofaxPCO, Long> {
	
	Collection<? extends Persona> getPersonasConDireccion(String query);
	
	Collection<? extends Persona> getPersonas(String query);
	
	Collection<DtoPersonaManual> getPersonasConContrato(String query);
	Collection<DtoPersonaManual> getPersonasConContrato(String query, boolean addManuales);
	
	Long obtenerSecuenciaFicheroDocBurofax();

	List<ContratosPCODto> getContratosProcPersona(Long idProcedimientoPCO, Long idPersona, Boolean manual);
}
