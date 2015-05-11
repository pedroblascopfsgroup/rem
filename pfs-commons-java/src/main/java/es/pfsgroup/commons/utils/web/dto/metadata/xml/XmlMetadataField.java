package es.pfsgroup.commons.utils.web.dto.metadata.xml;

import com.thoughtworks.xstream.annotations.XStreamAsAttribute;

public class XmlMetadataField {

	@XStreamAsAttribute
	private String name;
	
	@XStreamAsAttribute
	private String fieldLabel;
	
	@XStreamAsAttribute
	private String fieldLabelCode;
	
	@XStreamAsAttribute
	private String xtype;
	
	@XStreamAsAttribute
	private boolean obligatory;
	
	@XStreamAsAttribute
	private String dictionary;
	
	@XStreamAsAttribute
	private Integer width;
	
	@XStreamAsAttribute
	private Integer height;
	
	@XStreamAsAttribute
	private String style;
	
	@XStreamAsAttribute
	private String labelStyle;
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getFieldLabel() {
		return fieldLabel;
	}

	public void setFieldLabel(String fieldLabel) {
		this.fieldLabel = fieldLabel;
	}

	public String getFieldLabelCode() {
		return fieldLabelCode;
	}

	public void setFieldLabelCode(String fieldLabelCode) {
		this.fieldLabelCode = fieldLabelCode;
	}

	public void setXtype(String xtype) {
		this.xtype = xtype;
	}

	public String getXtype() {
		return xtype;
	}

	public void setObligatory(boolean obligatory) {
		this.obligatory = obligatory;
	}

	public boolean isObligatory() {
		return obligatory;
	}

	public void setDictionary(String dictionary) {
		this.dictionary = dictionary;
	}

	public String getDictionary() {
		return dictionary;
	}

	public Integer width() {
		return width;
	}

	public void setWidth(Integer width) {
		this.width = width;
	}

	public Integer height() {
		return height;
	}

	public void setHeight(Integer height) {
		this.height = height;
	}

	public String style() {
		return style;
	}

	public void setStyle(String style) {
		this.style = style;
	}

	public String labelStyle() {
		return labelStyle;
	}

	public void setLableStyle(String lableStyle) {
		this.labelStyle = lableStyle;
	}
}
