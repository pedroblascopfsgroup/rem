package es.pfsgroup.recovery.bpmframework.test.input.RecoveryBPMfwkInputManager;

import static org.mockito.Mockito.*;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDDTipoInput;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.test.matchers.RecoveryBPMfwkInputInputArgumentMatcher;

/**
 * Simulador de interacciones para el Manager de Inputs
 * 
 * @author bruno
 * 
 */
public class SimuladorRecoveryBPMfwkInputManager {

    private GenericABMDao mockGenericDao;

    /**
     * Deben pasarse mocks de todos los colaboradores del Manager
     * 
     * @param mockGenericDao
     */
    public SimuladorRecoveryBPMfwkInputManager(GenericABMDao mockGenericDao) {
        super();
        this.mockGenericDao = mockGenericDao;
    }

    /**
     * Simula que se obtiene el tipo de input con el código especificado
     * 
     * @param codigoTipoInput
     */
    public void seObtieneTipoDeInput(String codigoTipoInput) {
        Filter mockFiltro = mock(Filter.class);
        RecoveryBPMfwkDDTipoInput mockTipoInput = mock(RecoveryBPMfwkDDTipoInput.class);
        when(mockTipoInput.getCodigo()).thenReturn(codigoTipoInput);

        when(mockGenericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipoInput)).thenReturn(mockFiltro);
        when(mockGenericDao.get(RecoveryBPMfwkDDTipoInput.class, mockFiltro)).thenReturn(mockTipoInput);

    }

    /**
     * Simula que se obtiene el input persisitdo después de guardarlo la primera
     * vez
     * 
     * @param dtoInput
     * @param idNuevoInput
     */
    public void seObtieneUnInputDespuesDeGuardar(RecoveryBPMfwkInputDto dtoInput, Long idNuevoInput) {
        RecoveryBPMfwkDDTipoInput mockTipoInput = mock(RecoveryBPMfwkDDTipoInput.class);
        when(mockTipoInput.getCodigo()).thenReturn(dtoInput.getCodigoTipoInput());

        RecoveryBPMfwkInput mockInputPersistido = mock(RecoveryBPMfwkInput.class);
        when(mockInputPersistido.getId()).thenReturn(idNuevoInput);
        when(mockInputPersistido.getAdjunto()).thenReturn(dtoInput.getAdjunto());
        
        when(mockInputPersistido.getTipo()).thenReturn(mockTipoInput);
        when(mockInputPersistido.getIdProcedimiento()).thenReturn(dtoInput.getIdProcedimiento());
        when(mockGenericDao.save(eq(RecoveryBPMfwkInput.class), argThat(new RecoveryBPMfwkInputInputArgumentMatcher(dtoInput)))).thenReturn(mockInputPersistido);

    }
}
