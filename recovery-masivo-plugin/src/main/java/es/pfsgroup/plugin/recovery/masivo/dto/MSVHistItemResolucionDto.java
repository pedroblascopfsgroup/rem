package es.pfsgroup.plugin.recovery.masivo.dto;

import java.util.List;


public class MSVHistItemResolucionDto {
	
	private List<String> values;
	private String label;
	private String value;
	private String type;
	private String nombre;
	private String validation;
	private int order;
	
	public List<String> getValues() {
		return values;
	}
	public void setValues(List<String> values) {
		this.values = values;
	}
	public String getLabel() {
		return label;
	}
	public void setLabel(String label) {
		this.label = label;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getValidation() {
		return validation;
	}
	public void setValidation(String validation) {
		this.validation = validation;
	}
	public int getOrder() {
		return order;
	}
	public void setOrder(int order) {
		this.order = order;
	}
}
