package es.pfsgroup.plugin.rem.proveedores.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;

public interface ProveedoresDao extends AbstractDao<ActivoProveedor, Long>{

	public Page getProveedoresList(DtoProveedorFilter dtoProveedorFiltro);

	public ActivoProveedor getProveedorById(Long id);

}
