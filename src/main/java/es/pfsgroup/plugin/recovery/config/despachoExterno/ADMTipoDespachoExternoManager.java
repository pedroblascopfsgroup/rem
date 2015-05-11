package es.pfsgroup.plugin.recovery.config.despachoExterno;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.pfsgroup.plugin.recovery.config.despachoExterno.dao.ADMTipoDespachoExternoDao;

@Service("admTipoDespachoExternoManager")
public class ADMTipoDespachoExternoManager {
	
	@Autowired
	private ADMTipoDespachoExternoDao tipoDespachoDao;

	public ADMTipoDespachoExternoManager(){}
	
	public ADMTipoDespachoExternoManager(ADMTipoDespachoExternoDao dao) {
		tipoDespachoDao = dao;
	}

	
	@BusinessOperation("admTipoDespachoExternoManager.getList")
	public List<DDTipoDespachoExterno> getList() {
		return tipoDespachoDao.getList();
	}

}
