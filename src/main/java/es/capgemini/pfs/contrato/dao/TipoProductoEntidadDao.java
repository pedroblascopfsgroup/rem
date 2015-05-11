package es.capgemini.pfs.contrato.dao;

import java.util.List;
import java.util.Set;
import es.capgemini.pfs.contrato.model.DDTipoProductoEntidad;
import es.capgemini.pfs.dao.AbstractDao;

/**
 * Interfaz para el DAO de DDTipoProductoEntidad.
 */

public interface TipoProductoEntidadDao extends AbstractDao<DDTipoProductoEntidad, Long> {
	
	List<DDTipoProductoEntidad> getOrderedList();
}
