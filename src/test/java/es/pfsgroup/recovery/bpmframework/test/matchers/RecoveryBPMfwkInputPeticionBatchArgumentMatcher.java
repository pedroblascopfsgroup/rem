package es.pfsgroup.recovery.bpmframework.test.matchers;

import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkCallback;
import es.pfsgroup.recovery.bpmframework.batch.model.RecoveryBPMfwkPeticionBatch;

public class RecoveryBPMfwkInputPeticionBatchArgumentMatcher extends AbstractMatcher<RecoveryBPMfwkPeticionBatch> {

    private Long expectedIdProcess;
    private Long expectedIdInput;
    private RecoveryBPMfwkCallback expectedCallback;

    public RecoveryBPMfwkInputPeticionBatchArgumentMatcher(Long idProcess, Long idInput, RecoveryBPMfwkCallback callback) {
        this.expectedIdProcess = idProcess;
        this.expectedIdInput = idInput;
        this.expectedCallback = callback;
    }

    @Override
    public boolean matches(Object item) {
        if (!(item instanceof RecoveryBPMfwkPeticionBatch)) {
            return false;
        } else {
            RecoveryBPMfwkPeticionBatch current = (RecoveryBPMfwkPeticionBatch) item;
            boolean igual = true;
            igual = compareValues(expectedIdProcess, current.getIdToken());
            igual = compareValues(expectedIdInput, current.getInput().getId());
            igual = compareValues(expectedCallback.onProcessStart(), current.getOnStartBo());
            igual = compareValues(expectedCallback.onProcessEnd(), current.getOnEndBo());
            igual = compareValues(expectedCallback.onSuccess(), current.getOnSuccessBo());
            igual = compareValues(expectedCallback.onError(), current.getOnErrorBo());
            return igual;
        }
    }
}
