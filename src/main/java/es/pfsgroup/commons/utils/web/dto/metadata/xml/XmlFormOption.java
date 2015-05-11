package es.pfsgroup.commons.utils.web.dto.metadata.xml;

import com.thoughtworks.xstream.annotations.XStreamAsAttribute;

public class XmlFormOption {
	
	@XStreamAsAttribute
	private String name;
	
	@XStreamAsAttribute
	private String value;

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

}
