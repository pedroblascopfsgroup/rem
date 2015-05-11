package es.pfsgroup.commons.utils.web.dto.metadata;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.io.xml.DomDriver;

import es.pfsgroup.commons.utils.web.dto.metadata.xml.XmlFormOption;
import es.pfsgroup.commons.utils.web.dto.metadata.xml.XmlHtmlTextElement;
import es.pfsgroup.commons.utils.web.dto.metadata.xml.XmlMetadataField;
import es.pfsgroup.commons.utils.web.dto.metadata.xml.XmlMetaform;

@SuppressWarnings("unchecked")
public class XmlDynamicMetadataDto extends AbstractMetadataDto {

	private static final long serialVersionUID = 6217831048333793724L;

	@IgnoreField
	private XmlMetaform metaform;

	public XmlDynamicMetadataDto(String xml) {
		super(xml);
		if (metaform == null)
			metaform = parseXml(xml);
	}
	@Override
	public void putValue(String key, Object value){
		super.putValue(key, value);
	}

	@Override
	boolean initFields() {
		return extractFieldsFromXml(metaform);
	}

	@Override
	HashMap<String, Object> initConfig(Object... args) {
		assert (args.length == 1);
		assert (args[0] instanceof String);
		if (metaform == null)
			metaform = parseXml((String) args[0]);
		return extractFormConfigFromXml(metaform);
	}

	@Override
	HtmlTextElement initTopHtml(Object... args) {
		assert (args.length == 1);
		assert (args[0] instanceof String);
		if (metaform == null)
			metaform = parseXml((String) args[0]);
		if (metaform.getTophtml() != null) {
			XmlHtmlTextElement xh = metaform.getTophtml();
			HtmlTextElement h = new HtmlTextElement();
			h.setHtml(xh.getHtml());
			if (xh.getBorder() != null) {
				h.setBorder(xh.getBorder());
			}
			if (xh.getStyle() != null) {
				h.setStyle(xh.getStyle());
			}
			return h;
		}
		return null;
	}


	protected XmlMetaform parseXml(String xml) {
		XStream xstream1 = new XStream(new DomDriver());
		xstream1.processAnnotations(XmlMetadataField.class);
		xstream1.processAnnotations(XmlFormOption.class);
		xstream1.processAnnotations(XmlHtmlTextElement.class);
		xstream1.alias("metaform", XmlMetaform.class);
		xstream1.alias("field", XmlMetadataField.class);
		xstream1.alias("option", XmlFormOption.class);
		xstream1.alias("tophtml", XmlHtmlTextElement.class);
		XStream xstream = xstream1;
		XmlMetaform metaform = (XmlMetaform) xstream.fromXML(xml);
		return metaform;
	}
	
	protected final XmlMetaform getMetaformXML(){
		return this.metaform;
	}
	
	

	@SuppressWarnings("unused")
	private XmlDynamicMetadataDto() {
		super();
	}

	private HashMap<String, Object> extractFormConfigFromXml(
			XmlMetaform metaform) {
		HashMap<String, Object> config = new HashMap<String, Object>();
		List<XmlFormOption> options = metaform.getConfig();
		if ((options != null) && (!options.isEmpty())) {
			for (XmlFormOption o : options) {
				config.put(o.getName(), o.getValue());
			}
		}
		return config;
	}

	private boolean extractFieldsFromXml(XmlMetaform metaform) {
		boolean hasfields = false;
		List<XmlMetadataField> fieldset = metaform.getFields();
		if ((fieldset != null) && (!fieldset.isEmpty())) {
			int contador = 0;
			for (XmlMetadataField f : metaform.getFields()) {
				try {
					MetadataField mf = new MetadataField(contador++);
					mf.setName(f.getName());
					mf.setFieldLabel(f.getFieldLabel());
					mf.setFieldLabelCode(f.getFieldLabelCode());
					mf.setEditor(templateOptions(f));
					putField(f.getName(), mf);
				} catch (ClassNotFoundException e) {
					throw new MetadataDtoException(e);
				}
			}
			hasfields = true;
		}
		return hasfields;
	}

	private Map<String, Object> templateOptions(XmlMetadataField f)
			throws ClassNotFoundException {
		if (f == null)
			return null;
		Map<String, Object> map = putCommonProperties(f);
		if (EditorOptions.XTYPE_DATEFIELD.equals(f.getXtype())) {
			return datefieldEditorOptions(map);
		} else if (EditorOptions.XTYPE_CURRENCY_FIELD.equals(f.getXtype())) {
			return currencyfieldEditorOptions(map, f.isObligatory());
		} else if (EditorOptions.XTYPE_NUMBER_FIELD.equals(f.getXtype())) {
			return numberfieldEditorOptions(map);
		} else if (EditorOptions.XTYPE_TEXTAREA.equals(f.getXtype())) {
			return textareaEditorOptions(map);
		} else if (EditorOptions.TMPL_BO_REFERENCE.equals(f.getXtype())) {
			return boreferenceEditorOptions(map);
		} else if (EditorOptions.TMPL_DD_COMBO.equals(f.getXtype())) {
			return ddcomboEditorOptions(map, getClassFor(f.getDictionary()));
		}
		return map;
	}

	private Class getClassFor(String dictionary) throws ClassNotFoundException {
		if (dictionary == null) {
			throw new IllegalArgumentException("'dictionary' IS NULL");
		}
		return Class.forName(dictionary);
	}

}
