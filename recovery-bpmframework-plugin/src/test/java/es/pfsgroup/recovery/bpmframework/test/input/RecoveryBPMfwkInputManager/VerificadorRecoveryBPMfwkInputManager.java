package es.pfsgroup.recovery.bpmframework.test.input.RecoveryBPMfwkInputManager;

import static org.mockito.Mockito.*;

import java.util.Map;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDatoInput;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.test.matchers.RecoveryBPMfwkDatoInputArgumentMatcher;
import es.pfsgroup.recovery.bpmframework.test.matchers.RecoveryBPMfwkInputInputArgumentMatcher;

/**
 * Verificador de interacciones del manager
 * 
 * @author bruno
 * 
 */
public class VerificadorRecoveryBPMfwkInputManager {

    private GenericABMDao mockGenericDao;

    /**
     * Hay que pasarle mocks de todos los colaboradores del manager
     * 
     * @param mockGenericDao
     */
    public VerificadorRecoveryBPMfwkInputManager(GenericABMDao mockGenericDao) {
        super();
        this.mockGenericDao = mockGenericDao;
    }

    /**
     * Verifica que se haya guardado el Input
     * 
     * @param dtoInput
     */
    public void seHaGuardadoElInput(RecoveryBPMfwkInputDto dtoInput) {
        verify(mockGenericDao).save(eq(RecoveryBPMfwkInput.class), argThat(new RecoveryBPMfwkInputInputArgumentMatcher(dtoInput)));
    }

    /**
     * Verifica que se hayan guardado los datos, los datos del input se tienen que guardar mediante DAO a parte uno por uno
     * @param datosInput
     */
    public void seHanGuardadoLosDatos(Map<String, Object> datosInput) {
       if (!Checks.estaVacio(datosInput)){
           verify(mockGenericDao, times(datosInput.size())).save(eq(RecoveryBPMfwkDatoInput.class), argThat(new RecoveryBPMfwkDatoInputArgumentMatcher(datosInput)));
//           for (Entry<String, Object> e : datosInput.entrySet()){
//               
//           }
       }
    }

}
