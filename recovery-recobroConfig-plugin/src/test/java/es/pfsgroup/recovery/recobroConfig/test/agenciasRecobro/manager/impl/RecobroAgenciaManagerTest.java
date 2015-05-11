package es.pfsgroup.recovery.recobroConfig.test.agenciasRecobro.manager.impl;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.dto.RecobroAgenciaDto;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.manager.impl.RecobroAgenciaManager;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroConfig.test.agenciasRecobro.AbstractRecobroManagerTest;

/**
 * Clase para los test de la clase {@link RecobroAgenciaManager}
 * @author diana
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class RecobroAgenciaManagerTest extends AbstractRecobroManagerTest{
	
	@InjectMocks
	RecobroAgenciaManager recobroAgenciaManager;
	
	private RecobroAgenciaDto dto;
	
	
	@Override
	public void childBefore() {
		dto = new RecobroAgenciaDto();
		
	}

	@Override
	public void childAfter() {
		dto=null;
	}

	@Test
	public void testBuscaAgencias() {
		
		when(mockRecobroAgenciaDao.buscaAgencias(dto)).thenReturn(mockPagina);
		
		Page resultado = recobroAgenciaManager.buscaAgencias(dto);
		assertEquals(resultado, mockPagina);
	}

//	@Test
//	public void testSaveAgencia() {
//		
//		
//	}
//
//	@Test
//	public void testDeleteAgencia() {
//		fail("Not yet implemented");
//	}

	@Test
	public void testGetAgencia() {
		when(mockRecobroAgenciaDao.get(idAgencia)).thenReturn(agencia);
		
		RecobroAgencia resultado = recobroAgenciaManager.getAgencia(idAgencia);
		assertEquals(resultado, agencia);
		
	}

	

}
