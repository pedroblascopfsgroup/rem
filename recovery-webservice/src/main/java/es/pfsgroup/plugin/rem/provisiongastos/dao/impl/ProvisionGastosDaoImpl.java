package es.pfsgroup.plugin.rem.provisiongastos.dao.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.model.DtoProvisionGastosFilter;
import es.pfsgroup.plugin.rem.model.ProvisionGastos;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;
import es.pfsgroup.plugin.rem.provisiongastos.dao.ProvisionGastosDao;

@Repository("ProvisionGastosDao")
public class ProvisionGastosDaoImpl extends AbstractEntityDao<ProvisionGastos, Long> implements ProvisionGastosDao{
	
	@Autowired
	ProveedoresDao proveedorDao;

	@Override
	public Page findAll(DtoProvisionGastosFilter dto) {
		
		HQLBuilder hb = new HQLBuilder(" from ProvisionGastos prg");

   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "prg.numProvision", dto.getNumProvision());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "prg.estadoProvision.codigo", dto.getEstadoProvisionCodigo());
		
   		return HibernateQueryUtils.page(this, hb, dto);

	}
	
	@SuppressWarnings("static-access")
	@Override
	public Page findAllFilteredByProveedor(DtoProvisionGastosFilter dto, Long idUsuario) {
		
		HQLBuilder hb = new HQLBuilder(" from ProvisionGastos prg");

   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "prg.numProvision", dto.getNumProvision());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "prg.estadoProvision.codigo", dto.getEstadoProvisionCodigo());
   		
   		if(!Checks.esNulo(idUsuario)) {
   			hb.addFiltroWhereInSiNotNull(hb, "prg.gestoria.id", proveedorDao.getIdProveedoresByIdUsuario(idUsuario));
   		}
   		else {
   			hb.appendWhere("prg.id is null");
   		}
		
   		return HibernateQueryUtils.page(this, hb, dto);
	}
    
}
