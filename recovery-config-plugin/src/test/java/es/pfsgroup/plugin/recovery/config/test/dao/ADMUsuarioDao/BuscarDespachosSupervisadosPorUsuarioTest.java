package es.pfsgroup.plugin.recovery.config.test.dao.ADMUsuarioDao;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;

import es.capgemini.pfs.despachoExterno.model.DespachoExterno;

public class BuscarDespachosSupervisadosPorUsuarioTest extends AbstractADMUsuarioDaoTest{

	
	@Test
	public void testBuscaDespachoSupervisado_() throws Exception {
		
		cargaDatos();
		
		List<DespachoExterno> result1 =  dao.findDespachoSupervisor(2L, 1L);
		List<DespachoExterno> result2 =  dao.findDespachoSupervisor(5L, 1L);
		
		assertEquals(1, result1.size());
		assertEquals(2, result2.size());
	}
	
	@Test
	public void testBuscaDespachoSupervisado_idEntidadIncorrecto_sinDatos() throws Exception {
		
		cargaDatos();
		
		List<DespachoExterno> result =  dao.findDespachoSupervisor(2L, 2L);
		
		assertEquals(0, result.size());
	}
	
	@Test
	public void testIdEntidadNull() throws Exception {
		try{
			dao.findDespachoSupervisor(2L, null);
			fail("Debería haberse lanzado una excepción");
		}catch(IllegalArgumentException e){
			
		}
	}
}
