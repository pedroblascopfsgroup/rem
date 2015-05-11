package es.pfsgroup.recovery.bpmframework.test.config.RecoveryBPMfwkConfigManager;

import static org.mockito.Mockito.*;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;

/**
 * Verificador de interacciones del manager
 * 
 * @author manuel
 * 
 */
public class VerificadorRecoveryBPMfwkConfigManager {

    private GenericABMDao mockGenericDao;

    /**
     * Hay que pasarle mocks de todos los colaboradores del manager
     * 
     * @param mockGenericDao
     */
    public VerificadorRecoveryBPMfwkConfigManager(GenericABMDao mockGenericDao) {
        super();
        this.mockGenericDao = mockGenericDao;
    }
    
    /**
     * Verifica que se ha recuperado el input config
     * 
     * @param dtoInput
     */
    @SuppressWarnings("unchecked")
	public void seHaRecuperadoElInputConfig() {
        verify(mockGenericDao).getList(any(Class.class), any(Filter.class), any(Filter.class));
    }    
}
