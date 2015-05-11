package es.pfsgroup.plugin.recovery.config.test.dao.ADMPerfilDao;

import org.junit.Test;

import es.capgemini.devon.bo.BusinessOperationException;
import es.pfsgroup.recovery.ext.impl.perfil.model.EXTPerfil;
import es.pfsgroup.testfwk.FieldCriteria;
import es.pfsgroup.testfwk.TestData;

public class GuardarOActualizarPerfilTest extends AbstractADMPerfilDaoTest {

	private static final String NUEVA_DESCRIPCION_PERFIL = "nueva descripcion perfil";

	@Test
	public void testGuardarNuevoPerfil() throws Exception {
		EXTPerfil p = TestData.newTestObject(EXTPerfil.class, new FieldCriteria("id",
				null), new FieldCriteria("auditoria", null), new FieldCriteria(
				"id", 1L), new FieldCriteria("codigo", "42"));
		dao.save(p);
		assertEquals(1L, dao.getList().size());
	}

	@Test
	public void testActualizaPerfil() throws Exception {

		cargaDatos();
		EXTPerfil p = TestData.newTestObject(EXTPerfil.class, new FieldCriteria("id",
				1L), new FieldCriteria("id", 1L), new FieldCriteria("codigo",
				"42"));
		p.setDescripcion(NUEVA_DESCRIPCION_PERFIL);
		dao.saveOrUpdate(p);
		assertEquals(NUEVA_DESCRIPCION_PERFIL, dao.get(1L).getDescripcion());
	}

	@Test
	public void testGuardarNuevo_codigoNoNumerico() throws Exception {
		EXTPerfil p = TestData.newTestObject(EXTPerfil.class, new FieldCriteria("id",
				null), new FieldCriteria("auditoria", null), new FieldCriteria(
				"codigo", "a"));

		try {
			dao.save(p);
			fail("Deber�a  haberse lanzado una excepci�n");
		} catch (BusinessOperationException e) {

		}
	}

	@Test
	public void testActualizar_codigoNoNumerico() throws Exception {
		EXTPerfil p = TestData.newTestObject(EXTPerfil.class, new FieldCriteria("id",
				1L), new FieldCriteria("codigo", "a"));

		try {
			dao.saveOrUpdate(p);
			fail("Deber�a  haberse lanzado una excepci�n");
		} catch (BusinessOperationException e) {

		}
	}
}
