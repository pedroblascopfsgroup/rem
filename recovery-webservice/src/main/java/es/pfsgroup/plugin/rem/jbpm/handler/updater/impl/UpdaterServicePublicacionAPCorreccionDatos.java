package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoLocalizacion;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInformeComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTrabajo;

@Component
public class UpdaterServicePublicacionAPCorreccionDatos implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private GenericAdapter genericAdapter;
    
    @Autowired
    private ActivoApi activoApi;
        
    
    private static final String COMBO_ACEPTACION = "comboAceptacion";
	private static final String MOTIVO_DENEGACION = "motivoRechazo";
	
	private static final String CODIGO_T011_AP_CORRECCION = "T011_AnalisisPeticionCorreccion";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		ActivoEstadosInformeComercialHistorico activoEstadosInformeComercialHistorico = new ActivoEstadosInformeComercialHistorico();
		Filter estadoInformeComercialFilter;
		
		//Se recupera el activo y la info comercial
		Activo activo = tramite.getActivo();
		ActivoInfoComercial activoInfoComercial = null;
		ActivoLocalizacion activoLocalizacion = null;
		
		if(!Checks.esNulo(activo)){
			activoInfoComercial = activo.getInfoComercial();
			activoLocalizacion = activo.getLocalizacion();
		}
		
		//Se asocia el activo al historico
		if(!Checks.esNulo(activo))
			activoEstadosInformeComercialHistorico.setActivo(activo);
		
		for(TareaExternaValor valor :  valores){

			if(COMBO_ACEPTACION.equals(valor.getNombre())){
				
				if(valor.getValor().equals(DDSiNo.NO)){
					// En caso de que se deniegue se prepara un historico estado rechazado con fecha rechazo y motivo
					estadoInformeComercialFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_RECHAZO);
					activoEstadosInformeComercialHistorico.setEstadoInformeComercial(genericDao.get(DDEstadoInformeComercial.class, estadoInformeComercialFilter));
					activoEstadosInformeComercialHistorico.setFecha(new Date());
					
					// Marca activo como NO publicable
					activo.setFechaPublicable(null);
					
				} else {
					// En caso de que se acepte se prepara un historico estado rechazado con fecha rechazo y motivo y se cambia el tipo de activo
					estadoInformeComercialFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_ACEPTACION);
					activoEstadosInformeComercialHistorico.setEstadoInformeComercial(genericDao.get(DDEstadoInformeComercial.class, estadoInformeComercialFilter));
					activoEstadosInformeComercialHistorico.setFecha(new Date());
					
					if(!Checks.esNulo(activo) && !Checks.esNulo(activoInfoComercial)){
						if(!Checks.esNulo(activoInfoComercial.getTipoActivo())) activo.setTipoActivo(activoInfoComercial.getTipoActivo());
						if(!Checks.esNulo(activoInfoComercial.getSubtipoActivo())) activo.setSubtipoActivo(activoInfoComercial.getSubtipoActivo());
						
						//TODO: La direccion se machaca SIEMPRE que nos llega un nuevo IC automaticamente, no hay que hacerlo en esta tarea
						//Actualiza la direccion del activo por la que proporciona mediador
//						if(!Checks.esNulo(activoInfoComercial.getTipoVia())) activo.setTipoVia(activoInfoComercial.getTipoVia().getDescripcion());
//						activo.setNombreVia(activoInfoComercial.getNombreVia());
//						activo.setNumeroDomicilio(activoInfoComercial.getNumeroVia());
//						activo.setEscalera(activoInfoComercial.getEscalera());
//						activo.setPiso(activoInfoComercial.getPlanta());
//						activo.setPuerta(activoInfoComercial.getPuerta());
//						if(!Checks.esNulo(activoLocalizacion)){
//							activoLocalizacion.setLatitud(activoInfoComercial.getLatitud());
//							activoLocalizacion.setLongitud(activoInfoComercial.getLongitud());
//							activo.setLocalizacion(activoLocalizacion);
//						}
//						activo.setCodPostal(activoInfoComercial.getCodigoPostal());
//						activo.setLocalidad(activoInfoComercial.getLocalidad());
//						if(!Checks.esNulo(activoInfoComercial.getProvincia())) activo.setProvincia(activoInfoComercial.getProvincia().getCodigo());
					}

					// Marca activo como publicable
					activo.setFechaPublicable(new Date());
				}
				
			}
			
			if(MOTIVO_DENEGACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				//Motivo de denegación (o rechazo) del cambio de tipologia del activo
				if(!Checks.esNulo(activoEstadosInformeComercialHistorico) && !Checks.esNulo(valor.getValor()))
					activoEstadosInformeComercialHistorico.setMotivo(valor.getValor());
			}
			

		}
		
		//Si han habido cambios en el historico, lo persistimos.
		if(!Checks.esNulo(activoEstadosInformeComercialHistorico) && !Checks.esNulo(activoEstadosInformeComercialHistorico.getEstadoInformeComercial())){
			activoEstadosInformeComercialHistorico.getAuditoria().setUsuarioCrear(genericAdapter.getUsuarioLogado().getUsername());
			activoEstadosInformeComercialHistorico.getAuditoria().setFechaCrear(new Date());
			
			genericDao.save(ActivoEstadosInformeComercialHistorico.class, activoEstadosInformeComercialHistorico);
		}
		
		//Si han habido cambios en el activo, lo persistimos
		if(!Checks.esNulo(activo))
			activoApi.saveOrUpdate(activo);
			
	}


	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T011_AP_CORRECCION};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
