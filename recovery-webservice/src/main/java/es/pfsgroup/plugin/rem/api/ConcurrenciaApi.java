package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;

public interface ConcurrenciaApi {

	boolean isActivoEnConcurrencia(Activo activo);

	boolean tieneActivoOfertasDeConcurrencia(Activo activo);

	boolean isAgrupacionEnConcurrencia(ActivoAgrupacion agr);

	boolean tieneAgrupacionOfertasDeConcurrencia(ActivoAgrupacion agr);

	
}
