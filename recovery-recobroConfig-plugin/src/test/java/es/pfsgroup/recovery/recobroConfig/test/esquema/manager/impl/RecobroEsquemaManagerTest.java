package es.pfsgroup.recovery.recobroConfig.test.esquema.manager.impl;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroEsquemaDto;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.impl.RecobroEsquemaManager;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroConfig.test.agenciasRecobro.AbstractRecobroManagerTest;

/**
 * Clase para los test de la clase {@link RecobroEsquemaManager}
 * @author diana
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class RecobroEsquemaManagerTest extends AbstractRecobroManagerTest{
	
	@InjectMocks
	RecobroEsquemaManager recobroEsquemaManager;
	
	private RecobroEsquemaDto dto;
	private Long idEsquema;
	private RecobroEsquema esquema;
	private RecobroCarteraEsquema carteraEsquema;
	private Long idCarteraEsquema;
	private Filter filtro;
	
	@Override
	public void childBefore() {
		dto=new RecobroEsquemaDto();
		idEsquema=random.nextLong();
		esquema=new RecobroEsquema();
		esquema.setId(idEsquema);
		idCarteraEsquema= random.nextLong();
		carteraEsquema = new RecobroCarteraEsquema();
		carteraEsquema.setId(idCarteraEsquema);
		filtro = new Filter() {
			
			@Override
			public FilterType getType() {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public Object getPropertyValue() {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public String getPropertyName() {
				// TODO Auto-generated method stub
				return null;
			}
		};
	}

	@Override
	public void childAfter() {
		dto= null;
		idEsquema=null;
		esquema=null;
		idCarteraEsquema=null;
		carteraEsquema=null;
		filtro=null;
		
		
	}

	@Test
	public void testBuscarRecobroEsquema() {
		when(mockRecobroEsquemaDao.buscarRecobroEsquema(dto)).thenReturn(mockPagina);
		Page resultado = recobroEsquemaManager.buscarRecobroEsquema(dto);
		
		assertEquals(resultado, mockPagina);
	}

	
	@Test
	public void testGetRecobroEsquema() {
		when(mockRecobroEsquemaDao.get(idEsquema)).thenReturn(esquema);
		
		RecobroEsquema resultado = recobroEsquemaManager.getRecobroEsquema(idEsquema);
		assertEquals(resultado, esquema);
	}

	@Test
	public void testGetRecobroCarteraEsquema (){
		when(mockGenericDao.createFilter(FilterType.EQUALS, "id", idCarteraEsquema)).thenReturn(filtro) ;
		when(mockGenericDao.get(RecobroCarteraEsquema.class, filtro)).thenReturn(carteraEsquema);
		
		
		RecobroCarteraEsquema resultado = recobroEsquemaManager.getRecobroCarteraEsquema(idCarteraEsquema); 
		assertEquals(resultado, carteraEsquema);
	}
	
//	@Test
//	public void testBorrarRecobroEsquema() {
//		fail("Not yet implemented");
//	}
//
//	@Test
//	public void testGuardarRecobroEsquema() {
//		fail("Not yet implemented");
//	}

	
}
