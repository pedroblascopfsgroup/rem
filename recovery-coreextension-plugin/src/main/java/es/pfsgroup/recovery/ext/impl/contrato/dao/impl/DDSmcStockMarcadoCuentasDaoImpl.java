package es.pfsgroup.recovery.ext.impl.contrato.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.ext.impl.contrato.dao.DDSmcStockMarcadoCuentasDao;
import es.pfsgroup.recovery.ext.impl.contrato.model.DDSmcStockMarcadoCuentas;

@Repository("DDSmcStockMarcadoCuentasDaoImpl")
public class DDSmcStockMarcadoCuentasDaoImpl extends AbstractEntityDao<DDSmcStockMarcadoCuentas, Long> implements DDSmcStockMarcadoCuentasDao{

	@Override
	public DDSmcStockMarcadoCuentas getDDSmcStockMarcadoCuentasByID(Long id) {
		HQLBuilder hb = new HQLBuilder("from DDSmcStockMarcadoCuentas ddssmc");
		hb.appendWhere("ddssmc.id = " + id); // ID.

		return HibernateQueryUtils.uniqueResult(this, hb);
	}

}
