package es.pfsgroup.recovery.cajamar.serviciosonline;

import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.GestorDocumentalInputDto;
import es.pfsgroup.recovery.cajamar.gestorDocumental.dto.GestorDocumentalOutputDto;

public interface GestorDocumentalWSApi {

	GestorDocumentalOutputDto ejecutar(GestorDocumentalInputDto dto);
	
}
