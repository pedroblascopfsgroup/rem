package es.pfsgroup.plugin.recovery.mejoras.procuradores;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.parametrizacion.ParametrizacionManager;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;

@Component
public class MEJProcuradoresManager extends BusinessOperationOverrider<MEJProcuradoresApi> implements MEJProcuradoresApi {

	@Autowired
	private ParametrizacionManager parametrizacionManager; 

	@Override
	@BusinessOperation(MEJ_PROCURADORES_IS_INSTALL)
	public boolean pluginProcuradoresIsInstall() {
		Parametrizacion parametroModuloProcuradoresActivado = parametrizacionManager.buscarParametroPorNombre("moduloProcuradoresActivado");

		return Boolean.valueOf(parametroModuloProcuradoresActivado.getValor()); 
	}

	@Override
	public String managerName() {
		// TODO Auto-generated method stub
		return "MEJProcuradoresManager";
	}

}
