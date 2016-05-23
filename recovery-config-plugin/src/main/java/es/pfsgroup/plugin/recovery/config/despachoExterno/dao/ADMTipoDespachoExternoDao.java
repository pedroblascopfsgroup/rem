package es.pfsgroup.plugin.recovery.config.despachoExterno.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;

public interface ADMTipoDespachoExternoDao extends AbstractDao<DDTipoDespachoExterno, Long>{

	/**
	 * Devuelve los tipos de despacho, teniendo en cuenta la multi-entidad, para que no los mezcle.
	 * @return
	 */
	List<DDTipoDespachoExterno> getListTipoDespachoByEntidad();
}
