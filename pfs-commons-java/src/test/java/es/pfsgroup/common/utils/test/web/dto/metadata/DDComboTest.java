package es.pfsgroup.common.utils.test.web.dto.metadata;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;
import java.io.Serializable;
import java.util.Map.Entry;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.web.dto.metadata.AbstractMetadataDto;
import es.pfsgroup.commons.utils.web.dto.metadata.tmpl.DDCombo;

public class DDComboTest {

	private static final String CODIGO_OP_2 = "02";
	private static final String CODIGO_OP_1 = "01";
	private static final String DESCRIPCION_OP_1 = "Opcion 1";
	private static final String DESCRIPCION_OP_2 = "Opcion 2";

	private static class ConcreteObject implements Serializable {
		private DDOption opcion1;
		private DDOption opcion2;

		public DDOption getOpcion1() {
			return opcion1;
		}

		public void setOpcion1(DDOption opcion1) {
			this.opcion1 = opcion1;
		}

		public DDOption getOpcion2() {
			return opcion2;
		}

		public void setOpcion2(DDOption opcion2) {
			this.opcion2 = opcion2;
		}
	}

	public static class DDOption implements Serializable {

		private String codigo;
		private String descripcion;

		public DDOption(String codigoOp1, String descripcionOp1) {
			this.codigo = codigoOp1;
			this.descripcion = descripcionOp1;
		}

		public String getCodigo() {
			return codigo;
		}

		public void setCodigo(String codigo) {
			this.codigo = codigo;
		}

		public String getDescripcion() {
			return descripcion;
		}

		public void setDescripcion(String descripcion) {
			this.descripcion = descripcion;
		}

	}

	private static class ConcreteDto extends
			AbstractMetadataDto<ConcreteObject> {

		@DDCombo(dictionary = DDOption.class, labelCode = "aaa", name="opcion1")
		private String opcion1;

		@DDCombo(dictionary = DDOption.class, labelCode = "aaa", name="opcion2")
		private DDOption opcion2 = new DDOption(null,null);

		@Override
		public ConcreteObject createObject() throws Exception {
			ConcreteObject o = new ConcreteObject();
			o.setOpcion1(dictionary(DDOption.class, "opcion1"));
			o.setOpcion2(dictionary(DDOption.class, "opcion2"));

			return o;
		}
		
		@Override
		public void loadObject(ConcreteObject o) throws Exception {
			this.opcion1 = o.getOpcion1().getCodigo();
			this.opcion2 = o.getOpcion2();
		}

		public String getOpcion1() {
			return opcion1;
		}

		public void setOpcion1(String opcion1) {
			this.opcion1 = opcion1;
		}

		public DDOption getOpcion2() {
			return opcion2;
		}

		public void setOpcion2(DDOption opcion2) {
			this.opcion2 = opcion2;
		}

	}

	
	private GenericABMDao genericDao;
	private ConcreteDto dto;
	
	@Before
	public void before(){
		genericDao = mock(GenericABMDao.class);
		dto = new ConcreteDto();
		dto.setGenericDao(genericDao);
		Filter f1 = mock(Filter.class);
		Filter f2 = mock(Filter.class);
		
		DDOption op1 = new DDOption(CODIGO_OP_1,DESCRIPCION_OP_1);
		DDOption op2 = new DDOption(CODIGO_OP_2,DESCRIPCION_OP_2);
		
		when(genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_OP_1)).thenReturn(f1);
		when(genericDao.createFilter(FilterType.EQUALS, "codigo", CODIGO_OP_2)).thenReturn(f2);
		
		when(genericDao.get(DDOption.class, f1)).thenReturn(op1);
		when(genericDao.get(DDOption.class, f2)).thenReturn(op2);
	}
	
	@After
	public void after(){
		genericDao = null;
		dto = null;
	}
	
	/**
	 * Comprueba que funcione el método create con un dto que tiene dos DDCombos
	 * con el mismo diccionario. También comprueba que se cree correctamtente
	 * para el caso que el DDCombo se persista en un String o en un Objeto DD
	 * 
	 * @throws Exception
	 */
	@Test
	public void testDosPropiedadesMismoDiccionario() throws Exception {
		dto.setOpcion1(CODIGO_OP_1);
		dto.getOpcion2().setCodigo(CODIGO_OP_2);
		
		ConcreteObject o = dto.createObject();
		
		assertEquals(CODIGO_OP_1,o.getOpcion1().getCodigo());
		assertEquals(DESCRIPCION_OP_1, o.getOpcion1().getDescripcion());
		
		assertEquals(CODIGO_OP_2,o.getOpcion2().getCodigo());
		assertEquals(DESCRIPCION_OP_2, o.getOpcion2().getDescripcion());
		
	}
	
	/**
	 * En este test compruebo que los valores que va a mostrar el formulario para los combos es el correcto en ambos casos: propiedad String y diccionario.
	 * @throws Exception
	 */
	@Test
	public void testValoresFormulario() throws Exception {
		
		ConcreteObject o = new ConcreteObject();
		o.setOpcion1(new DDOption(CODIGO_OP_1, DESCRIPCION_OP_1));
		o.setOpcion2(new DDOption(CODIGO_OP_2, DESCRIPCION_OP_2));
		
		dto.loadObject(o);
		
		String dataOpcion1 = null;
		String dataOpcion2 = null;
		
		for (Entry<String, Object> e : dto.getData()){
			if ("opcion1".equals(e.getKey())){
				dataOpcion1 = e.getValue().toString();
			}
			
			if ("opcion2".equals(e.getKey())){
				dataOpcion2 = e.getValue().toString();
			}
		}
		
		assertEquals(CODIGO_OP_1, dataOpcion1);
		assertEquals(CODIGO_OP_2, dataOpcion2);
	}

}
