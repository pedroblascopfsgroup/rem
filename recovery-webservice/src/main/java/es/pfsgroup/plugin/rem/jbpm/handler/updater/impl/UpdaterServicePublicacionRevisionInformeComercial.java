package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.auditoria.model.Auditoria;
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
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInformeComercial;

@Component
public class UpdaterServicePublicacionRevisionInformeComercial implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private GenericAdapter genericAdapter;
    
    @Autowired
    private ActivoApi activoApi;
    
    private static final String COMBO_ACEPTACION = "comboAceptacion";
    private static final String COMBO_DATOS_IGUALES = "comboDatosIguales";
	private static final String MOTIVO_DENEGACION = "motivoDenegacion";
	
	private static final String CODIGO_T011_REVISION_IC = "T011_RevisionInformeComercial";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, List<TareaExternaValor> valores) {

		ActivoEstadosInformeComercialHistorico activoEstadosInformeComercialHistorico = new ActivoEstadosInformeComercialHistorico();
		Filter estadoInformeComercialFilter;
		boolean checkAcepta = false;
		boolean checkContinuaProceso = false;
		String motivoDenegacion = new String();
		Date fechaRevision = new Date();
		
		Activo activo = tramite.getActivo();
		
		// Recoge todos los valores de la tarea porque el proceso esta condicionado a valores entre si
		for(TareaExternaValor valor :  valores){

			if(COMBO_ACEPTACION.equals(valor.getNombre())){				
				if(DDSiNo.SI.equals(valor.getValor()))
					checkAcepta = true;				
			}
			
			if(COMBO_DATOS_IGUALES.equals(valor.getNombre())){				
				if(DDSiNo.SI.equals(valor.getValor()))
					checkContinuaProceso = true;				
			}
			
			if(MOTIVO_DENEGACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				//Motivo de denegación (o rechazo) del cambio de tipologia del activo
				if(!Checks.esNulo(valor.getValor()))
					motivoDenegacion = valor.getValor();
			}
			

		}
		
		fechaRevision = new Date();
				
		if(checkAcepta){
			if(checkContinuaProceso){
				// Ha aceptado el proceso, sin realizar modificaciones
				estadoInformeComercialFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_ACEPTACION);
				activoEstadosInformeComercialHistorico.setEstadoInformeComercial(genericDao.get(DDEstadoInformeComercial.class, estadoInformeComercialFilter));
				activoEstadosInformeComercialHistorico.setFecha(new Date());
				
				// Marca activo como publicable directamente
				activo.setFechaPublicable(new Date());
				
			} else {
				// Ha aceptado el proceso, con modificaciones del informe comercial en el activo
				estadoInformeComercialFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_MODIFICACION);
				activoEstadosInformeComercialHistorico.setEstadoInformeComercial(genericDao.get(DDEstadoInformeComercial.class, estadoInformeComercialFilter));
				activoEstadosInformeComercialHistorico.setFecha(fechaRevision);
			}
		} else {
			// Ha rechazado proceso
			estadoInformeComercialFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_RECHAZO);
			activoEstadosInformeComercialHistorico.setEstadoInformeComercial(genericDao.get(DDEstadoInformeComercial.class, estadoInformeComercialFilter));
			activoEstadosInformeComercialHistorico.setFecha(new Date());
			activoEstadosInformeComercialHistorico.setMotivo(motivoDenegacion);
			
			// Marca activo como NO publicable directamente
			activo.setFechaPublicable(null);
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
		return new String[]{CODIGO_T011_REVISION_IC};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
