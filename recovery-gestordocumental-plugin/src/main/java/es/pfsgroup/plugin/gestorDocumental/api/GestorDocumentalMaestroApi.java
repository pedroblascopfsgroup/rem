package es.pfsgroup.plugin.gestorDocumental.api;

import es.pfsgroup.plugin.gestorDocumental.dto.ActivoInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.ActivoOutputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaOutputDto;


public interface GestorDocumentalMaestroApi {

	ActivoOutputDto ejecutarActivo(ActivoInputDto dto);
	
	PersonaOutputDto ejecutarPersona(PersonaInputDto dto);
}
