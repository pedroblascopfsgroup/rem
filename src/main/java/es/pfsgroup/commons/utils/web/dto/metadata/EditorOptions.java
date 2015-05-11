package es.pfsgroup.commons.utils.web.dto.metadata;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface EditorOptions {
	public static final String FIELD_EDITOR_OPTION_XTYPE = "xtype";
	public static final String FIELD_EDITOR_OPTION_ALLOWBLANK = "allowBlank";
	public static final String FIELD_EDITOR_OPTION_FORMAT = "format";
	public static final String FIELD_EDITOR_OPTION_WIDTH = "width";
	public static final String FIELD_EDITOR_OPTION_HEIGHT = "height";
	public static final String FIELD_EDITOR_OPTION_STYLE = "style";
	public static final String FIELD_EDITOR_OPTION_LABEL_STYLE = "labelStyle";
	public static final String FIELD_EDITOR_OPTION_READONLY = "readOnly";
	public static final String DD_DATA = "data";
	public static final String DD_TYPE = "ddType";
	
	public static final String XTYPE_DATEFIELD = "datefield";
	public static final String XTYPE_TEXTAREA = "textarea";
	public static final String XTYPE_HIDDEN = "hidden";
	public static final String XTYPE_NUMBER_FIELD = "numberfield";
	public static final String XTYPE_TEXT_FIELD = "textfield";
	public static final String XTYPE_CURRENCY_FIELD = "currencyfield";
	public static final String XTYPE_DDCOMBO = "ddcombo";
	public static final String XTYPE_DATEFIELD_RO = "datefieldRO";
	public static final String XTYPE_TEXTAREA_RO = "textareaRO";
	public static final String XTYPE_NUMBER_FIELD_RO = "numberfieldRO";
	public static final String XTYPE_CURRENCY_FIELD_RO = "currencyfieldRO";
	public static final String XTYPE_DDCOMBO_RO = "ddcomboRO";
	public static final String XTYPE_TEXT_FIELD_RO = "textfieldRO";
	public static final String TMPL_BO_REFERENCE = "boref";
	public static final String TMPL_DD_COMBO = "ddcombo";
	
	Option[] options();
}
