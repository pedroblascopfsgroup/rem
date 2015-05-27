package es.pfsgroup.plugin.recovery.mejoras.procuradores;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;

@Component
public class MEJProcuradoresManager extends BusinessOperationOverrider<MEJProcuradoresApi> implements MEJProcuradoresApi {
	
  @Autowired
  public ApplicationContext appContext;

	@Override
	@BusinessOperation(MEJ_PROCURADORES_IS_INSTALL)
	public boolean pluginProcuradoresIsInstall() {
		// TODO Auto-generated method stub
		
		try{
			Object bean = appContext.getBean("Procurador");
		}catch(Exception e){
			return false;
		}

		return true;
	}

	@Override
	public String managerName() {
		// TODO Auto-generated method stub
		return "MEJProcuradoresManager";
	}


    
}
