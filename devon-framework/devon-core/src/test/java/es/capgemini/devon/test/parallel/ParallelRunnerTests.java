package es.capgemini.devon.test.parallel;

import java.util.List;

import org.junit.internal.runners.InitializationError;
import org.junit.runner.Runner;
import org.junit.runner.notification.RunNotifier;
import org.junit.runners.Suite;

import es.capgemini.devon.test.parallel.notifier.DefaultRunNotifier;

/**
 * Clase encargada de ejecutar una serie de JUnits de forma paralela
 * 
 * @author lgiavedo
 *
 */
public class ParallelRunnerTests extends Suite {

    public ParallelRunnerTests(Class<?> klass) throws InitializationError {
        super(klass);
    }

    public ParallelRunnerTests(Class<?> klass, Class<?>[] annotatedClasses) throws InitializationError {
        super(klass, annotatedClasses);
    }

    public RunNotifier runTests(final RunNotifier runNotifier) {
        final List<Runner> runners = getRunners();
        return runRunnersInParallel(runNotifier, runners);
    }

    public RunNotifier runRunnersInParallel(final List<Runner> runners) {
        return runRunnersInParallel(new DefaultRunNotifier(), runners);
    }

    public RunNotifier runRunnersInParallel(final RunNotifier runNotifier, final List<Runner> runners) {
        Thread[] threads = new Thread[runners.size()];
        for (int i = 0; i < threads.length; i++) {
            final int index = i;
            threads[i] = new Thread(new Runnable() {
                public void run() {
                    runners.get(index).run(runNotifier);
                }
            });
            threads[i].start();
        }
        for (int i = 0; i < threads.length; i++) {
            try {
                threads[i].join();
            } catch (InterruptedException e) {
                throw new RuntimeException("Couldn't join thread nicely", e);
            }
        }
        return runNotifier;
    }

    public static RunNotifier runRunnersInParallel(Class<?> klass, Class<?>[] annotatedClasses, final RunNotifier runNotifier) {
        ParallelRunnerTests prt = null;
        try {
            prt = new ParallelRunnerTests(klass, annotatedClasses);
        } catch (InitializationError e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        return prt.runTests(runNotifier);
    }
}
