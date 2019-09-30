package es.pfsgroup.plugin.rem.activo.dao;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.ActivoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoActivosPublicacion;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPreciosFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.DtoLlaves;
import es.pfsgroup.plugin.rem.model.DtoPropuestaActivosVinculados;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.DtoTrabajoListActivos;
import es.pfsgroup.plugin.rem.model.PropuestaActivosVinculados;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;
import es.pfsgroup.plugin.rem.model.VBusquedaProveedoresActivo;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.VOfertasTramitadasPendientesActivosAgrupacion;

public interface ActivoDao extends AbstractDao<Activo, Long>{
	
	Page getListActivos(DtoActivoFilter dtoActivoFiltro, Usuario usuLogado);
	
	List<Activo> getListActivosLista(DtoActivoFilter dto, Usuario usuLogado);
	
	Integer isIntegradoAgrupacionRestringida(Long id, Usuario usuLogado);

	Integer isIntegradoAgrupacionComercial(Long idActivo);

	List<DDUnidadPoblacional> getComboInferiorMunicipio(String codigoMunicipio);

	Integer isIntegradoAgrupacionObraNueva(Long id, Usuario usuLogado);

	Integer getMaxOrdenFotoById(Long id);

	Page getListHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dto, Usuario usuLogado);

	Long getPresupuestoActual(Long id);

	Long getUltimoHistoricoPresupuesto(Long id);

	Integer getMaxOrdenFotoByIdSubdivision(Long idEntidad, BigDecimal hashSdv);
	
	Page getListActivosPrecios(DtoActivoFilter dto);

	Page getHistoricoValoresPrecios(DtoHistoricoPreciosFilter dto);

	void deleteValoracionById(Long id);

	boolean deleteValoracionSinDuplicarById(Long id);

	ActivoCondicionEspecifica getUltimaCondicion(Long idActivo);

	Page getPropuestas(DtoPropuestaFilter dtoPropuestaFiltro);

	Page getActivosPublicacion(DtoActivosPublicacion dtoActivosPublicacion);
	
    Long getNextNumOferta();

	Long getNextNumExpedienteComercial();

    Long getNextClienteRemId();

	Page getPropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto);

	Activo getActivoByNumActivo(Long activoVinculado);

	Activo getActivoById(Long activoId);

	PropuestaActivosVinculados getPropuestaActivosVinculadosByID(Long id);

	ActivoTasacion getActivoTasacion(Long id);

	List<ActivoTasacion> getListActivoTasacionByIdActivo(Long idActivo);

	Page getActivosFromCrearTrabajo(List<String> listIdActivos, DtoTrabajoListActivos dto);
	
	Page getLlavesByActivo(DtoLlaves dto);
	
	Page getListMovimientosLlaveByLlave(WebDto dto, Long idLlave);
	
	Page getListMovimientosLlaveByActivo(WebDto dto, Long idActivo);
	
	Integer isIntegradoAgrupacionObraNuevaOrAsistida(Long id);

	Boolean getDptoPrecio(Activo activo);
	
	void actualizarRatingActivo(Long idActivo, String username);

	List<VOfertasActivosAgrupacion> getListOfertasActivo(Long idActivo);

	/**
	 * Realiza una llamada al procedure CALCULO_SINGULAR_RETAIL_AUTO, el cual calcula el tipo comercializar que 
	 * le corresponde al activo según X criterios.
	 * @param idActivo - Activo a actualizar
	 * @param username - usuario que realiza la modificación
	 * @param all_activos - Indicador para hacerlo en todos los activos
	 * @param ingore_block - Indicador para ignorar el bloque automático indicado en el activo, el cual impide que este proceso automático lo recalcule.
	 */
	void actualizarSingularRetailActivo(Long idActivo, String username, Integer all_activos, Integer ingore_block);
	
	/**
	 * Devuelve el códgio del tipo de comercializar (Singular/Retail) del activo, con una consulta SQL directa.
	 * @param idActivo
	 * @return
	 */
	String getCodigoTipoComercializarByActivo(Long idActivo);
	
	/**
	 * Recupera una lista de activos con los id pasados en la cadena por parámetro
	 * @param cadenaId
	 * @return
	 */
	List<VBusquedaActivosPrecios> getListActivosPreciosFromListId(String cadenaId);
	 
	/**
	 *  Este método obtiene el siguiente número de la secuencia para el campo de
	 * 'ACT_NUM_ACTIVO_REM'.
	 * 
	 * @return Devuelve un Long con el siguiente número de la secuencia.
	 */
	Long getNextNumActivoRem();

	/**
	 * Este método recoje una lista de Ids de activo y obtiene en base a estos una lista de activos.
	 * @param activosID : Lista de ID de los activos a obtener.
	 * @return Devuelve una lista de Activos.
	 */
	List<Activo> getListActivosPorID(List<Long> activosID);

	/**
	 * Este método devuelve 1 si el ID del activo pertenece a una agrupación de tipo restringida
	 * y es el activo principal de la misma. 0 si no es el activo principal de la agrupación.
	 * 
	 * @param id: ID del activo a comprobar si es el activo principal de la agrupación restringida.
	 * @return Devuelve 1 si es el activo principal, 0 si no lo es.
	 */
	Integer isActivoPrincipalAgrupacionRestringida(Long id);

	/**
	 * Este método obtiene un objeto ActivoAgrupacionActivo de una agrupación de tipo restringida por el ID
	 * de activo.
	 * 
	 * @param id: Id del activo que pertenece a la agrupación.
	 * @return Devuelve un objeto de tipo ActivoAgrupacionActivo.
	 */
	ActivoAgrupacionActivo getActivoAgrupacionActivoAgrRestringidaPorActivoID(Long id);

	void deleteActivoDistribucion(Long idActivoInfoComercial);
	
	/**
	 * Este método lanza el procedimiento de cambio de estado de publicación y realiza la operación de generar un
	 * histórico para los movimientos realizados.
	 *
	 * @param idActivo: ID del activo para el cual se desea realizar la operación.
	 * @param username: nombre del usuario, si la llamada es desde la web, que realiza la operación.
	 * @param eleccionUsuarioTipoPublicacionAlquiler: indica si el tipo de publicación de alquiler es pre-publicado o publicado forzado.
	 * @return Devuelve True si la operación ha sido satisfactorio, False si no ha sido satisfactoria.
	 */
	Boolean publicarActivoConHistorico(Long idActivo, String username, String eleccionUsuarioTipoPublicacionAlquiler, boolean doFlush);

	Boolean publicarAgrupacionConHistorico(Long idAgrupacion, String username, String eleccionUsuarioTipoPublicacionAlquiler, boolean doFlush);

	/**
	 * Establece la fecha fin de los registros de un activo en el Historico de destino comercial
	 *
	 * @param activo
	 */
	void finHistoricoDestinoComercial(Activo activo, Object[] extraArgs);

	/**
	 * Crea un nuevo registro de un activo en el Historico de destino comercial
	 * con fechaFin a null y fechaInicio a la fecha actual
	 *
	 * @param activo
	 */
	void crearHistoricoDestinoComercial(Activo activo, Object[] extraArgs);

	List<VOfertasTramitadasPendientesActivosAgrupacion> getListOfertasTramitadasPendientesActivo(Long idActivo);

	List<ActivoCalificacionNegativa> getListActivoCalificacionNegativaByIdActivo(Long idActivo);

	Page getListHistoricoOcupacionesIlegalesByActivo(WebDto dto, Long idActivo);

	void hibernateFlush();
	
	/**
	 * Dado un idActivo devuelve una agrupacion de tipo PA si el idActivo pertenece a alguna
	 *
	 * @param idActivo
	 */
	ActivoAgrupacion getAgrupacionPAByIdActivo(Long idActivo);
	
	/**
	 * Dado un idActivo devuelve true si forma parte de una agrupacion de tipo Promocion Alquiler(PA) tanto si es AM como UA
	 *
	 * @param idActivo
	 */
	boolean isIntegradoEnAgrupacionPA(Long idActivo);
	
	/**
	 * Dado un idActivo devuelve true si es un Activo Matriz(AGA_PRINCIPAL = 1) en una agrupacion de tipo Promocion Alquiler(PA)
	 *
	 * @param idActivo
	 */
	boolean isActivoMatriz(Long idActivo);
	
	/**
	 * Dado un idActivo devuelve true si es un activo con DDTipoTituloActivo.UNIDAD_ALQUILABLE
	 *
	 * @param idActivo
	 */
	boolean isUnidadAlquilable(Long idActivo);
	/**
	 * Dado un id de Agrupacion devuelve el numero de los activos que la componen.
	 * Nota: El count cuenta tambien el activo matriz.
	 * @param idAgrupacion
	 */
	Long countUAsByIdAgrupacionPA(Long idAgrupacion);
	/**
	 * Dado un id de Agrupacion devuelve true si la agrupacion es de tipo de Promocion de alquiler.
	 * 
	 * @param idAgrupacion
	 */
	boolean isAgrupacionPromocionAlquiler ( Long idAgrupacion );
	/**
	 * Dado un id de Agrupacion devuelve el numero de los activos que tienen ofertas Vivas.
	 * 
	 * @param idAgrupacion
	 */
	boolean existenUAsconOfertasVivas( Long idAgrupacion );
	
	boolean existenUAsconTrabajos( Long idAgrupacion );
	/**
	 * Dado un id de activo devuelve el si tiene ofertas vivas.
	 * 
	 * @param idActivo
	 */
	boolean existeAMconOfertasVivas(Long idAgrupacion);

	Long getIdActivoMatriz(Long idAgrupacion);
	
	void validateAgrupacion(Long idActivo);

	/**
	 * Comprueba en un activo si tiene ofertas de venta.
	 * @param idActivo
	 * @return boolean true or false
	 */
	Boolean existenOfertasVentaActivo(Long idActivo);
	
	Boolean todasLasOfertasEstanAnuladas(Long idActivo);

	List<ActivoCalificacionNegativa> getListActivoCalificacionNegativaByIdActivoBorradoFalse(Long idActivo);


	List<VBusquedaProveedoresActivo> getListProveedor(List<String> listaIds);

	Boolean isPANoDadaDeBaja(Long idActivo);

	
	ActivoAgrupacion getAgrupacionPAByIdActivoConFechaBaja(Long idActivo);

	Boolean checkOfertasVivasAgrupacion(Long idAgrupacion);

	Boolean checkOTrabajosVivosAgrupacion(Long idAgrupacion);

	List<Object[]> getTrabajosUa(Long idAM, Long idUA);
	/**
	 * Comprueba en un activo si tiene trabajos vivos.
	 * @param idActivo
	 * @return boolean true or false
	 */
	boolean activoUAsconTrabajos(Long idActivo);
	/**
	 * Comprueba en un activo si tiene ofertas vivas.
	 * @param idActivo
	 * @return boolean true or false
	 */
	boolean activoUAsconOfertasVivas(Long idActivo);
	
	/**
	 * Comprueba si existe un numActivo.
	 * @param numActivo
	 * @return boolean true or false
	 */
	Boolean existeActivo(Long numActivo);
	
	ActivoAgrupacionActivo getActivoAgrupacionActivoObraNuevaPorActivoID(Long id);
	
	ActivoAgrupacionActivo getActivoAgrupacionActivoPA(Long idActivo);
	
	List<ActivoProveedor> getComboApiPrimario();
}
