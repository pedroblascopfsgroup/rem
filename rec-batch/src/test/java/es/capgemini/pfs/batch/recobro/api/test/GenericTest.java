package es.capgemini.pfs.batch.recobro.api.test;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.rules.TestName;
import org.springframework.batch.core.Job;
import org.springframework.beans.factory.annotation.Autowired;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import es.capgemini.pfs.batch.recobro.api.test.GenericConstantsTest.Genericas;
import es.capgemini.pfs.batch.recobro.manager.api.test.GenericTestManager;
import es.capgemini.pfs.batch.recobro.util.test.XMLManager;

/**
 * Clase abstracta de test para proveer de m�todos gen�ricos a los tests cases
 * @author Guillem
 *
 */
public abstract class GenericTest extends AbstractGenericTest{

	/**
	 * M�todo que instancia el logger del test
	 * @param configLoadDataTest
	 */
	protected abstract void loadLogger();
	
	/**
	 * Generic Manager para ejecutar las sqls de carga y/o validaci�n del job
	 */
	@Autowired private GenericTestManager genericTestManager;

	/**
	 * Rule para obtener el nombre del test
	 */
	@Rule public TestName name = new TestName();
	
	/**
	 * Bean de configuraci�n para las acciones que preparan el entorno
	 */
	private ConfigLoadData configLoadDataTest = null;
	
	/**
	 * M�todo que carga el bean de configuraci�n de las acciones que preparan el entorno desde la implementaci�n del test
	 * @param configLoadDataTest
	 */
	protected abstract ConfigLoadData loadConfigLoadDataTest();
	
	/**
	 * Bean de configuraci�n para las acciones que validan el proceso
	 */
	private ConfigValidationData configValidationDataTest = null;
	
	/**
	 * M�todo que carga el bean de configuraci�n de las acciones de validaci�n del proceso desde la implementaci�n del test
	 * @param configValidationDataTest
	 */
	protected abstract ConfigValidationData loadConfigValidationDataTest();
	
	/**
	 * Bean de configuraci�n para las acciones post validaci�n y limpieza del entorno
	 */
	private ConfigPostData configPostDataTest = null;
	
	/**
	 * M�todo que carga el bean de configuraci�n de las acciones post validaci�n y limpieza del entorno desde la implementaci�n del test
	 * @param configLoadDataTest
	 */
	protected abstract ConfigPostData loadConfigPostDataTest();
	
	/**
	 * Variable de control de fallos del test
	 */
	String postOK;
	
	/**
	 * Inicializamos el test del proceso ejecutando las acciones que preparan el entorno
	 */
	@Before
	public void inicializaTest(){
		postOK = "";
		try{
			loadLogger();
			initTestLog(name.getMethodName());
			logger.info(Genericas.INICIO_PREPARACION_ENTORNO);
			this.configLoadDataTest = loadConfigLoadDataTest();
			loadDataTest();
		}catch(Throwable e){postOK = e.getMessage();}
	}
	
	/**
	 * Finalizamos el test del proceso validando los cambios realizados
	 */
	@After
	public void validaTest(){	
		try{
			logger.info(Genericas.INICIO_VALIDACION_ENTORNO);
			this.configValidationDataTest = loadConfigValidationDataTest();
			validationDataTest();
			logger.info(Genericas.EMPTY);
			logger.info(Genericas.INICIO_LIMPIEZA_ENTORNO);
		}catch(Throwable e){postOK = e.getMessage();}
		this.configPostDataTest = loadConfigPostDataTest();
		postDataTest();
		finalizeTestLog(name.getMethodName());
	}
		
	/**
	 * Lanza el test del Job
	 */
    public void testLaunchJob(Job job) throws Throwable {
    	try{
	    	logger.info(Genericas.EMPTY);
	    	logger.info(Genericas.INICIO_TEST);
	        super.testLaunchJob(job);
	        logger.info(Genericas.EMPTY);
    	}catch(Throwable e){
    		logger.error(e.getMessage());
    		postOK = e.getMessage();
    	}
    }
    
	/**
	 * Lanza el test del Job
	 */
    public void testLaunchJob(Job job, HashMap<String, Object> parameters) throws Throwable {
    	try{
    		logger.info(Genericas.EMPTY);
	    	logger.info(Genericas.INICIO_TEST);
	        super.testLaunchJob(job, parameters);
	        logger.info(Genericas.EMPTY);
		}catch(Throwable e){
			logger.error(e.getMessage());
			postOK = e.getMessage();
		}
    }
    
	/**
	 * Lanza el test sobre el job de devon que queramos utilizando el BatchManager
	 */
    public void testLaunchDevonJob(Job job, HashMap<String, Object> parameters) throws Throwable {
    	try{
	    	logger.info(Genericas.EMPTY);
	    	logger.info(Genericas.INICIO_TEST);
	        super.testLaunchDevonJob(job, parameters);
	        logger.info(Genericas.EMPTY);
		}catch(Throwable e){
			logger.error(e.getMessage());
			postOK = e.getMessage();
		}
    }
    
    /**
     * Obtiene un job espec�fico de la lista de jobs a partir de su nombre
     * @param jobName
     * @return
     */
	protected Job getJob(String jobName){
		Job job = null;
		try{
			List<Job> jobs = getJobs();
			Iterator<Job> it = jobs.iterator();
			while(it.hasNext()){
				job = it.next();
				if(job.getName().equals(jobName)){return job;}
			}
		}catch(Throwable e){
			logger.error(Genericas.EXCEPTION_GENERIC_TEST_LOAD_DATA_TEST + e);
			fail();
			return null;
		}
		return null;
	}
    
	/**
	 * Inicializa el entorno del test
	 * @param configLoadDataTest
	 * @return
	 */
	private boolean loadDataTest(){
		XMLManager xmlManager = null;		
		Document xmlDocument = null;
		String msg = null;
		String value = null;
		String type = null;
		String filePath = null;		
		Element parent = null;
		try{
			if(this.configLoadDataTest==null){
				logger.error(Genericas.NO_CONFIG_LOAD_DATA);
				return true;
			}
			logger.info(Genericas.CONFIG_LOAD_DATA_OK);
			filePath = this.configLoadDataTest.getSqlFile();
			if(filePath==null || filePath.equals(Genericas.EMPTY)){
				logger.error(Genericas.NO_LOAD_DATA_SCRIPT_FOUND);
				return true;
			}
			xmlManager = new XMLManager();
			xmlDocument = xmlManager.parseXML(filePath);
			NodeList nl = xmlDocument.getElementsByTagName(Genericas.SQL);
			if(nl!=null){
				for(int i=0;i<nl.getLength();i++){
					parent = (Element) nl.item(i);
					NodeList typeValue = parent.getElementsByTagName(Genericas.TYPE);
					NodeList listaValue = parent.getElementsByTagName(Genericas.VALUE);
					NodeList listaMsg = parent.getElementsByTagName(Genericas.MSG);
					type = typeValue.item(0).getFirstChild().getTextContent();
					value = listaValue.item(0).getFirstChild().getTextContent();
					msg = listaMsg.item(0).getFirstChild().getTextContent();
					genericTestManager.ejecutarSQL(type, value, msg, null);
				}				
			}
		}catch(Throwable e){
			logger.error(Genericas.EXCEPTION_GENERIC_TEST_LOAD_DATA_TEST + e);
			postOK = e.getMessage();
			return false;
		}
		return true;
	}
	
	/**
	 * Inicializa el entorno del test
	 * @param configLoadDataTest
	 * @return
	 */
	private boolean validationDataTest(){
		XMLManager xmlManager = null;		
		Document xmlDocument = null;
		String msg = null;
		String value = null;
		String type = null;
		String expected = null;
		String filePath = null;		
		Element parent = null;
		try{
			if(this.configValidationDataTest==null){
				logger.error(Genericas.NO_CONFIG_VALIDATION_DATA);
				return true;
			}
			logger.info(Genericas.CONFIG_VALIDATION_DATA_OK);
			filePath = this.configValidationDataTest.getSqlFile();
			if(filePath==null || filePath.equals(Genericas.EMPTY)){
				logger.error(Genericas.NO_VALIDATION_DATA_SCRIPT_FOUND);
				return true;
			}
			xmlManager = new XMLManager();
			xmlDocument = xmlManager.parseXML(filePath);
			NodeList nl = xmlDocument.getElementsByTagName(Genericas.SQL);
			if(nl!=null){
				for(int i=0;i<nl.getLength();i++){
					parent = (Element) nl.item(i);
					NodeList typeValue = parent.getElementsByTagName(Genericas.TYPE);
					NodeList listaValue = parent.getElementsByTagName(Genericas.VALUE);
					NodeList listaMsg = parent.getElementsByTagName(Genericas.MSG);
					NodeList listaExpected = parent.getElementsByTagName(Genericas.EXPECTED);
					type = typeValue.item(0).getFirstChild().getTextContent();
					value = listaValue.item(0).getFirstChild().getTextContent();
					msg = listaMsg.item(0).getFirstChild().getTextContent();
					expected = null;
					if((listaExpected.item(0) != null) && (listaExpected.item(0).getFirstChild()!=null)){
						expected = listaExpected.item(0).getFirstChild().getTextContent();
					}					
					genericTestManager.ejecutarSQL(type, value, msg, expected);
				}				
			}
		}catch(Throwable e){
			logger.error(Genericas.EXCEPTION_GENERIC_TEST_VALIDATION_DATA_TEST + e);
			postOK = e.getMessage();
			return false;
		}
		return true;
	}
	
	/**
	 * Inicializa la limpieza del entorno del test
	 * @param configLoadDataTest
	 * @return
	 */
	private boolean postDataTest(){
		XMLManager xmlManager = null;		
		Document xmlDocument = null;
		String msg = null;
		String value = null;
		String type = null;
		String filePath = null;		
		Element parent = null;
		try{
			if(this.configPostDataTest==null){
				fail(Genericas.NO_CONFIG_POST_DATA);
			}
			logger.info(Genericas.CONFIG_POST_DATA_OK);
			filePath = this.configPostDataTest.getSqlFile();
			if(filePath==null || filePath.equals(Genericas.EMPTY)){
				fail(Genericas.NO_POST_DATA_SCRIPT_FOUND);
			}
			xmlManager = new XMLManager();
			xmlDocument = xmlManager.parseXML(filePath);
			NodeList nl = xmlDocument.getElementsByTagName(Genericas.SQL);
			if(nl!=null){
				for(int i=0;i<nl.getLength();i++){
					parent = (Element) nl.item(i);
					NodeList typeValue = parent.getElementsByTagName(Genericas.TYPE);
					NodeList listaValue = parent.getElementsByTagName(Genericas.VALUE);
					NodeList listaMsg = parent.getElementsByTagName(Genericas.MSG);
					type = typeValue.item(0).getFirstChild().getTextContent();
					value = listaValue.item(0).getFirstChild().getTextContent();
					msg = listaMsg.item(0).getFirstChild().getTextContent();
					try{
						genericTestManager.ejecutarSQL(type, value, msg, null);
					}catch(Throwable e){postOK = e.getMessage();}
				}				
			}
			if(postOK!=null && !postOK.equals(Genericas.EMPTY))fail();
		}catch(Throwable e){
			logger.error(Genericas.EXCEPTION_GENERIC_TEST_POST_DATA_TEST + postOK);
			finalizeTestLog(name.getMethodName());
			fail(Genericas.EXCEPTION_GENERIC_TEST_POST_DATA_TEST + postOK);
		}
		return true;
	}
    
	/**
	 * Loggea el inicio de un test
	 * @param testName
	 * @param testMethod
	 * @return
	 */
	protected boolean initTestLog(String testMethod){
		try{
			logger.info(Genericas.ASTERISC_LINE);
			logger.info(Genericas.RECOBRO_TEST);
			logger.info(Genericas.INICIO_TEST + getClass().getSimpleName() + Genericas.DOT);
			logger.info(Genericas.ASTERISC_LINE);
			logger.info(Genericas.EMPTY);
		}catch(Throwable e){
			logger.error(Genericas.EXCEPTION_GENERIC_TEST_INIT_TEST_LOG);
			fail();
			return false;
		}
		return true;
	}
	
	/**
	 * Loggea el fin de un test
	 * @param testName
	 * @param testMethod
	 * @return
	 */
	private boolean finalizeTestLog(String testMethod){
		try{
			logger.info(Genericas.EMPTY);
			logger.info(Genericas.ASTERISC_LINE);
			logger.info(Genericas.RECOBRO_TEST);
			logger.info(Genericas.FIN_TEST + getClass().getSimpleName() + Genericas.DOT);
			logger.info(Genericas.ASTERISC_LINE);
		}catch(Throwable e){
			logger.error(Genericas.EXCEPTION_GENERIC_TEST_FINALIZE_TEST_LOG);
			fail();
			return false;
		}
		return true;
	}
	
}
