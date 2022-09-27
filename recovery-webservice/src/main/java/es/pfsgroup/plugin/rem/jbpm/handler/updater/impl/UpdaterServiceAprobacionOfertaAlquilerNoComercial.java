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
import es.pfsgroup.plugin.rem.model.dd.DDTipoAdenda;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOfertaAlquiler;

@Component
public class UpdaterServiceAprobacionOfertaAlquilerNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
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
 		DtoTareasFormalizacion dto = new DtoTareasFormalizacion();
 		boolean isSubrogacion = DDTipoOfertaAlquiler.isSubrogacion(expedienteComercial.getOferta().getTipoOfertaAlquiler());
 		
		
 		try {
 			for(TareaExternaValor valor :  valores) {

				if(TIPO_ADENDA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setTipoAdenda(valor.getValor());
				}
				if(COMBO_CLIENTE_ACEPTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setClienteAcepta(DDSinSiNo.cambioStringtoBooleano(valor.getValor()));
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
 			
 			if(dto.getTipoAdenda() != null) {
 				expedienteComercial.getOferta().setTipoAdenda(genericDao.get(DDTipoAdenda.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoAdenda())));
 			}
 			
 			funcionesTramitesApi.createOrUpdateComunicacionApi(expedienteComercial, dto);
 			expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigoC4C", this.devolverEstadoBC(isSubrogacion, dto))));
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

	private String devolverEstadoBC(boolean isSubrogacion,  DtoTareasFormalizacion dto) {
		String estadoExpBC = null;
		
		if(isSubrogacion) {
			if(dto.getTipoAdenda() == null || DDTipoAdenda.CODIGO_NO_APLICA_ADENDA.equals(dto.getTipoAdenda())) {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_CONTRATO_FIRMADO;
			}else {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_ADENDA_NECESARIA;
			}
		}else {
			if(dto.getClienteAcepta() != null && dto.getClienteAcepta()) {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_BORRADOR_ACEPTADO;
			}else {
				estadoExpBC = DDEstadoExpedienteBc.CODIGO_GESTION_ADECUCIONES_CERTIFICACIONES_CLIENTE;
			}
		}
		
		return estadoExpBC;
	}
}
