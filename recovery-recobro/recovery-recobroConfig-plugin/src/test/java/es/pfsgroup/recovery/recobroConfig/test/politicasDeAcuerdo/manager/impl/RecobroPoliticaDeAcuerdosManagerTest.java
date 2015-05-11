package es.pfsgroup.recovery.recobroConfig.test.politicasDeAcuerdo.manager.impl;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;

import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dto.RecobroPoliticaAcuerdosPalancaDto;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dto.RecobroPoliticaDeAcuerdosDto;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.manager.impl.RecobroPoliticaDeAcuerdosManager;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model.RecobroPoliticaAcuerdosPalanca;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model.RecobroPoliticaDeAcuerdos;
import es.pfsgroup.recovery.recobroConfig.test.agenciasRecobro.AbstractRecobroManagerTest;

@RunWith(MockitoJUnitRunner.class)
public class RecobroPoliticaDeAcuerdosManagerTest extends AbstractRecobroManagerTest{

	@InjectMocks
	RecobroPoliticaDeAcuerdosManager politicaDeAcuerdosManager;
	
	private RecobroPoliticaDeAcuerdosDto dto;
	private RecobroPoliticaAcuerdosPalancaDto dtoPalanca;
	private Long idPolitica;
	private RecobroPoliticaDeAcuerdos politica;
	private Long idPoliticaPalanca;
	private RecobroPoliticaAcuerdosPalanca palanca;
	private Filter filtro;

	@Override
	public void childBefore() {
		dto = new RecobroPoliticaDeAcuerdosDto();
		idPolitica = random.nextLong();
		dtoPalanca= new RecobroPoliticaAcuerdosPalancaDto();
		dtoPalanca.setIdPolitica(idPolitica);
		politica = new RecobroPoliticaDeAcuerdos();
		politica.setId(idPolitica);
		idPoliticaPalanca = random.nextLong();
		palanca = new RecobroPoliticaAcuerdosPalanca();
		palanca.setPoliticaAcuerdos(politica);
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
		dto=null;
		dtoPalanca=null;
		idPolitica= null;
		politica=null;
		idPoliticaPalanca=null;
		palanca=null;
		filtro=null;
		
	}
	
	@Test
	public void testBuscaPoliticas() {
		when(mockRecobroPoliticaDeAcuerdosDao.buscaPoliticas(dto)).thenReturn(mockPagina);
		Page resultado = politicaDeAcuerdosManager.buscaPoliticas(dto);
		
		assertEquals(resultado, mockPagina);
	}
	
	@Test
	@Ignore
	public void testGuardaPalancaPolitica (){
		
		politicaDeAcuerdosManager.guardaPalancaPolitica(dtoPalanca);
		
	}
	
	@Test
	public void getPoliticaDeAcuerdosPalanca (){
		when(mockGenericDao.createFilter(FilterType.EQUALS, "id", idPoliticaPalanca)).thenReturn(filtro) ;
		when(mockGenericDao.get(RecobroPoliticaAcuerdosPalanca.class, filtro)).thenReturn(palanca);
		
		RecobroPoliticaAcuerdosPalanca resultado = politicaDeAcuerdosManager.getPoliticaDeAcuerdosPalanca(idPoliticaPalanca);
		
		assertEquals(resultado, palanca);
	}

}
