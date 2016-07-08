package es.pfsgroup.framework.paradise.bulkUpload.liberators.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberatorsFactory;

@Component
public class MSVLiberatorsFactoryImpl implements MSVLiberatorsFactory {

	@Autowired(required = false)
	private List<MSVLiberator> liberators;
	
	@Override
	public MSVLiberator dameLiberator(MSVDDOperacionMasiva tipoOperacion) {
		if (tipoOperacion == null){
			return null;
		}
		if (!Checks.estaVacio(liberators)){
			for (int i = 0; i < liberators.size(); i++) {
				MSVLiberator s=liberators.get(i);
				if (s.isValidFor(tipoOperacion)){
					return s;
				}
			}
			
			// Si no encuentra ninguno ..
			return null;
		}else{
			return null;
		}
	}
	

}
