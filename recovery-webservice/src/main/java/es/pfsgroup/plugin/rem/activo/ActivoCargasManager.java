package es.pfsgroup.plugin.rem.activo;

import java.text.SimpleDateFormat;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.users.FuncionManager;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoCargasDao;
import es.pfsgroup.plugin.rem.api.ActivoCargasApi;
import es.pfsgroup.plugin.rem.model.ActivoCargas;


@Service("activoCargasManager")
public class ActivoCargasManager extends BusinessOperationOverrider<ActivoCargasApi> implements ActivoCargasApi {

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	
	protected static final Log logger = LogFactory.getLog(ActivoCargasManager.class);
	
	@Autowired
	private Executor executor;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoCargasDao ActivoCargasDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Override
	public String managerName() {
		return "activoCargasManager";
	}

	@Autowired
	private FuncionManager funcionManager;

	@Override
	@BusinessOperation(overrides = "activoCargasManager.get")
	public ActivoCargas get(Long id) {
		return ActivoCargasDao.get(id);
	}
	
	@Override
	@BusinessOperation(overrides = "activoCargasManager.saveOrUpdate")
	@Transactional
	public boolean saveOrUpdate(ActivoCargas activoCargas) {
		ActivoCargasDao.saveOrUpdate(activoCargas);
		return true;
	}

}