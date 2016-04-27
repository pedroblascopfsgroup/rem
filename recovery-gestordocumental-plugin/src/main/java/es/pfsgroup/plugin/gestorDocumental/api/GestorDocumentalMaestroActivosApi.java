package es.pfsgroup.plugin.gestorDocumental.api;

import es.pfsgroup.plugin.gestorDocumental.dto.InputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.OutputDto;


public interface GestorDocumentalMaestroActivosApi {

	OutputDto ejecutar(InputDto dto);
	
}
