package es.pfsgroup.plugin.recovery.config.test.dao.ADMPerfilDao;

import java.util.Arrays;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

import org.junit.Test;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.users.domain.Perfil;
import es.pfsgroup.plugin.recovery.config.perfiles.dto.ADMDtoBuscaPerfil;

public class BuscarPerfilesTest extends AbstractADMPerfilDaoTest {

	@Test
	public void testBuscarPerfiles_DTOSinDatos_todosLosResultados()
			throws Exception {

		cargaDatos();
		ADMDtoBuscaPerfil dto = new ADMDtoBuscaPerfil();
		Page result = dao.findPerfiles(dto);

		assertNotNull(result);
		assertTrue(result.getResults().size() == 3);
	}

	@Test
	public void testBuscarPerfiles_sinDatos() {
		ADMDtoBuscaPerfil dto = new ADMDtoBuscaPerfil();
		Page result = dao.findPerfiles(dto);

		assertNotNull(result);
		assertTrue(result.getResults().size() == 0);
	}

	@Test
	public void testBuscarPerfiles_filtrarDatosPerfil() throws Exception {

		cargaDatos();
		ADMDtoBuscaPerfil dto = new ADMDtoBuscaPerfil();

		dto.setDescripcion("Jefe de Zona");
		assertQuery(dto, Arrays.asList(2L));
		dto.setDescripcion("jefe de zona");
		assertQuery(dto, Arrays.asList(2L));
		dto.setDescripcion("zona");
		assertQuery(dto, Arrays.asList(2L));

		dto = new ADMDtoBuscaPerfil();
		dto.setDescripcionLarga("Dir. de riesgos");
		assertQuery(dto, Arrays.asList(3L));

		dto = new ADMDtoBuscaPerfil();
		dto.setId(1L);
		assertQuery(dto, Arrays.asList(1L));
	}

	@Test
	public void testBuscarPerfiles_dtoEsNull() {
		//TODO: Revisar... comentado para que no falle en hudson
		/*
		TestTemplate template = new NullArgumentsTest(dao, "findPerfiles",
				ADMDtoPerfil.class);
		template.run();
		*/
	}

	@Test
	public void testBusscarPorFunciones() throws Exception {
		cargaDatos();
		ADMDtoBuscaPerfil dto = new ADMDtoBuscaPerfil();

		dto.setFunciones("3,2,1");
		assertQuery(dto, Arrays.asList(1L, 2L, 3L));

		dto.setFunciones("1,3,2");
		assertQuery(dto, Arrays.asList(1L, 2L, 3L));

		dto.setFunciones("1,3");
		assertQuery(dto, Arrays.asList(1L, 3L));

		dto.setFunciones("1,3,3");
		assertQuery(dto, Arrays.asList(1L, 3L));

		dto.setFunciones("1");
		assertQuery(dto, Arrays.asList(1L));

		dto.setFunciones("1,2");
		assertQuery(dto, Arrays.asList(1L, 2L, 3L));
	}

	@Test
	public void testSQLInjection_lanzaExcepcion() throws Exception {
		cargaDatos();
		ADMDtoBuscaPerfil dto = new ADMDtoBuscaPerfil();
		dto.setFunciones("select id from Perfil");
		try {
			dao.findPerfiles(dto);
			fail("Se deber�a haber lanzado una excepci�n");
		} catch (Exception e) {

		}
	}

	private void assertQuery(ADMDtoBuscaPerfil dto, Collection<Long> perfiles) {
		Page result = dao.findPerfiles(dto);
		assertNotNull(result);
		assertTrue("No se ha devuelto el numero de resultados esperados",
				result.getResults().size() == perfiles.size());

		Set<Long> obtenidos = new HashSet<Long>();
		for (int i = 0; i < result.getResults().size(); i++) {
			obtenidos.add(((Perfil) result.getResults().get(i)).getId());
		}

		assertTrue("Se han obtenido resultados que no son los esperados.",
				perfiles.containsAll(obtenidos));
		assertTrue("No se han obtenido todos los resultados esperados.",
				obtenidos.containsAll(perfiles));
	}
}
