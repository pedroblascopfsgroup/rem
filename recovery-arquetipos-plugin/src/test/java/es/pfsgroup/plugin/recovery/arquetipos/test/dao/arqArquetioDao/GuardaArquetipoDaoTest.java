package es.pfsgroup.plugin.recovery.arquetipos.test.dao.arqArquetioDao;

import org.junit.Test;

import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.model.ARQListaArquetipo;

public class GuardaArquetipoDaoTest extends AbstractARQArquetipoDaoTest {
	
	@Test
	public void testGuardaArquetipo_NecesitaInsertarVariableGestion() throws Exception {
		ARQListaArquetipo arq = new ARQListaArquetipo();
		arq.setNombre("aaa");
		arq.setGestion(true);
		dao.save(arq);
		
		assertEquals(1, dao.getList().size());
		
	}

}
