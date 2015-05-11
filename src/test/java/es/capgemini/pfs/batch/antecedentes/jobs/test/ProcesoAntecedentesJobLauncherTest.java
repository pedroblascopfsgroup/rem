package es.capgemini.pfs.batch.antecedentes.jobs.test;

import java.util.Date;
import java.util.HashMap;
import java.util.Random;

import org.apache.commons.logging.LogFactory;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import es.capgemini.pfs.batch.antecedentes.constantes.test.AntecedentesConstantesTest.Genericas;
import es.capgemini.pfs.batch.antecedentes.constantes.test.AntecedentesConstantesTest.ProcesoAntecedentes;
import es.capgemini.pfs.batch.load.BatchLoadConstants;
import es.capgemini.pfs.batch.recobro.api.test.ConfigLoadData;
import es.capgemini.pfs.batch.recobro.api.test.ConfigPostData;
import es.capgemini.pfs.batch.recobro.api.test.ConfigValidationData;
import es.capgemini.pfs.batch.recobro.api.test.GenericTest;


/**
 * Test Case para el proceso de cálculo de Antecedentes
 * @author Guillem
 *
 */
@ContextConfiguration(locations= Genericas.FICHERO_CONTEXTO_SPRING)
@RunWith(SpringJUnit4ClassRunner.class)
public class ProcesoAntecedentesJobLauncherTest extends GenericTest {
	/**
	 * Método de test del proceso
	 */
	@Test
	public void test() {
		try {
			HashMap<String, Object> parameters = new HashMap<String, Object>();
			parameters.put(Genericas.RANDOM, new Random(System.currentTimeMillis()).toString());
			parameters.put(BatchLoadConstants.EXTRACTTIME, new Date(System.currentTimeMillis()));
			parameters.put(BatchLoadConstants.ENTIDAD, Genericas.ENTIDAD_9999);
			testLaunchDevonJob(getJob(ProcesoAntecedentes.PROCESO_ANTECEDENTES_JOBNAME), parameters);
		} catch(Throwable e) {
			logger.error(e);
			fail();
		}
	}

	/**
	 * Mi métodod para cargar el logger del test
	 */
	@Override
	protected void loadLogger() {
		try {
			logger = LogFactory.getLog(getClass());
		}catch(Throwable e) {
			System.out.println(e);
			fail();
		}
	}

	/**
	 * Método para pasar la configuración de carga de datos para el test
	 */
	@Override
	protected ConfigLoadData loadConfigLoadDataTest() {
		ConfigLoadData configLoadDataTest = null;
		try {
			configLoadDataTest = new ConfigLoadData();
			configLoadDataTest.setSqlFile("loadTestData/antecedentes/procesoAntecedentes.xml");
		} catch(Throwable e) {
			logger.error(e);
			fail();
		}
		return configLoadDataTest;
	}

	/**
	 * Método para pasar la configuración de validación de datos para el test
	 */
	@Override
	protected ConfigValidationData loadConfigValidationDataTest() {
		ConfigValidationData configValidationDataTest = null;
		try {
			configValidationDataTest = new ConfigValidationData();
			configValidationDataTest.setSqlFile("validationTestData/antecedentes/procesoAntecedentes.xml");
		} catch(Throwable e) {
			logger.error(e);
			fail();
		}
		return configValidationDataTest;
	}

	/**
	 * Método para pasar la configuración de limpieza de datos para el test
	 */
	@Override
	protected ConfigPostData loadConfigPostDataTest() {
		ConfigPostData configPostDataTest = null;
		try {
			configPostDataTest = new ConfigPostData();
			configPostDataTest.setSqlFile("postTestData/antecedentes/procesoAntecedentes.xml");
		} catch(Throwable e){
			logger.error(e);
			fail();
		}
		return configPostDataTest;
	}

}
