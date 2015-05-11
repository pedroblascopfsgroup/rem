package es.pfsgroup.common.utils.test.web.dto.metadata;

import static org.junit.Assert.*;

import java.util.Date;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;

import es.capgemini.devon.bo.Executor;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.web.dto.metadata.AbstractMetadataDto;
import es.pfsgroup.commons.utils.web.dto.metadata.EditorOptions;
import es.pfsgroup.commons.utils.web.dto.metadata.FormOptions;
import es.pfsgroup.commons.utils.web.dto.metadata.MetadataField;
import es.pfsgroup.commons.utils.web.dto.metadata.Option;
import es.pfsgroup.commons.utils.web.dto.metadata.MetadataDto.ReadOnlyDtoError;
import es.pfsgroup.commons.utils.web.dto.metadata.tmpl.Currencyfield;
import es.pfsgroup.commons.utils.web.dto.metadata.tmpl.DDCombo;
import es.pfsgroup.commons.utils.web.dto.metadata.tmpl.Datefield;
import es.pfsgroup.commons.utils.web.dto.metadata.tmpl.Numberfield;
import es.pfsgroup.commons.utils.web.dto.metadata.tmpl.Textarea;
import es.pfsgroup.commons.utils.web.dto.metadata.tmpl.Textfield;

public class ReadOnlyTest {

	@SuppressWarnings("unused")
	private static class ConcreteDto extends AbstractMetadataDto {
		private static final long serialVersionUID = -7766186602124510434L;

		@Textfield(labelCode = "qwerty")
		private String someString;

		@Textfield(labelCode = "qwerty", readOnly = true)
		private String someRoString;

		@Datefield(labelCode = "qwerty")
		private Date someDate;

		@Datefield(labelCode = "qwerty", readOnly = true)
		private Date someRoDate;

		@Currencyfield(labelCode = "qwerty")
		private Float someCurrency;

		@Currencyfield(labelCode = "qwerty", readOnly = true)
		private Float someRoCurrency;

		@DDCombo(labelCode = "qwer", dictionary = Class.class)
		private String someCombo;

		@DDCombo(labelCode = "qwer", dictionary = Class.class, readOnly = true)
		private String someRoCombo;

		@Numberfield(labelCode = "aaa")
		private Integer someNumber;

		@Numberfield(labelCode = "aaa", readOnly = true)
		private Integer someRoNumber;

		@Textarea(labelCode = "qqwert")
		private String someTextArea;

		@Textarea(labelCode = "qqwert", readOnly = true)
		private String someRoTextArea;

		@Override
		public void putValue(String key, Object value) {
			super.putValue(key, value);
		}

	}

	private ConcreteDto dto;
	private String[] readOnlyFields;
	private String[] readWriteFields;

	@Before
	public void before() {
		dto = new ConcreteDto();
		dto.setGenericDao(Mockito.mock(GenericABMDao.class));
		readOnlyFields = new String[] { "someRoString", "someRoDate",
				"someRoCurrency", "someRoCombo", "someRoNumber" , "someRoTextArea"};
		readWriteFields = new String[] { "someString", "someDate",
				"someCurrency", "someCombo", "someNumber", "someTextArea" };
	}

	@After
	public void after() {
		dto = null;
		readOnlyFields = null;
		readWriteFields = null;
	}

	@Test
	public void testReadWriteDto() throws Exception {

		dto.putValue("key", "value");
		assertFalse(dto.isReadOnly());
		asertFormOptionReadonly(false, dto);
		assertEquals("value", dto.getValue("key"));

		assertReadOnlyFields(true, dto, readOnlyFields);
		dto.setReadOnly(false);
		assertReadOnlyFields(false, dto, readOnlyFields);

	}

	@Test
	public void testReadOnlyDto() throws Exception {
		assertReadOnlyFields(false, dto, readWriteFields);
		dto.setReadOnly(true);
		assertTrue(dto.isReadOnly());
		asertFormOptionReadonly(true, dto);
		assertReadOnlyFields(true, dto, readWriteFields);
		try {
			dto.putValue("key", "value");
			fail("Debería haberse lanzado un ReadOnlyDtoError");
		} catch (ReadOnlyDtoError e) {
		}

	}

	private void assertReadOnlyFields(boolean b, ConcreteDto dto,
			String[] fields) {
		for (String fieldName : fields) {
			MetadataField f = (MetadataField) dto.getField().get(fieldName);
			assertNotNull(fieldName + ": Campo no definido en el DTO", f);
			assertNotNull(fieldName
					+ ": EditorOptions no establecidas para el camp", f
					.getEditor());
			String xtype = (String) f.getEditor().get(
					EditorOptions.FIELD_EDITOR_OPTION_XTYPE);
			assertNotNull(fieldName + ": Xtype no definido", xtype);
			assertEquals(xtype + ": xtype no es de sólo lectura", b,
					readOnlyXtypeVersion(xtype));
		}
	}

	private boolean readOnlyXtypeVersion(String xtype) {

		return EditorOptions.XTYPE_CURRENCY_FIELD_RO.equals(xtype)
				|| EditorOptions.XTYPE_DATEFIELD_RO.equals(xtype)
				|| EditorOptions.XTYPE_DDCOMBO_RO.equals(xtype)
				|| EditorOptions.XTYPE_NUMBER_FIELD_RO.equals(xtype)
				|| EditorOptions.XTYPE_TEXTAREA_RO.equals(xtype)
				|| EditorOptions.XTYPE_TEXT_FIELD_RO.equals(xtype);
	}

	private void asertFormOptionReadonly(boolean b, AbstractMetadataDto dto) {
		assertEquals(b ? Option.TRUE : Option.FALSE, dto.getFormConfig().get(
				FormOptions.FORM_OPTION_READONLY));
	}
}
