package es.pfsgroup.procedimientos.adjudicacion;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.api.AdjudicacionHandlerDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public class CesionRemateHayaLeaveActionHandler extends PROGenericLeaveActionHandler {

	/**
	 * Serial ID
	 */
	private static final long serialVersionUID = 1L;

	@Autowired
	private Executor executor;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private AdjudicacionHayaProcedimientoManager hayaProcManager;
	
	private SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	
	@Override
	protected void process(Object delegateTransitionClass,
			Object delegateSpecificClass, ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass,
				executionContext);
		

		Boolean tareaTemporal = (executionContext.getTransition().getName().equals(BPMContants.TRANSICION_PARALIZAR_TAREAS)
				|| executionContext.getTransition().getName().equals(BPMContants.TRANSICION_ACTIVAR_TAREAS)
				|| executionContext.getTransition().getName().equals(BPMContants.TRANSICION_PRORROGA));
		if (!tareaTemporal) {
			personalizamosTramiteCesionRemate(executionContext);
		}
	}
	
	private void personalizamosTramiteCesionRemate(
			ExecutionContext executionContext) {

		Procedimiento prc = getProcedimiento(executionContext);
		TareaExterna tex = getTareaExterna(executionContext);
		List<EXTTareaExternaValor> listado = ((SubastaProcedimientoApi) proxyFactory
				.proxy(SubastaProcedimientoApi.class))
				.obtenerValoresTareaByTexId(tex.getId());
		
		if ("H006_ConfirmarContabilidad".equals(executionContext
				.getNode().getName())) {
			for (TareaExternaValor tev : listado) {
				try {
					if ("fecha".equals(tev.getNombre())) {
						Date fecha = formatter.parse(tev.getValor());
						executor.execute(
								AdjudicacionHandlerDelegateApi.BO_ADJUDICACION_HANDLER_INSERT_ADJUDICACION_FECHA_CONTABILIDAD,
								prc.getId(), fecha);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}

}
