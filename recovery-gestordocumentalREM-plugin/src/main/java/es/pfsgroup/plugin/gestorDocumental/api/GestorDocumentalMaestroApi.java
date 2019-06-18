package es.pfsgroup.plugin.gestorDocumental.api;

import java.io.Serializable;

import es.pfsgroup.plugin.gestorDocumental.dto.ActivoInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.ActivoOutputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.GDInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.PersonaOutputDto;


public interface GestorDocumentalMaestroApi {

	public <T extends GDInputDto> Object ejecutar(T dto);
	
}
