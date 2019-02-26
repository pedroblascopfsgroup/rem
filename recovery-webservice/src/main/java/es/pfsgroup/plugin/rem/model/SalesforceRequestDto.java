package es.pfsgroup.plugin.rem.model;

import java.util.List;

import org.codehaus.jackson.map.ObjectMapper;

public class SalesforceRequestDto<T> {
	
	private List<T> records;
	
	public String toBodyString() {
		ObjectMapper mapper = new ObjectMapper();
		try {
			return mapper.writeValueAsString(this);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public List<T> getRecords() {
		return records;
	}

	public void setRecords(List<T> records) {
		this.records = records;
	}
}
