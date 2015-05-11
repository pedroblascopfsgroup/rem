package es.capgemini.pfs.batch.recobro.api.test;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.AbstractDependencyInjectionSpringContextTests;

import es.capgemini.devon.batch.BatchExitStatus;
import es.capgemini.devon.batch.BatchManager;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.batch.load.BatchLoadConstants;
import es.capgemini.pfs.batch.recobro.api.test.GenericConstantsTest.Genericas;
import es.capgemini.pfs.batch.recobro.constantes.RecobroConstantes.ProcesoMarcadoExpedientes;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;

/**
 * Clase abstracta genérica para proveer de métodos genéricos a los tests cases de Recobro
 * @author Guillem
 *
 */
public abstract class AbstractGenericTest extends AbstractDependencyInjectionSpringContextTests{
	
	protected Log logger = null;
	
	@Autowired
	JobLauncher launcher;
    
    @Autowired
    private BatchManager batchManager;
	
	@Autowired
	private List<Job> jobs;
	
	private JobParameters jobParameters;
    
    @Resource
    private EntidadDao entidadDao;

	/**
	 * Configuramos las dependencias del test genérico
	 */
	public AbstractGenericTest() {
	  setDependencyCheck(false);
	}
	
	/**
	 * Lanza el test sobre el job que queramos
	 * @param job
	 * @throws Exception
	 */
	public void testLaunchJob(Job job) throws Throwable { 
		try{
			if(jobParameters==null){jobParameters = new JobParameters();}
			launcher.run(job, jobParameters);
		}catch(Throwable e){
			fail(e.getMessage());
		}
	}
	
	/**
	 * Lanza el test sobre el job que queramos incluyendo parámetros de configuración para la BBDD
	 * @param job
	 * @throws Exception
	 */
	public void testLaunchJob(Job job, HashMap<String, Object> parameters) throws Throwable {
		try{
			if(parameters.get(BatchLoadConstants.ENTIDAD) != null && !parameters.get(BatchLoadConstants.ENTIDAD).equals(Genericas.EMPTY)){
				Entidad entidad = entidadDao.findByWorkingCode(parameters.get(BatchLoadConstants.ENTIDAD).toString());
				DbIdContextHolder.setDbId(entidad.getId());      
				if(jobParameters==null){jobParameters = new JobParameters();}
				launcher.run(job, jobParameters);
			}else{
				fail(Genericas.WORKING_CODE_NULO_O_VACIO);
			}
		}catch(junit.framework.AssertionFailedError a){
			fail(a.getMessage());
		}catch(Throwable e){
			fail(e.getMessage());
		}
	}
	
	/**
	 * Lanza el test sobre el job de devon que queramos utilizando el BatchManager
	 * @param job
	 * @throws Exception
	 */
	public void testLaunchDevonJob(Job job, HashMap<String, Object> parameters) throws Throwable {
		try{
			if(parameters.get(BatchLoadConstants.ENTIDAD) != null && !parameters.get(BatchLoadConstants.ENTIDAD).equals(Genericas.EMPTY)){
				if(jobParameters==null){jobParameters = new JobParameters();}
		        Entidad entidad = entidadDao.findByWorkingCode(parameters.get(BatchLoadConstants.ENTIDAD).toString());
		        DbIdContextHolder.setDbId(entidad.getId());        
		        BatchExitStatus result = batchManager.run(job.getName(), parameters);
		        if (BatchExitStatus.COMPLETED.equals(result) || BatchExitStatus.NOOP.equals(result)) {
		            logger.info(ProcesoMarcadoExpedientes.FIN_MSG + Genericas.CORCHETE_IZQ + parameters.get(BatchLoadConstants.ENTIDAD).toString() + 
		            		Genericas.CORCHETE_DER + Genericas.FINALIZADO_MSG);
		        }
		        if (BatchExitStatus.FAILED.equals(result)) {
		            fail(ProcesoMarcadoExpedientes.FIN_MSG + Genericas.CORCHETE_IZQ  + parameters.get(BatchLoadConstants.ENTIDAD).toString() + 
		            		Genericas.CORCHETE_DER + Genericas.FALLO_MSG);
		        } 
			}else{
				fail(Genericas.WORKING_CODE_NULO_O_VACIO);
			}
		}catch(junit.framework.AssertionFailedError a){
			fail(a.getMessage());
		}catch(Throwable e){
			fail(e.getMessage());
		}
	}
	
	/**
	 * Obtiene la lista de jobs cargados en el batch
	 * @return List<Job>
	 */
	public List<Job> getJobs() {
		return jobs;
	}

	/**
	 * Configura los parámetros del job, por defecto vacíos
	 * @param jobParameters
	 */
	public void setJobParameters(JobParameters jobParameters) {
		this.jobParameters = jobParameters;
	}
	
}