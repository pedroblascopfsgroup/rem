package es.pfsgroup.plugin.recovery.config.test.dao.ADMDespachoExternoDao;

import org.junit.Test;

import es.capgemini.pfs.despachoExterno.model.DespachoExterno;

/**
 * Esta clase verifica que se cree correctamente un nuevo DespachoExterno. Es decir, se cree un objeto nuevo y por tanto no persisitido.
 * @author bruno
 *
 */
public class CrearNuevoDespachoExterno extends AbstractADMDespachoExternoDaoTest{
	
	@Test
	public void testCrearNuevoDespachoExterno(){
		DespachoExterno resultado = dao.createNewDespachoExterno();
		
		assertNull(resultado.getId());
	}

}
