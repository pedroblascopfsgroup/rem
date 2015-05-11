package es.capgemini.pfs.test.config;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.config.ConfigListDTO;
import es.capgemini.pfs.config.ConfigManager;
import es.capgemini.pfs.test.CommonTestAbstract;

public class ConfigManagerTest extends CommonTestAbstract{
	
	@Autowired
	ConfigManager configManager;

	@Test
	public final void testGetConfigByKey() {
		configManager.getConfigByKey("key2");
	}

	@Test
	public final void testGetConfigByDTO() {
		ConfigListDTO dto = new ConfigListDTO();
		dto.setKey("1");
		configManager.getConfigByDTO(dto );
	}

}
