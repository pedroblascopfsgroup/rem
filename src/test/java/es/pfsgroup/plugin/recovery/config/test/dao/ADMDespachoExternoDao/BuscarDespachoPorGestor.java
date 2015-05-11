package es.pfsgroup.plugin.recovery.config.test.dao.ADMDespachoExternoDao;

import org.junit.Test;

import es.capgemini.pfs.despachoExterno.model.DespachoExterno;


public class BuscarDespachoPorGestor extends AbstractADMDespachoExternoDaoTest{

	@Test
	public void testBuscarDespachoPorGestor() throws Exception{
		cargaDatos();
		DespachoExterno result = dao.buscarPorGestor(1L);
		
		assertEquals((Long) 1L, result.getId());
		
		result = dao.buscarPorGestor(4L); 
		
		assertEquals((Long) 2L, result.getId());
	}
	
	@Test
	public void testDebeSerGestorExterno_NoSupervisor(){
		cambiaFicheroDatos("/dbunit-test-data/Gestores-Despachos_usuarioInterno_supervisor.xml");
		
		DespachoExterno result = dao.buscarPorGestor(1L);
		assertNull("Devuelve el despacho a pesar de ser usuario interno",result);
		
		result = dao.buscarPorGestor(2L);
		assertNull("Devuelve el despacho a pesar de ser supervisor",result);
	}
}
