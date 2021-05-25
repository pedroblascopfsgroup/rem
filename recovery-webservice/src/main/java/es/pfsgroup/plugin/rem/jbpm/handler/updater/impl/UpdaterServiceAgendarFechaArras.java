package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.Oferta;

@Component
public class UpdaterServiceAgendarFechaArras implements UpdaterService {

	@Autowired
	private OfertaApi ofertaApi;

	private static final String CODIGO_T017_AGENDAR_FECHA_ARRAS = "T017_AgendarFechaFirmaArras";
	private static final String COMBO_FECHA_ENVIO_PROPUESTA = "fechaEnvioPropuesta";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	protected static final Log logger = LogFactory.getLog(UpdaterServiceAgendarFechaArras.class);

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {
		Date fechaArras = null;
		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		try {
			if (ofertaAceptada != null) {
				for(TareaExternaValor valor :  valores){
					if(COMBO_FECHA_ENVIO_PROPUESTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
						fechaArras = ft.parse(valor.getValor());
						break;
					}
				}
				if(fechaArras != null) {
				//TODO rellenarGrid
				}
			}
		}catch(ParseException e) {
			e.printStackTrace();
		}
	}

	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T017_AGENDAR_FECHA_ARRAS };
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
