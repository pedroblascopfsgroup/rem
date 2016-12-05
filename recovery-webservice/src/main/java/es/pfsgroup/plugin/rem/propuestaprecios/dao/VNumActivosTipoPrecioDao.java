package es.pfsgroup.plugin.rem.propuestaprecios.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.VBusquedaNumActivosTipoPrecio;

public interface VNumActivosTipoPrecioDao extends AbstractDao<VBusquedaNumActivosTipoPrecio, String>{

	/**
	 * Devuelve un listado con la cantidad de activos por Preciar o Repreciar, agrupados por cartera
	 * @return
	 */
	List<VBusquedaNumActivosTipoPrecio> getNumActivosByTipoPrecioAndCartera();
	
	List<VBusquedaNumActivosTipoPrecio> getNumActivosByTipoPrecioAndEstado(String entidadPropietariaCodigo);
}
