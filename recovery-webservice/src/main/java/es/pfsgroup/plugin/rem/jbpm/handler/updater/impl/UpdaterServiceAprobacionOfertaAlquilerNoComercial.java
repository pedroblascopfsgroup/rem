package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.FuncionesTramitesApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerNoComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAdenda;

@Component
public class UpdaterServiceAprobacionOfertaAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
	private TramiteAlquilerNoComercialApi tramiteAlquilerNoComercialApi;
    
    @Autowired
    private FuncionesTramitesApi funcionesTramitesApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceAprobacionOfertaAlquilerNoComercial.class);
    
	private static final String CODIGO_T018_APROBACION_OFERTA = "T018_AprobacionOferta";
	private static final String COMBO_CLIENTE_ACEPTA = "comboAprobadoApi";
	private static final String COMBO_LLAMADA = "llamadaRealizada";
	private static final String COMBO_BUROFAX = "burofaxEnviado";
	private static final String FECHA_LLAMADA = "fechaLlamada";
	private static final String FECHA_BUROFAX = "fechaBurofax";
	private static final String TIPO_ADENDA = "tipoAdenda";
	
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		boolean subrogacionDacion = tramiteAlquilerNoComercialApi.esSubrogacionCompraVenta(tareaExternaActual);
		boolean novacionRenovacion = tramiteAlquilerNoComercialApi.esRenovacion(tareaExternaActual);
		boolean subrogacionHipotecaria = tramiteAlquilerNoComercialApi.esSubrogacionHipoteca(tareaExternaActual);
		boolean alquilerSocial = tramiteAlquilerNoComercialApi.esAlquilerSocial(tareaExternaActual);
 		String estadoExpBC = null;
 		DtoTareasFormalizacion dto = new DtoTareasFormalizacion();
		
 		try {
 			for(TareaExternaValor valor :  valores) {
 				if(subrogacionHipotecaria) {
 					if(TIPO_ADENDA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
 						if(DDTipoAdenda.CODIGO_NO_APLICA_ADENDA.equals(valor.getValor())){
 							estadoExpBC = "130";
 	 					}else {
 	 						estadoExpBC = "550";
 	 					}
 	 				}
 				}else if (subrogacionDacion) {
 	 				estadoExpBC = "130";
 	 			}else if (novacionRenovacion || alquilerSocial) {
 	 					
 					if(COMBO_CLIENTE_ACEPTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
 						if(DDSiNo.SI.equals(valor.getValor())) { 
 							estadoExpBC = "730";
 	 					}else {
 	 						estadoExpBC = "750";
 	 					}
 					}
 					
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
 					if(COMBO_CLIENTE_ACEPTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {					
 						dto.setFechaBurofaxEnviado(ft.parse(valor.getValor()));
 					}
 	 			}
 			}
 			
 			funcionesTramitesApi.createOrUpdateComunicacionApi(expedienteComercial, dto);
 			expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigoC4C", estadoExpBC)));
 			genericDao.save(ExpedienteComercial.class, expedienteComercial);
 			
 		}catch(ParseException e) {
 			e.printStackTrace();
 		}
		
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_APROBACION_OFERTA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
