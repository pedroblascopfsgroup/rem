package es.pfsgroup.plugin.rem.adapter;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.config.Config;
import es.capgemini.pfs.config.ConfigManager;
import es.pfsgroup.commons.utils.Checks;

import java.util.List;

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
	
	public static String generateRandomString(){
		int length = 10;
	    boolean useLetters = true;
	    boolean useNumbers = false;
	    return RandomStringUtils.random(length, useLetters, useNumbers);
	}

	public static String join(String separator, List<String> input) {

		if (input == null || input.size() == 0) return "";

		StringBuilder sb = new StringBuilder();

		for (int i = 0; i < input.size(); i++) {
			sb.append(input.get(i));
			if (i != input.size() - 1) {
				sb.append(separator);
			}
		}

		return sb.toString();
	}
}
	