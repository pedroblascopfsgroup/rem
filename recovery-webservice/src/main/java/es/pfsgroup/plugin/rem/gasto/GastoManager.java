package es.pfsgroup.plugin.rem.gasto;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.api.GastoApi;
import es.pfsgroup.plugin.rem.gasto.dao.GastoDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

@Service("gastoManager")
public class GastoManager extends BusinessOperationOverrider<GastoApi> implements  GastoApi {
	
	
	protected static final Log logger = LogFactory.getLog(GastoManager.class);
	
	
	@Autowired
	private RestApi restApi;
	
	@Autowired
	private ActivoAgrupacionActivoApi activoAgrupacionActivoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GastoDao gastoDao;
	
	@Autowired
	private MSVRawSQLDao rawDao;
	
	@Autowired
	private GenericAdapter genericAdapter;

	@Override
	public String managerName() {
		return "gastoManager";
	}
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	
	
	
	
	@Override
	public GastoProveedor getGastoById(Long id){		
		GastoProveedor gastoProveedor = null;
		
		try{
			
			gastoProveedor = gastoDao.get(id);
		
		} catch(Exception ex) {
			ex.printStackTrace();			
		}
		
		return gastoProveedor;
	}
	
	public Long getGastoExists(Long numGasto) {

		String idGasto = null;

		try {
				idGasto = rawDao.getExecuteSQL(
						"SELECT GPV_ID FROM GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = " + numGasto + " AND BORRADO = 0");
			
			
			return Long.parseLong(idGasto);

		} catch (Exception e) {
			return null;
		}
	}
	
	
	
	@Override
	public DtoPage getListGastos(DtoGastosFilter dtoGastosFilter) {

		return gastoDao.getListGastos(dtoGastosFilter);
	}
	
	@Override
	public GastoProveedor getByNumGasto(Long numGastoHaya) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", numGastoHaya);
		Filter filterBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		return genericDao.get(GastoProveedor.class, filter,filterBorrado);
	}
	
	
	
	
}
