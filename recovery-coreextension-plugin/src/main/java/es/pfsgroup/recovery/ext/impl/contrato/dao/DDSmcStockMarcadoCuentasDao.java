package es.pfsgroup.recovery.ext.impl.contrato.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.ext.impl.contrato.model.DDSmcStockMarcadoCuentas;

public interface DDSmcStockMarcadoCuentasDao extends AbstractDao<DDSmcStockMarcadoCuentas, Long>{

	public static final String BO_GET_DDSMCSTOCKMARCADOCUENTAS_BY_CNTID = "es.pfsgroup.recovery.ext.impl.contrato.dao.getDDSmcStockMarcadoCuentasByID";

	/**
	 * Obtiene un DDSmcStockMarcadoCuentas por el ID.
	 * 
	 * @param idContrato : el id.
	 * @return devuelve un objeto DDSmcStockMarcadoCuentas relleno con la
	 * 			informacion.
	 */
	@BusinessOperationDefinition(BO_GET_DDSMCSTOCKMARCADOCUENTAS_BY_CNTID)
	DDSmcStockMarcadoCuentas getDDSmcStockMarcadoCuentasByID(Long id);
	
}
