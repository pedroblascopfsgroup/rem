package es.pfsgroup.plugin.rem.adapter;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.config.Config;
import es.capgemini.pfs.config.ConfigManager;
import es.pfsgroup.commons.utils.Checks;

@Component
public class RemUtils {
	
	@Autowired
	private ConfigManager configManager;
	
	protected static final Log logger = LogFactory.getLog(ActivoAdapter.class);
	
	public String obtenerUsuarioPorDefecto(String key){
		Config config = configManager.getConfigByKey(key);
		String username = null;
		try{
			if(!Checks.esNulo(config)){
				username = config.getValor();
			}
		}catch(Exception e){
			logger.error("La key "+key+" no existe");
			
		}
		return username;	
	}
}
	