package es.pfsgroup.recovery.haya.procedimientos;


import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.BusinessOperationDefinitionNotFoundException;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bpm.ProcessManager;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;


@Component("PROFaseLiquidacionLeaveActionHandler")
public class PROFaseLiquidacionLeaveActionHandler extends PROGenericLeaveActionHandler {
 
	private static final long serialVersionUID = 8973221089858907441L;
	
	@Autowired
	private ProcessManager processManager;
	
	@Autowired
	private Executor executor;
	
	private ExecutionContext executionContext;


	/**
	 * Procesa tras la salida del estado JBPM
	 */
	@Override
	protected String getDecision(ExecutionContext executionContext) {
		super.finalizarTarea(executionContext);
		this.executionContext = executionContext;
		return getDecisionSalida();
	}

	/**
	 * Establece la variable de salida de decisión de 1 tarea
	 * antes de avanzar o escribir en el contexto la info (se ocupa clase padre)
	 * para el procedimiento al que se añade faseLiquidacionLeaveActionHandler
	 * como Handler de salida
	 */
	@SuppressWarnings({ "unused" })
	private String getDecisionSalida() {
		
		String salida = "";
		String valorComboCierre = "";
		Calendar fComprobacion = Calendar.getInstance();
		Calendar fHoy = Calendar.getInstance();
		SimpleDateFormat fFormat = new SimpleDateFormat("yyyy-MM-dd");

		//Acciones a realizar solo si el Handler de salida se ejecuta desde la tarea "H033_regInformeTrimestral2"
		//Se evalúan los distintos casos que deben aportar el resultado para la Decisión siguiente, estableciendo
		//la variable de contexto de salida en esta tarea:
		//3 casos:
		//  - Si el Ítem comboCierre = 'SI' --> Al nodo Decisión Supervisor
		//  - Si el Ítem comboCierre = 'NO' y no ha pasado 1 año desde F.Resolución Aprobación (H033_regResolucionAprovacion.fecha < 1 año) --> Vuelve a lanzar misma tarea
		//  - Si el Ítem comboCierre = 'NO' y si ha pasado 1 año desde F.Resolución Aprobación (H033_regResolucionAprovacion.fecha >= 1año) --> Continúa BPM
		try{

			if (getNombreNodo(executionContext).toString().equals("H033_regInformeTrimestral2")){

				valorComboCierre = getValorTareaExterna("H033_regInformeTrimestral2","comboCierre");
				fComprobacion.setTime(fFormat.parse(getValorTareaExterna("H033_regResolucionAprovacion","fecha")));
				fComprobacion.add(Calendar.YEAR, +1);
				//Fecha comprobación = F.Resol Aprobación + 1 año
		
				if (valorComboCierre.equals(DDSiNo.SI)){
					salida = "SI";
				} else{
					if (fHoy.after(fComprobacion)){
						salida = "No365";
					}else{
						salida = "NO";
					}
				}
				
			}
		}catch(Exception e){
			logger.error("Error en clase PROFaseLiquidacionLeaveActionHandler",e);
			return null;
		}
			

		return salida;
		
	}
	
	private String getValorTareaExterna(String nombreTarea, String nombreItem){

		List<EXTTareaExternaValor> listado = (List<EXTTareaExternaValor>)executor.execute(ComunBusinessOperation.BO_TAREA_EXTERNA_MGR_OBTENER_VALORES_TAREA, getIdTareaExterna(nombreTarea));
		
		for (TareaExternaValor tev : listado) {
			try {
				if (nombreItem.equals(tev.getNombre())) {
					return tev.getValor().toString();
				}
			} catch (Exception e) {
				logger.error("Error al recuperar valor con getValorTareaExterna, clase PROFaseLiquidacionLeaveActionHandler.", e);
			}
		}
		return null;
		
	}
	
	private Long getIdTareaExterna(String nombreTarea){
		
		Long idTarea =  (Long)getVariable("id"+nombreTarea+"."+executionContext.getToken().getId(), executionContext);
		// buscamos en el padre si es null
		if (idTarea == null){
			idTarea =  (Long)getVariable("id"+nombreTarea+"."+executionContext.getToken().getParent().getId(), executionContext);
		}
		// si en el padre no la encontramos entonces petamos
		if (idTarea == null) {
			throw new BusinessOperationException("No he podido encontrar el id para la tarea " + nombreTarea);
		}
		return idTarea;
	}
	
}
