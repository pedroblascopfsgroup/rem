package es.capgemini.pfs.batch.recobro.jobs.test.procesoGeneracionExpedientesJobLauncherTest;

import java.util.Date;
import java.util.HashMap;
import java.util.Random;

import org.apache.commons.logging.LogFactory;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import es.capgemini.pfs.batch.load.BatchLoadConstants;
import es.capgemini.pfs.batch.recobro.api.test.GenericConstantsTest.Genericas;
import es.capgemini.pfs.batch.recobro.api.test.GenericConstantsTest.ProcesoGeneracionExpedientes;
import es.capgemini.pfs.batch.recobro.api.test.ConfigLoadData;
import es.capgemini.pfs.batch.recobro.api.test.ConfigPostData;
import es.capgemini.pfs.batch.recobro.api.test.ConfigValidationData;
import es.capgemini.pfs.batch.recobro.api.test.GenericTest;

/**
 * Test Case para el subproceso de Generaci�n de Expedientes del proceso de
 * Recobro. Este caso prueba la generación de expedientes arrastrando los
 * contratos del grupo.
 * 
 * @author Bruno
 * 
 */
@ContextConfiguration(locations = Genericas.FICHERO_CONTEXTO_SPRING)
@RunWith(SpringJUnit4ClassRunner.class)
@Ignore
public class ProcesoGeneracionExpedientesJobLauncherGrupoCPaseTest extends
		GenericTest {

	/**
	 * M�todo de test del proceso
	 */
	@Test
	public void test() {
		try {
			HashMap<String, Object> parameters = new HashMap<String, Object>();
			parameters.put(Genericas.RANDOM,
					new Random(System.currentTimeMillis()).toString());
			parameters.put(BatchLoadConstants.EXTRACTTIME,
					new Date(System.currentTimeMillis()));
			parameters.put(BatchLoadConstants.ENTIDAD, Genericas.ENTIDAD_9999);
			testLaunchDevonJob(
					getJob(ProcesoGeneracionExpedientes.PROCESO_GENERACION_EXPEDIENTES_JOBNAME),
					parameters);
		} catch (Throwable e) {
			logger.error(e);
			fail();
		}
	}

	/**
	 * M�todo para cargar el logger del test
	 */
	@Override
	protected void loadLogger() {
		try {
			logger = LogFactory.getLog(getClass());
		} catch (Throwable e) {
			System.out.println(e);
			fail();
		}
	}

	/**
	 * M�todo para pasar la configuraci�n de carga de datos para el test
	 */
	@Override
	protected ConfigLoadData loadConfigLoadDataTest() {
		ConfigLoadData configLoadDataTest = null;
		try {
			configLoadDataTest = new ConfigLoadData();
			configLoadDataTest
					.setSqlFile("loadTestData/recobro/procesoGeneracionExpedientes/procesoGeneracionExpedientes_contratoGrupo.xml");
		} catch (Throwable e) {
			logger.error(e);
			fail();
		}
		return configLoadDataTest;
	}

	/**
	 * M�todo para pasar la configuraci�n de validaci�n de datos para el test
	 */
	@Override
	protected ConfigValidationData loadConfigValidationDataTest() {
		ConfigValidationData configValidationDataTest = null;
		try {
			configValidationDataTest = new ConfigValidationData();
			configValidationDataTest
					.setSqlFile("validationTestData/recobro/procesoGeneracionExpedientes/procesoGeneracionExpedientes_contratoGrupo.xml");
		} catch (Throwable e) {
			logger.error(e);
			fail();
		}
		return configValidationDataTest;
	}

	/**
	 * M�todo para pasar la configuraci�n de limpieza de datos para el test
	 */
	@Override
	protected ConfigPostData loadConfigPostDataTest() {
		ConfigPostData configPostDataTest = null;
		try {
			configPostDataTest = new ConfigPostData();
			configPostDataTest
					.setSqlFile("postTestData/recobro/procesoGeneracionExpedientes/procesoGeneracionExpedientes_all.xml");
		} catch (Throwable e) {
			logger.error(e);
			fail();
		}
		return configPostDataTest;
	}

}
