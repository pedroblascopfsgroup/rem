package es.pfsgroup.recovery.bpmframework.test.config.RecoveryBPMfwkConfigManager;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkTipoProcInput;



/**
 * Simulador de interacciones para el Manager de Inputs
 * 
 * @author manuel
 * 
 */
public class SimuladorRecoveryBPMfwkConfigManager {

    private GenericABMDao mockGenericDao;

    /**
     * Deben pasarse mocks de todos los colaboradores del Manager
     * 
     * @param mockGenericDao
     */
    public SimuladorRecoveryBPMfwkConfigManager(GenericABMDao mockGenericDao) {
        super();
        this.mockGenericDao = mockGenericDao;
    }
    
    /**
     * Simula que se obtiene el objeto de configuración en función de
     * 
     * @param codigoTipoInput
     * @param tipoProcInput 
     */
    public void getTipoProcInput(String codigoTipoInput, String codigoTipoProcedimiento, RecoveryBPMfwkTipoProcInput tipoProcInput) {

    	Filter mockFiltro = mock(Filter.class);
    	
    	List<RecoveryBPMfwkTipoProcInput> lista = new ArrayList<RecoveryBPMfwkTipoProcInput>();
    	lista.add(tipoProcInput);
    	
        when(mockGenericDao.createFilter(FilterType.EQUALS, "tipoInput.codigo", codigoTipoInput)).thenReturn(mockFiltro);
        when(mockGenericDao.createFilter(FilterType.EQUALS, "tipoProcedimiento.codigo", codigoTipoProcedimiento)).thenReturn(mockFiltro);
        when(mockGenericDao.getList(RecoveryBPMfwkTipoProcInput.class, mockFiltro, mockFiltro)).thenReturn(lista);

    }   
}