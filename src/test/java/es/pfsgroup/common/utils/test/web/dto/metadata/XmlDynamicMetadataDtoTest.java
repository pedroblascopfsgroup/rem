package es.pfsgroup.common.utils.test.web.dto.metadata;

import static org.junit.Assert.*;

import java.util.Map;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;

import com.sun.java.swing.plaf.windows.resources.windows;

import es.capgemini.devon.bo.Executor;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.web.dto.metadata.EditorOptions;
import es.pfsgroup.commons.utils.web.dto.metadata.FormOptions;
import es.pfsgroup.commons.utils.web.dto.metadata.HtmlTextElement;
import es.pfsgroup.commons.utils.web.dto.metadata.MetadataField;
import es.pfsgroup.commons.utils.web.dto.metadata.XmlDynamicMetadataDto;
import es.pfsgroup.commons.utils.web.dto.metadata.MetadataDto.ReadOnlyDtoError;

public class XmlDynamicMetadataDtoTest {

	private static final int TOTAL_FIELDS = 7;
	private static final String FIELD_1_NAME = "test1";
	private static final String FIELD_1_FIELD_LABEL = "label.test.1";
	private static final String FIELD_1_FIELD_LABEL_CODE = "labelcode.test.1";

	private static final String FIELD_2_NAME = "test2";
	private static final String FIELD_2_XTYPE = EditorOptions.XTYPE_DATEFIELD;
	private static final String FIELD_2_FIELD_LABEL = "label.test.2";
	private static final String FIELD_2_FIELD_LABEL_CODE = "labelcode.test.2";

	private static final String FIELD_3_NAME = "test3";
	private static final String FIELD_3_XTYPE = EditorOptions.XTYPE_CURRENCY_FIELD;
	private static final String FIELD_3_FIELD_LABEL = "label.test.3";
	private static final String FIELD_3_FIELD_LABEL_CODE = "labelcode.test.3";

	private static final String FIELD_4_NAME = "test4";
	private static final String FIELD_4_XTYPE = EditorOptions.XTYPE_NUMBER_FIELD;
	private static final String FIELD_4_FIELD_LABEL = "label.test.4";
	private static final String FIELD_4_FIELD_LABEL_CODE = "labelcode.test.4";

	private static final String FIELD_5_NAME = "test5";
	private static final String FIELD_5_XTYPE = EditorOptions.XTYPE_TEXTAREA;
	private static final String FIELD_5_FIELD_LABEL = "label.test.5";
	private static final String FIELD_5_FIELD_LABEL_CODE = "labelcode.test.5";

	private static final String FIELD_6_NAME = "test6";
	private static final String FIELD_6_XTYPE = EditorOptions.TMPL_BO_REFERENCE;
	private static final String FIELD_6_FIELD_LABEL = "label.test.6";
	private static final String FIELD_6_FIELD_LABEL_CODE = "labelcode.test.6";

	private static final String FIELD_7_NAME = "test7";
	private static final String FIELD_7_XTYPE = EditorOptions.TMPL_DD_COMBO;
	private static final String FIELD_7_DICTIONARY = XmlDynamicMetadataDtoTest.class
			.getName();
	private static final String FIELD_7_FIELD_LABEL = "label.test.7";
	private static final String FIELD_7_FIELD_LABEL_CODE = "labelcode.test.7";

	private static final String HEIGHT = "200";

	private static final String WIDTH = "300";

	private static final String STYLE = "ABCDE";

	private static final String LABELSTYLE = "FGHI";

	private static final String FORM_OPTION_COLUMNS = "1";

	private static final String FORM_OPTION_WIDTH = "200";

	private static final String FORM_OPTION_HEIGHT = "500";

	private static final String FORM_OPTION_TITLE = "Sample title";

	private static final String TOP_HTML = "<h1>This is a HTML sample text</h1>";

	private XmlDynamicMetadataDto dto;

	@Before
	public void before() {
		String xml = createTextXML();
		dto = new XmlDynamicMetadataDto(xml);
		dto.setGenericDao(Mockito.mock(GenericABMDao.class));
	}

	@After
	public void after() {
		dto = null;
	}

	@Test
	public void testLoadXML() throws Exception {

		assertEquals(FORM_OPTION_TITLE, dto.getWindowTitle());
		assertFormConfig(dto);

		assertTrue(dto.getData().isEmpty());

		assertTopHtml(dto);

		assertEquals(TOTAL_FIELDS, dto.getFields().size());

		assertEquals(FIELD_1_NAME, getField(dto, FIELD_1_NAME).getName());
		assertEquals(FIELD_1_FIELD_LABEL, getField(dto, FIELD_1_NAME)
				.getFieldLabel());
		assertEquals(FIELD_1_FIELD_LABEL_CODE, getField(dto, FIELD_1_NAME)
				.getFieldLabelCode());
		assertCommons(getField(dto, FIELD_1_NAME));

		assertEquals(FIELD_2_NAME, getField(dto, FIELD_2_NAME).getName());
		assertEquals(FIELD_2_XTYPE, getField(dto, FIELD_2_NAME).getEditor()
				.get(EditorOptions.FIELD_EDITOR_OPTION_XTYPE));
		assertEquals(FIELD_2_FIELD_LABEL, getField(dto, FIELD_2_NAME)
				.getFieldLabel());
		assertEquals(FIELD_2_FIELD_LABEL_CODE, getField(dto, FIELD_2_NAME)
				.getFieldLabelCode());
		assertCommons(getField(dto, FIELD_2_NAME));

		assertEquals(FIELD_3_NAME, getField(dto, FIELD_3_NAME).getName());
		assertEquals(FIELD_3_XTYPE, getField(dto, FIELD_3_NAME).getEditor()
				.get(EditorOptions.FIELD_EDITOR_OPTION_XTYPE));
		assertEquals(FIELD_3_FIELD_LABEL, getField(dto, FIELD_3_NAME)
				.getFieldLabel());
		assertEquals(FIELD_3_FIELD_LABEL_CODE, getField(dto, FIELD_3_NAME)
				.getFieldLabelCode());
		assertCommons(getField(dto, FIELD_3_NAME));

		assertEquals(FIELD_4_NAME, getField(dto, FIELD_4_NAME).getName());
		assertEquals(FIELD_4_XTYPE, getField(dto, FIELD_4_NAME).getEditor()
				.get(EditorOptions.FIELD_EDITOR_OPTION_XTYPE));
		assertEquals(FIELD_4_FIELD_LABEL, getField(dto, FIELD_4_NAME)
				.getFieldLabel());
		assertEquals(FIELD_4_FIELD_LABEL_CODE, getField(dto, FIELD_4_NAME)
				.getFieldLabelCode());
		assertCommons(getField(dto, FIELD_4_NAME));

		assertEquals(FIELD_5_NAME, getField(dto, FIELD_5_NAME).getName());
		assertEquals(FIELD_5_XTYPE, getField(dto, FIELD_5_NAME).getEditor()
				.get(EditorOptions.FIELD_EDITOR_OPTION_XTYPE));
		assertEquals(FIELD_5_FIELD_LABEL, getField(dto, FIELD_5_NAME)
				.getFieldLabel());
		assertEquals(FIELD_5_FIELD_LABEL_CODE, getField(dto, FIELD_5_NAME)
				.getFieldLabelCode());
		assertCommons(getField(dto, FIELD_5_NAME));

		assertEquals(FIELD_6_NAME, getField(dto, FIELD_6_NAME).getName());
		assertEquals(EditorOptions.XTYPE_HIDDEN, getField(dto, FIELD_6_NAME)
				.getEditor().get(EditorOptions.FIELD_EDITOR_OPTION_XTYPE));
		assertEquals(FIELD_6_FIELD_LABEL, getField(dto, FIELD_6_NAME)
				.getFieldLabel());
		assertEquals(FIELD_6_FIELD_LABEL_CODE, getField(dto, FIELD_6_NAME)
				.getFieldLabelCode());
		assertCommons(getField(dto, FIELD_6_NAME));

		assertEquals(FIELD_7_NAME, getField(dto, FIELD_7_NAME).getName());
		assertEquals(FIELD_7_XTYPE, getField(dto, FIELD_7_NAME).getEditor()
				.get(EditorOptions.FIELD_EDITOR_OPTION_XTYPE));
		assertEquals(FIELD_7_FIELD_LABEL, getField(dto, FIELD_7_NAME)
				.getFieldLabel());
		assertEquals(FIELD_7_FIELD_LABEL_CODE, getField(dto, FIELD_7_NAME)
				.getFieldLabelCode());
		assertCommons(getField(dto, FIELD_7_NAME));
	}

	@Test
	public void testPutAndGetValues() throws Exception {

		String va = "this is a sample value";
		dto.putValue("v1", va);
		assertEquals(va, dto.getValue("v1"));
	}

	@Test
	public void testReadOnly() throws Exception {

		dto.setReadOnly(true);
		assertTrue(dto.isReadOnly());
		try {
			dto.putValue("key", "value");
			fail("Debería haberse lanzado una BpmReadOnlyDataStore");
		} catch (ReadOnlyDtoError e) {
		}

		dto.setReadOnly(false);
		assertFalse(dto.isReadOnly());
		dto.putValue("key", "value");
	}

	private void assertTopHtml(XmlDynamicMetadataDto dto) {
		assertNotNull(dto.getTopHtml());
		assertFalse(dto.getTopHtml().getBorder());
		assertEquals(HtmlTextElement.DEFAULT_STYLE, dto.getTopHtml().getStyle());

	}

	private void assertFormConfig(XmlDynamicMetadataDto dto) {
		assertEquals(FORM_OPTION_COLUMNS, dto.getFormConfig().get(
				FormOptions.FORM_OPTION_COLUMNS));
		assertEquals(FORM_OPTION_WIDTH, dto.getFormConfig().get(
				FormOptions.FORM_OPTION_WIDTH));
		assertEquals(FORM_OPTION_HEIGHT, dto.getFormConfig().get(
				FormOptions.FORM_OPTION_HEIGHT));
		assertEquals(FORM_OPTION_TITLE, dto.getFormConfig().get(
				FormOptions.FORM_OPTION_TITLE));

	}

	private MetadataField getField(XmlDynamicMetadataDto dto, String name) {
		assertNotNull("No hay campos en el DTO", dto.getField());
		assertNotNull("No se encuentra el campo '" + name + "' en el DTO", dto
				.getField().get(name));
		assertTrue(dto.getField().get(name) instanceof MetadataField);
		return ((MetadataField) dto.getField().get(name));
	}

	private void assertCommons(MetadataField field) {
		Map<String, Object> editor = field.getEditor();
		assertNotNull("No hay opciones del editor para el campo", editor);
		assertEquals(WIDTH, editor.get(EditorOptions.FIELD_EDITOR_OPTION_WIDTH));
		assertEquals(HEIGHT, editor
				.get(EditorOptions.FIELD_EDITOR_OPTION_HEIGHT));
		assertEquals(STYLE, editor.get(EditorOptions.FIELD_EDITOR_OPTION_STYLE));
		assertEquals(LABELSTYLE, editor
				.get(EditorOptions.FIELD_EDITOR_OPTION_LABEL_STYLE));
	}

	private String createTextXML() {
		return "<metaform>" /**/
				+ "<config>" /**/
				+ "<option name=\"title\" value=\""
				+ FORM_OPTION_TITLE
				+ "\" />" //
				+ "<option name=\"columnCount\" value=\"" + FORM_OPTION_COLUMNS
				+ "\" />" /**/
				+ "<option name=\"width\" value=\"" + FORM_OPTION_WIDTH
				+ "\" />" /**/
				+ "<option name=\"height\" value=\"" + FORM_OPTION_HEIGHT
				+ "\" />" /**/
				+ "</config>" /**/
				+ "<tophtml>"/**/
				+ "<html>" /**/
				+ "<![CDATA[" + TOP_HTML + "]]>"/**/
				+ "</html>" /**/
				+ "</tophtml>" /**/
				+ "<fields>" /**/
				+ "<field name=\"" + FIELD_1_NAME + "\" " + "fieldLabel=\""
				+ FIELD_1_FIELD_LABEL + "\" " + "fieldLabelCode=\""
				+ FIELD_1_FIELD_LABEL_CODE + "\" " + "width=\"" + WIDTH + "\" "
				+ "height=\"" + HEIGHT + "\" " + "style=\"" + STYLE + "\" "
				+ "labelStyle=\"" + LABELSTYLE + "\" " + "/>" /**/
				+ "<field name=\"" + FIELD_2_NAME + "\" " + "xtype=\""
				+ FIELD_2_XTYPE + "\" " + "fieldLabel=\"" + FIELD_2_FIELD_LABEL
				+ "\" " + "fieldLabelCode=\"" + FIELD_2_FIELD_LABEL_CODE
				+ "\" " + "width=\"" + WIDTH + "\" " + "height=\"" + HEIGHT
				+ "\" " + "style=\"" + STYLE + "\" " + "labelStyle=\""
				+ LABELSTYLE + "\" " + "/>" /**/
				+ "<field name=\"" + FIELD_3_NAME + "\" " + "xtype=\""
				+ FIELD_3_XTYPE + "\" " + "fieldLabel=\"" + FIELD_3_FIELD_LABEL
				+ "\" " + "fieldLabelCode=\"" + FIELD_3_FIELD_LABEL_CODE
				+ "\" " + "width=\"" + WIDTH + "\" " + "height=\"" + HEIGHT
				+ "\" " + "style=\"" + STYLE + "\" " + "labelStyle=\""
				+ LABELSTYLE + "\" " + "/>" + "<field name=\"" + FIELD_4_NAME
				+ "\" " + "xtype=\"" + FIELD_4_XTYPE + "\" " + "fieldLabel=\""
				+ FIELD_4_FIELD_LABEL + "\" " + "fieldLabelCode=\""
				+ FIELD_4_FIELD_LABEL_CODE + "\" " + "width=\"" + WIDTH + "\" "
				+ "height=\"" + HEIGHT + "\" " + "style=\"" + STYLE + "\" "
				+ "labelStyle=\"" + LABELSTYLE + "\" " + "/>"
				+ "<field name=\"" + FIELD_5_NAME + "\" " + "xtype=\""
				+ FIELD_5_XTYPE + "\" " + "fieldLabel=\"" + FIELD_5_FIELD_LABEL
				+ "\" " + "fieldLabelCode=\"" + FIELD_5_FIELD_LABEL_CODE
				+ "\" " + "width=\"" + WIDTH + "\" " + "height=\"" + HEIGHT
				+ "\" " + "style=\"" + STYLE + "\" " + "labelStyle=\""
				+ LABELSTYLE + "\" " + "/>" + "<field name=\"" + FIELD_6_NAME
				+ "\" " + "xtype=\"" + FIELD_6_XTYPE + "\" " + "fieldLabel=\""
				+ FIELD_6_FIELD_LABEL + "\" " + "fieldLabelCode=\""
				+ FIELD_6_FIELD_LABEL_CODE + "\" " + "width=\"" + WIDTH + "\" "
				+ "height=\"" + HEIGHT + "\" " + "style=\"" + STYLE + "\" "
				+ "labelStyle=\"" + LABELSTYLE + "\" " + "/>"
				+ "<field name=\"" + FIELD_7_NAME + "\" " + "xtype=\""
				+ FIELD_7_XTYPE + "\" " + "dictionary=\"" + FIELD_7_DICTIONARY
				+ "\" " + "fieldLabel=\"" + FIELD_7_FIELD_LABEL + "\" "
				+ "fieldLabelCode=\"" + FIELD_7_FIELD_LABEL_CODE + "\" "
				+ "width=\"" + WIDTH + "\" " + "height=\"" + HEIGHT + "\" "
				+ "style=\"" + STYLE + "\" " + "labelStyle=\"" + LABELSTYLE
				+ "\" " + "/>" + "</fields>" + "</metaform>";
	}
}
