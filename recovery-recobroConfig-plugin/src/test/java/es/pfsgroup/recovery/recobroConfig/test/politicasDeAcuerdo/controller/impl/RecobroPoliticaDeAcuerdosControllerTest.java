package es.pfsgroup.recovery.recobroConfig.test.politicasDeAcuerdo.controller.impl;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.ui.ModelMap;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.dto.RecobroPoliticaDeAcuerdosDto;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model.RecobroPoliticaDeAcuerdos;
import es.pfsgroup.recovery.recobroConfig.politicasDeAcuerdo.controller.impl.RecobroPoliticaDeAcuerdosController;
import es.pfsgroup.recovery.recobroConfig.test.AbstractRecobroControllerTest;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.RecobroAgenciasConstants;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.RecobroPoliticaDeAcuerdosConstants;

@RunWith(MockitoJUnitRunner.class)
public class RecobroPoliticaDeAcuerdosControllerTest extends AbstractRecobroControllerTest {

	@InjectMocks
	RecobroPoliticaDeAcuerdosController recobroPoliticaDeAcuerdosController;
	
	@Mock
	Page mockPagina;
	
	private ModelMap map;
	private RecobroPoliticaDeAcuerdosDto dto;
	private Long idPolitica;
	private RecobroPoliticaDeAcuerdos politica;
	
	@Override
	public void childBefore() {
		map = new ModelMap();
		dto = new RecobroPoliticaDeAcuerdosDto();
		idPolitica = random.nextLong();
		politica = new RecobroPoliticaDeAcuerdos();
		
	}

	@Override
	public void childAfter() {
		map=null;
		dto=null;
		idPolitica=null;
		politica=null;
		
	}
	
	@Test
	public void testOpenABMPoliticas() {
		String resultado = recobroPoliticaDeAcuerdosController.openABMPoliticas(map);
		
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR ,RecobroPoliticaDeAcuerdosConstants.PLUGIN_RECOBROCONFIG_OPEN_BUSQUEDA_POLITICAS, resultado);
    	
		
	}
	
	@Test
	public void testBuscaPoliticasAcuerdos(){
		
		when(mockRecobroPoliticaDeAcuerdoManager.buscaPoliticas(dto)).thenReturn(mockPagina);
		
		String resultado = recobroPoliticaDeAcuerdosController.buscaPoliticasAcuerdos(dto, map);
		
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR ,RecobroPoliticaDeAcuerdosConstants.PLUGIN_RECOBROCONFIG_LISTA_POLITICAS_JSON, resultado);
    	
		
	}
	
	@Test
	public void testBorrarPoliticaAcuerdos (){
		String resultado = recobroPoliticaDeAcuerdosController.borrarPoliticaAcuerdos(idPolitica, map);
		
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR ,RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT, resultado);
    	
	}
	
	@Test
	public void testBuscaPalancasPolitica(){
		when(mockRecobroPoliticaDeAcuerdoManager.getPoliticaDeAcuerdo(idPolitica)).thenReturn(politica);
		
		
		String resultado = recobroPoliticaDeAcuerdosController.buscaPalancasPolitica(idPolitica, map);
		
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR ,RecobroPoliticaDeAcuerdosConstants.PLUGIN_RECOBROCONFIG_LISTA_PALANCASPOLITICA_JSON, resultado);
    	
	}
	
	@Test
	public void testAltaPoliticaAcuerdos(){
		String resultado = recobroPoliticaDeAcuerdosController.altaPoliticaAcuerdos(map);
		
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR ,RecobroPoliticaDeAcuerdosConstants.PLUGIN_RECOBROCONFIG_OPEN_ALTA_POLITICA, resultado);
    	
	}
	
	@Test
	public void testAddPalancaPolitica(){
		String resultado = recobroPoliticaDeAcuerdosController.addPalancaPolitica(idPolitica, map);
		
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR ,RecobroPoliticaDeAcuerdosConstants.PLUGIN_RECOBROCONFIG_ADD_PALANCA_POLITICA, resultado);
    	
	}

	

}
