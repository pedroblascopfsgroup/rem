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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoExpedienteComercial;
import es.pfsgroup.plugin.rem.model.DtoGridFechaArras;
import es.pfsgroup.plugin.rem.model.DtoPosicionamiento;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.FechaArrasExpediente;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Posicionamiento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
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
    private static final String MOTIVO_APLAZAMIENTO = "Firma forzada de arras";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	protected static final Log logger = LogFactory.getLog(UpdaterServiceFirmaContrato.class);

	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		boolean vuelveArras = false;
		Double importe = null;
		Integer mesesFianza = null;
		try {
			if (ofertaAceptada != null) {
				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
				Posicionamiento pos = null;
				DDEstadosExpedienteComercial estadoExp = null;
				DDEstadoExpedienteBc estadoBc = null;
				
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
								estadoExp = genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadosExpedienteComercial.PTE_AGENDAR_FIRMA));
								estadoBc = genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_FIRMA_APROBADA));
								expediente.setEstado(estadoExp);
								expediente.setEstadoBc(estadoBc);
							}
						}
						if(COMBO_MOTIVO_APLAZAMIENTO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
							pos = expedienteComercialApi.getUltimoPosicionamiento(expediente.getId(),null,false);
							if(pos != null) {
								DDMotivosEstadoBC motivo = genericDao.get(DDMotivosEstadoBC.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDMotivosEstadoBC.CODIGO_APLAZADA));
								if (motivo != null) {
									pos.setValidacionBCPos(motivo);
								}
								pos.setFechaFinPosicionamiento(new Date());
								pos.setMotivoAplazamiento(valor.getValor());
							}
							genericDao.save(Posicionamiento.class, pos);
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
									DDMotivosEstadoBC estado = genericDao.get(DDMotivosEstadoBC.class, genericDao.createFilter(FilterType.EQUALS,"codigo", DDMotivosEstadoBC.CODIGO_ANULADA));
									pos.setValidacionBCPos(estado);
								}else if(DDMotivosEstadoBC.isRechazado(pos.getValidacionBCPos())) {
									pos.setMotivoAplazamiento(MOTIVO_APLAZAMIENTO);
								}
								pos.setFechaFinPosicionamiento(new Date());
								genericDao.save(Posicionamiento.class, pos);
							}
						}
					}
					genericDao.save(ExpedienteComercial.class, expediente);
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
