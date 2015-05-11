package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.PluginMejorasBOConstants;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevosmanagers.dao.MEJTipoProcedimientoDao;

@Component
public class MEJTipoProcedimientoManager {

	@Autowired
	private MEJTipoProcedimientoDao tpDao;
	
	@BusinessOperation(PluginMejorasBOConstants.BO_TPO_MGR_GET_BY_CODIGO)
	public TipoProcedimiento getByCodigo(String codigo){
		return tpDao.getByCodigo(codigo);
	}
}
