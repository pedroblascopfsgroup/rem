package es.capgemini.pfs.batch.recobro.simulacion.test;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

import es.capgemini.pfs.batch.recobro.simulacion.jobs.test.ProcesoControlSimulacionJobLauncherTest;
import es.capgemini.pfs.batch.recobro.simulacion.jobs.test.ProcesoGeneracionYPersistenciaInformeSimulacionJobLauncherTest;
import es.capgemini.pfs.batch.recobro.simulacion.jobs.test.ProcesoPrepacionSimulacionJobLauncherTest;

@RunWith(Suite.class)
@SuiteClasses({ProcesoControlSimulacionJobLauncherTest.class,
			   ProcesoPrepacionSimulacionJobLauncherTest.class,
			   ProcesoGeneracionYPersistenciaInformeSimulacionJobLauncherTest.class})
public class BatchRecobroSimulacionConsolePluginTest {

}
