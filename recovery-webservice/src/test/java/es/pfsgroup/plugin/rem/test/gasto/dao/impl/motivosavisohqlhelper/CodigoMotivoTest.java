package es.pfsgroup.plugin.rem.test.gasto.dao.impl.motivosavisohqlhelper;

import static org.junit.Assert.*;

import org.junit.Test;

import es.pfsgroup.plugin.rem.gasto.dao.impl.MotivosAvisoHqlHelper;

public class CodigoMotivoTest {
	
	@Test
	public void codigoNoExiste () {
		assertNull(MotivosAvisoHqlHelper.codigoMotivo("---"));
	}
	
	@Test
	public void codigoCorrespondeComprador () {
		assertEquals("01", MotivosAvisoHqlHelper.codigoMotivo("correspondeComprador"));
	}

}
