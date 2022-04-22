package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
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
import es.pfsgroup.plugin.rem.model.DtoExpedienteComercial;
import es.pfsgroup.plugin.rem.model.DtoPosicionamiento;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;

@Component
public class UpdaterServiceAgendarPosicionamiento implements UpdaterService {

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private BoardingComunicacionApi boardingComunicacionApi;

	private static final String CODIGO_T017_AGENDAR_POSICIONAMIENTO = "T017_AgendarPosicionamiento";
	private static final String COMBO_FECHA_ENVIO_PROPUESTA = "fechaPropuestaFC";
	private static final String COMBO_FECHA_ENVIO = "fechaEnvio";
	
    private static final String COMBO_ARRAS = "comboArras";
    private static final String MESES_FIANZA = "mesesFianza";
    private static final String IMPORTE_FIANZA = "importeFianza";
    private static final String TIPO_OPERACION = "tipoOperacion";
	private static final String COMBO_RIESGO = "cambioRiesgo";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	protected static final Log logger = LogFactory.getLog(UpdaterServiceAgendarPosicionamiento.class);

	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		DtoPosicionamiento dtoPosicionamiento = new DtoPosicionamiento();
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		ExpedienteComercial expediente = null;
		boolean vuelveArras = false;
		Double importe = null;
		Integer mesesFianza = null;
		String estadoBC = null;
		boolean vuelvePBC = false;
		String fechaPropuesta = null;
		Map<String, Boolean> campos = new HashMap<String,Boolean>();
		try {
			if (ofertaAceptada != null) {
				expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
				for(TareaExternaValor valor :  valores){
					if(COMBO_FECHA_ENVIO_PROPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						dtoPosicionamiento.setFechaPosicionamiento(ft.parse(valor.getValor()));
						fechaPropuesta = valor.getValor();
					}
					if(COMBO_FECHA_ENVIO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						dtoPosicionamiento.setFechaEnvioPos(ft.parse(valor.getValor()));
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
					if(COMBO_RIESGO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						if(DDSiNo.SI.equals(valor.getValor())) {
							if(expediente.getUltimoPosicionamiento() != null){
								DtoPosicionamiento dto = new DtoPosicionamiento();
								dto.setIdPosicionamiento(expediente.getUltimoPosicionamiento().getId());
								dto.setMotivoAplazamiento("Aplazamiento automático por cálculo riesgo");
								dto.setMotivoAnulacionBc(DDMotivoAnulacionBC.CODIGO_PENDIENTE_PBC);
								dto.setValidacionBCPosi(DDMotivosEstadoBC.CODIGO_ANULADA);
								expedienteComercialApi.savePosicionamiento(dto);
							}
							expediente.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.APROBADO)));
							estadoBC = DDEstadoExpedienteBc.PTE_SANCION_PBC_SERVICER;
							vuelvePBC = true;
						}
					}
				}

				if (vuelveArras) {		
					campos.put(TIPO_OPERACION, true);			
					expedienteComercialApi.createReservaAndCondicionesReagendarArras(expediente, importe, mesesFianza, ofertaAceptada);

				}else if(!vuelvePBC){
					DtoExpedienteComercial dto = expedienteComercialApi.getExpedienteComercialByOferta(ofertaAceptada.getNumOferta());	
					dtoPosicionamiento.setValidacionBCPosi(DDMotivosEstadoBC.CODIGO_PDTE_VALIDACION);
					expedienteComercialApi.createOrUpdateUltimoPosicionamientoEnviado(dto.getId(), dtoPosicionamiento);
					estadoBC = estadoBC != null ? estadoBC : DDEstadoExpedienteBc.CODIGO_VALIDACION_DE_FIRMA_DE_CONTRATO_POR_BC;
				}
				
				expediente.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", estadoBC)));
				genericDao.save(ExpedienteComercial.class, expediente);
				
				if (!campos.isEmpty() && boardingComunicacionApi.modoRestClientBloqueoCompradoresActivado())
					boardingComunicacionApi.enviarBloqueoCompradoresCFV(ofertaAceptada, campos ,BoardingComunicacionApi.TIMEOUT_1_MINUTO);
			}
		}catch(ParseException e) {
			e.printStackTrace();
		}
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T017_AGENDAR_POSICIONAMIENTO };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
