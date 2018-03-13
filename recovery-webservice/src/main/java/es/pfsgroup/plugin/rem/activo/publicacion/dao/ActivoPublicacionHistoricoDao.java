package es.pfsgroup.plugin.rem.activo.publicacion.dao;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoPublicacionHistorico;
import es.pfsgroup.plugin.rem.model.DtoHistoricoEstadoPublicacion;

public interface ActivoPublicacionHistoricoDao extends AbstractDao<ActivoPublicacionHistorico, Long> {

	/**
	 * Este método devuelve un listado de histórico de estados de publicaciones de un activo por
	 * el ID de activo que recibe.
	 * 
	 * @param dto : dto con el ID de activo para filtrar el listado.
	 * @return Devuelve un listado con los resultados obtenidos.
	 */
	public List<ActivoPublicacionHistorico> getListadoHistoricoEstadosPublicacionVentaByIdActivo(DtoHistoricoEstadoPublicacion dto);

	/**
	 * Este método devuelve un listado de histórico de estados de publicaciones de un activo por
	 * el ID de activo que recibe.
	 * 
	 * @param dto : dto con el ID de activo para filtrar el listado.
	 * @return Devuelve un listado con los resultados obtenidos.
	 */
	public List<ActivoPublicacionHistorico> getListadoHistoricoEstadosPublicacionAlquilerByIdActivo(DtoHistoricoEstadoPublicacion dto);
	

	/**
	 * Este método convierte una entidad de tipo venta DtoHistoricoEstadoPublicacion a un pojo.
	 * 
	 * @param entidad: entidad a convertir en un objeto plano.
	 * @return Devuelve un obeto DtoHistoricoEstadoPublicacion relleno con la información de
	 * la entidad.
	 */
	public DtoHistoricoEstadoPublicacion convertirEntidadTipoVentaToDto(ActivoPublicacionHistorico entidad);

	/**
	 * Este método convierte una entidad de tipo alquiler DtoHistoricoEstadoPublicacion a un pojo.
	 * 
	 * @param entidad: entidad a convertir en un objeto plano.
	 * @return Devuelve un obeto DtoHistoricoEstadoPublicacion relleno con la información de
	 * la entidad.
	 */
	public DtoHistoricoEstadoPublicacion convertirEntidadTipoAlquilerToDto(ActivoPublicacionHistorico entidad);
}
