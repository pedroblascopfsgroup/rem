package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;

@Component
public class UpdaterServiceSancionOfertaDocumentosPostVenta implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private OfertaApi ofertaApi;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaDocumentosPostVenta.class);
    
    private static final String FECHA_INGRESO = "fechaIngreso";
    private static final String CHECKBOX_VENTA_DIRECTA = "checkboxVentaDirecta";
   	private static final String CODIGO_T013_DOCUMENTOS_POST_VENTA = "T013_DocumentosPostVenta";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		for(TareaExternaValor valor :  valores){

			// fecha ingreso cheque
			if(FECHA_INGRESO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				Oferta oferta = ofertaApi.trabajoToOferta(tramite.getTrabajo());
				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());

				//Guardado adicional Fecha inicio => expediente comercial.fecha inicio
				try {
					if (!Checks.esNulo(expediente)) {
						expediente.setFechaContabilizacionPropietario(ft.parse(valor.getValor()));	
					}
				} catch (ParseException e) {
					logger.error(e);
				}

				genericDao.save(ExpedienteComercial.class, expediente);
			}

			if(CHECKBOX_VENTA_DIRECTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				Oferta oferta = ofertaApi.trabajoToOferta(tramite.getTrabajo());
				Activo activo = oferta.getActivoPrincipal();
				activo.setVentaDirectaBankia("true".equals(valor.getValor()) ? true : false);
				genericDao.save(Activo.class, activo);
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T013_DOCUMENTOS_POST_VENTA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
