package es.pfsgroup.plugin.rem.jbpm.handler.user.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.ProveedoresApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionService;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;

@Component
public class ActuacionTecnicaUserAssignationService implements UserAssigantionService {

	private static final String CODIGO_T004_ANALISIS_PETICION = "T004_AnalisisPeticion";
	private static final String CODIGO_T004_AUTORIZACION_PROPIETARIO = "T004_AutorizacionPropietario";
	private static final String CODIGO_T004_CIERRE_ECONOMICO = "T004_CierreEconomico";
	private static final String CODIGO_T004_ELECCION_PRESUPUESTO = "T004_EleccionPresupuesto";
	private static final String CODIGO_T004_ELECCION_PROVEEDOR_Y_TARIFA = "T004_EleccionProveedorYTarifa";
	private static final String CODIGO_T004_FIJACION_PLAZO = "T004_FijacionPlazo";
	private static final String CODIGO_T004_SOLICITUD_EXTRAORDINARIA = "T004_SolicitudExtraordinaria";
	private static final String CODIGO_T004_SOLICITUD_PRESUPUESTO_COMPLEMENTARIO = "T004_SolicitudPresupuestoComplementario";
	private static final String CODIGO_T004_SOLICITUD_PRESUPUESTOS = "T004_SolicitudPresupuestos";
	private static final String CODIGO_T004_VALIDACION_TRABAJO = "T004_ValidacionTrabajo";

	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private ProveedoresApi proveedoresApi;


	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T004_ANALISIS_PETICION, CODIGO_T004_AUTORIZACION_PROPIETARIO,CODIGO_T004_CIERRE_ECONOMICO,
				CODIGO_T004_ELECCION_PRESUPUESTO,CODIGO_T004_ELECCION_PROVEEDOR_Y_TARIFA,CODIGO_T004_FIJACION_PLAZO,
				CODIGO_T004_SOLICITUD_EXTRAORDINARIA,CODIGO_T004_SOLICITUD_PRESUPUESTO_COMPLEMENTARIO,CODIGO_T004_SOLICITUD_PRESUPUESTOS,
				CODIGO_T004_VALIDACION_TRABAJO};
	}

	@Override
	public Usuario getUser(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo) tareaExterna.getTareaPadre();
		Trabajo trabajo = tareaActivo.getTramite().getTrabajo();
		String codigoTarea = tareaExterna.getTareaProcedimiento().getCodigo();

		if(!Checks.esNulo(tareaActivo.getTramite().getTrabajo().getUsuarioGestorActivoResponsable())){
			return trabajo.getUsuarioGestorActivoResponsable();

		} else if((CODIGO_T004_ANALISIS_PETICION.equals(codigoTarea) || CODIGO_T004_FIJACION_PLAZO.equals(codigoTarea)) && proveedoresApi.esUsuarioConPerfilProveedor(trabajo.getSolicitante()) && 
				DDTipoTrabajo.CODIGO_ACTUACION_TECNICA.equals(trabajo.getTipoTrabajo().getCodigo()) && DDSubtipoTrabajo.CODIGO_TOMA_DE_POSESION.equals(trabajo.getSubtipoTrabajo().getCodigo())) {
			return trabajo.getSolicitante();

		} else {
			return gestorActivoApi.getGestorByActivoYTipo(trabajo.getActivo(), GestorActivoApi.CODIGO_GESTOR_ACTIVO);
		}
	}

	@Override
	public Usuario getSupervisor(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		Trabajo trabajo = tareaActivo.getTramite().getTrabajo();
		if(!Checks.esNulo(tareaActivo.getTramite().getTrabajo().getSupervisorActivoResponsable())){
			return tareaActivo.getTramite().getTrabajo().getSupervisorActivoResponsable();
		} else {
			return gestorActivoApi.getGestorByActivoYTipo(trabajo.getActivo(), GestorActivoApi.CODIGO_SUPERVISOR_ACTIVOS);
		}
	}

}
