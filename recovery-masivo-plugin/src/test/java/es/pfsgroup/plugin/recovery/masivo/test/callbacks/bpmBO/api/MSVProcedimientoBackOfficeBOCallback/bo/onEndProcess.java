package es.pfsgroup.plugin.recovery.masivo.test.callbacks.bpmBO.api.MSVProcedimientoBackOfficeBOCallback.bo;


import static org.junit.Assert.assertNull;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.recovery.masivo.api.ExcelManagerApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoApi;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.test.callbacks.bpmBO.api.MSVProcedimientoBackOfficeBOCallback.AbstractMSVProcedimientoBackOfficeBOCallbackTests;



/**
 * Esta es la suite de test para probar el método onEndProcess
 * 
 * @author carlos
 *
 */

@RunWith(MockitoJUnitRunner.class)
public class onEndProcess extends AbstractMSVProcedimientoBackOfficeBOCallbackTests {

@Mock
ExcelManagerApi mockExcelManager;
	
	@Override
	protected void beforeChild() {
		dtoUpdateEstado.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_PROCESADO);	
		
		when(mockApiProxy.proxy(ExcelManagerApi.class)).thenReturn(mockExcelManager);
		when(mockApiProxy.proxy(MSVProcesoApi.class)).thenReturn(mockMSVProcesoApi);
		
	}

	@Override
	protected void afterChild() {
		
	}
	
	@Test
	public void testOnErrorConErrores() {
		manager.onStartProcess(token);
				
		manager.onError(token, input, "error1");
		manager.onError(token, input2, "error2");
		
		manager.onEndProcess(token);
		try {
			verificarInteracciones().verifyOnEndProcessErrores(mockExcelManager, mockMSVProcesoApi, token);
			
			//Nos aseguramos que se ha eliminado el mapa de errores para este proceso
			assertNull(manager.getMapaErrores().get(token));
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		reset(mockMSVProcesoApi);
		
	}
	
	@Test
	public void testOnErrorSinErrores() {
		
		manager.onStartProcess(token);			
		manager.onEndProcess(token);
		
		try {
			verificarInteracciones().verifyOnEndProcessSinErrores(mockExcelManager, mockMSVProcesoApi, token);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	
	
	
}
