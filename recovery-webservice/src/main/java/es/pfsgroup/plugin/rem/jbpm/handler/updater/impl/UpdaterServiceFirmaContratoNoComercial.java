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
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.RecalculoVisibilidadComercialApi;
import es.pfsgroup.plugin.rem.api.TramiteAlquilerApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoEstados;
import es.pfsgroup.plugin.rem.model.DtoTareasFormalizacion;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpedienteBc;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;

@Component
public class UpdaterServiceFirmaContratoNoComercial implements UpdaterService {
	
    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;
    
    @Autowired
    private ActivoDao activoDao;
    
    @Autowired
    private ActivoAdapter activoAdapter;
        
	@Autowired
	private RecalculoVisibilidadComercialApi recalculoVisibilidadComercialApi;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private TramiteAlquilerApi tramiteAlquilerApi;
	
    protected static final Log logger = LogFactory.getLog(UpdaterServiceFirmaContratoNoComercial.class);
    
	private static final String COMBO_RESULTADO = "comboResultado";
	private static final String FECHA_FIRMA = "fechaFirma";
	private static final String FECHA_INICIO = "fechaInicioAlquiler";
	private static final String FECHA_FIN = "fechaFinAlquiler";

	private static final String CODIGO_T018_FIRMA_CONTRATO = "T018_FirmaContrato";
	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");

	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ExpedienteComercial expedienteComercial = expedienteComercialApi.findOneByTrabajo(tramite.getTrabajo());
		boolean anular = false;
		DtoTareasFormalizacion dto = new DtoTareasFormalizacion();
		Activo activo =tramite.getActivo();
		Oferta oferta = expedienteComercial.getOferta();

		try {
			for(TareaExternaValor valor :  valores){
				
				if(FECHA_FIRMA.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())) {
					dto.setFechaFirma(ft.parse(valor.getValor()));
				}
				if(COMBO_RESULTADO.equals(valor.getNombre())) {
					anular = !DDSinSiNo.cambioStringaBooleanoNativo(valor.getNombre());
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
		
		DtoEstados dtoEstados = this.devolverEstadosExpediente(anular);
		expedienteComercial.setEstadoBc(genericDao.get(DDEstadoExpedienteBc.class,genericDao.createFilter(FilterType.EQUALS, "codigo", dtoEstados.getCodigoEstadoExpedienteBc())));
		expedienteComercial.setEstado(genericDao.get(DDEstadosExpedienteComercial.class,genericDao.createFilter(FilterType.EQUALS, "codigo", dtoEstados.getCodigoEstadoExpediente())));
		recalculoVisibilidadComercialApi.recalcularVisibilidadComercial(expedienteComercial.getOferta(), expedienteComercial.getEstado());

		genericDao.save(ExpedienteComercial.class, expedienteComercial);
			
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T018_FIRMA_CONTRATO};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	
	private DtoEstados devolverEstadosExpediente(boolean anular) {
		DtoEstados dto = new DtoEstados();
		dto.setCodigoEstadoExpedienteBc(DDEstadoExpedienteBc.CODIGO_CONTRATO_FIRMADO);
		dto.setCodigoEstadoExpediente(DDEstadosExpedienteComercial.FIRMADO);
		if(anular) {
			dto.setCodigoEstadoExpedienteBc(DDEstadoExpedienteBc.CODIGO_COMPROMISO_CANCELADO);
			dto.setCodigoEstadoExpediente(DDEstadosExpedienteComercial.ANULADO);
		}
		return dto;
	}
}
