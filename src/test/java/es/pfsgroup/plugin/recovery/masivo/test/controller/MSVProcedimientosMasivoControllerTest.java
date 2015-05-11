/**
 * 
 */
package es.pfsgroup.plugin.recovery.masivo.test.controller;

import static org.junit.Assert.*;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.ui.ModelMap;

import static org.mockito.Matchers.any;
import static org.mockito.Mockito.when;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.controller.MSVProcedimientosMasivoController;
import es.pfsgroup.plugin.recovery.masivo.controller.MSVProcesadoResolucionesController;
import es.pfsgroup.plugin.recovery.masivo.test.SampleBaseTestCase;
import es.pfsgroup.recovery.api.ProcedimientoApi;

/**
 * @author Diana
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class MSVProcedimientosMasivoControllerTest  extends SampleBaseTestCase{
	
	@InjectMocks MSVProcedimientosMasivoController msvProcdimientosMasivoController;
	
	@Mock ApiProxyFactory mockProxyFactory;
	@Mock ProcedimientoApi mockProcedimientoApi;

	/**
	 * Test method for {@link es.pfsgroup.plugin.recovery.masivo.controller.MSVProcedimientosMasivoController#listaDemandadosProcedimientoData(java.lang.Long, org.springframework.ui.ModelMap)}.
	 */
	@Test
	public void testListaDemandadosProcedimientoData() {
		Long idProcedimiento=1L;
		ModelMap map=new ModelMap();
		Procedimiento procedimiento=new Procedimiento();
		
		when(mockProxyFactory.proxy(ProcedimientoApi.class)).thenReturn(mockProcedimientoApi);
		when(mockProcedimientoApi.getProcedimiento(idProcedimiento)).thenReturn(procedimiento);
		
		String ruta=msvProcdimientosMasivoController.listaDemandadosProcedimientoData(idProcedimiento, map);
		
		assertNotNull(ruta);
    	assertEquals(ruta, MSVProcedimientosMasivoController.JSON_LISTA_DEUDORES);
    	
	}

}
