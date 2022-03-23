package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.Concurrencia;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosAgrupacionConcurrencia;

public interface ConcurrenciaApi {
	
	Concurrencia getUltimaConcurrenciaByActivo(Activo activo);	

	boolean isActivoEnConcurrencia(Activo activo);

	boolean tieneActivoOfertasDeConcurrencia(Activo activo);

	boolean isAgrupacionEnConcurrencia(ActivoAgrupacion agr);

	boolean tieneAgrupacionOfertasDeConcurrencia(ActivoAgrupacion agr);

    boolean isOfertaEnConcurrencia(Oferta ofr);
	
	boolean createPuja(Concurrencia concurrencia, Oferta oferta, Double importe);

	Concurrencia getUltimaConcurrenciaByAgrupacion(ActivoAgrupacion agrupacion);
	
	Oferta getOfertaGanadora(Activo activo);

	List<VGridOfertasActivosAgrupacionConcurrencia> getListOfertasVivasConcurrentes(Long idActivo);

	boolean isConcurrenciaOfertasEnProgresoActivo(Activo activo);

	boolean isConcurrenciaOfertasEnProgresoAgrupacion(ActivoAgrupacion agrupacion);
}
