package es.capgemini.pfs.batch;

import java.util.Date;

import org.springframework.jmx.export.annotation.ManagedOperation;
import org.springframework.jmx.export.annotation.ManagedResource;
import org.springframework.stereotype.Component;

import es.capgemini.devon.utils.ApplicationContextUtil;
import es.capgemini.pfs.batch.revisar.ProcesoRevisionJobLauncher;

/**
 * @author lgiavedo
 * 
 */
@Component
@ManagedResource("devon:type=Batch")
public class BatchConsolePlugin {

	@ManagedOperation(description = "Ejecuta el proceso de Revision. Se debe indicar el workingCode")
	public void ejecutarProcesoRevision(String workingCode) {
		ProcesoRevisionJobLauncher revisionJobLauncher = (ProcesoRevisionJobLauncher) ApplicationContextUtil
				.getApplicationContext().getBean("procesoRevisionHandler");
		revisionJobLauncher.handle(workingCode, new Date());
	}

}
