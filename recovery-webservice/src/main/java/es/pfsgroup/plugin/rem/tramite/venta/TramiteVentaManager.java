package es.pfsgroup.plugin.rem.tramite.venta;

import java.util.Date;
import java.util.List;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.plugin.rem.api.*;
import es.pfsgroup.plugin.rem.constants.TareaProcedimientoConstants;
import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.model.dd.*;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService;
import es.pfsgroup.plugin.rem.model.DtoDocPostVenta;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.FechaArrasExpediente;
import es.pfsgroup.plugin.rem.model.Posicionamiento;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosEstadoBC;

@Service("tramiteVentaManager")
public class TramiteVentaManager implements TramiteVentaApi {
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private FuncionesApi funcionesApi;
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private OfertaApi ofertaApi;

	@Autowired
	private ActivoTramiteApi activoTramiteApi;

	public class AvanzaTareaFuncion{
		public static final String FUNCION_AVANZA_POSICIONAMIENTO = "AV_CONF_F_ESC";
		public static final String FUNCION_AVANZA_PDTE_FIRMA_ARRAS = "AV_CONF_FF_ARRAS";
	}
	
	@Override
	public boolean checkAprobadoRechazadoBC(TareaExterna tareaExterna) {
		ExpedienteComercial expedienteComercial = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if (expedienteComercial != null) {
			FechaArrasExpediente fechaArrasExpediente =  expedienteComercialApi.getUltimaPropuesta(expedienteComercial.getId(),null);
			if (fechaArrasExpediente != null && this.isAprobadoRechazadoBC(fechaArrasExpediente.getValidacionBC())){
				return true;
			}				
		}
		return false;
	}
	
	@Override
	public boolean checkAprobadoRechazadoBCPosicionamiento(TareaExterna tareaExterna) {
		ExpedienteComercial expedienteComercial = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if (expedienteComercial != null) {
			Posicionamiento posicionamiento =  expedienteComercialApi.getUltimoPosicionamiento(expedienteComercial.getId(), null, false);
			if (posicionamiento != null && this.isAprobadoRechazadoBC(posicionamiento.getValidacionBCPos())) {
				return true;
			}				
		}
		return false;
	}
	
	@Override
	public boolean userHasPermisoParaAvanzarTareas(TareaExterna tareaExterna) {
		Usuario user = genericAdapter.getUsuarioLogado();
		String descripcionFuncion = "";
		if(tareaExterna.getTareaProcedimiento() != null) {
			if(ComercialUserAssigantionService.TramiteVentaAppleT017.CODIGO_T017_CONFIRMAR_FECHA_ESCRITURA.equals(tareaExterna.getTareaProcedimiento().getCodigo())) {
				descripcionFuncion = AvanzaTareaFuncion.FUNCION_AVANZA_POSICIONAMIENTO;
			}
			if(ComercialUserAssigantionService.TramiteVentaAppleT017.CODIGO_T017_CONFIRMAR_FECHA_FIRMA_ARRAS.equals(tareaExterna.getTareaProcedimiento().getCodigo())) {
				descripcionFuncion = AvanzaTareaFuncion.FUNCION_AVANZA_PDTE_FIRMA_ARRAS;
			}
		}
		
		return funcionesApi.userHasFunction(user.getUsername(), descripcionFuncion);
	}
	
	private boolean isAprobadoRechazadoBC(DDMotivosEstadoBC estado) {
		boolean is = false;
		if(DDMotivosEstadoBC.isAprobado(estado) || DDMotivosEstadoBC.isRechazado(estado)) {
			is = true;
		}
		return is;
	}
	
	@Override
	public boolean isTramiteT017Aprobado(List<String> tareasActivas){
		boolean isAprobado = false;
		String[] tareasParaAprobado = {ComercialUserAssigantionService.CODIGO_T017_DEFINICION_OFERTA, ComercialUserAssigantionService.CODIGO_T017_RESOLUCION_CES, 
				ComercialUserAssigantionService.TramiteVentaAppleT017.CODIGO_T017_PBC_CN};

		if(!CollectionUtils.containsAny(tareasActivas, Arrays.asList(tareasParaAprobado))) {
			isAprobado = true;
		}
		
		return isAprobado;
	}
	
	@Override
	public boolean tieneFechaVencimientoReserva(TareaExterna tareaExterna){
		boolean tieneFechaVencimientoReserva = false;
		ExpedienteComercial expedienteComercial = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if (expedienteComercial != null && expedienteComercial.getReserva() != null && !Checks.isFechaNula(expedienteComercial.getReserva().getFechaVencimiento())) {
			tieneFechaVencimientoReserva = true;
		}
		
		return tieneFechaVencimientoReserva;
	}
	
	@Override
	public boolean checkArrasEstadoBCIngreso(TareaExterna tareaExterna){
		ExpedienteComercial expedienteComercial = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if (expedienteComercial != null && expedienteComercial.getReserva() != null 
				&& !DDEstadoExpedienteBc.CODIGO_INGRESO_DE_ARRAS.equals(expedienteComercial.getEstadoBc().getCodigo())) {
			return false;
		}
		
		return true;
	}
	
	@Transactional(readOnly = false)
	@Override
	public void guardarEstadoAnulacionExpedienteBK(Long ecoId) {
		ExpedienteComercial eco = expedienteComercialApi.findOne(ecoId);
		
		if(eco.getOferta() != null && eco.getOferta().getActivoPrincipal() != null && DDCartera.isCarteraBk(eco.getOferta().getActivoPrincipal().getCartera()) && DDEstadosReserva.tieneReservaFirmada(eco.getReserva())) {
			eco.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_SOLICITAR_DEVOLUCION_DE_RESERVA_Y_O_ARRAS_A_BC)));
			eco.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.ANULADO)));
			if(eco.getFechaAnulacion() != null) {
	        	eco.setFechaAnulacion(new Date());
	        }
			genericDao.save(ExpedienteComercial.class, eco);
		}
	}
	
	@Override
	public boolean tieneReservaPrevia(TareaExterna tareaExterna){
		boolean tieneReservaPrevia = false;
		ExpedienteComercial expedienteComercial = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if (expedienteComercial != null && expedienteComercial.getReserva() != null) {
			tieneReservaPrevia =  true;
		}
		
		return tieneReservaPrevia;
	}
	
	@Override
	public boolean checkFechaContabilizacionArras(TareaExterna tareaExterna){
		ExpedienteComercial expedienteComercial = expedienteComercialApi.tareaExternaToExpedienteComercial(tareaExterna);
		if (expedienteComercial != null && expedienteComercial.getReserva() != null && Checks.esNulo(expedienteComercial.getReserva().getFechaContArras())) {
			return false;
		}
		
		return true;
	}
	

	@Override
	public DtoDocPostVenta getDatosDocPostventa(Long idExpediente) {	
		ExpedienteComercial eco = expedienteComercialApi.findOne(idExpediente);
		DtoDocPostVenta dto = new DtoDocPostVenta();
		
		dto.setFechaContabilizacion(eco.getFechaContabilizacion());
		dto.setFechaIngresoCheque(eco.getFechaContabilizacionPropietario());
		dto.setVentaDirecta(eco.getOferta().getVentaDirecta());

		
		
		return dto;
	}
	
	@Override
	public boolean isExpedienteAntesAprobadoT013(DDEstadosExpedienteComercial estado){
		boolean isAntes = false;
		
		if(DDEstadosExpedienteComercial.isEnTramitacion(estado) ||  DDEstadosExpedienteComercial.isPendienteSancion(estado) || DDEstadosExpedienteComercial.isContraofertado(estado)) {
			isAntes = true;
		}
		
		
		return isAntes;
	}

	@Override
	public boolean isTramiteT017DivarianAprobado(ExpedienteComercial eco) {
		Trabajo trabajo = eco.getTrabajo();
		ActivoTramite tramite = genericDao.get(ActivoTramite.class, genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId()));
		List<TareaExterna> tareasExpediente = activoTramiteApi.getListaTareaExternaByIdTramite(tramite.getId());

		// El tramite esta aprobado en caso de que tenga alguna de las tareas siguientes tareas con resultado aprobado:
		// 		- T017_ResolucionCES
		// 		- T017_RespuestaOfertanteCES
		// 		- T017_RatificacionComiteCES
		for (TareaExterna tex : tareasExpediente) {
			List<TareaExternaValor> tevs = tex.getValores();
			if (TareaProcedimientoConstants.CODIGO_RESOLUCION_CES_T017.equals(tex.getTareaProcedimiento().getCodigo())) {
				for (TareaExternaValor tev : tevs) {
					if ("comboResolucion".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
						if (DDResolucionComite.CODIGO_APRUEBA.equals(tev.getValor())) {
							return true;
						}
					}
				}
			} else if (TareaProcedimientoConstants.TramiteComercialT017.CODIGO_T017_RESPUESTA_OFERTANTE_CES.equals(tex.getTareaProcedimiento().getCodigo())) {
				for (TareaExternaValor tev : tevs) {
					if ("comboRespuesta".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
						if (DDResolucionComite.CODIGO_APRUEBA.equals(tev.getValor())) {
							return true;
						}
					}
				}
			} else if (TareaProcedimientoConstants.TramiteComercialT017.CODIGO_T017_RATIFIACION_COMITE_CES.equals(tex.getTareaProcedimiento().getCodigo())) {
				for (TareaExternaValor tev : tevs) {
					if ("comboRatificacion".equals(tev.getNombre()) && !Checks.esNulo(tev.getValor())) {
						if (DDResolucionComite.CODIGO_APRUEBA.equals(tev.getValor())) {
							return true;
						}
					}
				}
			}
		}
		return false;
	}

}