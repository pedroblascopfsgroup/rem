package es.capgemini.pfs.contrato.model;

import java.util.Properties;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.APPConstants;

/**
 * El objetivo de esta clase es el de configurar ciertos aspectos de la entity {@link Contrato}
 * @author carlos
 *
 */
@Component
public class SpringContratoConfigurator implements ApplicationContextAware {


	@Override
	public void setApplicationContext(ApplicationContext applicationContext)
			throws BeansException {
		// Obtiene el bean de propiedades
		Properties appProperties = (Properties) applicationContext.getBean(APPConstants.CNT_BEAN_PROPERTIES);
		
		// Setea las propiedades en la propiedad del contrato
		Contrato.setAppProperties(appProperties);
	}
	
}
