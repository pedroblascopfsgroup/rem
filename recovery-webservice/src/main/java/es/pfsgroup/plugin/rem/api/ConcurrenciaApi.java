package es.pfsgroup.plugin.rem.api;

import java.io.IOException;
import java.util.List;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;

import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.Concurrencia;
import es.pfsgroup.plugin.rem.model.DtoHistoricoConcurrencia;
import es.pfsgroup.plugin.rem.model.DtoPujaDetalle;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.VGridCambiosPeriodoConcurrencia;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosConcurrencia;

public interface ConcurrenciaApi {
	
	public static final String COD_ANULACION_OFERTA_FALTA_CONFIRMACION_DEPOSITO = "AOFCD";
	public static final String COD_COMUNICACION_AMPLIACION_PROCESO_CONCURRENCIA = "CAPC";
	public static final String COD_COMUNICACION_ANULACION_PROCESO_CONCURRENCIA = "CANPC";
	public static final String COD_FIN_PUJA_REM = "FPR";
	public static final String COD_FIN_PUJA_REM_INTERNO = "FPRI";
	public static final String COD_OFERTA_ANULADA_FORMA_MANUAL = "OAFM";
	public static final String COD_OFERTA_GANADORA = "OFGA";
	public static final String COD_OFERTAS_PERDEDORAS = "OFPE";

	public static final String TIPO_ENVIO_UNICO = "send";
	public static final String TIPO_ENVIO_MULTIPLE = "sendBatch";
	
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

    void caducaOfertasRelacionadasConcurrencia(Long idActivo, Long idOferta, String codigoEnvioCorreo);

	@Transactional
	boolean caducaOfertaConcurrencia(Long idActivo, Long idOferta);

	boolean isConcurrenciaTerminadaOfertasEnProgresoActivo(Activo activo);

	boolean isConcurrenciaTerminadaOfertasEnProgresoAgrupacion(ActivoAgrupacion agrupacion);
	
	List<DtoPujaDetalle> getPujasDetalleByIdOferta(Long idActivo, Long idOferta);

	List<DtoHistoricoConcurrencia> getHistoricoConcurrencia(Long idActivo);

	List<VGridCambiosPeriodoConcurrencia> getListCambiosPeriodoConcurenciaByIdConcurrencia(Long idConcurrencia);

	boolean isOfertaEnPlazoConcu(boolean bloquear, List<Oferta> listOfertas);

	void comunicacionSFMC(List<Long> idOfertaList, String codigoEnvio, String tipoEnvio, ModelMap model)
			throws JsonGenerationException, JsonMappingException, IOException;

}
