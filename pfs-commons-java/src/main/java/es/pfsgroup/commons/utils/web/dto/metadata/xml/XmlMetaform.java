package es.pfsgroup.commons.utils.web.dto.metadata.xml;

import java.util.List;

import com.thoughtworks.xstream.annotations.XStreamAsAttribute;

import es.pfsgroup.commons.utils.web.dto.metadata.MetadataField;

public class XmlMetaform {
	
	
	private List<XmlMetadataField> fields;
	
	private XmlHtmlTextElement tophtml;
	
	private List<XmlFormOption> config;

	public List<XmlMetadataField> getFields() {
		return fields;
	}

	public void setFields(List<XmlMetadataField> fields) {
		this.fields = fields;
	}

	public void setConfig(List<XmlFormOption> config) {
		this.config = config;
	}

	public List<XmlFormOption> getConfig() {
		return config;
	}

	public void setTophtml(XmlHtmlTextElement tophtml) {
		this.tophtml = tophtml;
	}

	public XmlHtmlTextElement getTophtml() {
		return tophtml;
	}

}
