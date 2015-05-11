package es.pfsgroup.common.utils.test.web.dto.metadata;

import static org.junit.Assert.*;

import java.io.Serializable;
import java.lang.reflect.Method;

import net.sf.cglib.proxy.Callback;
import net.sf.cglib.proxy.Enhancer;
import net.sf.cglib.proxy.Dispatcher;
import net.sf.cglib.proxy.MethodInterceptor;
import net.sf.cglib.proxy.MethodProxy;

import org.junit.Test;

import es.pfsgroup.commons.utils.web.dto.metadata.AbstractMetadataDto;
import es.pfsgroup.commons.utils.web.dto.metadata.tmpl.BOReference;
import es.pfsgroup.commons.utils.web.dto.metadata.tmpl.DDCombo;

public class DefaultLoadObjectTest {
	
	
	
	private static final String DICT_CODE = "01";
	private static final Long REF_ID = 1L;
	private static final String STRING_VALUE = "My String";
	private static final Long LONG_VALUE = 42L;


	@Test
	public void testDefaultLoadObject() throws Exception {
		ExampleDictionary dict = new ExampleDictionary();
		dict.setCodigo(DICT_CODE);
		ExampleObject ref = new ExampleObject();
		ref.setId(REF_ID);
		
		ExampleObject object = new ExampleObject();
		object.setReference(ref);
		object.setType(dict);
		object.setStringValue(STRING_VALUE);
		object.setLongValue(LONG_VALUE);
		
		
		ExampleDto dto = new ExampleDto();
		dto.loadObject(object);
		
		assertEquals(DICT_CODE, dto.getType());
		assertEquals(REF_ID, dto.getReference());
		assertEquals(STRING_VALUE, dto.getStringValue());
		assertEquals(LONG_VALUE, dto.getLongValue());
		
	}
	
	@Test
	public void testLoadDefaultObjectCglibEnhanced() throws Exception {
		
		final ExampleObject source = new ExampleObject();
		Enhancer e = new Enhancer();
		e.setSuperclass(ExampleObject.class);
		e.setInterfaces(ExampleObject.class.getInterfaces());
		e.setCallback(new MethodInterceptor() {

			@Override
			public Object intercept(Object arg0, Method method, Object[] args,
					MethodProxy arg3) throws Throwable {
				return method.invoke(source, args);
			}
		});
		
		
		ExampleObject proxy =  (ExampleObject) e.create();
		
		source.setLongValue(1L);
		
		System.out.println(proxy.getClass().getSuperclass());
		
		
		
		
		ExampleDto dto = new ExampleDto();
		dto.loadObject(proxy);
		
		assertEquals((Long) 1L ,dto.getLongValue());
		
		
	}
	

	

	public class ExampleDto extends AbstractMetadataDto<ExampleObject>{
		
		
		private static final long serialVersionUID = 1517786634543441137L;

		private String inexistent;
		
		@BOReference(clazz = ExampleObject.class)
		private Long reference;
		
		private Long longValue;
		
		private String stringValue;
		
		@DDCombo(dictionary = ExampleDictionary.class,labelCode = "")
		private String type;

		public Long getReference() {
			return reference;
		}

		public void setReference(Long reference) {
			this.reference = reference;
		}

		public Long getLongValue() {
			return longValue;
		}

		public void setLongValue(Long longValue) {
			this.longValue = longValue;
		}

		public String getStringValue() {
			return stringValue;
		}

		public void setStringValue(String stringValue) {
			this.stringValue = stringValue;
		}

		public String getType() {
			return type;
		}

		public void setType(String type) {
			this.type = type;
		}

		public void setInexistent(String inexistent) {
			this.inexistent = inexistent;
		}

		public String getInexistent() {
			return inexistent;
		}
	}
	
	
	public  static class ExampleObject implements Serializable{

		
		private static final long serialVersionUID = -141820240458318245L;
		
		public ExampleObject (){}
		
		private Long id;
		private ExampleObject reference;
		private Long longValue;
		private String stringValue;
		private ExampleDictionary type;
		public Long getLongValue() {
			return longValue;
		}
		public void setLongValue(Long longValue) {
			this.longValue = longValue;
		}
		public String getStringValue() {
			return stringValue;
		}
		public void setStringValue(String stringValue) {
			this.stringValue = stringValue;
		}
		public ExampleDictionary getType() {
			return type;
		}
		public void setType(ExampleDictionary type) {
			this.type = type;
		}
		public void setReference(ExampleObject reference) {
			this.reference = reference;
		}
		public ExampleObject getReference() {
			return reference;
		}
		public void setId(Long id) {
			this.id = id;
		}
		public Long getId() {
			return id;
		}
	}
	
	
	public class ExampleDictionary {

		private String codigo;
		
		private String descripcion;

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

}
