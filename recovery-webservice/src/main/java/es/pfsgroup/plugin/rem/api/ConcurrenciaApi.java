package es.pfsgroup.plugin.rem.api;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.Concurrencia;
import es.pfsgroup.plugin.rem.model.Oferta;

public interface ConcurrenciaApi {
	
	Concurrencia getUltimaConcurrenciaByActivo(Activo activo);	

	boolean isActivoEnConcurrencia(Activo activo);

	boolean tieneActivoOfertasDeConcurrencia(Activo activo);

	boolean isAgrupacionEnConcurrencia(ActivoAgrupacion agr);

	boolean tieneAgrupacionOfertasDeConcurrencia(ActivoAgrupacion agr);

    boolean isOfertaEnConcurrencia(Oferta ofr);
	
	boolean createPuja(Concurrencia concurrencia, Oferta oferta, Double importe);

	Concurrencia getUltimaConcurrenciaByAgrupacion(ActivoAgrupacion agrupacion);
	
}
