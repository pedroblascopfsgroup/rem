package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.DDTipoReclamacion;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers.dao.MEJTipoReclamacionDao;

@Component
public class MEJTipoReclamacionManager {

	public static final String BO_TRE_MGR_GET_BY_CODIGO = "plugin.mejoras.tipoReclamacionManager.getByCodigo";
	
	@Autowired
	private MEJTipoReclamacionDao trDao;
	
	@BusinessOperation(BO_TRE_MGR_GET_BY_CODIGO)
	public DDTipoReclamacion get(String codigo){
		
		return trDao.getByCodigo(codigo);
	}
}
