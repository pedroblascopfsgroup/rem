package es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputGenDocExecutor;

import static org.mockito.Matchers.any;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

import java.util.HashMap;

import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputGenDocExecutor;
import es.pfsgroup.recovery.geninformes.api.GENINFInformesApi;
import es.pfsgroup.recovery.geninformes.dto.GENINFGenerarEscritoDto;

/**
 * Verificador de interacciones para
 * {@link RecoveryBPMfwkInputGenDocExecutor}
 * 
 * @author manuel
 * 
 */
public class VerificadorRecoveryBPMfwkInputGenDocExecutor {

    private GENINFInformesApi mockGENINFInformesManager;

    /**
     * Hay que pasarle mocks de todos los colaboradores
     * 
     * @param mockGENINFInformesManager
     */
    public VerificadorRecoveryBPMfwkInputGenDocExecutor(GENINFInformesApi mockGENINFInformesManager) {
        super();
        this.mockGENINFInformesManager = mockGENINFInformesManager;
    }

    /**
     * Verifica que se ejecute el método que genera el escrito.
     * @param tipoEntidad
     * @param tipoEscrito
     * @param idEntidad
     * @param adjuntar
     */
    @SuppressWarnings("unchecked")
	public void seLanzaLaGeneracionDeDocumentos(String tipoEntidad, String tipoEscrito, Long idEntidad, boolean adjuntar){
//    	GENINFGenerarEscritoDto generarEscritoDto = new GENINFGenerarEscritoDto(eq(tipoEntidad), eq(tipoEscrito), eq(idEntidad), eq(adjuntar), eq(adjuntar), any(Procedimiento.class), GENINFGestorInformes.SUFIJO_INFORME_RTF);
    	
    	verify(mockGENINFInformesManager, times(1)).generarEscritoEditable(any(GENINFGenerarEscritoDto.class), any(HashMap.class));
    	
    }

}
