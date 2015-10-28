package es.pfsgroup.procedimientos.subasta;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.recovery.coreextension.model.DDResultadoComiteConcursal;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDDecisionSuspension;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDEstadoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDResultadoComite;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.DDTipoSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDDocAdjudicacion;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDEntidadAdjudicataria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;

//public class SubastaV4HayaConcursalLeaveActionHandler extends SubastaV4LeaveActionHandler {
public class SubastaV4HayaConcursalLeaveActionHandler extends PROGenericLeaveActionHandler {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6476140372822561349L;

	private SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

	@Autowired
	GenericABMDao genericDao;

	@Autowired
	private Executor executor;

	@Autowired
	private JBPMProcessManager jbpmUtil;

    @Autowired
    private IntegracionBpmService bpmIntegracionService;
	
	private ExecutionContext executionContext;

	private final String SALIDA_ETIQUETA = "DecisionRama_%d";
	private final String SALIDA_SI = "si";
	private final String SALIDA_NO = "no";

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);
		this.executionContext = executionContext;

		String transition = executionContext.getTransition().getName();
		Boolean transicionTemporal = (
				transition.equals(BPMContants.TRANSICION_PRORROGA) || 
				transition.equals(BPMContants.TRANSICION_FIN) || 
				transition.equals(BPMContants.TRANSICION_APLAZAR_TAREAS) || 
				transition.equals(BPMContants.TRANSICION_PARALIZAR_TAREAS) || 
				transition.equals(BPMContants.TRANSICION_ACTIVAR_TAREAS));
		if (transicionTemporal) {
			return;
		}
		
		avanzamosEstadoSubasta();
	}

	private void avanzamosEstadoSubasta() {
		
		Procedimiento prc = getProcedimiento(executionContext);
		Subasta sub = proxyFactory.proxy(SubastaProcedimientoApi.class).obtenerSubastaByPrcId(prc.getId());		
		
		if (executionContext.getNode().getName().contains("SenyalamientoSubasta")) {
			//
			if (!Checks.esNulo(sub)) {

				cambiaEstadoSubasta(sub, DDEstadoSubasta.PIN);
				duplicaInfoSubasta(executionContext, sub);
			}
		} else if (executionContext.getNode().getName().contains("AdjuntarInformeSubasta")) {

			if (!Checks.esNulo(sub) && !Checks.esNulo(sub.getEstadoSubasta()) && DDEstadoSubasta.PIN.compareTo(sub.getEstadoSubasta().getCodigo()) == 0) {

				cambiaEstadoSubasta(sub, DDEstadoSubasta.PPR);
			}
		} else if (executionContext.getNode().getName().contains("PrepararPropuestaSubasta")) {

			if (!Checks.esNulo(sub)) {

				cambiaEstadoSubasta(sub, DDEstadoSubasta.PCO);
			}
		} else if (executionContext.getNode().getName().contains("ValidarPropuesta")) {

			if (!Checks.esNulo(sub)) {

				cambiaEstadoSubasta(sub, obtenerEstadoSiguiente(executionContext, "ValidarPropuesta", "comboResultado"));
				TareaExterna tex = getTareaExterna(executionContext);
				List<TareaExternaValor> listadoValores = tex.getValores();
				for(TareaExternaValor val : listadoValores){
					if("comboDelegada".equals(val.getNombre())){
						actualizarTipoSubasta(sub, val.getValor());
					}
				}
			}
		} else if (executionContext.getNode().getName().contains("LecturaAceptacionInstrucciones")) {

			if (!Checks.esNulo(sub)) {

				cambiaEstadoSubasta(sub, DDEstadoSubasta.PCE);
			}
		} else if (executionContext.getNode().getName()
				.contains("ElevarPropuestaAComite")) {
			if (!Checks.esNulo(sub)) {
				TareaExterna tex = getTareaExterna(executionContext);
				List<TareaExternaValor> listadoValores = tex.getValores();
				for(TareaExternaValor val : listadoValores){
					if("comboResultadoComite".equals(val.getNombre())){
						actualizarRevisionSubasta(sub, val.getValor());
					}
				}
			}
		} else if (executionContext.getNode().getName()
				.contains("RegistrarRespuestaSareb")) {
			if (!Checks.esNulo(sub)) {
				TareaExterna tex = getTareaExterna(executionContext);
				List<TareaExternaValor> listadoValores = tex.getValores();
				for(TareaExternaValor val : listadoValores){
					if("comboResultadoResolucion".equals(val.getNombre())){
						actualizarRevisionSubasta(sub, val.getValor());
					}
				}
			}
		} else if (executionContext.getNode().getName().contains("CelebracionSubasta")) {

			if (!Checks.esNulo(sub)) {

				cambiaEstadoSubasta(sub, obtenerEstadoSiguiente(executionContext, "CelebracionSubasta", "comboCelebracion"));
				estableceContexto();
			}
		} else if (executionContext.getNode().getName().contains("SuspenderSubasta")) {

			if (!Checks.esNulo(sub)) {

				cambiaEstadoSubasta(sub, DDEstadoSubasta.SUS);
			}

			// Finalizamos el procedimiento padre
			try {
				jbpmUtil.finalizarProcedimiento(prc.getId());
				prc.setEstadoProcedimiento(genericDao.get(DDEstadoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO)));
				genericDao.save(Procedimiento.class, prc);

			} catch (Exception e) {
				e.printStackTrace();
			}

			// FINALIZAMOS TODAS LAS TAREAS DEL PROCEDIMIENTO
			for (TareaNotificacion t : prc.getTareas()) {
				if (!t.getAuditoria().isBorrado()) {
					if (t.getTareaFinalizada() == null || (t.getTareaFinalizada() != null && !t.getTareaFinalizada())) {
						t.setTareaFinalizada(true);
						genericDao.update(TareaNotificacion.class, t);
						HibernateUtils.merge(t);
					}
				}
			}
		}

		genericDao.save(Subasta.class, sub);
		bpmIntegracionService.enviarDatos(sub);
	}
	
	private void cambiaEstadoSubasta(Subasta sub, String estado) {
		if (!Checks.esNulo(sub.getEstadoSubasta().getCodigo()) && 
				(DDEstadoSubasta.CEL.compareTo(sub.getEstadoSubasta().getCodigo()) != 0 && 
				DDEstadoSubasta.SUS.compareTo(sub.getEstadoSubasta().getCodigo()) != 0)) {
			DDEstadoSubasta esu = genericDao.get(DDEstadoSubasta.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estado), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
			sub.setEstadoSubasta(esu);
		}
	}	
	
	private String obtenerEstadoSiguiente(ExecutionContext executionContext, String tarea, String campo) {

		TareaExterna tex = getTareaExterna(executionContext);
		List<EXTTareaExternaValor> listado = ((SubastaProcedimientoApi) proxyFactory.proxy(SubastaProcedimientoApi.class)).obtenerValoresTareaByTexId(tex.getId());
		if (!Checks.esNulo(listado)) {
			if (tarea.contains("CelebracionSubasta")) {
				for (TareaExternaValor tev : listado) {
					if (DDSiNo.SI.equals(tev.getValor())) {
						return DDEstadoSubasta.CEL;
					} else if (DDSiNo.NO.equals(tev.getValor())) {
						return DDEstadoSubasta.SUS;
					}
				}
			}
			if (tarea.contains("ValidarPropuesta")) {
				for (TareaExternaValor tev : listado) {
					if (DDSiNo.SI.equals(tev.getValor())) {
						return DDEstadoSubasta.SUS;
					} else if (DDSiNo.NO.equals(tev.getValor())) {
						return DDEstadoSubasta.PAC;
					}
				}
				return DDEstadoSubasta.PCO;
			}
		}
		return null;

	}	
	
	private void duplicaInfoSubasta(ExecutionContext executionContext, Subasta sub) {

		TareaExterna tex = getTareaExterna(executionContext);
		List<EXTTareaExternaValor> listado = ((SubastaProcedimientoApi) proxyFactory.proxy(SubastaProcedimientoApi.class)).obtenerValoresTareaByTexId(tex.getId());
		if (!Checks.esNulo(listado)) {
			for (TareaExternaValor tev : listado) {
				try {
					if ("fechaAnuncio".equals(tev.getNombre())) {
						sub.setFechaAnuncio(formatter.parse(tev.getValor()));
					}
					if ("fechaSenyalamiento".equals(tev.getNombre())) {
						sub.setFechaSenyalamiento(formatter.parse(tev.getValor()));
					}
					if("numAuto".equals(tev.getNombre())){
						sub.setNumAutos(tev.getValor());
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}
	}	
	
	private void actualizarRevisionSubasta(Subasta sub, String resultado){
		if(!Checks.esNulo(resultado)){
			if(resultado.equals(DDResultadoComiteConcursal.CONCEDIDO) || resultado.equals(DDResultadoComiteConcursal.CONCEDIDO_CON_MODIFICACIONES)){
				DDResultadoComite resCom = genericDao.get(DDResultadoComite.class, genericDao.createFilter(FilterType.EQUALS,"codigo", DDResultadoComite.ACEPTADA), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
				sub.setResultadoComite(resCom);
			}else if(resultado.equals(DDResultadoComiteConcursal.MODIFICAR)){
				DDResultadoComite resCom = genericDao.get(DDResultadoComite.class, genericDao.createFilter(FilterType.EQUALS,"codigo", DDResultadoComite.RECTIFICAR), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
				sub.setResultadoComite(resCom);
			}else if(resultado.equals(DDResultadoComiteConcursal.DENEGADA)){
				DDResultadoComite resCom = genericDao.get(DDResultadoComite.class, genericDao.createFilter(FilterType.EQUALS,"codigo", DDResultadoComite.SUSPENDER), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
				sub.setResultadoComite(resCom);
			}
		}
	}
	
	private void actualizarTipoSubasta(Subasta sub, String resultado){
		if(!Checks.esNulo(resultado)){
			if(resultado.equals(DDSiNo.SI)){
				DDTipoSubasta tipoSubasta = genericDao.get(DDTipoSubasta.class, genericDao.createFilter(FilterType.EQUALS,"codigo", DDTipoSubasta.DEL), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
				sub.setTipoSubasta(tipoSubasta);
			}else if(resultado.equals(DDSiNo.NO)){
				DDTipoSubasta tipoSubasta = genericDao.get(DDTipoSubasta.class, genericDao.createFilter(FilterType.EQUALS,"codigo", DDTipoSubasta.NDE), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
				sub.setTipoSubasta(tipoSubasta);
			}
		}
	}
	
	private void estableceContexto() {
		Boolean[] valoresRamas = getValoresRamas();	
		/*
			resultado[0] -> A -> SuspendidaTerceros
			resultado[1] -> B -> SuspendidaEntidad
			resultado[2] -> C -> CesionRemateSi
			
			ANTIGUO -> resultado[3] -> D -> AdjudicadoEntidadPosibleRemateNo
			ANTIGUO -> resultado[4] -> E -> AdjudicadoEntidadPosibleRemateSi
			resultado[3] -> D -> AdjudicadoEntidadPosibleRemateNoSinOtorgamiento
			resultado[4] -> E -> AdjudicadoEntidadPosibleRemateSiSinOtorgamiento
			resultado[7] -> H -> AdjudicadoEntidadPosibleRemateNoConOtorgamiento
			resultado[8] -> I -> AdjudicadoEntidadPosibleRemateSiConOtorgamiento						
			
			
			resultado[5] -> F -> AdjudicadoTercero
			resultado[6] -> G -> SolicitarServicioIndices
		*/		
		
		for (int i = 0; i < valoresRamas.length; i++) {
			String variableName = String.format(SALIDA_ETIQUETA, i + 1);
			String valor = (valoresRamas[i]) ? SALIDA_SI : SALIDA_NO;
			executionContext.setVariable(variableName, valor);
		}
	}	
	
	protected Boolean[] getValoresRamas() {
		Procedimiento proc = getProcedimiento(executionContext);
		// Consulta los contratos.
		Boolean[] valores = (Boolean[]) bpmGetValoresRamasCelebracion(proc, getTareaExterna(executionContext));
		return valores;
	}	
	
	public Boolean[] bpmGetValoresRamasCelebracion(Procedimiento prc, TareaExterna tex){	
		
		List<TareaExternaValor> listadoValores = new ArrayList<TareaExternaValor>();
		
		//Inicio todos los valores a false
		Boolean[] resultado = {false, false, false, false, false, false, false, false, false};
		resultado[0] = false;
		resultado[1] = false;
		resultado[2] = false;
		resultado[3] = false;
		resultado[4] = false;
		resultado[5] = false;
		resultado[6] = false;		
		resultado[7] = false;
		resultado[8] = false;		
		
		String comboCelebrada = "";
		boolean celebrada = false;
		
		//String comboSuspendida = "";
		//boolean suspendida = false;
		
		String comboCesionRemate = "";
		boolean cesionRemate = false;
		
		String comboDecisionSuspension = "";
		boolean decisionSuspension = false;
		boolean suspendidaTerceros = false;
		boolean suspendidaEntidad = false;
		
		boolean bienAdjuEntidad = false;
		boolean bienAdjuTerceroFondo = false;		
		
		String comboAdjudicadoEntidad = "";
		boolean adjudicadoEntidadPosibleRemate = false;
		
		String comboPostores = "";
		boolean hayPostores = false;	
		
		String comboOtorgamientoEscritura = "";
		boolean otorgamientoEscritura = false;
		
		// Obtenemos la lista de valores de esa tarea
		listadoValores = tex.getValores();
		for (TareaExternaValor val : listadoValores) {						
			
			if ("comboCelebrada".equals(val.getNombre())){
				comboCelebrada =  val.getValor();
				if (DDSiNo.SI.equals(comboCelebrada)){
					celebrada = true;
				}
			}
			
			if ("comboDecisionSuspension".equals(val.getNombre())){
				comboDecisionSuspension = val.getValor();				
				if(DDDecisionSuspension.TERCEROS.equals(comboDecisionSuspension)){
					suspendidaTerceros = true;
				}			
				//B - suspendida entidad
				if(DDDecisionSuspension.ENTIDAD.equals(comboDecisionSuspension)){
					suspendidaEntidad = true;
				}												
			}
			
			if ("comboPostores".equals(val.getNombre())){
				comboPostores = val.getValor();
				if (DDSiNo.SI.equals(comboPostores)){
					hayPostores = true;
				}
			}	
			
		}	
		
		//Comprobamos los bienes
		List<Bien> listadoBienes = getBienesSubastaByPrcId(prc.getId());
		for(Bien b : listadoBienes){
			if(b instanceof NMBBien){
				NMBBien bien = (NMBBien) b;
				if (!Checks.esNulo(bien.getAdjudicacion())) {
					if(!Checks.esNulo(bien.getAdjudicacion().getEntidadAdjudicataria())){
						if (!Checks.esNulo(bien.getAdjudicacion().getEntidadAdjudicataria().getCodigo())){
							if(bien.getAdjudicacion().getEntidadAdjudicataria().getCodigo().compareTo(DDEntidadAdjudicataria.ENTIDAD) == 0) 
							{	
								if(!Checks.esNulo(bien.getAdjudicacion().getCesionRemate()) && bien.getAdjudicacion().getCesionRemate()){
									cesionRemate = true;
								}else if(!Checks.esNulo(bien.getAdjudicacion().getTipoDocAdjudicacion())){
									if(bien.getAdjudicacion().getTipoDocAdjudicacion().getCodigo().compareTo(DDDocAdjudicacion.ESCRITURA) == 0){
										otorgamientoEscritura = true;
									}else{
										bienAdjuEntidad = true;
									}
								}
							}
							else{
								bienAdjuTerceroFondo = true;
							}
						}
					}
				}
			}
		}		
		
		//1. Si SÍ está celebrada
		if (celebrada){
			
			// Hablado con Jorge por chat: siempre que se celebre se lanzará esta tarea.
			resultado[6] = true;
			
			//1.1 Si hay uno o más bienes adjudicados a un tercero se lanzará la tarea “Solicitar mandamiento de pago”
			if (bienAdjuTerceroFondo){
				resultado[5] = true;
				//No debo ejecutar la tarea porque se ejecutará después en este caso
				resultado[6] = false;
			}
			
			//1.2 Si existe Cesión de Remate se lanzará el "Trámite de Cesión de Remate"
			if (cesionRemate){
				resultado[2] = true;
			}
			
			//Si hay un bien que se lo ha adjudicado la entidad con decreto lanzamos el trámite Adjudicación:
			if (bienAdjuEntidad){	
				resultado[3] = true;
			}
			//Si hay un bien que se lo ha adjudicado la entidad con escritura lanzamos el trámite Escritura:
			if (otorgamientoEscritura){					
				resultado[7] = true;
			}																
			
		}
		//2. Si NO está celebrada:
		else{
			resultado[0] = true;
		}
				
		return resultado;
	}
	
	private List<Bien> getBienesSubastaByPrcId(Long prcId){
		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		
		List<Bien> bienes = new ArrayList<Bien>();
		
		if (!Checks.esNulo(sub)) {

			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = sub.getLotesSubasta();
			
			if (!Checks.estaVacio(listadoLotes)) {
				for(int i=0; i<listadoLotes.size(); i++){		
					bienes.addAll(listadoLotes.get(i).getBienes());
				}
			}
		}
		
		return bienes;
	}	
	
}
