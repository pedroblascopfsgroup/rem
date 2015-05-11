package es.pfsgroup.recovery.bpmframework.test.datosprc.RecoveryBPMfwkDatosProcedimientoManager;

import static org.mockito.Mockito.*;

import org.mockito.ArgumentCaptor;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.recovery.bpmframework.datosprc.RecoveryBPMfwkDatosProcedimientoManager;
import es.pfsgroup.recovery.bpmframework.datosprc.model.RecoveryBPMfwkDatosProcedimiento;;

/**
 * verificador de la clase {@link RecoveryBPMfwkDatosProcedimientoManager}
 * @author manuel
 *
 */
public class VerificadorRecoveryBPMfwkDatosProcedimientoManager {

	private GenericABMDao mockGenericDao;
	
	/**
	 * Constructor. Deben pasarse mocks de todos los colaboradores del Manager
	 * @param mockGenericDao
	 */
	public VerificadorRecoveryBPMfwkDatosProcedimientoManager(GenericABMDao mockGenericDao) {
		this.mockGenericDao = mockGenericDao;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void seHanGuardadoLosDatos(int times){
		
		ArgumentCaptor<RecoveryBPMfwkDatosProcedimiento> argDatosProc = ArgumentCaptor.forClass(RecoveryBPMfwkDatosProcedimiento.class);
		ArgumentCaptor<Class> argClase = ArgumentCaptor.forClass(Class.class);
		
		verify(mockGenericDao,times(times)).save(argClase.capture(), argDatosProc.capture());
		
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void noSeHanGuardadoLosDatos() {
		
		ArgumentCaptor<RecoveryBPMfwkDatosProcedimiento> argDatosProc = ArgumentCaptor.forClass(RecoveryBPMfwkDatosProcedimiento.class);
		ArgumentCaptor<Class> argClase = ArgumentCaptor.forClass(Class.class);
		
		verify(mockGenericDao,times(0)).save(argClase.capture(), argDatosProc.capture());
		
	}

}
