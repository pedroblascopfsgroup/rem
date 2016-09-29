package es.pfsgroup.plugin.rem.tests.restclient.webcom.schedule.dbchanges.common.utilities;

import java.util.HashMap;
import java.util.Map;

import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambioBD;

public class CambioBDStub extends CambioBD{

	private Map<String, Object> data;
	private Map<String, Object> vh = new HashMap<String, Object>();
	

	public CambioBDStub(Map<String, Object> data) {
		super(null);
		this.data = data;
	}

	@Override
	public Map<String, Object> getCambios() {
		return data;
	}

	public void setValoresHistoricos(Map<String, Object> vh) {
		this.vh = vh;
		
	}

	@Override
	public Map<String, Object> getValoresHistoricos(String[] camposObligatorios) {
		return this.vh;
	}

}
