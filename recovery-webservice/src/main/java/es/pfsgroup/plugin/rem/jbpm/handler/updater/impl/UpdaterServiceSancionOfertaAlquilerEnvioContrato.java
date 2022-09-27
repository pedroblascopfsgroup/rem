package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.FuncionesTramitesApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;

@Component
public class UpdaterServiceSancionOfertaAlquilerEnvioContrato implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
    private FuncionesTramitesApi funcionesTramitesApi;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquilerEnvioContrato.class);
    
	private static final String COMBO_LLAMADA = "comboLlamada";
	private static final String COMBO_BUROFAX = "comboBurofax";
	private static final String FECHA_LLAMADA = "fechaLlamada";
	private static final String FECHA_BUROFAX = "fechaBurofax";

	private static final String CODIGO_T015_ENVIO_CONTRATO = "T015_EnvioContrato";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	@Override
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		DDEstadoExpedienteBc estadoBc = null;
		DtoTareasFormalizacion dto = new DtoTareasFormalizacion();
		try {
			for(TareaExternaValor valor :  valores) {
				
				if(COMBO_LLAMADA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {					
					dto.setLlamadaRealizada(DDSinSiNo.cambioStringtoBooleano(valor.getValor()));
				}
				if(COMBO_BUROFAX.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {					
					dto.setBurofaxEnviado(DDSinSiNo.cambioStringtoBooleano(valor.getValor()));
				}
				if(FECHA_LLAMADA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {					
					dto.setFechaLlamadaRealizada(ft.parse(valor.getValor()));
				}
				if(FECHA_BUROFAX.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {					
					dto.setFechaBurofaxEnviado(ft.parse(valor.getValor()));
				}
			}
			
				
			funcionesTramitesApi.createOrUpdateComunicacionApi(expedienteComercial, dto);
			estadoBc = genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoExpedienteBc.CODIGO_BORRADOR_ENVIADO));
			expedienteComercial.setEstadoBc(estadoBc);	
	
			expedienteComercialApi.update(expedienteComercial, false);
		
		}catch(ParseException e) {
			e.printStackTrace();
		}

	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_ENVIO_CONTRATO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}