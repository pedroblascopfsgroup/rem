package es.pfsgroup.plugin.rem.gasto;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GastoApi;
import es.pfsgroup.plugin.rem.gasto.dao.GastoDao;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.GastoProveedor;

@Service("gastoManager")
public class GastoManager extends BusinessOperationOverrider<GastoApi> implements  GastoApi {
	
	
	protected static final Log logger = LogFactory.getLog(GastoManager.class);
	
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
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numGasto", numGasto);
		
		rawDao.addParams(params);

		try {
				idGasto = rawDao.getExecuteSQL(
						"SELECT GPV_ID FROM GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = :numGasto AND BORRADO = 0");
			
			
			return Long.parseLong(idGasto);

		} catch (Exception e) {
			return null;
		}
	}
	
	@Override
	public DtoPage getListGastos(DtoGastosFilter dtoGastosFilter) {
		Usuario usuarioId = genericAdapter.getUsuarioLogado();
		
		return gastoDao.getListGastos(dtoGastosFilter, usuarioId.getId());
	}
	
	@Override
	public GastoProveedor getByNumGasto(Long numGastoHaya) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", numGastoHaya);
		Filter filterBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		return genericDao.get(GastoProveedor.class, filter,filterBorrado);
	}
	
}
