package es.pfsgroup.plugin.rem.thread;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.plugin.rem.bulkAdvisoryNote.BulkAdvisoryNoteAdapter;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

public class AvanzaTareaOfertasBulkAN implements Runnable {

	@Autowired
	private RestApi restApi;
	
	@Autowired
	private BulkAdvisoryNoteAdapter bulkAdvisoryNoteAdapter;
	
	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;
	
	public static final String COD_TAP_TAREA_AUTORIZACION_PROPIEDAD = "T017_ResolucionPROManzana";
	public static final String COD_TAP_TAREA_ADVISORY_NOTE = "T017_AdvisoryNote";
	public static final String COD_TAP_TAREA_RECOM_ADVISORY= "T017_RecomendCES";
	
	private final Log logger = LogFactory.getLog(getClass());
	private String userName = null;
	private List<Long> listIdsOfertasDelBulk = new ArrayList<Long>();
	private Long idOfertaActual= null;
	private Map<String,String[]> valoresTarea = null;
	private String tapCodigoActual = "";
		
	public AvanzaTareaOfertasBulkAN(String userName, List<Long> listIdsOfertasDelBulk, Long idOfertaActual, Map<String,String[]> valoresTarea,String tapCodigoActual ) {
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.userName = userName;
		this.listIdsOfertasDelBulk = listIdsOfertasDelBulk;
		this.idOfertaActual = idOfertaActual;
		this.valoresTarea = valoresTarea;
		this.tapCodigoActual= tapCodigoActual;
	}

	@Override
	public void run() {

		try {
			restApi.doSessionConfig(this.userName);
			bulkAdvisoryNoteAdapter.avanzaTareasDelBulk(userName,listIdsOfertasDelBulk,idOfertaActual,valoresTarea,tapCodigoActual);
		}catch (Exception e) {
			logger.error("[ERROR] Error en AvanzaTareaOfertasBulkAN al intentar avanzar la tarea de la oferta", e);
		}
	}

}
