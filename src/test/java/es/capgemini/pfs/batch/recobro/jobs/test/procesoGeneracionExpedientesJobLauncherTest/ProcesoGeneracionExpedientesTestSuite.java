package es.capgemini.pfs.batch.recobro.jobs.test.procesoGeneracionExpedientesJobLauncherTest;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

/**
 * Suite de testing con todos los casos posibles en la generación de expedientes
 * 
 * @author bruno
 * 
 */
@RunWith(Suite.class)
@SuiteClasses({
		ProcesoGeneracionExpedientesJobLauncherContratoUnicoTest.class,
		ProcesoGeneracionExpedientesJobLauncherGrupoCPaseTest.class,
		ProcesoGeneracionExpedientesJobLauncherGrupoyPrimeraGeneracionTest.class,
		ProcesoGeneracionExpedientesJobLauncherGrupoySegundaGeneracionTest.class
		})
public class ProcesoGeneracionExpedientesTestSuite {

}
