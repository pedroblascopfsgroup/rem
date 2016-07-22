package es.pfsgroup.plugin.rem.api.impl;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoCambioEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDPortal;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPublicacion;


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
	
    BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
    
	
    public void publicacionChangeState(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion, DtoEstadoPublicacion dtoEstadoPublicacion){
    	cambioEstadosPublicacion(dtoCambioEstadoPublicacion);
    	nuevoEstadoPublicacion(dtoCambioEstadoPublicacion, dtoEstadoPublicacion);
    }
    
	public void cambioEstadosPublicacion(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion) {
		Activo activo = activoApi.get(dtoCambioEstadoPublicacion.getIdActivo());		
		
		//Estudiar cada cambio de estados y meterlo en el histórico y en la tabla del activo
		if(dtoCambioEstadoPublicacion.getPublicacionForzada() || dtoCambioEstadoPublicacion.getPublicacionOrdinaria()){ //Publicada
			if(dtoCambioEstadoPublicacion.getPublicacionOrdinaria()){ //Publicación ordinaria (sólo en caso de no estar oculto o precio oculto)
				if(dtoCambioEstadoPublicacion.getOcultacionForzada()){ //Publicación oculto
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO);
					DDEstadoPublicacion estadoPublicacion = genericDao.get(DDEstadoPublicacion.class, filtro);
					activo.setEstadoPublicacion(estadoPublicacion);
				}else{
					if(dtoCambioEstadoPublicacion.getOculacionPrecio()){ //Precio oculto
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO);
						DDEstadoPublicacion estadoPublicacion = genericDao.get(DDEstadoPublicacion.class, filtro);
						activo.setEstadoPublicacion(estadoPublicacion);
					}else{ //Publicacion ordinaria
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO);
						DDEstadoPublicacion estadoPublicacion = genericDao.get(DDEstadoPublicacion.class, filtro);
						activo.setEstadoPublicacion(estadoPublicacion);
					}
				}
				}else{ //Publicacion forzada
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO);
					DDEstadoPublicacion estadoPublicacion = genericDao.get(DDEstadoPublicacion.class, filtro);
					activo.setEstadoPublicacion(estadoPublicacion);
					}		
			}else{ //No publicada
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_DESPUBLICADO);
				DDEstadoPublicacion estadoPublicacion = genericDao.get(DDEstadoPublicacion.class, filtro);
				activo.setEstadoPublicacion(estadoPublicacion);
			}
	}
	
	public void nuevoEstadoPublicacion(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion, DtoEstadoPublicacion dtoEstadoPublicacion){
		ActivoHistoricoEstadoPublicacion activoHistoricoEstadoPublicacion = new ActivoHistoricoEstadoPublicacion();
		Activo activo = activoApi.get(dtoCambioEstadoPublicacion.getIdActivo());
		
		activoHistoricoEstadoPublicacion.setActivo(activo);
		//activoHistoricoEstadoPublicacion.getFechaHasta() Tendríamos que ponerle fecha hasta al estado anterior.
		
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
			
			beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "motivo", dtoEstadoPublicacion.getMotivo());
			beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "fechaDesde" , new Date());
			
			genericDao.save(ActivoHistoricoEstadoPublicacion.class, activoHistoricoEstadoPublicacion);
			
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		//ActivoHistoricoEstadoPublicacion activoHistoricoEstadoPublicacion = genericDao
	}

	@Override
	public void publicacionChangeState(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion) {
		// TODO Auto-generated method stub
		
	}
}