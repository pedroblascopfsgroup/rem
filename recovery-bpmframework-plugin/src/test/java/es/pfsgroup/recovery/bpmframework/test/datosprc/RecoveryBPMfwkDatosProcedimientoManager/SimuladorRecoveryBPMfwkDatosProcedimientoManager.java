package es.pfsgroup.recovery.bpmframework.test.datosprc.RecoveryBPMfwkDatosProcedimientoManager;

import static org.mockito.Mockito.*;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.datosprc.RecoveryBPMfwkDatosProcedimientoManager;
import es.pfsgroup.recovery.bpmframework.datosprc.model.RecoveryBPMfwkDatosProcedimiento;

/**
 * Simulador del mánager {@link RecoveryBPMfwkDatosProcedimientoManager}
 * @author manuel
 *
 */
public class SimuladorRecoveryBPMfwkDatosProcedimientoManager {
	
    final private ProcedimientoApi mockProcedimientosManager;
    
    final private GenericABMDao mockGenericDao;

	/**
	 *  Constructor. Deben pasarse mocks de todos los colaboradores del Manager
	 * @param mockGenericDao
	 */
	public SimuladorRecoveryBPMfwkDatosProcedimientoManager(GenericABMDao mockGenericDao, ProcedimientoApi mockProcedimientosManager) {
		super();
		this.mockGenericDao = mockGenericDao;
		this.mockProcedimientosManager = mockProcedimientosManager;
	}

	public void getProcedimiento(Long idProcedimiento) {
		Procedimiento mockProcedimiento = mock(Procedimiento.class);
		
		when(mockProcedimiento.getId()).thenReturn(idProcedimiento);
		when(mockProcedimientosManager.getProcedimiento(idProcedimiento)).thenReturn(mockProcedimiento);
		
	}

	@SuppressWarnings({ "unchecked" })
	public void guardaDatos() {

		RecoveryBPMfwkDatosProcedimiento mockDatosProc = mock(RecoveryBPMfwkDatosProcedimiento.class);
		
		when(mockGenericDao.save(any(Class.class), any(RecoveryBPMfwkDatosProcedimiento.class))).thenReturn(mockDatosProc);
		
	}

	public void getProcedimientoNull(Long idProcedimiento) {
		when(mockProcedimientosManager.getProcedimiento(idProcedimiento)).thenReturn(null);
	}

}
