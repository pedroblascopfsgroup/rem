package es.pfsgroup.recovery.bpmframework.test.matchers;

import java.util.Collection;
import java.util.Map;

import org.hamcrest.BaseMatcher;
import org.hamcrest.Description;

import es.pfsgroup.commons.utils.Checks;

/**
 * Case genérica para los Matchers de Mockito que con métodos útiles para comparar objetos
 * @author bruno
 *
 * @param <T> Clase de los objetos a matchear
 */
public abstract class  AbstractMatcher<T> extends BaseMatcher<T>{

    /**
     * compara que dos colecciones tengan el mismo tamaño
     * @param expected
     * @param current
     * @return
     */
    @SuppressWarnings("rawtypes")
    protected boolean compareCollectionSize(Map expected, Collection current) {
        if (!Checks.estaVacio(expected)){
            if (Checks.estaVacio(current)){
                return false;
            }else{
                return expected.size() == current.size();
            }
        }else{
            return Checks.estaVacio(current);
        }
    }

    /**
     * Compara dos objetos y devuelve true si son iguales (false si no lo son)
     * @param expected
     * @param current
     * @return
     */
    protected boolean compareValues(Object expected, Object current) {
        if (!Checks.esNulo(expected)){
            return expected.equals(current);
        }else{
            return Checks.esNulo(current);
        }
    }

    @Override
    public void describeTo(Description description) {
        // se deja vacío intencionadamente
    }

}
