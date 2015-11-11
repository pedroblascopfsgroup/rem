package es.pfsgroup.recovery.cajamar.serviciosonline;

import es.pfsgroup.recovery.gestorDocumental.dto.GestorDocumentalInputDto;
import es.pfsgroup.recovery.gestorDocumental.dto.GestorDocumentalOutputDto;

public interface GestorDocumentalWSApi {

	GestorDocumentalOutputDto ejecutar(GestorDocumentalInputDto dto);
	
}
