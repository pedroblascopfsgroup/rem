package es.pfsgroup.plugin.recovery.masivo.test.callbacks.bpmBO.api.MSVProcedimientoBackOfficeBOCallback;

import static org.junit.Assert.assertEquals;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.atLeastOnce;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.ExcelManagerApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoApi;
import es.pfsgroup.plugin.recovery.masivo.callbacks.bpmBO.api.impl.MSVProcedimientoBackOfficeBOCallback;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoAltaProceso;

/**
 * Verificación de las interacciones del manager con otros objetos
 * <p>
 * Contiene un método por cada verificación que se quiera hacer en los tests.
 * </p>
 * @author carlos
 *
 */
public class VerificadorInteraccionesMSVProcedimientoBackOfficeBOCallback {

	/**
	 * verifica que se ha creado correctamente el map concurrente de lista de grupo de errores
	 */
	public void isCorrectSize(MSVProcedimientoBackOfficeBOCallback manager, int size) {
		assertEquals("El tamaño no coincide", manager.getLengthMapaErrores(),size);		
	}
	
	/**
	 * Verifica que se ha pasado por la modificacion del proceso masivo
	 * @throws Exception 
	 */
	public void verifyModificarProcesoMasivo(ApiProxyFactory mockApiProxy, MSVProcesoApi mockMSVProcesoApi, MSVDtoAltaProceso dtoUpdateEstado, Integer invocaciones) throws Exception {
		// Verifico que por lo menos pasa una vez
		verify(mockApiProxy,atLeastOnce()).proxy(MSVProcesoApi.class);
		verify(mockMSVProcesoApi, times(invocaciones)).modificarProcesoMasivo(any(MSVDtoAltaProceso.class));
	}

	/**
	 * Verifica que inserta los errores en el map
	 * @param manager
	 */
	public void verifyInsertError(MSVProcedimientoBackOfficeBOCallback manager, Long idProcess, Integer invocaciones) {
		int cuentaInserts = 0;
		for (int i = 0; i< (Integer) manager.getMapaErrores().get(idProcess).size(); i++) {
			if (!Checks.esNulo((manager.getMapaErrores().get(idProcess).get(i)))) {
				cuentaInserts++;
			}
		}
		assertEquals(invocaciones, (Integer) cuentaInserts);		
	}

	public void verifyOnEndProcessErrores(ExcelManagerApi mockExcelManager, MSVProcesoApi mockMSVProcesoApi, Long idProcess) throws Exception {
		
		verify(mockExcelManager, times(1)).updateErrores(any(Long.class), any(FileItem.class));
		
		verify(mockMSVProcesoApi, times(2)).modificarProcesoMasivo(any(MSVDtoAltaProceso.class));
	}

	public void verifyOnEndProcessSinErrores(ExcelManagerApi mockExcelManager, MSVProcesoApi mockMSVProcesoApi, Long idProcess) throws Exception {
		verify(mockExcelManager, never()).updateErrores(any(Long.class), any(FileItem.class));
		
		verify(mockMSVProcesoApi, times(2)).modificarProcesoMasivo(any(MSVDtoAltaProceso.class));
		
	}


	
	
}
