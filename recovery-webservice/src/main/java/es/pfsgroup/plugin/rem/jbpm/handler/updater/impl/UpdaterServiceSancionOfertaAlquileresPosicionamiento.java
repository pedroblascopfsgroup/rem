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
import es.pfsgroup.plugin.rem.model.Posicionamiento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;

@Component
public class UpdaterServiceSancionOfertaAlquileresPosicionamiento implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresPosicionamiento.class);
    
	private static final String FECHA_FIRMA = "fechaFirmaContrato";
	private static final String LUGAR_FIRMA = "lugarFirma";
	
	
	private static final String CODIGO_T015_POSICIONAMIENTO = "T015_Posicionamiento";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Posicionamiento posicionamiento = new Posicionamiento();
		DDEstadosExpedienteComercial estadoExpedienteComercial = null;
		if(!Checks.esNulo(expedienteComercial)) {
			posicionamiento.setExpediente(expedienteComercial);
		}
		estadoExpedienteComercial = genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadosExpedienteComercial.PTE_FIRMA));
		expedienteComercial.setEstado(estadoExpedienteComercial);
		
		for(TareaExternaValor valor :  valores){
			
			if(FECHA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				try {
					posicionamiento.setFechaPosicionamiento(ft.parse(valor.getValor()));
				} catch (ParseException e) {
					logger.error("Error insertando Fecha anulación.", e);
				}
			}
			
			if(LUGAR_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				posicionamiento.setLugarFirma(valor.getValor());
			}
				
		}
		genericDao.save(Posicionamiento.class, posicionamiento);
		
		expedienteComercialApi.enviarCorreoGestionLlaves(expedienteComercial.getId(), 0);
		expedienteComercialApi.enviarCorreoPosicionamientoFirma(expedienteComercial.getId());
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_POSICIONAMIENTO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
