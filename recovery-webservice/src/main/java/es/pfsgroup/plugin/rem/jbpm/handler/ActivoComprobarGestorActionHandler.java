package es.pfsgroup.plugin.rem.jbpm.handler;

import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;

/**
 * Clase que comprueba si el usuario que ha creado el trámite es Gestor de
 * Activo del activo o Gestor de admisión del activo al que pertenece el
 * trámite.
 * 
 * @author Daniel Gutiérrez
 */

public class ActivoComprobarGestorActionHandler extends ActivoBaseActionHandler {

	private static final long serialVersionUID = 1920406024815248515L;

	@Autowired
	GestorActivoApi gestorActivoApi;
	
	@Autowired
	TrabajoApi trabajoApi;

	@Override
	public void run(ExecutionContext executionContext) throws Exception {

		ActivoTramite tramite = getActivoTramite(executionContext);
		Usuario usuario = tramite.getTrabajo().getSolicitante();

		// Si viene del Trámite documental, se debe comprobar "si es gest.
		// activo o gest. de admisión".
		// para el resto de trámites, solo "gestor de activo"
		
		
		if (ActivoTramiteApi.CODIGO_TRAMITE_OBTENCION_DOC.equals(tramite.getTipoTramite().getCodigo())) {
			Boolean esTramiteValido = trabajoApi.tipoTramiteValidoObtencionDocSolicitudDocumentoGestoria(tramite.getTrabajo());
			
			if(!Checks.esNulo(tramite.getActivo()) && !Checks.esNulo(tramite.getActivo().getCartera()) && esTramiteValido
				&& (DDCartera.CODIGO_CARTERA_SAREB.equals(tramite.getActivo().getCartera().getCodigo()) || DDCartera.CODIGO_CARTERA_BANKIA.equals(tramite.getActivo().getCartera().getCodigo()))
				&& gestorActivoApi.isGestorMantenimiento(tramite.getActivo(), usuario) 
			) {
				getExecutionContext().getToken().signal("OKConPagoYSaldo");
			}else {
				getExecutionContext().getToken().signal("ConAnalisisPeticion");
			}
			/*	
			if (gestorActivoApi.isGestorActivoOAdmision(tramite.getActivo(), usuario))
				getExecutionContext().getToken().signal("GestorActivo");
			else
				getExecutionContext().getToken().signal("OtrosGestores");
			*/

		} else if (ActivoTramiteApi.CODIGO_TRAMITE_OBTENCION_DOC_CEDULA.equals(tramite.getTipoTramite().getCodigo())) {
			
			Activo activo = tramite.getActivo();
			if (DDCartera.CODIGO_CARTERA_SAREB.equals(activo.getCartera().getCodigo()) || 
			    DDCartera.CODIGO_CARTERA_TANGO.equals(activo.getCartera().getCodigo()) || 
			    DDCartera.CODIGO_CARTERA_GIANTS.equals(activo.getCartera().getCodigo())) {
				if (gestorActivoApi.isUsuarioGestorAdmision(usuario)) {
					getExecutionContext().getToken().signal("SinAnalisisPeticion");
				} else {
					getExecutionContext().getToken().signal("ConAnalisisPeticion");
				}

			} else {
				getExecutionContext().getToken().signal("ConAnalisisPeticion");
			}

		} else {

			// Si viene del Tramite de Propuesta de precios, debe comprobar si
			// "es gestor precios/marketing u otros"
			if (ActivoTramiteApi.CODIGO_TRAMITE_PROPUESTA_PRECIOS.equals(tramite.getTipoTramite().getCodigo())) {

				if (gestorActivoApi.isGestorPreciosOMarketing(tramite.getActivo(), usuario))
					getExecutionContext().getToken().signal("GestorMarketingOPrecio");
				else
					getExecutionContext().getToken().signal("OtrosGestores");

			} else {

				// Si viene del Trámite documental emision CEE, se debe
				// comprobar "la cartera y si es gest. activo o gest. de
				// admisión".
				// para el resto de trámites, solo "gestor de activo"
				if (ActivoTramiteApi.CODIGO_TRAMITE_OBTENCION_DOC_CEE.equals(tramite.getTipoTramite().getCodigo())) {

					// Obtenemos la lista de activos (por si fuera tramite
					// multiactivo)
					List<Activo> listaActivos = tramite.getActivos();

					// Tomamos la cartera del primer activo
					Activo primerActivo = tramite.getActivo();
					DDCartera carteraActivos = null;
					if (!Checks.esNulo(primerActivo) && !Checks.esNulo(primerActivo.getCartera())) {
						carteraActivos = primerActivo.getCartera();
					} else {
						// Si pasa por aqui, el primer activo no tiene definida
						// la cartera (o no hay lista de activos)
						// Recorremos el resto de activos en busca de la cartera
						for (Activo activo : listaActivos) {
							if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getCartera())) {
								carteraActivos = activo.getCartera();
							}
						}
					}

					// Comprobamos gestor de activos con el primer activo
					boolean esGestorActivos = false;
					if (!Checks.esNulo(primerActivo) && gestorActivoApi.isGestorActivo(primerActivo, usuario)) {
						esGestorActivos = true;
					} else {
						// Si pasa por aqui, el usuario NO es gestor del primer
						// activo - se evalua sobre el resto de activos
						// Solo es necesario que sea gestor de activo de 1 del
						// conjunto
						for (Activo activo : listaActivos) {
							if (!Checks.esNulo(activo) && gestorActivoApi.isGestorActivo(activo, usuario)) {
								esGestorActivos = true;
							}
						}
					}

					// Logica del BPM emsision CEE
					if (!Checks.esNulo(carteraActivos)) {
						if (DDCartera.CODIGO_CARTERA_CAJAMAR.equals(carteraActivos.getCodigo()) || 
								DDCartera.CODIGO_CARTERA_LIBERBANK.equals(carteraActivos.getCodigo())) {
							// Cartera Cajamar o Liberbank- Analisis peticion
							getExecutionContext().getToken().signal("ConAnalisisPeticion");
						} else {
							// Resto carteras - Se evalua por si es gestor
							// activos
							if (esGestorActivos)
								getExecutionContext().getToken().signal("DirectoEmision");
							else
								getExecutionContext().getToken().signal("ConAnalisisPeticion");
						}
					} else {
						// No hay cartera definida en el conjunto de activos -
						// Analisis peticion
						getExecutionContext().getToken().signal("ConAnalisisPeticion");
					}

				} else {

					// OTROS TRAMITES - Se valora solo "si es gest. activo o
					// gest. de admisión".
					if (gestorActivoApi.isGestorActivo(tramite.getActivo(), usuario))
						getExecutionContext().getToken().signal("GestorActivo");
					else
						getExecutionContext().getToken().signal("OtrosGestores");

				}

			}

		}
	}

}
