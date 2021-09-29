package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

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
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoPosicionamiento;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Posicionamiento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionBC;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosEstadoBC;

@Component
public class UpdaterServiceFirmaContrato implements UpdaterService {

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
    @Autowired
    private GenericABMDao genericDao;

	private static final String CODIGO_T017_FIRMA_CONTRATO = "T017_FirmaContrato";
	private static final String COMBO_FECHA_FIRMA = "fechaFirma";
	private static final String COMBO_NUMERO_PROTOCOLO = "numeroProtocolo";
	private static final String COMBO_RESULTADO = "comboResultado";
	private static final String COMBO_MOTIVO_APLAZAMIENTO = "motivoAplazamiento";
    private static final String COMBO_ARRAS = "comboArras";
    private static final String MESES_FIANZA = "mesesFianza";
    private static final String IMPORTE_FIANZA = "importeFianza";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	protected static final Log logger = LogFactory.getLog(UpdaterServiceFirmaContrato.class);

	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		boolean vuelveArras = false;
		Double importe = null;
		Integer mesesFianza = null;
		boolean aplaza = false;
		boolean aprueba = false;
		DtoPosicionamiento dtoPos = new DtoPosicionamiento();
		try {
			if (ofertaAceptada != null) {
				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
				Posicionamiento pos = null;
				String estadoExp = null;
				String estadoBc = null;
				
				if (expediente != null) {
					for(TareaExternaValor valor :  valores){
						if(COMBO_FECHA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
							expediente.setFechaFirmaContrato(ft.parse(valor.getValor()));
						}
						if(COMBO_NUMERO_PROTOCOLO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
							expediente.setNumeroProtocolo(valor.getValor());
						}
						if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
							if(DDSiNo.SI.equals(valor.getValor())) {
								aprueba = true;
							}
						}
						if(COMBO_MOTIVO_APLAZAMIENTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
							aplaza = false;
							dtoPos.setMotivoAplazamiento(valor.getValor());
						}
						if (COMBO_ARRAS.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
							if(DDSiNo.SI.equals(valor.getValor())) {
								vuelveArras = true;
							}
						}
						if (MESES_FIANZA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
							mesesFianza = Integer.valueOf(valor.getValor());
						}
						if (IMPORTE_FIANZA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
							if (valor.getValor().contains(",")) {
								String valorCambiado = valor.getValor().replaceAll(",", ".");
								importe = Double.valueOf(valorCambiado).doubleValue();
							}else {
								importe = Double.valueOf(valor.getValor());
							}
							
						}
					}
					if (vuelveArras) {											
						if(expediente != null) {
							expedienteComercialApi.createReservaAndCondicionesReagendarArras(expediente, importe, mesesFianza, ofertaAceptada);
							pos = expedienteComercialApi.getUltimoPosicionamiento(expediente.getId(), null, false);
							if(pos != null) {
								if (DDMotivosEstadoBC.isAprobado(pos.getValidacionBCPos())) {
									pos.setValidacionBCPos(genericDao.get(DDMotivosEstadoBC.class, genericDao.createFilter(FilterType.EQUALS,"codigo", DDMotivosEstadoBC.CODIGO_ANULADA)));
								}else if(DDMotivosEstadoBC.isRechazado(pos.getValidacionBCPos())) {
									pos.setMotivoAnulacionBc(genericDao.get(DDMotivoAnulacionBC.class, genericDao.createFilter(FilterType.EQUALS,"codigo", DDMotivoAnulacionBC.CODIGO_FIRMA_FORZADA_ARRAS)));
								}
								pos.setFechaFinPosicionamiento(new Date());
								genericDao.save(Posicionamiento.class, pos);
							}
						}
					}else if(aplaza){
						estadoExp = DDEstadosExpedienteComercial.PTE_AGENDAR_FIRMA;
						estadoBc = DDEstadoExpedienteBc.CODIGO_IMPORTE_FINAL_APROBADO;
						dtoPos.setMotivoAnulacionBc(DDMotivosEstadoBC.CODIGO_APLAZADA);
						dtoPos.setFechaFinPosicionamiento(new Date());
						expedienteComercialApi.createOrUpdateUltimoPosicionamiento(expediente.getId(), dtoPos);
					}else {
						if(aprueba) {
							estadoExp = DDEstadosExpedienteComercial.FIRMADO;
							estadoBc = DDEstadoExpedienteBc.CODIGO_CONTRATO_FIRMADO;
						}else {
							estadoExp = DDEstadosExpedienteComercial.ANULADO;
							estadoBc = DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO;
						}
					}
					
					expediente.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoExp)));
					expediente.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo",estadoBc)));

					genericDao.save(ExpedienteComercial.class, expediente);
					
			        ofertaApi.replicateOfertaFlushDto(expediente.getOferta(), expedienteComercialApi.buildReplicarOfertaDtoFromExpediente(expediente));

				}				
			}
		}catch(ParseException e) {
			e.printStackTrace();
		}
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T017_FIRMA_CONTRATO };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
}
