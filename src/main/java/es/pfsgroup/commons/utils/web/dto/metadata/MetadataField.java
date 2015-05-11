package es.pfsgroup.commons.utils.web.dto.metadata;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

import com.thoughtworks.xstream.annotations.XStreamAsAttribute;

public class MetadataField implements Comparable<MetadataField> {

	private String name;
	private String fieldLabel;
	private String fieldLabelCode;
	private Map<String, Object> editor;
	private Integer id;
	
	public MetadataField(Integer id){
		setId(id);
	}

	public MetadataField(Integer id, Field f, Map<String, Object> fieldcfg,
			Map<String, Object> editorcfg) {
		

		this.name = f.getName();
		String fieldLabel = null;
		String fieldLabelCode = null;
		if (fieldcfg != null) {
			fieldLabelCode = (String) fieldcfg.get(FieldOptions.FIELD_OPTION_LABEL_CODE);
		}
		this.fieldLabel = fieldLabel != null ? fieldLabel : f.getName();
		this.fieldLabelCode = fieldLabelCode != null ? fieldLabelCode : f
				.getName();
		this.editor = editorcfg;
		setId(id);
	}
	

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

	public void setFieldLabelCode(String fieldLabelCode) {
		this.fieldLabelCode = fieldLabelCode;
	}

	public String getFieldLabelCode() {
		return fieldLabelCode;
	}

	public Map<String, Object> getEditor() {
		return editor;
	}

	public void setEditor(Map<String, Object> editor) {
		this.editor = editor;
	}
	

	@Override
	public int compareTo(MetadataField o) {
		return this.id.compareTo(o.id);
	}

	private void setId(Integer id) {
		if (id == null) {
			throw new IllegalArgumentException("id: NO PUEDE SER NULL");
		}
		if ((editor != null)
				&& EditorOptions.XTYPE_HIDDEN.equals(editor
						.get(EditorOptions.FIELD_EDITOR_OPTION_XTYPE))) {
			this.id = 1000 * id;
		}
		this.id = id;
	}

}
