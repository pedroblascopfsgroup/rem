package es.pfsgroup.plugin.rem.model;

import java.util.List;


public class DtoCampo {
	String xtype;
	String fieldLabel;
	String valueField;
	String displayField;
	String store;
	String name;
	String value;
	List values;
	String allowBlank;
	String blankText;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getXtype() {
		return xtype;
	}
	public void setXtype(String xtype) {
		this.xtype = xtype;
	}
	public String getFieldLabel() {
		return fieldLabel;
	}
	public void setFieldLabel(String fieldLabel) {
		this.fieldLabel = fieldLabel;
	}
	public String getValueField() {
		return valueField;
	}
	public void setValueField(String valueField) {
		this.valueField = valueField;
	}
	public String getDisplayField() {
		return displayField;
	}
	public void setDisplayField(String displayField) {
		this.displayField = displayField;
	}
	public String getStore() {
		return store;
	}
	public void setStore(String store) {
		this.store = store;
	}
	public String getValue(){
		return value;
	}
	public void setValue(String value){
		this.value = value;
	}
	public List getValues() {
		return values;
	}
	public void setValues(List values) {
		this.values = values;
	}
	public String getAllowBlank() {
		return allowBlank;
	}
	public void setAllowBlank(String allowBlank) {
		this.allowBlank = allowBlank;
	}
	public String getBlankText() {
		return blankText;
	}
	public void setBlankText(String blankText) {
		this.blankText = blankText;
	}

}