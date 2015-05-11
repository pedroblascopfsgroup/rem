package es.pfsgroup.plugin.recovery.config.test.dao.ADMPerfilDao;

import static org.junit.Assert.*;

import org.junit.Test;

public class GetLastIdTest extends AbstractADMPerfilDaoTest{

	
	@Test
	public void testSinDatos_devuelveCero() throws Exception {
		assertEquals((Long) 0L, dao.getLastCodigo());
	}
	
	@Test
	public void testGetLastCodigo() throws Exception {
		cargaDatos();
		assertEquals((Long) 3L, dao.getLastCodigo());
	}
}
