package es.pfsgroup.plugins.domain;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import es.pfsgroup.commons.utils.Assertions;

public class PluginConfigurations {
	
	private Map<String, PluginConfig> configs = new HashMap<String, PluginConfig>();

	public Collection<PluginConfig> getAll() {
		return configs.values();
	}
	
	public PluginConfig getConfig(String key){
		return configs.get(key);
	}
	
	
	public int count(){
		return configs.size();
	}
	
	public boolean isEmpty(){
		return configs.isEmpty();
	}

	public void add(PluginConfig pc) {
		Assertions.assertNotNull(pc, null);
		configs.put(pc.getKey(), pc);
	}

}
