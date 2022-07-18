package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import es.pfsgroup.plugin.rem.model.dd.*;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.BoardingComunicacionApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoPosicionamiento;
import es.pfsgroup.plugin.rem.model.DtoRespuestaBCGenerica;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoSancionesBc;
import es.pfsgroup.plugin.rem.model.Oferta;

@Component
public class UpdaterServiceConfirmarFechaEscritura implements UpdaterService {

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private BoardingComunicacionApi boardingComunicacionApi;

	private static final String CODIGO_T017_CONFIRMAR_FECHA_ESCRITURA = "T017_ConfirmarFechaEscritura";
	
    private static final String MOTIVO_APLAZAMIENTO = "Firma forzada de arras";
    

    
    private class CamposConfirmarFechaFirmaEscritura{
    	private static final String OBSERVACIONES_BC = "observacionesBC";
        private static final String FECHA_RESPUESTA = "fechaRespuesta";
        private static final String COMBO_VALIDACION_BC = "comboValidacionBC";
        private static final String COMBO_ARRAS = "comboArras";
        private static final String MESES_FIANZA = "mesesFianza";
        private static final String IMPORTE_FIANZA = "importeFianza";
        private static final String OBSERVACIONES_REM = "observaciones";
		private static final String COMBO_RIESGO = "cambioRiesgo";
    }
    
    private static final String TIPO_OPERACION = "tipoOperacion";
	private static final String PLANIFICADA_FIRMA = "fechaPropuestaPlanificadaFirma";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	protected static final Log logger = LogFactory.getLog(UpdaterServiceConfirmarFechaEscritura.class);

	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		ExpedienteComercial eco = expedienteComercialApi.getExpedienteByIdTramite(tramite.getId());	
		boolean vuelveArras = false;
		Double importe = null;
		Integer mesesFianza = null;
		String estadoBC = null;
		String estadoExpediente = null;
		boolean vuelvePBC = false;
		Map<String, Boolean> campos = new HashMap<String,Boolean>();
		
		DtoPosicionamiento dto = new DtoPosicionamiento();
		DtoRespuestaBCGenerica dtoHistoricoBC = new DtoRespuestaBCGenerica();
		try {
			if (ofertaAceptada != null && eco != null) {
				
				dtoHistoricoBC.setComiteBc(DDComiteBc.CODIGO_COMITE_COMERCIAL);
				dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_APRUEBA);
				
				for(TareaExternaValor valor :  valores){
					if(CamposConfirmarFechaFirmaEscritura.COMBO_VALIDACION_BC.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						if (DDMotivosEstadoBC.CODIGO_APROBADA_BC.equals(valor.getValor())) {
							campos.put(PLANIFICADA_FIRMA, true);
						} else if (DDMotivosEstadoBC.CODIGO_RECHAZADA_BC.equals(valor.getValor())) {
							campos.put(PLANIFICADA_FIRMA, false);
						}
						dto.setValidacionBCPosi(valor.getValor());
					}else if (CamposConfirmarFechaFirmaEscritura.COMBO_ARRAS.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						if(DDSiNo.SI.equals(valor.getValor())) {
							vuelveArras = true;
						}
					} else if (CamposConfirmarFechaFirmaEscritura.MESES_FIANZA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						mesesFianza = Integer.valueOf(valor.getValor());
					} else if (CamposConfirmarFechaFirmaEscritura.IMPORTE_FIANZA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						if (valor.getValor().contains(",")) {
							String valorCambiado = valor.getValor().replaceAll(",", ".");
							importe = Double.valueOf(valorCambiado).doubleValue();
						}else {
							importe = Double.valueOf(valor.getValor());
						}
					}else if(CamposConfirmarFechaFirmaEscritura.FECHA_RESPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						dto.setFechaValidacionBCPos(ft.parse(valor.getValor()));
					} else if(CamposConfirmarFechaFirmaEscritura.OBSERVACIONES_BC.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						dto.setObservacionesBcPos(valor.getValor());
						dtoHistoricoBC.setObservacionesBC(valor.getValor());
					}
					else if(CamposConfirmarFechaFirmaEscritura.OBSERVACIONES_REM.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						dto.setObservacionesRem(valor.getValor());
					}
					if(CamposConfirmarFechaFirmaEscritura.COMBO_RIESGO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						if(DDSiNo.SI.equals(valor.getValor())) {
								if(eco.getUltimoPosicionamiento() != null){
									DtoPosicionamiento dtoPos = new DtoPosicionamiento();
									dtoPos.setIdPosicionamiento(eco.getUltimoPosicionamiento().getId());
									dtoPos.setMotivoAplazamiento("Aplazamiento automático por cálculo riesgo");
									dtoPos.setMotivoAnulacionBc(DDMotivoAnulacionBC.CODIGO_PENDIENTE_PBC);
									dtoPos.setValidacionBCPosi(DDMotivosEstadoBC.CODIGO_ANULADA);
									expedienteComercialApi.savePosicionamiento(dtoPos);
								}
								estadoExpediente = DDEstadosExpedienteComercial.APROBADO;
								estadoBC = DDEstadoExpedienteBc.PTE_SANCION_PBC_SERVICER;
								vuelvePBC = true;
						}
					}
				}
				
				if (vuelveArras) {
					campos.put(TIPO_OPERACION, true);
					expedienteComercialApi.createReservaAndCondicionesReagendarArras(eco, importe, mesesFianza, ofertaAceptada);
					if(DDMotivosEstadoBC.CODIGO_RECHAZADA_BC.equals(dto.getValidacionBCPosi())){
						dto.setMotivoAplazamiento(MOTIVO_APLAZAMIENTO);
						dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_DENIEGA);
					}
									
				}else if(!vuelvePBC){

					if(DDMotivosEstadoBC.CODIGO_RECHAZADA_BC.equals(dto.getValidacionBCPosi())) {
						dto.setFechaFinPosicionamiento(new Date());
						estadoExpediente = DDEstadosExpedienteComercial.PTE_AGENDAR_FIRMA;
						estadoBC = estadoBC != null ? estadoBC :  DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO;
						dtoHistoricoBC.setRespuestaBC(DDApruebaDeniega.CODIGO_DENIEGA);
					}else {
						estadoExpediente = DDEstadosExpedienteComercial.POSICIONADO;
						estadoBC = estadoBC != null ? estadoBC :  DDEstadoExpedienteBc.CODIGO_FIRMA_DE_CONTRATO_AGENDADO;
					}
				}
				if(!vuelvePBC){
					expedienteComercialApi.createOrUpdateUltimoPosicionamiento(eco.getId(), dto);
				}
			}
			
			eco.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoExpediente)));
			eco.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBC)));
			
			genericDao.save(ExpedienteComercial.class, eco);
			
			HistoricoSancionesBc historico = expedienteComercialApi.dtoRespuestaToHistoricoSancionesBc(dtoHistoricoBC, eco);
				
			genericDao.save(HistoricoSancionesBc.class, historico);
	        
	        if (!campos.isEmpty() && boardingComunicacionApi.modoRestClientBloqueoCompradoresActivado())
				boardingComunicacionApi.enviarBloqueoCompradoresCFV(ofertaAceptada, campos,BoardingComunicacionApi.TIMEOUT_1_MINUTO);

		}catch(ParseException e) {
			e.printStackTrace();
		}
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T017_CONFIRMAR_FECHA_ESCRITURA };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
