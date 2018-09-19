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
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceSancionOfertaAlquileresCierreContrato implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresCierreContrato.class);
    
	private static final String DOCUMENTO_OK = "docOK";
	private static final String FECHA_VALIDACION = "fechaValidacion";
	private static final String N_CONTRATO_PRINEX = "ncontratoPrinex";
	
	private static final String CODIGO_T015_CIERRE_CONTRATO = "T015_CierreContrato";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();

		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		
		for(TareaExternaValor valor :  valores){
			
			if(DOCUMENTO_OK.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.FIRMADO_AQLUILER));
				expedienteComercial.setEstado(estadoExpedienteComercial);
				expedienteComercial.setDocumentacionOk(true);
			}
			
			if(FECHA_VALIDACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				try {
					expedienteComercial.setFechaValidacion(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					logger.error("Error insertando Fecha validación.", e);
				}
			}
			
			if(N_CONTRATO_PRINEX.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				oferta.setNumContratoPrinex(valor.getValor());
			}
		}
		
		if (!Checks.esNulo(expedienteComercial.getSeguroRentasAlquiler())) {
			expedienteComercialApi.enviarCorreoAsegurador(expedienteComercial.getId());
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_CIERRE_CONTRATO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
