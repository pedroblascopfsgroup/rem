package es.pfsgroup.plugin.rem.api;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.Concurrencia;
import es.pfsgroup.plugin.rem.model.DtoHistoricoConcurrencia;
import es.pfsgroup.plugin.rem.model.DtoPujaDetalle;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.VGridCambiosPeriodoConcurrencia;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosAgrupacionConcurrencia;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosConcurrencia;

public interface ConcurrenciaApi {
	
	Concurrencia getUltimaConcurrenciaByActivo(Activo activo);	

	boolean isActivoEnConcurrencia(Activo activo);

	boolean tieneActivoOfertasDeConcurrencia(Activo activo);

	boolean isAgrupacionEnConcurrencia(ActivoAgrupacion agr);

	boolean tieneAgrupacionOfertasDeConcurrencia(ActivoAgrupacion agr);
	
	boolean bloquearEditarOfertasPorConcurrenciaActivo(Activo activo);
	
	boolean bloquearEditarOfertasPorConcurrenciaAgrupacion(ActivoAgrupacion agr); 

    boolean isOfertaEnConcurrencia(Oferta ofr);
	
	boolean createPuja(Concurrencia concurrencia, Oferta oferta, Double importe);

	Concurrencia getUltimaConcurrenciaByAgrupacion(ActivoAgrupacion agrupacion);
	
	Oferta getOfertaGanadora(Activo activo);

	List<VGridOfertasActivosConcurrencia> getListOfertasVivasConcurrentes(Long idActivo, Long idConcurrencia);

	boolean isConcurrenciaOfertasEnProgresoActivo(Activo activo);

	boolean isConcurrenciaOfertasEnProgresoAgrupacion(ActivoAgrupacion agrupacion);

    void caducaOfertasRelacionadasConcurrencia(Long idActivo, Long idOferta);

	@Transactional
	void caducaOfertaConcurrencia(Long idActivo, Long idOferta);

	boolean isConcurrenciaTerminadaOfertasEnProgresoActivo(Activo activo);

	boolean isConcurrenciaTerminadaOfertasEnProgresoAgrupacion(ActivoAgrupacion agrupacion);
	
	List<DtoPujaDetalle> getPujasDetalleByIdOferta(Long idActivo, Long idOferta);

	List<DtoHistoricoConcurrencia> getHistoricoConcurrencia(Long idActivo);

	List<VGridCambiosPeriodoConcurrencia> getListCambiosPeriodoConcurenciaByIdConcurrencia(Long idConcurrencia);
}
