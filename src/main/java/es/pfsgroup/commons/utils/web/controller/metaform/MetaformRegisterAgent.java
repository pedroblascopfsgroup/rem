package es.pfsgroup.commons.utils.web.controller.metaform;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.utils.ApplicationContextUtil;
import es.pfsgroup.commons.utils.Checks;

public abstract class MetaformRegisterAgent {
	
	@Autowired
	MetaformRegistry registry;
	
	public MetaformRegisterAgent(){
		Registry reg = this.getClass().getAnnotation(Registry.class);
		
		if (Checks.esNulo(reg)){
			throw new IllegalStateException(this.getClass().getName() + ": missing @Registry");
		}
		
		if (Checks.esNulo(registry)){
			registry = (MetaformRegistry) ApplicationContextUtil.getApplicationContext().getBean(MetaformRegistry.BEAN_NAME);
			if (registry == null) throw new IllegalStateException(this.getClass().getName() + ": repository NOT FOUND");
		}
		
		if (reg.items() != null){
			for (Metaform mf : reg.items()){
				registry.register(mf.mfid(), mf);
			}
		}
		
	}

}
