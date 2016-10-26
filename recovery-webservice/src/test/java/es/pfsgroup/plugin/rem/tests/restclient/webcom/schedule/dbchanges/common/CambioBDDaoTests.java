package es.pfsgroup.plugin.rem.tests.restclient.webcom.schedule.dbchanges.common;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.dao.SessionFactoryFacade;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambioBD;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambiosBDDao;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.FieldInfo;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.HibernateExecutionFacade;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.InfoTablasBD;
import es.pfsgroup.plugin.rem.tests.restclient.webcom.examples.ExampleDto;
import es.pfsgroup.plugin.rem.tests.restclient.webcom.examples.ExampleSubDto;

@RunWith(MockitoJUnitRunner.class)
public class CambioBDDaoTests {

	private static class TestDto {
		String primerCampo;
		String segundoCampo;
		String tercerCampo;
		String cuartoCampo;
		String quintoCampo;
		String sextoCampo;
		String septimoCampo;
		String octavoCampo;
	}

	private static class TestInfoTabla implements InfoTablasBD {

		private String clavePrimaria = "TERCER_CAMPO";

		public void cambiaClavePrimaria(String s) {
			this.clavePrimaria = s;
		}

		@Override
		public String nombreVistaDatosActuales() {
			return "";
		}

		@Override
		public String nombreTablaDatosHistoricos() {
			return "";
		}

		@Override
		public String clavePrimaria() {
			return clavePrimaria;
		}

	}

	@Mock
	private SessionFactoryFacade sessionFactory;

	@Mock
	private HibernateExecutionFacade facade;

	@InjectMocks
	private CambiosBDDao dao;

	private ArrayList<Object[]> resultadoMinus;

	private String[] datosHistoricos;

	private ArgumentCaptor<String> uniqueQueryCaptor;

	@Before
	public void setup() {
		resultadoMinus = new ArrayList<Object[]>();
		when(sessionFactory.getSession(any(HibernateDaoSupport.class))).thenReturn(mock(Session.class));

	}

	@Test
	public void listCambios_datosActuales_primaryKey_noEsPrimeraColumna() {

		resultadoMinus.add(new String[] { "7", "2016-10-10T00:00:00", "1", "1", "1", "AAA", "12345", null });
		datosHistoricos = new String[] { "7", "2016-10-10T00:00:00", "1", "1", "1", "AAA", "777", null };
		hibernateExecutionFacadeBehaviour();

		List<CambioBD> cambios = dao.listCambios(TestDto.class, new TestInfoTabla(), null);
		assertEquals("La lista de cambios debe contener sólo 1 elemento", 1, cambios.size());

		String query = uniqueQueryCaptor.getValue();
		assertTrue("No se está recuperando correctamente la primary key", query.endsWith("TERCER_CAMPO = 1"));

	}

	@Test
	public void listCambios_datosActuales_primaryKey_noEsCampoDelDTO() {
		// hibernateExecutorFacade devolvería ese nuevo campo al final.

		resultadoMinus.add(new String[] { "7", "2016-10-10T00:00:00", "1", "1", "1", "AAA", "12345", null, "42" });
		datosHistoricos = new String[] { "7", "2016-10-10T00:00:00", "1", "1", "1", "AAA", "777", null, "42" };
		hibernateExecutionFacadeBehaviour();

		TestInfoTabla infoTablas = new TestInfoTabla();
		infoTablas.cambiaClavePrimaria("ESTO_NO_ES_UN_CAMPO");

		List<CambioBD> cambios = dao.listCambios(TestDto.class, infoTablas, null);

		assertEquals("La lista de cambios debe contener sólo 1 elemento", 1, cambios.size());

		String query = uniqueQueryCaptor.getValue();
		assertTrue("No se está recuperando correctamente la primary key", query.endsWith("ESTO_NO_ES_UN_CAMPO = 42"));

	}

	@Test
	public void colum4select_clavePrimaria_incluidaEnCampos() {
		FieldInfo[] fields = { new FieldInfo("primerCampo"), new FieldInfo("segundoCampo") };
		String clavePrimaria = "PRIMER_CAMPO";
		String columns = dao.columns4Select(fields, clavePrimaria);

		String[] array = columns.split(CambiosBDDao.SEPARADOR_COLUMNAS);
		assertEquals("El número de columnas no es el esperado", 2, array.length);

	}

	@Test
	public void colum4select_clavePrimaria_faltaClavePrimaria() {
		FieldInfo[] fields = { new FieldInfo("primerCampo"), new FieldInfo("segundoCampo") };
		String clavePrimaria = "TERCER_CAMPO";
		String columns = dao.columns4Select(fields, clavePrimaria);

		String[] array = columns.split(CambiosBDDao.SEPARADOR_COLUMNAS);
		assertEquals("El número de columnas no es el esperado", 3, array.length);

	}


	@Test
	public void getDtoFields_DTOs_anidados() {
		List<String> campos = listOfStrings(dao.getDtoFields(ExampleDto.class));

		// El DTO tiene 6 campos y además 2 sub-dtos con 3 campos cada uno
		assertEquals("El número de campos no coincide", 12, campos.size());

		assertTrue(campos.contains("idObjeto"));
		assertTrue(campos.contains("idUsuarioRemAccion"));
		assertTrue(campos.contains("fechaAccion"));
		assertTrue(campos.contains("campoObligatorio"));
		assertTrue(campos.contains("campoOpcional"));
		assertTrue(campos.contains("listado1.campoObligatorio"));
		assertTrue(campos.contains("listado1.campoOpcional"));
		assertTrue(campos.contains("listado2.campoObligatorio"));
		assertTrue(campos.contains("listado2.campoOpcional"));
	}

	@Test
	public void columns4select_DTOs_anidados() {
		List<String> columnas = Arrays.asList(dao.columns4Select(
				new FieldInfo[] { new FieldInfo("campo"), new FieldInfo("miCampo"), new FieldInfo("listado.miCampo") },
				null).split(","));
		assertEquals("La cantidad de columans no es la esperada", 3, columnas.size());

		assertTrue(columnas.contains("CAMPO"));
		assertTrue(columnas.contains("MI_CAMPO"));
		assertTrue("El campo anidado no se ha devuelto correctamente", columnas.contains("LISTADO_MI_CAMPO"));

	}
	
	@Test
	public void getDtoFiends_and_colum4select_nombresLargosDeColumna() {
		/*
		 * Example DTO contiene un campo muy largo que deberá convertirse al
		 * valor indicado por @MappedColumn cuando se obtengan los nombres de
		 * columnas.
		 * 
		 * Para ello los métodos getDtoFields y column4select deben
		 * "entenderse bien"
		 */
		FieldInfo[] fields = dao.getDtoFields(ExampleDto.class);
		String columns = dao.columns4Select(fields, null);

		List<String> columnList = Arrays.asList(columns.split(CambiosBDDao.SEPARADOR_COLUMNAS));
		assertTrue("No se ha devuelto la columna esperada", columnList.contains(ExampleDto.SHORT_COLUMN_NAME));

		// Comprobamos que esta anotación también tiene efectos en sub-dtos.
		assertTrue("No se ha devuelto la columna esperada (en el sub-dto)",
				columnList.contains("LISTADO1_" + ExampleSubDto.SHORT_COLUMN_NAME));
		assertTrue("No se ha devuelto la columna esperada (en el sub-dto)",
				columnList.contains("LISTADO2_" + ExampleSubDto.SHORT_COLUMN_NAME));

	}

	private void hibernateExecutionFacadeBehaviour() {
		when(facade.createCriteria(any(Session.class), any(Class.class))).thenReturn(mock(Criteria.class));
		when(facade.criteriaRunUniqueResult(any(Criteria.class))).thenReturn(mock(Usuario.class));

		when(facade.sqlRunList(any(Session.class), anyString())).thenReturn(resultadoMinus);
		uniqueQueryCaptor = ArgumentCaptor.forClass(String.class);
		when(facade.sqlRunUniqueResult(any(Session.class), uniqueQueryCaptor.capture())).thenReturn(datosHistoricos);
	}

	private List<String> listOfStrings(FieldInfo[] dtoFields) {
		ArrayList<String> list = new ArrayList<String>();
		if (dtoFields != null) {
			for (FieldInfo fi : dtoFields) {
				list.add(fi.getFieldName());
			}
		}
		return list;
	}

}
