package es.pfsgroup.plugin.rem.jbpm.handler.user.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.ProveedoresApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.PresupuestoTrabajo;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.TrabajoConfiguracionTarifa;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
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
	
	public static final double LIBERBANK_LIMITE_INFERIOR = 3000;
	public static final double LIBERBANK_LIMITE_INFERIOR_AGRUPACIONES = 25000;
	public static final double LIBERBANK_LIMITE_INTERMEDIO_AGRUPACIONES = 50000;
	public static final double LIBERBANK_LIMITE_SUPERIOR_AGRUPACIONES = 500000;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private ProveedoresApi proveedoresApi;

	@Autowired
	private GenericABMDao genericDao;
	
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
		if(CODIGO_T004_AUTORIZACION_PROPIETARIO.equals(codigoTarea)
				&& DDCartera.CODIGO_CARTERA_LIBERBANK.equals(trabajo.getActivo().getCartera().getCodigo())){
			List<ActivoTrabajo> listActivos = trabajo.getActivosTrabajo(); // Filtrar si uno o más activos
			int nActivos = listActivos.size();
			boolean hasCodPrinex = false;
			Double importe = new Double("0.0");
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId());
			if(!Checks.esNulo(trabajo.getAgrupacion()))
				for(ActivoTrabajo activo : listActivos) {
					if(null != activo.getActivo().getCodigoPromocionPrinex() && !activo.getActivo().getCodigoPromocionPrinex().isEmpty()){
						hasCodPrinex = true;
						break;
					}
				}
			else
				if(!Checks.esNulo(trabajo.getCodigoPromocionPrinex()))
					hasCodPrinex = true;
			
			
			if (!Checks.esNulo(trabajo.getEsTarificado()) && !trabajo.getEsTarificado()) { // Presupuesto
				List<PresupuestoTrabajo> presupuestos = genericDao.getList(PresupuestoTrabajo.class, filtro);
				for (PresupuestoTrabajo presupuesto : presupuestos) {
					if (!presupuesto.getAuditoria().isBorrado() && !Checks.esNulo(presupuesto.getImporte())
							&& presupuesto.getEstadoPresupuesto() != null && "02".equals(presupuesto.getEstadoPresupuesto().getCodigo())) {
							importe += presupuesto.getImporte();
					}
				}
			}else { // Tarifas
				List<TrabajoConfiguracionTarifa> cfgTarifas = genericDao.getList(TrabajoConfiguracionTarifa.class, filtro);
				for (TrabajoConfiguracionTarifa tarifa : cfgTarifas) {
					if (!tarifa.getAuditoria().isBorrado() && !Checks.esNulo(tarifa.getPrecioUnitario())
							&& !Checks.esNulo(tarifa.getMedicion())) {
						importe += tarifa.getPrecioUnitario() * tarifa.getMedicion();
					}
				}
			}
			String gestor = GestorActivoApi.CODIGO_GESTOR_ACTIVO;
			if(nActivos > 1 && hasCodPrinex){
				if(importe>= LIBERBANK_LIMITE_INFERIOR_AGRUPACIONES && importe < LIBERBANK_LIMITE_INTERMEDIO_AGRUPACIONES) {
					gestor = GestorActivoApi.CODIGO_GESTOR_COMITE_INMOBILIARIO_LIBERBANK;
				}else if(importe>= LIBERBANK_LIMITE_INTERMEDIO_AGRUPACIONES && importe < LIBERBANK_LIMITE_SUPERIOR_AGRUPACIONES) {
					gestor = GestorActivoApi.CODIGO_GESTOR_COMITE_INVERSION_INMOBILIARIA_LIBERBANK;
				}else if(importe>= LIBERBANK_LIMITE_SUPERIOR_AGRUPACIONES) {
					gestor = GestorActivoApi.CODIGO_GESTOR_COMITE_DIRECCION_LIBERBANK;
				}
			}else {
				if(importe>= LIBERBANK_LIMITE_INFERIOR && importe < LIBERBANK_LIMITE_INTERMEDIO_AGRUPACIONES) {
					gestor = GestorActivoApi.CODIGO_GESTOR_COMITE_INMOBILIARIO_LIBERBANK;
				}else if(importe>= LIBERBANK_LIMITE_INTERMEDIO_AGRUPACIONES && importe < LIBERBANK_LIMITE_SUPERIOR_AGRUPACIONES) {
					gestor = GestorActivoApi.CODIGO_GESTOR_COMITE_INVERSION_INMOBILIARIA_LIBERBANK;
				}else if(importe>= LIBERBANK_LIMITE_SUPERIOR_AGRUPACIONES) {
					gestor = GestorActivoApi.CODIGO_GESTOR_COMITE_DIRECCION_LIBERBANK;
				}
			}
			return gestorActivoApi.getGestorByActivoYTipo(trabajo.getActivo(),gestor);
		}else if(!Checks.esNulo(tareaActivo.getTramite().getTrabajo().getUsuarioGestorActivoResponsable())){
			return trabajo.getUsuarioGestorActivoResponsable();

		} else if((CODIGO_T004_ANALISIS_PETICION.equals(codigoTarea) || CODIGO_T004_FIJACION_PLAZO.equals(codigoTarea) || CODIGO_T004_ELECCION_PROVEEDOR_Y_TARIFA.equals(codigoTarea)) && proveedoresApi.esUsuarioConPerfilProveedor(trabajo.getSolicitante()) && 
				DDTipoTrabajo.CODIGO_ACTUACION_TECNICA.equals(trabajo.getTipoTrabajo().getCodigo()) && DDSubtipoTrabajo.CODIGO_TOMA_DE_POSESION.equals(trabajo.getSubtipoTrabajo().getCodigo())) {
			return trabajo.getSolicitante();
				
		}
			
		return gestorActivoApi.getGestorByActivoYTipo(trabajo.getActivo(), GestorActivoApi.CODIGO_GESTOR_ACTIVO);
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
