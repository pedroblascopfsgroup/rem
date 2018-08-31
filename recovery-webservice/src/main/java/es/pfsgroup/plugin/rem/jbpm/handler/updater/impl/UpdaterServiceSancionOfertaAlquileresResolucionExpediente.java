package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;

@Component
public class UpdaterServiceSancionOfertaAlquileresResolucionExpediente implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
        
    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresResolucionExpediente.class);
			
    private static final String RESOLUCION_EXPEDIENTE = "resolucionExpediente";
	private static final String FECHA_RESOLUCION = "fechaResolucion";
	private static final String MOTIVO = "motivo";
	private static final String IMPORTE_CONTRAOFERTA = "importeContraoferta";
	
	private static final String CODIGO_T015_RESOLUCION_EXPEDIENTE = "T015_ResolucionExpediente";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		Oferta oferta = expedienteComercial.getOferta();
		
		for(TareaExternaValor valor :  valores){

			if(RESOLUCION_EXPEDIENTE.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				Filter filtroResolucionExpediente = null;
				
				if(DDResolucionComite.CODIGO_APRUEBA.equals(valor.getValor())) {
					filtroResolucionExpediente = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResolucionComite.CODIGO_APRUEBA);
				}else if(DDResolucionComite.CODIGO_RECHAZA.equals(valor.getValor())) {
					filtroResolucionExpediente = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResolucionComite.CODIGO_RECHAZA);
				}else if(DDResolucionComite.CODIGO_CONTRAOFERTA.equals(valor.getValor())) {
					filtroResolucionExpediente = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResolucionComite.CODIGO_CONTRAOFERTA);
				}
				
				if(!Checks.esNulo(filtroResolucionExpediente)) {
					DDResolucionComite resolucionExpediente = genericDao.get(DDResolucionComite.class, filtroResolucionExpediente);
					//¿Donde se guarda la resolucion del expediente?
				}
			}
			
			if(FECHA_RESOLUCION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				//¿Donde se guarda la fecha de resolucion?
			}
			
			if(MOTIVO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				//¿Donde se guarda el motivo?
				//En ECO_EXPEDIENTE_COMERCIAL aparece como DD_MAN_ID y es de campo de texto en el funcional...
			}
			
			if(IMPORTE_CONTRAOFERTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
				//¿Donde se guarda el importe de la contraoferta?
			}
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_RESOLUCION_EXPEDIENTE};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
