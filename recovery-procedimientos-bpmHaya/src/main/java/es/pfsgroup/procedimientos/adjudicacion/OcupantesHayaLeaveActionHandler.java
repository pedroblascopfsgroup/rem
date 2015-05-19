package es.pfsgroup.procedimientos.adjudicacion;

import java.util.ArrayList;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.multigestor.api.GestorAdicionalAsuntoApi;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.api.AdjudicacionHandlerDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.dto.DtoCrearAnotacion;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;

public class OcupantesHayaLeaveActionHandler extends
		PROGenericLeaveActionHandler {
	/**
	 * 
	 */
	private static final long serialVersionUID = 4574718797919597271L;

	private final static String CODIGO_TIPO_GESTOR_ADMISION = "GAREO";

	@Autowired
	GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private Executor executor;

	@Override
	protected void process(Object delegateTransitionClass,
			Object delegateSpecificClass, ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass,
				executionContext);

		personalizamosTramiteAdjudicacion(executionContext);
	}

	private void personalizamosTramiteAdjudicacion(
			ExecutionContext executionContext) {

		Procedimiento prc = getProcedimiento(executionContext);

		if ("H048_ResolucionFirme".equals(executionContext.getNode().getName())) {
			List<Usuario> lUsuario = proxyFactory.proxy(
					GestorAdicionalAsuntoApi.class).findGestoresByAsunto(
					prc.getAsunto().getId(), CODIGO_TIPO_GESTOR_ADMISION);
			if (!Checks.estaVacio(lUsuario)) {
				List<Long> listIdUsuarioGestor = new ArrayList<Long>();
				for (Usuario usu : lUsuario) {
					listIdUsuarioGestor.add(usu.getId());
				}
				// Se crea la anotacion y se llamara al EXECUTOR
				String asunto = "Referencia del asunto de ocupantes";
				String cuerpoEmail = "Le comunico la resoluci&oacute;n favorable de gesti&oacute;n de ocupantes del inmueble numero de finca: NNNNN y referencia catastral: NNNNNNNNNAAAAA para que notifique al departamento de alquileres de la situaci&oacute;n en la que se encuentra el inmueble.";

				DtoCrearAnotacion crearAnotacion = DtoCrearAnotacion
						.crearAnotacionDTO(listIdUsuarioGestor, false, true,
								null, asunto, cuerpoEmail, prc.getAsunto().getId(),
								DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, "A");

				proxyFactory.proxy(AdjudicacionHandlerDelegateApi.class)
						.createAnotacion(crearAnotacion);
			}
		}

	}

}
