package es.pfsgroup.common.utils.test.web.dto.dynamic;

public class ComplexType {
	

	private String name;
	
	private String value;
	
	private ComplexType2 complexType;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public ComplexType2 getComplexType() {
		return complexType;
	}

	public void setComplexType(ComplexType2 complexType) {
		this.complexType = complexType;
	}

}
