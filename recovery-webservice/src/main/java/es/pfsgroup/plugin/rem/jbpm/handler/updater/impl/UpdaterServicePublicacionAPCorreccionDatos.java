package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.message.MessageService;
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
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoLocalizacion;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoCambioEstadoPublicacion;
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
    
    @Autowired
    private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;
    
    @Resource
    private MessageService messageService;
        
    
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
				
				if(DDSiNo.NO.equals(valor.getValor())){
					// En caso de que se deniegue se prepara un historico estado rechazado con fecha rechazo y motivo
					estadoInformeComercialFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_RECHAZO);
					activoEstadosInformeComercialHistorico.setEstadoInformeComercial(genericDao.get(DDEstadoInformeComercial.class, estadoInformeComercialFilter));
					activoEstadosInformeComercialHistorico.setFecha(new Date());
					
					// El tramite NO puede des-publicar activos, solo sirve para publicar
					// activo.setFechaPublicable(null);
					
				} else {
						
					// 0.) En caso de que se acepte se prepara un historico estado aceptado con fecha aceptado
					estadoInformeComercialFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_ACEPTACION);
					activoEstadosInformeComercialHistorico.setEstadoInformeComercial(genericDao.get(DDEstadoInformeComercial.class, estadoInformeComercialFilter));
					activoEstadosInformeComercialHistorico.setFecha(new Date());

					// 1.) Se realiza una comprobacion que verifique si el activo YA esta publicado.
					//     Si esta publicado, NO se vuelven a realizar las operaciones de publicacion.
					//     Se deja todo como esta y se avanza la tarea.
					//     Esto evita provocar la excepcion al llamar al procedure y por tanto bloquear la tarea por estar publicado.
					DtoCambioEstadoPublicacion estadoPublicacion = activoEstadoPublicacionApi.getState(activo.getId());
					
					if(!estadoPublicacion.getPublicacionOrdinaria()){
						// Activo NO publicado ordinario
						
						if(!Checks.esNulo(activo) && !Checks.esNulo(activoInfoComercial)){
							if(!Checks.esNulo(activoInfoComercial.getTipoActivo())) activo.setTipoActivo(activoInfoComercial.getTipoActivo());
							if(!Checks.esNulo(activoInfoComercial.getSubtipoActivo())) activo.setSubtipoActivo(activoInfoComercial.getSubtipoActivo());
							
							//TODO: La direccion se machaca SIEMPRE que nos llega un nuevo IC automaticamente, no hay que hacerlo en esta tarea
							//Actualiza la direccion del activo por la que proporciona mediador
//							if(!Checks.esNulo(activoInfoComercial.getTipoVia())) activo.setTipoVia(activoInfoComercial.getTipoVia().getDescripcion());
//							activo.setNombreVia(activoInfoComercial.getNombreVia());
//							activo.setNumeroDomicilio(activoInfoComercial.getNumeroVia());
//							activo.setEscalera(activoInfoComercial.getEscalera());
//							activo.setPiso(activoInfoComercial.getPlanta());
//							activo.setPuerta(activoInfoComercial.getPuerta());
//							if(!Checks.esNulo(activoLocalizacion)){
//								activoLocalizacion.setLatitud(activoInfoComercial.getLatitud());
//								activoLocalizacion.setLongitud(activoInfoComercial.getLongitud());
//								activo.setLocalizacion(activoLocalizacion);
//							}
//							activo.setCodPostal(activoInfoComercial.getCodigoPostal());
//							activo.setLocalidad(activoInfoComercial.getLocalidad());
//							if(!Checks.esNulo(activoInfoComercial.getProvincia())) activo.setProvincia(activoInfoComercial.getProvincia().getCodigo());
						}
	
						// 2.) Se marca activo como publicable, porque en el tramite se han cumplido todos los requisitos
						activo.setFechaPublicable(new Date());
						activoApi.saveOrUpdate(activo);
						
						// 3.) Se publica el activo
						try {
							activoApi.publicarActivo(activo.getId(), messageService.getMessage("tramite.publicacion.publicar.con.correccion.datos.IC.sin.cambio"));
						} catch (SQLException e) {
							e.printStackTrace();
						}
					}
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
			if(Checks.esNulo(activoEstadosInformeComercialHistorico.getAuditoria())){
				Auditoria auditoria = new Auditoria();
				auditoria.setUsuarioCrear(genericAdapter.getUsuarioLogado().getUsername());
				auditoria.setFechaCrear(new Date());
				activoEstadosInformeComercialHistorico.setAuditoria(auditoria);
			}else{
				activoEstadosInformeComercialHistorico.getAuditoria().setUsuarioCrear(genericAdapter.getUsuarioLogado().getUsername());
				activoEstadosInformeComercialHistorico.getAuditoria().setFechaCrear(new Date());
			}
			activoEstadosInformeComercialHistorico.setActivo(activo);
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
