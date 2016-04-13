package es.pfsgroup.recovery.context;

import java.util.Map;

public class CajamarHreProjectContextImpl implements CajamarHreProjectContext {
	
	private Map<String, String> mapaClasesExpeGesDoc;

	
	@Override
	public Map<String, String> getMapaClasesExpeGesDoc() {
		return mapaClasesExpeGesDoc;
	}

	public void setMapaClasesExpeGesDoc(Map<String, String> mapaClasesExpeGesDoc) {
		this.mapaClasesExpeGesDoc = mapaClasesExpeGesDoc;
	}
}
