package es.pfsgroup.plugin.rem.gasto;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionActivoApi;
import es.pfsgroup.plugin.rem.api.GastoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.gasto.dao.GastoDao;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

@Service("gastoManager")
public class GastoManager extends BusinessOperationOverrider<OfertaApi> implements  GastoApi {
	
	
	protected static final Log logger = LogFactory.getLog(GastoManager.class);
	
	
	@Autowired
	private RestApi restApi;
	
	@Autowired
	private ActivoAgrupacionActivoApi activoAgrupacionActivoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GastoDao gastoDao;

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
	
	
	
	
	
	@Override
	public DtoPage getListGastos(DtoGastosFilter dtoGastosFilter) {

		return gastoDao.getListGastos(dtoGastosFilter);
	}
	
	
}
