package es.pfsgroup.plugin.rem.api.impl;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoCambioEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDPortal;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPublicacion;
import es.pfsgroup.recovery.integration.bpm.payload.AcuerdoPayload;

@Service("activoEstadoPublicacionManager")
public class ActivoEstadoPublicacionManager implements ActivoEstadoPublicacionApi{

	/**
	 * Posibles estados: Publicado / Publicación forzada / Publicado oculto / Publicado con precio ocultado / Despublicado
	 * 
	 * PUBLICACIÓN ORDINARIA/FORZADA
	 * Si el activo es prepublicable, el check Ordinaria estará habilitado.
	 *	- Al estar habilitado el estado del activo pasará a ser publicado si se marca. (¿Debe aparecer el check de forzada también o sólo ordinaria?)
	 * Si el activo es prepublicable tiene el informe comercial aprobado y está preciado no se podrá poner como publicación forzada.
	 *  - En este estado no estará habilitada la publicación forzada.
	 * Si el activo está publicado ordinario
	 * 	- Se mostrará check ordinario marcado y no editable. El check forzado deshabilitado y el check de despublicación forzada habilitado.
	 * En el resto de casos se habilitará forzada y seguirá el flujo normal pudiendo pasar a publicada ordinaria.
	 * 
	 * OCULTACIÓN FORZADA
	 * Sólo con el activo publicado.
	 * 
	 * OCULTACIÓN DE PRECIO
	 * Se puede marcar cuando se publica o después.
	 * 
	 * DESPUBLICACIÓN FORZADA
	 * Sólo se habilita para activos con publicación forzada.
	 */
	
	@Autowired
	ActivoApi activoApi;
	
	@Autowired
	GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
    BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
    
    public DtoCambioEstadoPublicacion getState(Long idActivo){
    	DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion = new DtoCambioEstadoPublicacion();
    	Activo activo = activoApi.get(idActivo);
    	dtoCambioEstadoPublicacion.setActivo(idActivo);
    	
    	DDEstadoPublicacion estadoPublicacion = activo.getEstadoPublicacion();
    	if(estadoPublicacion.equals(DDEstadoPublicacion.CODIGO_PUBLICADO)){
    		dtoCambioEstadoPublicacion.setPublicacionOrdinaria(true);
    	} else if(estadoPublicacion.equals(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO)){
    		dtoCambioEstadoPublicacion.setPublicacionForzada(true);
    	} else if(estadoPublicacion.equals(DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO)){
    		dtoCambioEstadoPublicacion.setPublicacionOrdinaria(true);
    		dtoCambioEstadoPublicacion.setOcultacionForzada(true);
    	} else if(estadoPublicacion.equals(DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO)){
    		dtoCambioEstadoPublicacion.setPublicacionOrdinaria(true);
    		dtoCambioEstadoPublicacion.setOcultacionPrecio(true);
    	} else if(estadoPublicacion.equals(DDEstadoPublicacion.CODIGO_DESPUBLICADO)){
    		dtoCambioEstadoPublicacion.setDespublicacionForzada(true);
    	} else if(estadoPublicacion.equals(DDEstadoPublicacion.CODIGO_NO_PUBLICADO)){
    		//Se quedaría todo a false en este estado
    	}
    	
    	return dtoCambioEstadoPublicacion;
    }
    
    @Override
    @Transactional(readOnly = false)
    public boolean publicacionChangeState(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion){
    	return nuevoEstadoPublicacion(dtoCambioEstadoPublicacion);
    }
	
	private boolean nuevoEstadoPublicacion(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion){
		ActivoHistoricoEstadoPublicacion activoHistoricoEstadoPublicacion = new ActivoHistoricoEstadoPublicacion();
		Activo activo = activoApi.get(dtoCambioEstadoPublicacion.getIdActivo());
		Filter filtro = null;
		DDEstadoPublicacion estadoPublicacion= null;
		
		if(dtoCambioEstadoPublicacion.getOcultacionForzada()) { // Publicación oculto.
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO);
		} else if(dtoCambioEstadoPublicacion.getOcultacionPrecio()){ // Publicación precio oculto.
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO);
		} else if (dtoCambioEstadoPublicacion.getPublicacionOrdinaria()) { // Publicación ordinaria.
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO);
		} else if(dtoCambioEstadoPublicacion.getPublicacionForzada()) { // Publicación forzada.
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO);
		}else if(dtoCambioEstadoPublicacion.getDespublicacionForzada()) { // Despublicación forzada.
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_DESPUBLICADO);
		}

		if(!Checks.esNulo(filtro)){
			estadoPublicacion = genericDao.get(DDEstadoPublicacion.class, filtro);
			activo.setEstadoPublicacion(estadoPublicacion);
		} else {
			return false;
		}
		
		activoHistoricoEstadoPublicacion.setActivo(activo);

		// Establecer la fecha de hoy en el campo 'Fecha Hasta' del anterior/último histórico y el usuario que lo ha modificado.
		ActivoHistoricoEstadoPublicacion ultimoHistorico = activoApi.getUltimoHistoricoEstadoPublicacion(dtoCambioEstadoPublicacion.getIdActivo());
		if(!Checks.esNulo(ultimoHistorico)){
			Date ahora = new Date(System.currentTimeMillis());
			ultimoHistorico.setFechaHasta(ahora);
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			ultimoHistorico.getAuditoria().setUsuarioModificar(usuarioLogado.getUsername());
		}
		
		try {
			if(dtoCambioEstadoPublicacion.getPublicacionForzada()){
				Filter filtroPortal = genericDao.createFilter(FilterType.EQUALS, "codigo", DDPortal.CODIGO_INVERSORES);
				DDPortal portal = genericDao.get(DDPortal.class, filtroPortal);
				beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "portal", portal);
					
				Filter filtroTpu = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoPublicacion.CODIGO_FORZADA);
				DDTipoPublicacion tipoPublicacion = genericDao.get(DDTipoPublicacion.class, filtroTpu);
				beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "tipoPublicacion", tipoPublicacion);
			}else{
				Filter filtroPortal = genericDao.createFilter(FilterType.EQUALS, "codigo", DDPortal.CODIGO_HAYA);
				DDPortal portal = genericDao.get(DDPortal.class, filtroPortal);
				activoHistoricoEstadoPublicacion.setPortal(portal);
				beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "portal", portal);
				
				Filter filtroTpu = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoPublicacion.CODIGO_ORDINARIA);
				DDTipoPublicacion tipoPublicacion = genericDao.get(DDTipoPublicacion.class, filtroTpu);
				activoHistoricoEstadoPublicacion.setTipoPublicacion(tipoPublicacion);
				beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "tipoPublicacion", tipoPublicacion);
			}
			
			beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "motivo", dtoCambioEstadoPublicacion.getMotivo());
			beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "fechaDesde" , new Date());
			//beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "estadoPublicacion", estadoPublicacion);
			
			genericDao.save(ActivoHistoricoEstadoPublicacion.class, activoHistoricoEstadoPublicacion);
			
			return true;
		} catch (IllegalAccessException e) {
			e.printStackTrace();
			return false;
		} catch (InvocationTargetException e) {
			e.printStackTrace();
			return false;
		}

	}

}