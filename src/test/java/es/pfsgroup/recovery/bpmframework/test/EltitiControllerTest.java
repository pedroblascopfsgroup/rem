package es.pfsgroup.recovery.bpmframework.test;

import static org.junit.Assert.*;
import static org.mockito.Mockito.when;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.bpmframework.EltitiController;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkConfigApi;

/**
 * Tests para el Controlador EltitiControllerTest
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class EltitiControllerTest {
	
	//Definimos la clase sobre la que vamos a realizar los tests mediante la anotación @InjectMocks
	@InjectMocks EltitiController mockEltitiController;
	
	//Definimos los objetos Mock que vamos a utilizar.
	@Mock private ApiProxyFactory mockProxyFactory;
	@Mock private RecoveryBPMfwkBatchApi mockRecoveryBPMfwkBatchApi;
	@Mock private RecoveryBPMfwkConfigApi mockRecoveryBPMfwkConfigApi;
	
    /**
     * Comprobamos que existe el método abrirPantalla()
     */
    @Test    
    public void testAbrirPantalla(){
    	
    	when(mockProxyFactory.proxy(RecoveryBPMfwkBatchApi.class)).thenReturn(mockRecoveryBPMfwkBatchApi);
    	String result = mockEltitiController.procesadobatch();
    	
    	assertNotNull(result);
    }
    
    /**
     * Comprobamos que existe el método recuperaConfiguracion
     */
    @Test    
    public void testRecuperaConfiguracion(){
    	
    	String codigoTipoInput = RandomStringUtils.randomAlphanumeric(20);
    	String codigoTipoProcedimiento = RandomStringUtils.randomAlphanumeric(20);
    	String codigoNodo = RandomStringUtils.randomAlphanumeric(20);
    	
    	when(mockProxyFactory.proxy(RecoveryBPMfwkConfigApi.class)).thenReturn(mockRecoveryBPMfwkConfigApi);
    	String result = mockEltitiController.recuperaConfiguracion(codigoTipoInput, codigoTipoProcedimiento, codigoNodo);
    	
    	assertNotNull(result);
    }
    
    /**
     * Comprobamos que existe el método ejecutaPeticionesBatchPendientes
     * @return
     */
    @Test
    public void testEjecutaPeticionesBatchPendientes() {
    	
    	when(mockProxyFactory.proxy(RecoveryBPMfwkBatchApi.class)).thenReturn(mockRecoveryBPMfwkBatchApi);
    	String result = mockEltitiController.ejecutaPeticionesBatchPendientes();
    	
    	assertNotNull(result);
    }

}
