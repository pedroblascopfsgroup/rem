package es.pfsgroup.procedimientos.adjudicacion;

import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.api.AdjudicacionProcedimientoDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDEntidadAdjudicataria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public class AdjudicacionBccLeaveActionHandler extends AdjudicacionHayaLeaveActionHandler {

	/**
	 * Serial ID
	 */
	private static final long serialVersionUID = 1L;

	@Autowired
	@Qualifier("adjudicacionProcedimientoManagerDelegated")
	AdjudicacionProcedimientoDelegateApi adjProcedimientoManager;

	@Autowired
	private Executor executor;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private AdjudicacionHayaProcedimientoManager hayaProcManager;

	private List<EXTTareaExternaValor> camposTarea(TareaExterna tex) {
		return ((SubastaProcedimientoApi) proxyFactory
				.proxy(SubastaProcedimientoApi.class))
				.obtenerValoresTareaByTexId(tex.getId());
	}
	
	
	@Override
	protected void setDecisionVariable(ExecutionContext executionContext) {
		Procedimiento prc = getProcedimiento(executionContext);
		TareaExterna tex = getTareaExterna(executionContext);
		if (executionContext
				.getNode()
				.getName()
				.equals("H005_notificacionDecretoAdjudicacionAEntidad")) {
			
			List<EXTTareaExternaValor> campos = camposTarea(tex);
			// Pone diferentes valores de decisión:

			// opción A - IVA/IGIC
			String tributacion = adjProcedimientoManager.comprobarBienSujetoIVA(prc.getId());
        	boolean opA = (tributacion != null && (tributacion.startsWith("IGIC") || tributacion.startsWith("IVA")));
			
        	// opción E - Requiere doc Adicional
        	String docAdicional = dameValorTarea(campos, "comboAdicional");
        	boolean opE = (!Checks.esNulo(docAdicional) && docAdicional.equals(DDSiNo.SI));
        	
        	// Opción C, D
        	boolean adjudicadoEntidad = true;
        	
        	// Si procede del trámite de cesión de remate no se lanzan la tareas de la rama Adjudicado por la entidad
        	Procedimiento prcPadre = prc.getProcedimientoPadre();
        	if(prcPadre != null && prcPadre.getTipoProcedimiento().getCodigo().equals("H006")) {
        		adjudicadoEntidad = false;
        	}
        	else {
        		NMBBien bien = getBien(prc);
	        	adjudicadoEntidad = (bien.getAdjudicacion() != null 
	        			&& bien.getAdjudicacion().getEntidadAdjudicataria() != null 
	        			&& bien.getAdjudicacion().getEntidadAdjudicataria().getCodigo().equals(DDEntidadAdjudicataria.ENTIDAD));
        	}
        	
        	boolean cargasPrevias = false;
        	if (adjudicadoEntidad) {
        		cargasPrevias = hayaProcManager.existenCargasPreviasActivas(prc.getId());
        	}
        			
			this.setVariable("op_ivaigic", (opA ? "SI" : "NO"), executionContext);
			this.setVariable("op_adjudicadoAEntidad", (adjudicadoEntidad ? "SI" : "NO"), executionContext);
			this.setVariable("op_cargasPrevias", (cargasPrevias ? "SI" : "NO"), executionContext);
			this.setVariable("op_requieComAdicional", (opE ? "SI" : "NO"), executionContext);

		} else if (executionContext
				.getNode()
				.getName()
				.equals("H005_ConfirmarTestimonio")) {

			List<EXTTareaExternaValor> campos = camposTarea(tex);

			// opción B - Requiere doc Adicional
        	String comAdicional = dameValorTarea(campos, "comboAdicional");
        	boolean opB = (!Checks.esNulo(comAdicional) && comAdicional.equals(DDSiNo.SI));

			// opción C - Ocupantes
        	String ocupantes = dameValorTarea(campos, "comboOcupantes");
        	boolean opC = (!Checks.esNulo(ocupantes) && ocupantes.equals(DDSiNo.SI));
        	
			this.setVariable("op2_requieComAdicional", (opB ? "SI" : "NO"), executionContext);
			this.setVariable("op2_conOcupantes", (opC ? "SI" : "NO"), executionContext);
		}
		
		super.setDecisionVariable(executionContext);
	}

	private NMBBien getBien(Procedimiento prc) {
		NMBBien nmbBien = null;
		if (!Checks.estaVacio(prc.getBienes())) {
			ProcedimientoBien prcBien = prc.getBienes().get(0);
			nmbBien = (NMBBien) executor.execute(
					PrimariaBusinessOperation.BO_BIEN_MGR_GET, prcBien.getBien().getId());
		}
		return nmbBien;
	}
	
	private String dameValorTarea(List<EXTTareaExternaValor> campos, String nombreCampo) {
		String valor = null;
		for (TareaExternaValor tev : campos) {
			if (tev.getNombre().equals(nombreCampo)) {
				valor = tev.getValor();
				break;
			}
		}
		return valor;
		
	}
}