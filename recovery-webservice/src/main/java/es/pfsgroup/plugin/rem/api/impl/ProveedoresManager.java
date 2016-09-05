package es.pfsgroup.plugin.rem.api.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ProveedoresApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.factory.PropuestaPreciosExcelFactoryApi;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoProveedorFilter;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.PropuestaPrecioDao;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.VActivosPropuestaDao;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.VNumActivosTipoPrecioDao;

@Service("proveedoresManager")
public class ProveedoresManager extends BusinessOperationOverrider<ProveedoresApi> implements  ProveedoresApi {
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private PropuestaPrecioDao propuestaPrecioDao;
	
	@Autowired
	private VActivosPropuestaDao vActivosPropuestaDao;
	
	@Autowired
	private VNumActivosTipoPrecioDao vNumActivosTipoPrecioDao;
	
	@Autowired
	private PropuestaPreciosExcelFactoryApi propuestaPreciosExcelFactory;

	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

		
	@Override
	public String managerName() {
		return "preciosManager";
	}
	
	@Override
	public Page getProveedores(DtoProveedorFilter dtoProveedorFiltro) {

		return genericDao.getPage(ActivoProveedor.class, dtoProveedorFiltro);
		
	}	

}
