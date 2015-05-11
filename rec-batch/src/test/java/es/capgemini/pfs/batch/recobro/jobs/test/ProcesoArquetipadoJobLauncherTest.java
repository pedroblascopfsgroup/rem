package es.capgemini.pfs.batch.recobro.jobs.test;

import java.util.Date;
import java.util.HashMap;
import java.util.Random;

import org.apache.commons.logging.LogFactory;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import es.capgemini.pfs.batch.load.BatchLoadConstants;
import es.capgemini.pfs.batch.recobro.api.test.ConfigLoadData;
import es.capgemini.pfs.batch.recobro.api.test.ConfigPostData;
import es.capgemini.pfs.batch.recobro.api.test.ConfigValidationData;
import es.capgemini.pfs.batch.recobro.api.test.GenericConstantsTest.Genericas;
import es.capgemini.pfs.batch.recobro.api.test.GenericConstantsTest.ProcesoArquetipado;
import es.capgemini.pfs.batch.recobro.api.test.GenericTest;

/**
 * Test Case para el subproceso de Arquetipado del proceso de Recobro
 * @author Guillem
 *
 */
@ContextConfiguration(locations = Genericas.FICHERO_CONTEXTO_SPRING)
@RunWith(SpringJUnit4ClassRunner.class)
public class ProcesoArquetipadoJobLauncherTest extends GenericTest{

	/**
	 * M�todo de test del proceso
	 */
	@Test
	public void test() {	
		try{
	        HashMap<String, Object> parameters = new HashMap<String, Object>();
	        parameters.put(Genericas.RANDOM, new Random(System.currentTimeMillis()).toString());
	        parameters.put(BatchLoadConstants.EXTRACTTIME, new Date(System.currentTimeMillis()));
	        parameters.put(BatchLoadConstants.ENTIDAD, Genericas.ENTIDAD_9999);
	        testLaunchDevonJob(getJob(ProcesoArquetipado.PROCESO_ARQUETIPADO_JOBNAME), parameters);
		}catch(Throwable e){
			logger.error(e);
			fail();
		}
	}	
	
	/**
	 * M�todo para cargar el logger del test
	 */
	@Override
	protected void loadLogger() {
		try{
			logger = LogFactory.getLog(getClass());
		}catch(Throwable e){
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
		try{
			configLoadDataTest = new ConfigLoadData();
			configLoadDataTest.setSqlFile("loadTestData/recobro/procesoArquetipado.xml");
		}catch(Throwable e){
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
		try{
			configValidationDataTest = new ConfigValidationData();
			configValidationDataTest.setSqlFile("validationTestData/recobro/procesoArquetipado.xml");
		}catch(Throwable e){
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
		try{
			configPostDataTest = new ConfigPostData();
			configPostDataTest.setSqlFile("postTestData/recobro/procesoArquetipado.xml");
		}catch(Throwable e){
			logger.error(e);
			fail();
		}
		return configPostDataTest;
	}
}
