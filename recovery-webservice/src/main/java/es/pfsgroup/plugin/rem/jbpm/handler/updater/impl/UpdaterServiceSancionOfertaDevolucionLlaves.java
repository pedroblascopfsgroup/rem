package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceSancionOfertaDevolucionLlaves implements UpdaterService  {

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private OfertaApi ofertaApi;
 
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaDevolucionLlaves.class);

    private static final String CODIGO_T013_DEVOLUCIONLLAVES = "T013_DevolucionLlaves";
    

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		Oferta ofertaAceptada = ofertaApi.trabajoToOferta(tramite.getTrabajo());
		boolean rechazar = false;
		if(!Checks.esNulo(ofertaAceptada)){
			ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());

			if(!Checks.esNulo(expediente)){
				if (!Checks.esNulo(expediente.getCondicionante()) && !Checks.esNulo(expediente.getCondicionante().getSolicitaReserva())){

					if(!Integer.valueOf(1).equals(expediente.getCondicionante().getSolicitaReserva())){
						rechazar = true;

						expediente.setFechaVenta(null);
						expediente.setFechaAnulacion(new Date());
						genericDao.save(ExpedienteComercial.class, expediente);
					}
				}
				
				if(rechazar) {
	                ofertaApi.inicioRechazoDeOfertaSinLlamadaBC(ofertaAceptada, DDEstadosExpedienteComercial.ANULADO);
	            }
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_DEVOLUCIONLLAVES};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
}
