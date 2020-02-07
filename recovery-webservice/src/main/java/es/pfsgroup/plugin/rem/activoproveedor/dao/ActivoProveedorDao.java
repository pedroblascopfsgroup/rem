package es.pfsgroup.plugin.rem.activoproveedor.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;

public interface ActivoProveedorDao extends AbstractDao<ActivoProveedor, Long>{
	
	public ActivoProveedor getProveedorByCodigoRem(Long codigo);

}
