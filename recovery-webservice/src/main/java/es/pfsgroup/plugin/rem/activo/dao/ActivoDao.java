package es.pfsgroup.plugin.rem.activo.dao;

import java.math.BigDecimal;
import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoEstadoPublicacion;
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
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;

public interface ActivoDao extends AbstractDao<Activo, Long>{
	
	/* Nombre que le damos al Activo buscado en la HQL */
	public static final String NAME_OF_ENTITY_ACT = "act";
	
	public Page getListActivos(DtoActivoFilter dtoActivoFiltro, Usuario usuLogado);
	
	public List<Activo> getListActivosLista(DtoActivoFilter dto, Usuario usuLogado);
	
	public Integer isIntegradoAgrupacionRestringida(Long id, Usuario usuLogado);

	public Integer isIntegradoAgrupacionComercial(Long idActivo);
	
	public List<DDUnidadPoblacional> getComboInferiorMunicipio(String codigoMunicipio);
	
	public Integer isIntegradoAgrupacionObraNueva(Long id, Usuario usuLogado);

	public Integer getMaxOrdenFotoById(Long id);

	public Page getListHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dto, Usuario usuLogado);

	public Long getPresupuestoActual(Long id);
	
	public Long getUltimoHistoricoPresupuesto(Long id);

	public Integer getMaxOrdenFotoByIdSubdivision(Long idEntidad, BigDecimal hashSdv);
	
	public Page getListActivosPrecios(DtoActivoFilter dto);

	public Page getHistoricoValoresPrecios(DtoHistoricoPreciosFilter dto);

	public void deleteValoracionById(Long id);
	
	public boolean deleteValoracionSinDuplicarById(Long id);

	public ActivoCondicionEspecifica getUltimaCondicion(Long idActivo);

	public Page getPropuestas(DtoPropuestaFilter dtoPropuestaFiltro);

	public Page getActivosPublicacion(DtoActivosPublicacion dtoActivosPublicacion);

	public ActivoHistoricoEstadoPublicacion getUltimoHistoricoEstadoPublicacion(Long activoID);
	
	public ActivoHistoricoEstadoPublicacion getPenultimoHistoricoEstadoPublicacion(Long activoID);
	
	public ActivoHistoricoEstadoPublicacion getUltimoHistoricoEstadoPublicado(Long activoID);
	
	public int publicarActivo(Long idActivo, String username);
	
	public int publicarActivoPortal(Long idActivo, String username);
	
    public Long getNextNumOferta();
    
    public Long getNextNumExpedienteComercial();
    
    public Long getNextClienteRemId();

	public Page getPropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto);

	public Activo getActivoByNumActivo(Long activoVinculado);
	
	public Activo getActivoById(Long activoId);

	public PropuestaActivosVinculados getPropuestaActivosVinculadosByID(Long id);

	public ActivoTasacion getActivoTasacion(Long id);
	
	public List<ActivoTasacion> getListActivoTasacionByIdActivo(Long idActivo);
	
	public Page getActivosFromCrearTrabajo(List<String> listIdActivos, DtoTrabajoListActivos dto);
	
	public Page getLlavesByActivo(DtoLlaves dto);
	
	public Page getListMovimientosLlaveByLlave(WebDto dto, Long idLlave);
	
	public Page getListMovimientosLlaveByActivo(WebDto dto, Long idActivo);
	
	public Integer isIntegradoAgrupacionObraNuevaOrAsistida(Long id);

	public Boolean getDptoPrecio(Activo activo);
	
	public void actualizarRatingActivo(Long idActivo, String username);

	public List<VOfertasActivosAgrupacion> getListOfertasActivo(Long idActivo);

	/**
	 * Realiza una llamada al procedure CALCULO_SINGULAR_RETAIL_AUTO, el cual calcula el tipo comercializar que 
	 * le corresponde al activo según X criterios.
	 * @param idActivo - Activo a actualizar
	 * @param username - usuario que realiza la modificación
	 * @param all_activos - Indicador para hacerlo en todos los activos
	 * @param ingore_block - Indicador para ignorar el bloque automático indicado en el activo, el cual impide que este proceso automático lo recalcule.
	 */
	public void actualizarSingularRetailActivo(Long idActivo, String username, Integer all_activos, Integer ingore_block);
	
	/**
	 * Devuelve el códgio del tipo de comercializar (Singular/Retail) del activo, con una consulta SQL directa.
	 * @param idActivo
	 * @return
	 */
	public String getCodigoTipoComercializarByActivo(Long idActivo);
	
	/**
	 * Recupera una lista de activos con los id pasados en la cadena por parámetro
	 * @param cadenaId
	 * @return
	 */
	public List<VBusquedaActivosPrecios> getListActivosPreciosFromListId(String cadenaId);
	 
	/**
	 *  Este método obtiene el siguiente número de la secuencia para el campo de
	 * 'ACT_NUM_ACTIVO_REM'.
	 * 
	 * @return Devuelve un Long con el siguiente número de la secuencia.
	 */
	public Long getNextNumActivoRem();

	/**
	 * Este método recoje una lista de Ids de activo y obtiene en base a estos una lista de activos.
	 * @param activosID : Lista de ID de los activos a obtener.
	 * @return Devuelve una lista de Activos.
	 */
	public List<Activo> getListActivosPorID(List<Long> activosID);

	/**
	 * Este método devuelve 1 si el ID del activo pertenece a una agrupación de tipo restringida
	 * y es el activo principal de la misma. 0 si no es el activo principal de la agrupación.
	 * 
	 * @param id: ID del activo a comprobar si es el activo principal de la agrupación restringida.
	 * @return Devuelve 1 si es el activo principal, 0 si no lo es.
	 */
	public Integer isActivoPrincipalAgrupacionRestringida(Long id);

	/**
	 * Este método obtiene un objeto ActivoAgrupacionActivo de una agrupación de tipo restringida por el ID
	 * de activo.
	 * 
	 * @param id: Id del activo que pertenece a la agrupación.
	 * @return Devuelve un objeto de tipo ActivoAgrupacionActivo.
	 */
	public ActivoAgrupacionActivo getActivoAgrupacionActivoAgrRestringidaPorActivoID(Long id);
	
	public void deleteActivoDistribucion(Long idActivoInfoComercial);


}
