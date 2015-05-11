package es.pfsgroup.commons.utils.web.controller.metaform;



import java.util.HashMap;

import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.web.dto.metadata.MetadataDto;
import es.pfsgroup.commons.utils.Checks;



@Component("mfreg")
public class MetaformRegistry {
	
	public static final String BEAN_NAME= "mfreg";
	
	HashMap<String, MetaformEntry> dtos = new HashMap<String, MetaformEntry>();

	public MetaformEntry getDto(String mfId) {
		return dtos.get(mfId);
	}
	
	public void register(String mfId, Metaform metaform){
		if (Checks.esNulo(mfId)){
			throw new IllegalArgumentException("mfid: ES NULL");
		}
		if (Checks.esNulo(metaform)){
			throw new IllegalArgumentException("metaform: ES NULL");
		}
		MetaformEntry e = new MetaformEntry();
		e.setDtoType(metaform.dto());
		e.setEntityType(metaform.entity());
		e.setCreateBO(metaform.createBO());
		e.setGetBO(metaform.getBO());
		e.setUpdateBO(metaform.updateBO());
		e.setView(metaform.customView());
		dtos.put(mfId, e);
	}

}
