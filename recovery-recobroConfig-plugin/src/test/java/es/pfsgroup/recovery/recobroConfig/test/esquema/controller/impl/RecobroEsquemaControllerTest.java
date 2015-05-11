package es.pfsgroup.recovery.recobroConfig.test.esquema.controller.impl;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.ui.ModelMap;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.recovery.recobroCommon.esquema.dto.RecobroEsquemaDto;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroConfig.esquema.controller.impl.RecobroEsquemaController;
import es.pfsgroup.recovery.recobroConfig.test.AbstractRecobroControllerTest;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.RecobroAgenciasConstants;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.RecobroEsquemasConstants;

/**
 * Clase para los test de la clase {@link RecobroEsquemaController}
 * @author diana
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class RecobroEsquemaControllerTest extends AbstractRecobroControllerTest{

	@InjectMocks
	RecobroEsquemaController recobroEsquemaController;
	
	@Mock
	Page mockPagina;
	
	
	private ModelMap map;
	private Long idEsquema;
	private boolean ultimaVersionDelEsquema;
	private RecobroEsquemaDto dto;
	private RecobroEsquema esquema;
	private Long idCarteraEsquema;
	private RecobroCarteraEsquema recobroCarteraEsquema;
	
	@Override
	public void childBefore() {
		map = new ModelMap();
		idEsquema=random.nextLong();
		ultimaVersionDelEsquema=random.nextBoolean();
		dto = new RecobroEsquemaDto();
		esquema = new RecobroEsquema();
		esquema.setId(idEsquema);
		idCarteraEsquema=random.nextLong();
		recobroCarteraEsquema=new RecobroCarteraEsquema();
		
	}

	@Override
	public void childAfter() {
		map = null;
		idEsquema=null;
		ultimaVersionDelEsquema=false;
		dto = null;
		esquema=null;
		idCarteraEsquema=null;
		recobroCarteraEsquema=null;
		
	}
	
	@Test
	public void testOpenABMEsquema() {
		String resultado = recobroEsquemaController.openABMEsquema(map);
		
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR ,RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_OPEN_BUSQUEDA_ESQUEMAS, resultado);
    	
	}

	@Test
	public void testBuscaRecobroEsquema() {
		when(mockRecobroEsquemaManager.buscarRecobroEsquema(dto)).thenReturn(mockPagina);
		
		String resultado = recobroEsquemaController.buscaRecobroEsquema(dto, map);
		
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR ,RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_LISTA_ESQUEMAS_JSON, resultado);
    	
	}

	@Test
	public void testBorrarRecobroEsquema() {
		String resultado = recobroEsquemaController.borrarRecobroEsquema(idEsquema, map);
		
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR ,RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT, resultado);
    	
	}

	@Test
	public void testAbrirRecobroEsquema() {
		String resultado = recobroEsquemaController.abrirRecobroEsquema(idEsquema, "3", map);
		
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR ,RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_ABRIR_ESQUEMA, resultado);
    	
	}

	@Test
	public void testGuardarRecobroEsquema() {
		when(mockRecobroEsquemaManager.buscarRecobroEsquema(dto)).thenReturn(mockPagina);
		
		String resultado = recobroEsquemaController.guardarRecobroEsquema(dto, map);
		
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR ,RecobroAgenciasConstants.PLUGIN_RECOBROCONFIG_DEFAULT, resultado);
    	
	}
	
	@Test
	public void testBuscaCarterasEsquema(){
		when(mockRecobroEsquemaManager.getRecobroEsquema(idEsquema)).thenReturn(esquema);
		
		String resultado=recobroEsquemaController.buscaCarterasEsquema(idEsquema, map);
		
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR ,RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_LISTA_CARTERAS_ESQUEMA_JSON, resultado);
    	
	}
	
	@Test
	public void testOpenFacturacion(){
		
		String resultado=recobroEsquemaController.openFacturacion(idEsquema, ultimaVersionDelEsquema, map);
		
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR ,RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_ABRIR_FACTURACION_ESQUEMA , resultado);
    
	}
	
	@Test
	public void testBuscaSubCarterasCarteraEsquema(){
	
		when(mockRecobroEsquemaManager.getRecobroCarteraEsquema(idCarteraEsquema)).thenReturn(recobroCarteraEsquema);
		
		String resultado=recobroEsquemaController.buscaSubCarterasCarteraEsquema(idCarteraEsquema, map);
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR ,RecobroEsquemasConstants.PLUGIN_RECOBROCONFIG_LISTA_SUBCARTERAS_ESQUEMA_JSON , resultado);
	    
	}

	

}
