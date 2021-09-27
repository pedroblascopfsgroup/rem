package es.pfsgroup.plugin.rem.provisiongastos.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.DtoProvisionGastosFilter;
import es.pfsgroup.plugin.rem.model.VBusquedaProvisionAgrupacionGastos;

public interface ProvisionAgrupacionGastosDao extends AbstractDao<VBusquedaProvisionAgrupacionGastos, Long>{
	
/**
 * Devuelve una página filtrada de provisiones
 * @param dto
 * @return
 */
	Page findAll (DtoProvisionGastosFilter dto, Long usuarioId);
	
}
