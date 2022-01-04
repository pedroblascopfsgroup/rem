package es.pfsgroup.plugin.rem.activo.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionFilter;
import es.pfsgroup.plugin.rem.model.NotificacionGencat;
import es.pfsgroup.plugin.rem.model.ReclamacionGencat;
import es.pfsgroup.plugin.rem.model.VisitaGencat;

public interface ActivoAgrupacionActivoDao extends AbstractDao<ActivoAgrupacionActivo, Long>{
	
	/* Nombre que le damos al Agrupacion buscado en la HQL */
	public static final String NAME_OF_ENTITY_ACT = "act";

	public ActivoAgrupacionActivo getActivoAgrupacionActivoByIdActivoAndIdAgrupacion(long idActivo, long idAgrupacion);

	public void deleteById (Long id);
	
	public int numActivosPorActivoAgrupacion(long idAgrupacion);
	
	public ActivoAgrupacionActivo getByIdActivoAndIdAgrupacion(long idActivo, long idAgrupacion);
	
	public ActivoAgrupacionActivo getAgrupacionPAByIdAgrupacion(long idAgrupacion);
	
	public ActivoAgrupacionActivo primerActivoPorActivoAgrupacion(long idAgrupacion);

	public boolean isUniqueRestrictedActive(Activo activo); 
	
	public boolean isUniqueNewBuildingActive(Activo activo);
	
	public boolean isUniqueAgrupacionActivo(Long idActivo, String codigoTipoAgrupacion, Long numAgrupacion);
	
	public boolean estaAgrupacionActivoConFechaBaja(Activo activo);
	
	public List<ActivoAgrupacionActivo> getListActivosAgrupacion(DtoAgrupacionFilter dtoAgrupActivo);

	/**
	 * Este método obtiene una lista de ActivoAgrupacionActivo sobre la asociación entre una agrupación
	 * por su ID y una lista de activos. Si existe la coincidiencia añade el ID de la asociación a la lista.
	 * 
	 * @param idAgrupacion : ID de la agrupación contra la que contrastar los ID de activos.
	 * @param activosID : una lista que contiene los ID de los activos .
	 * @return Devuelve una lista de ActivoAgrupacionActivo para las coincidencias encontradas entre el ID
	 *  de la agrupación e ID de los activos.
	 */
	public List<ActivoAgrupacionActivo> getListActivoAgrupacionActivoByAgrupacionIDAndActivos(Long idAgrupacion, List<Long> activosID);

	/**
	 * Este método devuelve True si el activo se encuentre en alguna agrupación de tipo 'lote comercial'.
	 * 
	 * @param idActivo : ID del activo a comprobar si se encuentra en una agrupación de tipo 'lote comercial'.
	 * @return Devuelve True si el activo se encuentra en una agrupación de tipo 'lote comercial', False si no
	 * lo está.
	 */
	public boolean activoEnAgrupacionLoteComercial(Long idActivo);

	/**
	 * Este método devuelve True si algún activo de la lista se encuentra en alguna agrupación de tipo 'lote comercial'.
	 * 
	 * @param activosID : lista de ID de activos.
	 * @return Devuelve True si algún activo se encuentra en alguna agrupación de tipo 'lote comercial', False si no es así.
	 */
	public boolean algunActivoDeAgrRestringidaEnAgrLoteComercial(List<Long> activosID);

	/**
	 * Este método devuelve el Activo Matriz de una agrupacion de tipo PA por medio de un idAgrupacion
	 * 
	 * @param idAgrupacion : idAgrupacion.
	 * @return Activo
	 */
	public Activo getActivoMatrizByIdAgrupacion(Long idAgrupacion);

	public List<ActivoAgrupacionActivo> getListActivoAgrupacionVentaByIdActivo(Long idActivo);

	public void deleteTramiteGencat(ComunicacionGencat comunicacionGencat, List<NotificacionGencat> notificacionesGencat, List<ReclamacionGencat> reclamacionesGencat, VisitaGencat visitaGencat);
	
	/**
	 * Este método devuelve el Activo Matriz de una agrupacion de tipo PA por medio de un idAgrupacion
	 * 
	 * @param idAgrupacion : idAgrupacion.
	 * @return Activo
	 */
	public List<Activo> getListUAsByIdAgrupacion(Long idAgrupacion);
	
	public ActivoAgrupacionActivo getActivoAgrupacionActivoPrincipalByIdAgrupacion(long idAgrupacion);

	List<ActivoAgrupacionActivo> getListActivoAgrupacionActivoByAgrupacionID(Long idAgrupacion);

	/**
	 * Este método devuelve un objeto de tipo Activo a partir de un id de agrupación para obtener su piso piloto
	 * @param idAgrupacion : idAgrupacion
	 * @return Activo
	 */
	public Activo getPisoPilotoByIdAgrupacion(long idAgrupacion);

	boolean activoEnAgrupacionLoteComercialAlquiler(Long idActivo);
	
	boolean isTipoComercializacionesAgrupaciones(Long idAgrupacion);

	boolean algunActivoAlquilado(List<Long> activosID);

	boolean algunActivoVendido(List<Long> activosID);
}
