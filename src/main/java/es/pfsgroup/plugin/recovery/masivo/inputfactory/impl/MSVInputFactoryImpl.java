package es.pfsgroup.plugin.recovery.masivo.inputfactory.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.masivo.inputfactory.MSVInputFactory;
import es.pfsgroup.plugin.recovery.masivo.inputfactory.MSVSelectorTipoInput;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;

@Component
public class MSVInputFactoryImpl implements MSVInputFactory {

	@Autowired(required = false)
	private List<MSVSelectorTipoInput> selectors;

	@Override
	public MSVSelectorTipoInput dameSelector(
			MSVDDOperacionMasiva tipoOperacion, Map<String, Object> map) {
		if (tipoOperacion == null){
			return null;
		}
		if (!Checks.estaVacio(selectors)){
			for (int i = 0; i < selectors.size(); i++) {
				MSVSelectorTipoInput s=selectors.get(i);
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
