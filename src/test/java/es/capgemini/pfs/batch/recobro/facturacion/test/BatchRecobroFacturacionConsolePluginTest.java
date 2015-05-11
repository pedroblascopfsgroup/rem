package es.capgemini.pfs.batch.recobro.facturacion.test;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

import es.capgemini.pfs.batch.recobro.facturacion.jobs.ProcesoPreProcesadoCobrosJobLauncher;
import es.capgemini.pfs.batch.recobro.facturacion.jobs.test.ProcesoFacturacionJobLauncherTest;
import es.capgemini.pfs.batch.recobro.facturacion.jobs.test.ProcesoHistorizacionFacturacionJobLauncherTest;

@RunWith(Suite.class)
@SuiteClasses({ProcesoFacturacionJobLauncherTest.class,
			   ProcesoPreProcesadoCobrosJobLauncher.class,
			   ProcesoHistorizacionFacturacionJobLauncherTest.class
})
public class BatchRecobroFacturacionConsolePluginTest {

}
