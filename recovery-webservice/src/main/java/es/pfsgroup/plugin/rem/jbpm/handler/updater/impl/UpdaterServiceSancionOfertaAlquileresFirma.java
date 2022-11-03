package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;

@Component
public class UpdaterServiceSancionOfertaAlquileresFirma implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private ActivoDao activoDao;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
    private ActivoAdapter activoAdapter;
        
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private TramiteAlquilerApi tramiteAlquilerApi;
	
	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;

    protected static final Log logger = LogFactory.getLog(UpdaterServiceSancionOfertaAlquileresFirma.class);
    
	private static final String FECHA_FIRMA = "fechaFirma";
	private static final String COMBO_RESULTADO= "comboFirma";
	private static final String FECHA_INICIO = "fechaInicio";
	private static final String FECHA_FIN = "fechaFin";
	
	private static final String CODIGO_T015_FIRMA = "T015_Firma";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		boolean anular = false;
		
		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		DtoTareasFormalizacion dto = new DtoTareasFormalizacion();
		Activo activo =tramite.getActivo();
		Oferta oferta = expedienteComercial.getOferta();

		try {
			for(TareaExternaValor valor :  valores){
				
				if(FECHA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setFechaFirma(ft.parse(valor.getValor()));
				}
				if(COMBO_RESULTADO.equals(valor.getNombre()) && !Checks.esNulo(DDSinSiNo.cambioStringtoBooleano(valor.getValor())) && !DDSinSiNo.cambioStringtoBooleano(valor.getValor())) {
					anular = true;
				}
				if(FECHA_INICIO.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setFechaInicioAlquiler(ft.parse(valor.getValor()));
				}
				if(FECHA_FIN.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setFechaFinAlquiler(ft.parse(valor.getValor()));
				}
			}
		
		} catch (ParseException e) {
			logger.error("Error insertando Fecha fin.", e);
		}
		
		if(anular) {
			ofertaApi.finalizarOferta(oferta);
		}else {
			
			expedienteComercial.setFechaFirmaContrato(dto.getFechaFirma());
			expedienteComercial.setFechaVenta(dto.getFechaFirma());
			expedienteComercial.setFechaInicioAlquiler(dto.getFechaInicioAlquiler());
			oferta.setFechaInicioContrato(dto.getFechaInicioAlquiler());
			expedienteComercial.setFechaFinAlquiler(dto.getFechaFinAlquiler());
			oferta.setFechaFinContrato(dto.getFechaFinAlquiler());
			
			tramiteAlquilerApi.actualizarSituacionComercialUAs(activo);
			tramiteAlquilerApi.actualizarSituacionComercial(oferta.getActivosOferta(), activo, expedienteComercial.getId());
			activoDao.saveOrUpdate(activo);
			activoAdapter.actualizarEstadoPublicacionActivo(activo.getId(),true);

			if(activoDao.isActivoMatriz(activo.getId())){
				tramiteAlquilerApi.actualizarEstadoPublicacionUAs(activo);
			}
			
			genericDao.save(Oferta.class, oferta);
		}
		
		expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "codigo", this.devolverEstadoEco(activo, anular))));
		expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class, genericDao.createFilter(FilterType.EQUALS, "codigo", this.devolverEstadoBC(anular))));
		recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), expedienteComercial.getEstado());

		genericDao.save(ExpedienteComercial.class, expedienteComercial);
				
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T015_FIRMA};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}
	
	private String devolverEstadoEco(Activo activo, boolean anular) {
		String estadoExpediente = null;
		
		if(anular) {
			estadoExpediente = DDEstadosExpedienteComercial.FIRMADO;
		}else {
			if(DDCartera.isCarteraBk(activo.getCartera())) {
				estadoExpediente = DDEstadosExpedienteComercial.FIRMADO;
			}else {
				estadoExpediente = DDEstadosExpedienteComercial.PTE_CIERRE;
			}
		}
		
		return estadoExpediente;
	}
	
	private String devolverEstadoBC(boolean anular) {
		String estadoBC = DDEstadoExpedienteBc.CODIGO_CONTRATO_FIRMADO;
		if(anular) {
			estadoBC = DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO;
		}
		return estadoBC;
	}
	


}
