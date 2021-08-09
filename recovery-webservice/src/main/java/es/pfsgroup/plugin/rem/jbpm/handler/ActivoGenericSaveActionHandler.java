package es.pfsgroup.plugin.rem.jbpm.handler;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterServiceFactoryApi;
import es.pfsgroup.plugin.rem.model.ActivoTramite;

public class ActivoGenericSaveActionHandler extends ActivoGenericLeaveActionHandler {
	
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	private ExecutionContext executionContext;

	private static final long serialVersionUID = -5256087821622834764L;
	
    @Autowired
    private ActivoTareaExternaApi activoTareaExternaManagerApi;
    
    @Autowired
    private UpdaterServiceFactoryApi updaterServiceFactory;

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) {
		
		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);
		this.executionContext = executionContext;

		guardadoAdicionalTarea();
	}

	/**
	 * Guarda los datos adicionales de las tareas
	 */
	protected void guardadoAdicionalTarea() {
		TareaExterna tareaExterna = getTareaExterna(executionContext);
		ActivoTramite tramite = getActivoTramite(executionContext);
		TareaProcedimiento tareaProcedimiento = tareaExterna.getTareaProcedimiento();

		List<TareaExternaValor> valores = activoTareaExternaManagerApi.obtenerValoresTarea(tareaExterna.getId());
				
		UpdaterService dataUpdater = updaterServiceFactory.getService(tareaProcedimiento.getCodigo());
		
		dataUpdater.saveValues(tramite, tareaExterna, valores);
			
		logger.debug("\tGuardamos los datos de la tarea: " + getNombreNodo(executionContext));
	}
	
	private void writeObject(java.io.ObjectOutputStream out) throws IOException {
		//empty
	}

	private void readObject(java.io.ObjectInputStream in) throws IOException, ClassNotFoundException {
		//empty
	}

}
