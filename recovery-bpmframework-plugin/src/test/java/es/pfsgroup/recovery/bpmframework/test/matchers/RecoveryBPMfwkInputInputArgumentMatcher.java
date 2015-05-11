package es.pfsgroup.recovery.bpmframework.test.matchers;

import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

public class RecoveryBPMfwkInputInputArgumentMatcher extends AbstractMatcher<RecoveryBPMfwkInput> {

    private RecoveryBPMfwkInputDto expected;

    public RecoveryBPMfwkInputInputArgumentMatcher(RecoveryBPMfwkInputDto input) {
        this.expected = input;
    }

    @Override
    public boolean matches(Object item) {
        if (! (item instanceof RecoveryBPMfwkInput)) {
            return false;
        } else {
            RecoveryBPMfwkInput current = (RecoveryBPMfwkInput) item;
            boolean igual = true;
            igual = compareValues(expected.getIdProcedimiento(), current.getIdProcedimiento());
            igual = compareValues(expected.getCodigoTipoInput(), current.getTipo().getCodigo());
            igual = compareValues(expected.getAdjunto(), current.getAdjunto());
            return igual;
        }
    }

}
