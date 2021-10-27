package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.BoardingComunicacionApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoGridFechaArras;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosEstadoBC;

@Component
public class UpdaterServiceConfirmarFechaFirmaArras implements UpdaterService {

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private BoardingComunicacionApi boardingComunicacionApi;

	private static final String CODIGO_T017_CONFIRMAR_FECHA_FIRMA_ARRAS = "T017_ConfirmarFechaFirmaArras";
	private static final String motivoAplazamiento = "Suspensión proceso arras";
	
	
	private class CamposConfirmarFechaFirmaArras{
		private static final String COMBO_QUITAR = "comboQuitar";
		private static final String FECHA_PROPUESTA = "fechaPropuesta";
		private static final String FECHA_VALIDACION_BC = "fechaValidacionBC";
		private static final String COMBO_VALIDACION_BC = "comboValidacionBC";
		private static final String OBSERVACIONES_BC = "observacionesBC";
		private static final String OBSERVACIONES_REM = "observaciones";
	}
	
	private static final String TIPO_OPERACION = "tipoOperacion";
	private static final String FIRMA_RESERVA = "fechaPropuestaFirmaReserva";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	protected static final Log logger = LogFactory.getLog(UpdaterServiceConfirmarFechaFirmaArras.class);

	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		ExpedienteComercial eco = expedienteComercialApi.getExpedienteByIdTramite(tramite.getId());
		boolean comboQuitar = false;
		String estadoBc = null;
		String estadoExpediente = null;
		Map<String, Boolean> campos = new HashMap<String,Boolean>();
		try {
			if (ofertaAceptada != null && eco != null) {
				DtoGridFechaArras dto = new DtoGridFechaArras();
				
				for(TareaExternaValor valor :  valores){
					if (CamposConfirmarFechaFirmaArras.COMBO_QUITAR.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						if (DDSiNo.SI.equals(valor.getValor())) {
							comboQuitar = true;
						}
					}
					else if(CamposConfirmarFechaFirmaArras.COMBO_VALIDACION_BC.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						if (DDMotivosEstadoBC.CODIGO_APROBADA_BC.equals(valor.getValor())) {
							campos.put(FIRMA_RESERVA, true);
						} else if (DDMotivosEstadoBC.CODIGO_RECHAZADA_BC.equals(valor.getValor())) {
							campos.put(FIRMA_RESERVA, false);
						}
						dto.setValidacionBC(valor.getValor());
					}
					else if(CamposConfirmarFechaFirmaArras.FECHA_VALIDACION_BC.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						dto.setFechaBC(ft.parse(valor.getValor()));
					}
					else if(CamposConfirmarFechaFirmaArras.OBSERVACIONES_BC.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						dto.setComentariosBC(valor.getValor());
					}
					else if(CamposConfirmarFechaFirmaArras.OBSERVACIONES_REM.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						dto.setObservaciones(valor.getValor());
					}
				}
				
				if(comboQuitar) {
					campos.put(TIPO_OPERACION, false);
					dto.setMotivoAnulacion(motivoAplazamiento);
					dto.setValidacionBC(DDMotivosEstadoBC.CODIGO_ANULADA);
					
					estadoExpediente = DDEstadosExpedienteComercial.PTE_PBC_VENTAS;
					estadoBc = DDEstadoExpedienteBc.CODIGO_OFERTA_APROBADA;
					
					Filter filtroReserva = genericDao.createFilter(FilterType.EQUALS,  "expediente.id", eco.getId());
					Reserva reserva = genericDao.get(Reserva.class, filtroReserva);
					
					if (reserva != null) {
						Auditoria.delete(reserva);
						genericDao.save(Reserva.class, reserva);
					}
				}else {
					if(DDMotivosEstadoBC.CODIGO_APROBADA_BC.equals(dto.getValidacionBC())) {
						estadoExpediente = DDEstadosExpedienteComercial.PTE_FIRMA_ARRAS;
						estadoBc = DDEstadoExpedienteBc.CODIGO_FIRMA_DE_ARRAS_AGENDADAS;
					}else {
						estadoExpediente = DDEstadosExpedienteComercial.PTE_AGENDAR_ARRAS;
						estadoBc = DDEstadoExpedienteBc.CODIGO_ARRAS_APROBADAS;
					}
				}
				
				expedienteComercialApi.createOrUpdateUltimaPropuesta(eco.getId(), dto);
				
				eco.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoExpediente)));
	
				eco.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBc)));
				
				genericDao.save(ExpedienteComercial.class, eco);
				
				ofertaApi.replicateOfertaFlushDto(eco.getOferta(),expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(eco));
				
				if (!campos.isEmpty() && boardingComunicacionApi.modoRestClientBloqueoCompradoresActivado())
					boardingComunicacionApi.enviarBloqueoCompradoresCFV(ofertaAceptada, campos ,BoardingComunicacionApi.TIMEOUT_1_MINUTO);
			}
		}catch(ParseException e) {
			e.printStackTrace();
		}
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T017_CONFIRMAR_FECHA_FIRMA_ARRAS };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
}
