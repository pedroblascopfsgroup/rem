package es.pfsgroup.plugin.recovery.config.test.dao.ADMDespachoExternoDao;

import java.util.List;

import org.junit.Assert;
import org.junit.Test;

import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.testfwk.ColumnCriteria;
import es.pfsgroup.testfwk.JoinColumnCriteria;

public class BuscarGestoresDespacho extends AbstractADMDespachoExternoDaoTest {

	@Test
	public void testBuscaGestorDespacho() throws Exception {
		cargaDatos();
		List<GestorDespacho> resultado = dao.buscarGestoresDespacho(1L);

		List<GestorDespacho> esperado = getDatosPruebas(GestorDespacho.class,
				new JoinColumnCriteria("DES_ID", 1L), new ColumnCriteria("USD_SUPERVISOR", 0));

		Assert.assertEquals(esperado.size(), resultado.size());
	}
	
	@Test
	public void testDespachoInexistente() throws Exception{
		cargaDatos();
		List<GestorDespacho> resultado = dao.buscarGestoresDespacho(3L);
		
		Assert.assertTrue(resultado.isEmpty());
	}
	
	@Test
	public void testDespachoSinGesores() throws Exception{
		cambiaFicheroDatos("/dbunit-test-data/Gestores-Despachos_despachoSinGestores.xml");
		cargaDatos();
		List<GestorDespacho> resultado = dao.buscarGestoresDespacho(1L);
		
		Assert.assertTrue(resultado.isEmpty());
		
	}

}
