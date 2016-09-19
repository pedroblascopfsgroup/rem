package es.pfsgroup.plugin.rem.tests.restclient.webcom.schedule;

import java.util.Map;

import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambioBD;

public class CambioBDStub extends CambioBD{

	private Map<String, Object> data;

	public CambioBDStub(Map<String, Object> data) {
		super(null);
		this.data = data;
	}

	@Override
	public Map<String, Object> getCambios() {
		return data;
	}

}
