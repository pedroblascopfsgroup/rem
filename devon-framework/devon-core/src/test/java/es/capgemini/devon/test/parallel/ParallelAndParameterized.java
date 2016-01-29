package es.capgemini.devon.test.parallel;

import java.util.List;

import org.junit.runner.Runner;
import org.junit.runner.notification.RunNotifier;
import org.junit.runners.Parameterized;

public class ParallelAndParameterized extends Parameterized {

    public ParallelAndParameterized(Class<?> klass) throws Exception {
        super(klass);
    }

    @Override
    protected void runChildren(final RunNotifier runNotifier) {
        final List<Runner> runners = getRunners();
        //ParallelRunnerTests.runRunnersInParallel(runNotifier, runners);
    }
}
