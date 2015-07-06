package es.pfsgroup.procedimientos.asignacion;

import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoSubasta;
import es.pfsgroup.procedimientos.PROBaseActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public class AsignacionHayaEnterActionHandler extends PROBaseActionHandler{

	/**
	 * 
	 */
	private static final long serialVersionUID = 2156270993650719342L;
	private static final String COMBO_PROCEDIMIENTO = "comboProcedimiento";
	private static final String NODO_SALIENTE = "NOMBRE_NODO_SALIENTE";
	private static final String MASK_ULTIMA_TAREA = "id%s.%d";
	
	@Autowired
	private Executor executor;
	
	@Autowired
	TipoProcedimientoManager tipoProcedimientoManager;
	
	@Override
	public void run(ExecutionContext executionContext) throws Exception{
		Procedimiento prc = getProcedimiento(executionContext);			
		String nombreNodo = (String) this.getVariable("NOMBRE_NODO_SALIENTE", executionContext);
		Long idTex = (Long) (Long)executionContext.getVariable(String.format(MASK_ULTIMA_TAREA,nombreNodo, executionContext.getToken().getId()));
		//TareaExterna tex = proxyFactory.proxy(TareaExternaApi.class).get(idTex);
		
		@SuppressWarnings("unchecked")
		List<EXTTareaExternaValor> listado = (List<EXTTareaExternaValor>)executor.execute(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_OBTENER_VALORES_TAREA, idTex);
    	
    	TareaExternaValor valor = new TareaExternaValor();
		for (TareaExternaValor tev : listado) {
			try {
				if (COMBO_PROCEDIMIENTO.equals(tev.getNombre())) {
					valor = tev;
					break;
				}
			} catch (Exception e) {
				logger.error("Error al recuperar valor comboResultado", e);
			}
		}
		TipoProcedimiento tipoProcedimientoHijo = tipoProcedimientoManager.getByCodigo(valor.getValor());
		this.creaProcedimientoHijo(executionContext, tipoProcedimientoHijo, prc, null, null);
	}
	
	

}
