package es.pfsgroup.plugin.rem.activo;

import java.text.SimpleDateFormat;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.plugin.rem.activo.dao.ActivoCargasDao;
import es.pfsgroup.plugin.rem.api.ActivoCargasApi;
import es.pfsgroup.plugin.rem.model.ActivoCargas;

@Service("activoCargasManager")
public class ActivoCargasManager extends BusinessOperationOverrider<ActivoCargasApi> implements ActivoCargasApi {

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

	protected static final Log logger = LogFactory.getLog(ActivoCargasManager.class);

	@Autowired
	private ActivoCargasDao ActivoCargasDao;

	@Override
	public String managerName() {
		return "activoCargasManager";
	}

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

	@Override
	public boolean esActivoConCargasNoCanceladas(Long idActivo) {

		return ActivoCargasDao.esActivoConCargasNoCanceladas(idActivo);
	}

}