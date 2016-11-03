package es.pfsgroup.plugin.rem.proveedores.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoMediador;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;

public interface ProveedoresDao extends AbstractDao<ActivoProveedor, Long>{

	public List<DtoProveedorFilter> getProveedoresList(DtoProveedorFilter dtoProveedorFiltro);

	public ActivoProveedor getProveedorById(Long id);

	public ActivoProveedor getProveedorByNIFTipoSubtipo(DtoProveedorFilter dtoProveedorFilter);

	public List<ActivoProveedor> getMediadorListFiltered(Activo activo, DtoMediador dto);

	public Long getNextNumCodigoProveedor();

}
