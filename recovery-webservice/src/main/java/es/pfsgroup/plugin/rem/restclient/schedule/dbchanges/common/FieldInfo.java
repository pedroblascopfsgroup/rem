package es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common;

public class FieldInfo {
	
	private String mappedColumnName;
	
	private String fieldName;

	public FieldInfo(String fieldName) {
		super();
		this.fieldName = fieldName;
	}

	public FieldInfo(String fieldName, String mappedColumnName ) {
		super();
		this.mappedColumnName = mappedColumnName;
		this.fieldName = fieldName;
	}

	public String getMappedColumnName() {
		return mappedColumnName;
	}

	public String getFieldName() {
		return fieldName;
	}

}
