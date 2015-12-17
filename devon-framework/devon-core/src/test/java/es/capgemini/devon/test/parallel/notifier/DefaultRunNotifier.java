package es.capgemini.devon.test.parallel.notifier;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.runner.Description;
import org.junit.runner.notification.Failure;
import org.junit.runner.notification.RunNotifier;

/**
 * Clase encargada de manejar los errores que puedan producirce en la ejecución de JUnit en paralelo.
 * 
 * @author lgiavedo
 *
 */
public class DefaultRunNotifier extends RunNotifier {

    private final List<Throwable> errors = new ArrayList<Throwable>();

    @Override
    public void fireTestFailure(Failure failure) {
        super.fireTestFailure(failure);
        log.error(failure, failure.getException());
        errors.add(failure.getException());
    }

    @Override
    public void testAborted(Description description, Throwable cause) {
        super.testAborted(description, cause);
        log.error(description, cause);
        errors.add(cause);
    }

    public List<Throwable> getErrors() {
        return errors;
    }

    public boolean hasError() {
        if (errors.size() > 0) return true;
        return false;
    }

    public static DefaultRunNotifier getNewInstance() {
        return new DefaultRunNotifier();
    }

    private static Log log = LogFactory.getLog(DefaultRunNotifier.class);

}
