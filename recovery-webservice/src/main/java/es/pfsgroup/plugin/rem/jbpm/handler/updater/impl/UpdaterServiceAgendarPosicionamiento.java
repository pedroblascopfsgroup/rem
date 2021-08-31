package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoExpedienteComercial;
import es.pfsgroup.plugin.rem.model.DtoGridFechaArras;
import es.pfsgroup.plugin.rem.model.DtoPosicionamiento;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosEstadoBC;

@Component
public class UpdaterServiceAgendarPosicionamiento implements UpdaterService {

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;

	private static final String CODIGO_T017_AGENDAR_POSICIONAMIENTO = "T017_AgendarPosicionamiento";
	private static final String COMBO_FECHA_ENVIO_PROPUESTA = "fechaPropuestaFC";
	private static final String COMBO_FECHA_ENVIO = "fechaEnvio";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	protected static final Log logger = LogFactory.getLog(UpdaterServiceAgendarPosicionamiento.class);

	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		DtoPosicionamiento dtoPosicionamiento = new DtoPosicionamiento();
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		try {
			if (ofertaAceptada != null) {
				for(TareaExternaValor valor :  valores){
					if(COMBO_FECHA_ENVIO_PROPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						dtoPosicionamiento.setFechaPosicionamiento(ft.parse(valor.getValor()));
					}
					if(COMBO_FECHA_ENVIO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						dtoPosicionamiento.setFechaEnvioPos(ft.parse(valor.getValor()));
					}
				}

				DtoExpedienteComercial dto = expedienteComercialApi.getExpedienteComercialByOferta(ofertaAceptada.getNumOferta());	

				dtoPosicionamiento.setValidacionBCPosi(DDMotivosEstadoBC.CODIGO_PDTE_VALIDACION);
				expedienteComercialApi.createOrUpdateUltimoPosicionamientoEnviado(dto.getId(), dtoPosicionamiento);
				
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
