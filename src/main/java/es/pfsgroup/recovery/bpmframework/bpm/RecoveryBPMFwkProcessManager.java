package es.pfsgroup.recovery.bpmframework.bpm;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.bpm.ProcessManager;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
@Service
public class RecoveryBPMFwkProcessManager implements RecoveryBPMFwkProcessApi{
    
    @Autowired
    private ProcessManager processManager; 

    @Autowired
    private transient GenericABMDao genericDao;
    
    @Override
    @BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_BPM_SIGNAL_PROCESS)
    public void signalProcess(final Long idProcess, final String transitionName, final RecoveryBPMfwkInput input) {
        processManager.execute(new RecoveryBPMFwkInputJbpmCallback(idProcess, transitionName, input));
    }

    @Override
    public List<Long> getInputsForNode(String nodeName) {
        throw new RuntimeException("NO IMPLEMENTADO");
    }

	@Override
	@BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_BPM_GET_INPUTS_FOR_PRC)
	public List<RecoveryBPMfwkInput> getInputsForPrc(Long idProcedimiento) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "idProcedimiento", idProcedimiento);
		List<RecoveryBPMfwkInput> inputs = genericDao.getList(RecoveryBPMfwkInput.class, filtro);
		return inputs;
	}

}
