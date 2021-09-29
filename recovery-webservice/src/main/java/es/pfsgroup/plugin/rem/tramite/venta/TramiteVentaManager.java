package es.pfsgroup.plugin.rem.tramite.venta;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.FuncionesApi;
import es.pfsgroup.plugin.rem.api.TramiteVentaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.impl.ComercialUserAssigantionService;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.FechaArrasExpediente;
import es.pfsgroup.plugin.rem.model.Posicionamiento;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosEstadoBC;

@Service("tramiteVentaManager")
public class TramiteVentaManager implements TramiteVentaApi {
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private FuncionesApi funcionesApi;
	
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
	
}