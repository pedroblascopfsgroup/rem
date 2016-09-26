package es.pfsgroup.plugin.rem.tests.restclient.webcom.schedule.dbchanges.common;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
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

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.dao.SessionFactoryFacade;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambioBD;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.CambiosBDDao;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.HibernateExecutionFacade;
import es.pfsgroup.plugin.rem.restclient.schedule.dbchanges.common.InfoTablasBD;

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
		

		List<CambioBD> cambios = dao.listCambios(TestDto.class, new TestInfoTabla());
		assertEquals("La lista de cambios debe contener sólo 1 elemento", 1, cambios.size());

		String query = uniqueQueryCaptor.getValue();
		assertTrue("No se está recuperando correctamente la primary key", query.endsWith("TERCER_CAMPO = 1"));

	}

	@Test
	public void listCambios_datosActuales_primaryKey_noEsCampoDelDTO() {
		//hibernateExecutorFacade devolvería ese nuevo campo al final.
		
		resultadoMinus.add(new String[] { "7", "2016-10-10T00:00:00", "1", "1", "1", "AAA", "12345", null, "42" });
		datosHistoricos = new String[] { "7", "2016-10-10T00:00:00", "1", "1", "1", "AAA", "777", null, "42" };
		hibernateExecutionFacadeBehaviour();

		TestInfoTabla infoTablas = new TestInfoTabla();
		infoTablas.cambiaClavePrimaria("ESTO_NO_ES_UN_CAMPO");

		List<CambioBD> cambios = dao.listCambios(TestDto.class, infoTablas);

		assertEquals("La lista de cambios debe contener sólo 1 elemento", 1, cambios.size());
		
		String query = uniqueQueryCaptor.getValue();
		assertTrue("No se está recuperando correctamente la primary key", query.endsWith("ESTO_NO_ES_UN_CAMPO = 42"));

	}
	
	@Test
	public void colum4select_clavePrimaria_incluidaEnCampos(){
		String[] fields = {"primerCampo", "segundoCampo"};
		String clavePrimaria = "PRIMER_CAMPO";
		String columns = dao.columns4Select(fields, clavePrimaria);
		
		String[] array = columns.split(CambiosBDDao.SEPARADOR_COLUMNAS);
		assertEquals("El número de columnas no es el esperado", 2, array.length);
		
	}
	
	@Test
	public void colum4select_clavePrimaria_faltaClavePrimaria(){
		String[] fields = {"primerCampo", "segundoCampo"};
		String clavePrimaria = "TERCER_CAMPO";
		String columns = dao.columns4Select(fields, clavePrimaria);
		
		String[] array = columns.split(CambiosBDDao.SEPARADOR_COLUMNAS);
		assertEquals("El número de columnas no es el esperado", 3, array.length);
		
	}
	
	
	
	private void hibernateExecutionFacadeBehaviour() {
		when(facade.createCriteria(any(Session.class), any(Class.class))).thenReturn(mock(Criteria.class));
		when(facade.criteriaRunUniqueResult(any(Criteria.class))).thenReturn(mock(Usuario.class));

		when(facade.sqlRunList(any(Session.class), anyString())).thenReturn(resultadoMinus);
		uniqueQueryCaptor = ArgumentCaptor.forClass(String.class);
		when(facade.sqlRunUniqueResult(any(Session.class), uniqueQueryCaptor.capture())).thenReturn(datosHistoricos);
	}

}
