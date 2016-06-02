package es.pfsgroup.procedimientos.anticipoFondos;

import java.util.ArrayList;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.multigestor.api.GestorAdicionalAsuntoApi;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.utils.JBPMProcessManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.api.AdjudicacionHandlerDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.dto.DtoCrearAnotacion;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;

public class TramiteAntFondosLeaveActionHandler extends PROGenericLeaveActionHandler {

	/**
	 * Serial ID
	 */
	private static final long serialVersionUID = 1L;

	private final String CODIGO_TGE_PROCURADOR = "PROC";

	@Autowired
	private Executor executor;

	@Autowired
	protected GenericABMDao genericDao;

	@Autowired
	private JBPMProcessManager jbpmUtil;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	@Autowired
	private TareaNotificacionApi tareaNotificacionApi;

	@Autowired
	private UsuarioApi usuarioApi;
	
	@Autowired
    private ApiProxyFactory proxyFactory;

	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass,
			ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);

		personalizamosTramite(executionContext);
	}

	private void personalizamosTramite(ExecutionContext executionContext) {

		if (executionContext.getNode().getName().contains("RealizarTransferencia")) {
			estableceNotificacion(executionContext);
		}

	}

	/**
	 * Realiza la lógica principal de la clase.
	 * 
	 * @param executionContext
	 */

	private void estableceNotificacion(ExecutionContext executionContext) {
		
		Procedimiento prc = getProcedimiento(executionContext);
		String asunto = "Notificación";
		String textoNotificacion = "Se ha realizado la transferencia";
        
        List<Usuario> lUsuario = proxyFactory.proxy(
				GestorAdicionalAsuntoApi.class).findGestoresByAsunto(
						prc.getAsunto().getId(),
						CODIGO_TGE_PROCURADOR);
		if (!Checks.estaVacio(lUsuario)) {
			List<Long> listIdUsuarioGestor = new ArrayList<Long>();
			for (Usuario usu : lUsuario) {
				listIdUsuarioGestor.add(usu.getId());
			}
			
        DtoCrearAnotacion crearAnotacion = DtoCrearAnotacion
				.crearAnotacionDTO(
						listIdUsuarioGestor,
						false, true, null,asunto,
						textoNotificacion,
						prc.getAsunto().getId(),
						DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO,
						"A");

		proxyFactory.proxy(
				AdjudicacionHandlerDelegateApi.class)
				.createAnotacion(crearAnotacion);
		}
	}

}
