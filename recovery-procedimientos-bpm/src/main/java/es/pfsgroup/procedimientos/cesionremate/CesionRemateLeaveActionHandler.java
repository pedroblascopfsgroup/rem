package es.pfsgroup.procedimientos.cesionremate;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.api.AdjudicacionHandlerDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public class CesionRemateLeaveActionHandler extends PROGenericLeaveActionHandler {
	/**
	 * 
	 */
	private static final long serialVersionUID = -5583230911255732281L;

	private SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

	@Autowired
	GenericABMDao genericDao;
	
	@Autowired
    private TareaExternaManager tareaExternaManager;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private Executor executor;

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);
		
		Boolean tareaTemporal = (executionContext.getTransition().getName().equals(BPMContants.TRANSICION_PARALIZAR_TAREAS)
				|| executionContext.getTransition().getName().equals(BPMContants.TRANSICION_ACTIVAR_TAREAS)
				|| executionContext.getTransition().getName().equals(BPMContants.TRANSICION_PRORROGA));  //"activarProrroga"
		
		//Solo si el handle ha sido invocado por el guardado de la tarea, dentro del flujo BPM, realiza las acciones determinadas
		//Si ha sido invocado por una acci�n de paralizar la tarea o por una acci�n autoprorroga, no realiza las acciones determinadas
		if (!tareaTemporal) {
			personalizamosTramiteCesionRemate(executionContext);
		}
	}

	private void personalizamosTramiteCesionRemate(ExecutionContext executionContext) {
		
		Procedimiento prc = getProcedimiento(executionContext);
		TareaExterna tex = getTareaExterna(executionContext);
		List<TareaExternaValor> vValores = tareaExternaManager.obtenerValoresTarea(tex.getId());

		
		if ("P410_ResenyarFechaComparecencia".equals(executionContext.getNode().getName())){
			
			@SuppressWarnings("unchecked")
			List<Bien> listaProcedimientosBienes = (List<Bien>) executor
					.execute(
							ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO,
							prc.getId());
//			List<ProcedimientoBien> listaProcedimientosBienes= prc.getBienes();
			for(Bien bien: listaProcedimientosBienes){
//				Bien bien= pb.getBien();
				if (bien instanceof NMBBien) {
					NMBBien nmbien= (NMBBien)bien;
					
					if(!Checks.esNulo(vValores)){
						for(TareaExternaValor tev: vValores){
							try{
								if ("comboCesionRemate".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())){
									if(tev.getValor().equals("01")){
										if(!Checks.esNulo(nmbien) && !Checks.esNulo(nmbien.getAdjudicacion())){
											nmbien.getAdjudicacion().setCesionRemate(false);
										}
									}
								}
							}
							catch (Exception e) {
								e.printStackTrace();
							}
						}
					}
				}
			}
			
			
			
		}
		
		
	}

}
