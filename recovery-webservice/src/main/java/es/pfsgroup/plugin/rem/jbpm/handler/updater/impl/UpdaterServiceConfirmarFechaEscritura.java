package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

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
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.Posicionamiento;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosEstadoBC;

@Component
public class UpdaterServiceConfirmarFechaEscritura implements UpdaterService {

	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private OfertaApi ofertaApi;

	private static final String CODIGO_T017_CONFIRMAR_FECHA_ESCRITURA = "T017_ConfirmarFechaEscritura";
	private static final String COMBO_VALIDACION_BC = "comboValidacionBC";
    private static final String COMBO_ARRAS = "comboArras";
    private static final String MESES_FIANZA = "mesesFianza";
    private static final String IMPORTE_FIANZA = "importeFianza";
    private static final String MOTIVO_APLAZAMIENTO = "Firma forzada de arras";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	protected static final Log logger = LogFactory.getLog(UpdaterServiceConfirmarFechaEscritura.class);

	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		String codigoValidacionBC = null;
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		ExpedienteComercial eco = null;
		boolean vuelveArras = false;
		Double importe = null;
		Integer mesesFianza = null;

		if (ofertaAceptada != null) {
			for(TareaExternaValor valor :  valores){
				if(COMBO_VALIDACION_BC.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					codigoValidacionBC = valor.getValor();
					break;
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
				eco = expedienteComercialApi.getExpedienteByIdTramite(tramite.getId());
				
				
				if(eco != null) {
					expedienteComercialApi.createReservaAndCondicionesReagendarArras(eco, importe, mesesFianza, ofertaAceptada);
					Posicionamiento pos = expedienteComercialApi.getUltimoPosicionamiento(eco.getId(), null, false);
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
			}else {
				if(DDMotivosEstadoBC.CODIGO_RECHAZADA_BC.equals(codigoValidacionBC)) {
					eco = expedienteComercialApi.getExpedienteByIdTramite(tramite.getId());
					if(eco != null) {
						Posicionamiento pos = expedienteComercialApi.getUltimoPosicionamiento(eco.getId(), null, false);
						if(pos != null) {
							pos.setFechaFinPosicionamiento(new Date());
							genericDao.save(Posicionamiento.class, pos);
						}
					}
				}
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T017_CONFIRMAR_FECHA_ESCRITURA };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
