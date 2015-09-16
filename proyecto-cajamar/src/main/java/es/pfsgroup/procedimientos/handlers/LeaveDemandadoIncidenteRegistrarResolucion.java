package es.pfsgroup.procedimientos.handlers;

import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public class LeaveDemandadoIncidenteRegistrarResolucion extends
	PROGenericLeaveActionHandler {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6476140372822561349L;

	private final String SALIDA_OPERACION = "decision_operacion";
	private final String SALIDA_GARANTIA = "decision_garantia";
	private final String SALIDA_CREDITOS = "decision_creditos";
	private final String SALIDA_CONDENA = "decision_condena";
	private final String SALIDA_SI = "si";
	private final String SALIDA_NO = "no";
	
	@Override
	protected void process(Object delegateTransitionClass,
			Object delegateSpecificClass, ExecutionContext executionContext) {
	
		super.process(delegateTransitionClass, delegateSpecificClass,
				executionContext);

		boolean condena = false;
		boolean creditos = false;
		boolean operacion = false;
		boolean garantias = false;

		// Obtenemos la lista de valores de esa tarea
		TareaExterna tex = getTareaExterna(executionContext);
		List<EXTTareaExternaValor> listadoValores = ((SubastaProcedimientoApi) proxyFactory
				.proxy(SubastaProcedimientoApi.class))
				.obtenerValoresTareaByTexId(tex.getId());
		
		for (TareaExternaValor val : listadoValores) {

			if ("comboCondena".equals(val.getNombre()) && DDSiNo.SI.equals(val.getValor())) {
				condena = true;
			}
			if ("comboGarantias".equals(val.getNombre()) && DDSiNo.SI.equals(val.getValor())) {
				garantias = true;
			}
			if ("comboOperacion".equals(val.getNombre()) && DDSiNo.SI.equals(val.getValor())) {
				operacion = true;
			}
			if ("comboCreditos".equals(val.getNombre()) && DDSiNo.SI.equals(val.getValor())) {
				creditos = true;
			}

		}

		setVariable(SALIDA_OPERACION, (operacion ? SALIDA_SI : SALIDA_NO), executionContext);
		setVariable(SALIDA_GARANTIA, (garantias ? SALIDA_SI : SALIDA_NO), executionContext);
		setVariable(SALIDA_CREDITOS, (creditos ? SALIDA_SI : SALIDA_NO), executionContext);
		setVariable(SALIDA_CONDENA, (condena ? SALIDA_SI : SALIDA_NO), executionContext);

	}

}
