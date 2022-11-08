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
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.FuncionesTramitesApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.ActivoAdjudicacionJudicial;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoEstados;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
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
	private static final String FECHA_INICIO = "fechaInicioAlquiler";
	private static final String FECHA_FIN = "fechaFinAlquiler";
	private static final String FECHA_TITULO_OBTENIDO = "";
	private static final String TITULO_OBTENIDO = "";
	
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
 		DtoTareasFormalizacion dto = new DtoTareasFormalizacion();
 		boolean isSubrogacion = DDTipoOfertaAlquiler.isSubrogacion(expedienteComercial.getOferta().getTipoOfertaAlquiler());
 		Oferta oferta = expedienteComercial.getOferta();
		
 		try {
 			for(TareaExternaValor valor :  valores) {

				if(TIPO_ADENDA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setTipoAdenda(valor.getValor());
				}
				if(COMBO_CLIENTE_ACEPTA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setClienteAcepta(DDSinSiNo.cambioStringaBooleanoNativo(valor.getValor()));
				}
				if(COMBO_LLAMADA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {					
					dto.setLlamadaRealizada(DDSinSiNo.cambioStringaBooleanoNativo(valor.getValor()));
				}
				if(COMBO_BUROFAX.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {					
					dto.setBurofaxEnviado(DDSinSiNo.cambioStringaBooleanoNativo(valor.getValor()));
				}
				if(FECHA_LLAMADA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {					
					dto.setFechaLlamadaRealizada(ft.parse(valor.getValor()));
				}
				if(FECHA_BUROFAX.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {					
					dto.setFechaBurofaxEnviado(ft.parse(valor.getValor()));
				}
				if(FECHA_INICIO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setFechaInicioAlquiler(ft.parse(valor.getValor()));
				}
				if(FECHA_FIN.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setFechaFinAlquiler(ft.parse(valor.getValor()));
				}
				if(TITULO_OBTENIDO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setTituloObtenido(DDSinSiNo.cambioStringaBooleanoNativo(valor.getValor()));
				}
				if(FECHA_TITULO_OBTENIDO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setFechaTituloObtenido(ft.parse(valor.getValor()));
				}
 			}
 			
 			if(dto.getTipoAdenda() != null) {
 				expedienteComercial.getOferta().setTipoAdenda(genericDao.get(DDTipoAdenda.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getTipoAdenda())));
 			}
 			
 			if(dto.getTituloObtenido()) {
	 			ActivoAdjudicacionJudicial activoAdjudicacionJudicial = oferta.getActivoPrincipal().getAdjJudicial();
	            if (activoAdjudicacionJudicial != null){
	                 if(activoAdjudicacionJudicial.getAdjudicacionBien() != null){
	                	 NMBAdjudicacionBien adjBien =  activoAdjudicacionJudicial.getAdjudicacionBien();
	                	 adjBien.setFechaDecretoFirme(dto.getFechaTituloObtenido());
	                	 genericDao.save(NMBAdjudicacionBien.class, adjBien);
	                 }
	             }
 			}
 			
 			funcionesTramitesApi.createOrUpdateComunicacionApi(expedienteComercial, dto);
 			
 			DtoEstados dtoEstados = this.devolverEstados(isSubrogacion, dto);
 			expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dtoEstados.getCodigoEstadoExpedienteBc())));
 			expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", dtoEstados.getCodigoEstadoExpediente())));
 			
 			if(isSubrogacion) {
 				expedienteComercial.setFechaFirmaContrato(dto.getFechaFirma());
 				expedienteComercial.setFechaVenta(dto.getFechaFirma());
 				expedienteComercial.setFechaInicioAlquiler(dto.getFechaInicioAlquiler());
 				oferta.setFechaInicioContrato(dto.getFechaInicioAlquiler());
 				expedienteComercial.setFechaFinAlquiler(dto.getFechaFinAlquiler());
 				oferta.setFechaFinContrato(dto.getFechaFinAlquiler());
 			}
 			
 			if(DDEstadosExpedienteComercial.isFirmado(expedienteComercial.getEstado())) {
 				funcionesTramitesApi.actualizarEstadosPublicacionActivos(expedienteComercial);
 				genericDao.save(Oferta.class, oferta);
 			}
 			
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

	private DtoEstados devolverEstados( boolean isSubrogacion,  DtoTareasFormalizacion dto) {
		DtoEstados dtoEstados = new DtoEstados();
		
		if(isSubrogacion) {
			if(dto.getTipoAdenda() == null || DDTipoAdenda.CODIGO_NO_APLICA_ADENDA.equals(dto.getTipoAdenda())) {
				dtoEstados.setCodigoEstadoExpedienteBc(DDEstadoExpedienteBc.CODIGO_CONTRATO_FIRMADO);
				dtoEstados.setCodigoEstadoExpediente(DDEstadosExpedienteComercial.FIRMADO);
			}else {
				dtoEstados.setCodigoEstadoExpedienteBc(DDEstadoExpedienteBc.CODIGO_ADENDA_NECESARIA);
				dtoEstados.setCodigoEstadoExpediente(DDEstadosExpedienteComercial.PTE_AGENDAR_FIRMA_ADENDA);
			}
		}else {
			if(dto.getClienteAcepta() != null && dto.getClienteAcepta()) {
				dtoEstados.setCodigoEstadoExpedienteBc(DDEstadoExpedienteBc.CODIGO_BORRADOR_ACEPTADO);
				dtoEstados.setCodigoEstadoExpediente(DDEstadosExpedienteComercial.PTE_AGENDAR_FIRMA);				
			}else {
				dtoEstados.setCodigoEstadoExpedienteBc(DDEstadoExpedienteBc.CODIGO_GESTION_ADECUCIONES_CERTIFICACIONES_CLIENTE);
				dtoEstados.setCodigoEstadoExpediente(DDEstadosExpedienteComercial.PTE_RESPUESTA_BC);
			}
		}
		
		return dtoEstados;
	}
}
