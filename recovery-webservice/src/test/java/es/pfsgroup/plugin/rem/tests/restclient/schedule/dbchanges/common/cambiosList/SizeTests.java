package es.pfsgroup.plugin.rem.tests.restclient.schedule.dbchanges.common.cambiosList;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.Before;
import org.junit.Test;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.WebcomRESTDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.NestedDto;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambiosList;

public class SizeTests {
	
	
	private static class ExampleDto implements WebcomRESTDto {

		@Override
		public LongDataType getIdUsuarioRemAccion() {
			return null;
		}

		@Override
		public void setIdUsuarioRemAccion(LongDataType value) {
			
		}

		@Override
		public DateDataType getFechaAccion() {
			return null;
		}

		@Override
		public void setFechaAccion(DateDataType value) {
			
		}
	}
	
	private static class ExampleDtoWithNested extends ExampleDto {
		
		private String name;
		
		@NestedDto(groupBy="name", type=Class.class)
		private List<Object> objects = new ArrayList<Object>();
		
		public ExampleDtoWithNested(Object ...array) {
			if (array != null) {
				this.objects = Arrays.asList(array);
			}
		}
	}

	private static final int DEFAULT_BLOCK_SIZE = 100;
	private CambiosList cambios;

	@Before
	public void before() {
		cambios = new CambiosList(DEFAULT_BLOCK_SIZE);
	}
	
	public void after() {
		cambios = null;
	}

	@Test
	public void contieneObjects() {
		cambios.add(new Object());
		cambios.add(new Object());
		
		assertEquals(2, cambios.size());
		
	}
	
	@Test
	public void contieneWebcomRESTDto() {
		cambios.add(new ExampleDto());
		cambios.add(new ExampleDto());
		
		assertEquals(2, cambios.size());
	}
	
	@Test
	public void nestedDtosListaVacia() {
		cambios.add(new ExampleDtoWithNested());
		
		assertEquals(1, cambios.size());
	}
	
	@Test
	public void nestedDtosListaLLena() {
		cambios.add(new ExampleDtoWithNested(new ExampleDto(), new ExampleDto()));
		
		assertEquals(2, cambios.size());
	}

}
