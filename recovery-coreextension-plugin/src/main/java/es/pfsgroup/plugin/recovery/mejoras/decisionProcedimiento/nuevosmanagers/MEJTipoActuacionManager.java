package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers.dao.MEJTipoActuacionDao;

@Component
public class MEJTipoActuacionManager {
	
	public static final String BO_TAC_MGR_GET_BY_CODIGO = "plugin.mejoras.tipoActuacionManager.getByCodigo";
	
	@Autowired
	private MEJTipoActuacionDao taDao;

	@BusinessOperation(BO_TAC_MGR_GET_BY_CODIGO)
	public DDTipoActuacion getByCodigo(String codigo){
		return taDao.getByCodigo(codigo);
	}
}
