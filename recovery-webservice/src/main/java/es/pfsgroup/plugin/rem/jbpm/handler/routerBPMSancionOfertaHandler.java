package es.pfsgroup.plugin.rem.jbpm.handler;

import java.util.HashMap;
import java.util.Map;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.ActivoGenericActionHandler.ConstantesBPMPFS;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;

public class routerBPMSancionOfertaHandler extends ActivoBaseActionHandler{
	
	private static final long serialVersionUID = 1L;
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private TareaActivoApi tareaActivoApi;
	
	ExecutionContext executionContext;
	
	//Variables de mapeo de nodos
	private static final String INICIO_ESTANDAR = "avanzaBPM";
	private static final String RESULTADO_PBC = "T013_ResultadoPBC";
	private static final String INSTRUCCIONES_RESERVA = "T013_InstruccionesReserva";
	private static final String POSICIONAMIENTO_Y_FIRMA = "T013_PosicionamientoYFirma";
	private static final String RESOLUCION_EXPEDIENTE = "T013_ResolucionExpediente";
	private static final String INICIO_VENTA_SOBRE_PLANO = "inicioTramiteVentaSobrePlano";
	
	
	@Override
	public void run(ExecutionContext executionContext) throws Exception{
		this.setContext(executionContext);
		ActivoTramite tramite = getActivoTramite(executionContext);
		DDCartera cartera = tramite.getActivo().getCartera();
		DDSubcartera subcartera = tramite.getActivo().getSubcartera();
		String origin = (String)executionContext.getVariable(ConstantesBPMPFS.NOMBRE_NODO_SALIENTE);
		String subcarteraCodigo = subcartera != null ? subcartera.getCodigo() : null;
		String target = getTarget(tramite, cartera.getCodigo(), subcarteraCodigo, origin);
		if (Checks.esNulo(target) && Checks.esNulo(origin)) target = INICIO_ESTANDAR;
		executionContext.getToken().signal(target);
	}
	
	private String getTarget(ActivoTramite tramite, String codigo, String subCodigo, String origin) {
		Map<String, String> target = new HashMap<String, String>();
		if (DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(codigo) && DDSubcartera.CODIGO_YUBAI.equals(subCodigo))
			target.put(DDCartera.CODIGO_CARTERA_THIRD_PARTY, getTargetThirdPartiesYubai(origin, tramite));
		
		return target.get(codigo);
	}
	
	private String getTargetThirdPartiesYubai(String origin, ActivoTramite tramite) {
		if ( Checks.esNulo(origin) ) {
			return INICIO_VENTA_SOBRE_PLANO;
		}else if ( RESULTADO_PBC.equals(origin)  && !Checks.esNulo(tramite)) {
			ExpedienteComercial expediente = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
			if (!Checks.esNulo(expediente) && !Checks.esNulo(expediente.getCondicionante())) {
				if (Integer.valueOf(1).equals(expediente.getCondicionante().getSolicitaReserva()) 
				&& !tareaActivoApi.getSiTareaHaSidoCompletada(tramite.getId(), RESULTADO_PBC) 
				&& Integer.valueOf(2).equals(expediente.getEstadoPbc())) {
					return INSTRUCCIONES_RESERVA;
				}else {
					if (Integer.valueOf(1).equals(expediente.getEstadoPbc()))
						return POSICIONAMIENTO_Y_FIRMA;
					else
						return RESOLUCION_EXPEDIENTE;
				}
			}
		}
		return null;
	}
	
	
	
	private void setDecision(String variable, String action) {
		getContext().setVariable(variable, action);
	}
	
	private void setContext(ExecutionContext ctx) {
		this.executionContext = ctx;
	}
	
	private ExecutionContext getContext() {
		return executionContext;
	}
}

