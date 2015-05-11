package es.pfsgroup.recovery.recobroConfig.test.procesosFacturacion.controller.impl;

import static org.junit.Assert.assertEquals;

import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.ui.ModelMap;

import es.pfsgroup.recovery.recobroConfig.procesosFacturacion.controller.impl.RecobroProcesosFacturacionController;
import es.pfsgroup.recovery.recobroConfig.test.AbstractRecobroControllerTest;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.RecobroAgenciasConstants;
import es.pfsgroup.recovery.recobroConfig.utils.RecobroConfigConstants.RecobroProcesosFacturacionConstants;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonProcesosFacturacionConstants;

@RunWith(MockitoJUnitRunner.class)
public class RecobroProcesosFacturacionControllerTest extends AbstractRecobroControllerTest{
	
	@InjectMocks
	RecobroProcesosFacturacionController procesosFacturacionController;
	
	private ModelMap map;

	@Override
	public void childBefore() {
		map = new ModelMap();
		
	}

	@Override
	public void childAfter() {
		map=null;
		
	}
	
	@Test
	public void testOpenLauncher() {
		String resultado = procesosFacturacionController.openLauncher(map);
		
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR ,RecobroProcesosFacturacionConstants.PLUGIN_RECOBROCONFIG_OPEN_LAUNCHER, resultado);
    	
	}

//	@Test
//	public void testAbrirCalculo() {
//		String resultado = procesosFacturacionController.abrirCalculo(map);
//		
//		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR, RecobroProcesosFacturacionConstants.PLUGIN_RECOBROCONFIG_OPEN_CALCULO, resultado);
//	}

	@Ignore
	@Test
	public void testAbrirRemesas() {
		String resultado = procesosFacturacionController.abrirRemesas(map);
		
		assertEquals(RecobroAgenciasConstants.PUGIN_RECOBRO_TEST_CONTROLLER_ERROR, RecobroProcesosFacturacionConstants.PLUGIN_RECOBROCONFIG_OPEN_REMESAS, resultado);

	}

	

}
