package es.pfsgroup.recovery.bpmframework.test.matchers;

import java.util.Map;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDatoInput;

/**
 * Matcher par comprobar que el dato de input que se le pasa a un mock es el
 * correcto
 * 
 * @author bruno
 * 
 */
public class RecoveryBPMfwkDatoInputArgumentMatcher extends AbstractMatcher<RecoveryBPMfwkDatoInput> {
    
    private Map<String, Object> dataExpected;


    public RecoveryBPMfwkDatoInputArgumentMatcher(Map<String, Object> datosInput) {
        this.dataExpected = datosInput;
    }

    @Override
    public boolean matches(Object item) {
        if (!(item instanceof RecoveryBPMfwkDatoInput)) {
            return false;
        } else {
            RecoveryBPMfwkDatoInput current = (RecoveryBPMfwkDatoInput) item;
            boolean igual = true;
            Object val = dataExpected.get(current.getNombre());
            if (!Checks.esNulo(val)){
                igual = compareValues(val.toString(), current.getValor()) || compareValues(val.toString(), current.getValorLargo());
            }else{
                igual = false;
            }
            return igual;
        }
    }

}
