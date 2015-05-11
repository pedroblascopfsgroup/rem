package es.capgemini.pfs.batch.test;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

import es.capgemini.pfs.batch.recobro.facturacion.test.BatchRecobroFacturacionConsolePluginTest;
import es.capgemini.pfs.batch.recobro.simulacion.test.BatchRecobroSimulacionConsolePluginTest;
import es.capgemini.pfs.batch.recobro.test.BatchRecobroConsolePluginTest;

/**
 * Suit de tests para todos los procesos del Batch
 * @author Guillem
 *
 */
@RunWith(Suite.class)
@SuiteClasses({BatchRecobroConsolePluginTest.class, 
			   BatchRecobroFacturacionConsolePluginTest.class,
			   BatchRecobroSimulacionConsolePluginTest.class})
public class BatchTests {

	
}
