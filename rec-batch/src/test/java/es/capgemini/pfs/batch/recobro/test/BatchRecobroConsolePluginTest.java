package es.capgemini.pfs.batch.recobro.test;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

import es.capgemini.pfs.batch.recobro.jobs.test.ProcesoArquetipadoJobLauncherTest;
import es.capgemini.pfs.batch.recobro.jobs.test.ProcesoHistorizacionJobLauncherTest;
import es.capgemini.pfs.batch.recobro.jobs.test.ProcesoLimpiezaExpedientesJobLauncherTest;
import es.capgemini.pfs.batch.recobro.jobs.test.ProcesoMarcadoExpedientesJobLauncherTest;
import es.capgemini.pfs.batch.recobro.jobs.test.ProcesoPersistenciaPreviaEnvioJobLauncherTest;
import es.capgemini.pfs.batch.recobro.jobs.test.ProcesoPreparacionRecobroJobLauncherTest;
import es.capgemini.pfs.batch.recobro.jobs.test.ProcesoRearquetipacionExpedientesJobLauncherTest;
import es.capgemini.pfs.batch.recobro.jobs.test.ProcesoRepartoJobLauncherTest;
import es.capgemini.pfs.batch.recobro.jobs.test.ProcesoRevisionExpedientesActivosJobLauncherTest;
import es.capgemini.pfs.batch.recobro.jobs.test.ProcesoValidacionRecobroJobLauncherTest;
import es.capgemini.pfs.batch.recobro.jobs.test.procesoGeneracionExpedientesJobLauncherTest.ProcesoGeneracionExpedientesTestSuite;

/**
 * Suit de test para los subprocesos del proceso de Recobro
 * 
 * @author Guillem
 * 
 */
@RunWith(Suite.class)
@SuiteClasses({ 		
		ProcesoPreparacionRecobroJobLauncherTest.class,
		ProcesoValidacionRecobroJobLauncherTest.class,
		ProcesoMarcadoExpedientesJobLauncherTest.class,
		ProcesoLimpiezaExpedientesJobLauncherTest.class,
		ProcesoRevisionExpedientesActivosJobLauncherTest.class,
		ProcesoRearquetipacionExpedientesJobLauncherTest.class,
		ProcesoArquetipadoJobLauncherTest.class,
		ProcesoGeneracionExpedientesTestSuite.class,
		ProcesoRepartoJobLauncherTest.class,
		ProcesoPersistenciaPreviaEnvioJobLauncherTest.class,
		ProcesoHistorizacionJobLauncherTest.class,
		})

public class BatchRecobroConsolePluginTest {

}
