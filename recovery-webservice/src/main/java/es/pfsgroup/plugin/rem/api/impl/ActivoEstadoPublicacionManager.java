package es.pfsgroup.plugin.rem.api.impl;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
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

@Service("activoEstadoPublicacionManager")
public class ActivoEstadoPublicacionManager implements ActivoEstadoPublicacionApi{
	
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
    	if(DDEstadoPublicacion.CODIGO_PUBLICADO.equals(estadoPublicacion)){
    		dtoCambioEstadoPublicacion.setPublicacionOrdinaria(true);
    	} else if(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO.equals(estadoPublicacion)){
    		dtoCambioEstadoPublicacion.setPublicacionForzada(true);
    	} else if(DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO.equals(estadoPublicacion)){
    		dtoCambioEstadoPublicacion.setPublicacionOrdinaria(true);
    		dtoCambioEstadoPublicacion.setOcultacionForzada(true);
    	} else if(DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO.equals(estadoPublicacion)){
    		dtoCambioEstadoPublicacion.setPublicacionOrdinaria(true);
    		dtoCambioEstadoPublicacion.setOcultacionPrecio(true);
    	}else if(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO_PRECIOOCULTO.equals(estadoPublicacion)){
    		dtoCambioEstadoPublicacion.setPublicacionForzada(true);
    		dtoCambioEstadoPublicacion.setOcultacionPrecio(true);
    	} else if(DDEstadoPublicacion.CODIGO_DESPUBLICADO.equals(estadoPublicacion)){
    		dtoCambioEstadoPublicacion.setDespublicacionForzada(true);
    	} else if(DDEstadoPublicacion.CODIGO_NO_PUBLICADO.equals(estadoPublicacion)){
    		//Se quedaría todo a false en este estado
    	}
    	
    	return dtoCambioEstadoPublicacion;
    }
    
    @Override
    @Transactional(readOnly = false)
    public boolean publicacionChangeState(DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion){
    	ActivoHistoricoEstadoPublicacion activoHistoricoEstadoPublicacion = new ActivoHistoricoEstadoPublicacion();
		Activo activo = activoApi.get(dtoCambioEstadoPublicacion.getIdActivo());
		Filter filtro = null;
		DDEstadoPublicacion estadoPublicacion= null;
		String motivo = null;
		
		if(!Checks.esNulo(dtoCambioEstadoPublicacion.getOcultacionForzada()) && dtoCambioEstadoPublicacion.getOcultacionForzada()) { // Publicación oculto.
			if(!Checks.esNulo(activo.getEstadoPublicacion()) && activo.getEstadoPublicacion().getCodigo().equals(DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO)){
				return false; // Si es el mismo estado en el que se encuentra el activo, devolver error.
			}
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO);
			motivo = dtoCambioEstadoPublicacion.getMotivoOcultacionForzada();
		} else if(!Checks.esNulo(dtoCambioEstadoPublicacion.getOcultacionPrecio()) && dtoCambioEstadoPublicacion.getOcultacionPrecio()) { // Publicación precio oculto.
			if(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO.equals(activo.getEstadoPublicacion().getCodigo())){ // Si viene de publicación forzada.
				if(!Checks.esNulo(activo.getEstadoPublicacion()) && activo.getEstadoPublicacion().getCodigo().equals(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO_PRECIOOCULTO)){
					return false; // Si es el mismo estado en el que se encuentra el activo, devolver error.
				}
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO_PRECIOOCULTO);
			} else { // Si viene de publicación ordinaria.
				if(!Checks.esNulo(activo.getEstadoPublicacion()) && activo.getEstadoPublicacion().getCodigo().equals(DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO)){
					return false; // Si es el mismo estado en el que se encuentra el activo, devolver error.
				}
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO);
			}
			motivo = dtoCambioEstadoPublicacion.getMotivoOcultacionPrecio();
		} else if(!Checks.esNulo(dtoCambioEstadoPublicacion.getDespublicacionForzada()) && dtoCambioEstadoPublicacion.getDespublicacionForzada()) { // Despublicación forzada.
			if(!Checks.esNulo(activo.getEstadoPublicacion()) && activo.getEstadoPublicacion().getCodigo().equals(DDEstadoPublicacion.CODIGO_DESPUBLICADO)){
				return false; // Si es el mismo estado en el que se encuentra el activo, devolver error.
			}
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_DESPUBLICADO);
			motivo = dtoCambioEstadoPublicacion.getMotivoDespublicacionForzada();
		
		} else if(!Checks.esNulo(dtoCambioEstadoPublicacion.getPublicacionForzada()) && dtoCambioEstadoPublicacion.getPublicacionForzada()) { // Publicación forzada.
			if(!Checks.esNulo(activo.getEstadoPublicacion()) && activo.getEstadoPublicacion().getCodigo().equals(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO)){
				return false; // Si es el mismo estado en el que se encuentra el activo, devolver error.
			}
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO);
			motivo = dtoCambioEstadoPublicacion.getMotivoPublicacion();
		} else if(!Checks.esNulo(dtoCambioEstadoPublicacion.getPublicacionOrdinaria()) && dtoCambioEstadoPublicacion.getPublicacionOrdinaria()){ // Publicación ordinaria.
			if(!Checks.esNulo(activo.getEstadoPublicacion()) && activo.getEstadoPublicacion().getCodigo().equals(DDEstadoPublicacion.CODIGO_PUBLICADO)){
				return false; // Si es el mismo estado en el que se encuentra el activo, devolver error.
			}
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO);
		} else { // Deseleccionada cualquier opción.
			if(!Checks.esNulo(activo.getEstadoPublicacion()) && activo.getEstadoPublicacion().getCodigo().equals(DDEstadoPublicacion.CODIGO_NO_PUBLICADO)){
				return false; // Si es el mismo estado en el que se encuentra el activo, devolver error.
			}
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_NO_PUBLICADO);
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
			if(!Checks.esNulo(dtoCambioEstadoPublicacion.getPublicacionForzada()) && dtoCambioEstadoPublicacion.getPublicacionForzada()) {
				Filter filtroPortal = genericDao.createFilter(FilterType.EQUALS, "codigo", DDPortal.CODIGO_INVERSORES);
				DDPortal portal = genericDao.get(DDPortal.class, filtroPortal);
				beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "portal", portal);
					
				Filter filtroTpu = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoPublicacion.CODIGO_FORZADA);
				DDTipoPublicacion tipoPublicacion = genericDao.get(DDTipoPublicacion.class, filtroTpu);
				beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "tipoPublicacion", tipoPublicacion);
			} else if(!Checks.esNulo(dtoCambioEstadoPublicacion.getPublicacionOrdinaria()) && dtoCambioEstadoPublicacion.getPublicacionOrdinaria()) {
				Filter filtroPortal = genericDao.createFilter(FilterType.EQUALS, "codigo", DDPortal.CODIGO_HAYA);
				DDPortal portal = genericDao.get(DDPortal.class, filtroPortal);
				beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "portal", portal);
				
				Filter filtroTpu = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoPublicacion.CODIGO_ORDINARIA);
				DDTipoPublicacion tipoPublicacion = genericDao.get(DDTipoPublicacion.class, filtroTpu);
				beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "tipoPublicacion", tipoPublicacion);
			}
			beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "motivo", motivo);
			beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "fechaDesde" , new Date());
			beanUtilNotNull.copyProperty(activoHistoricoEstadoPublicacion, "estadoPublicacion", estadoPublicacion);
			
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

	@Override
	public DtoCambioEstadoPublicacion getHistoricoEstadoPublicacionByActivo(Long id) {
		DtoCambioEstadoPublicacion dto = new DtoCambioEstadoPublicacion();
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", id);
		Order order = new Order(OrderType.DESC, "id");
		List<ActivoHistoricoEstadoPublicacion> list = genericDao.getListOrdered(ActivoHistoricoEstadoPublicacion.class, order, filtroActivo, filtroBorrado);
		if(!Checks.estaVacio(list)){
			// Obtener el último estado o estado actual.
			ActivoHistoricoEstadoPublicacion activoHistoricoEstadoPublicacion = list.get(0);
			String tipoPublicacionInicial = null;
			
			// Obtener el tipo de publicación de la que viene, si la hubiera.
			for(ActivoHistoricoEstadoPublicacion estado: list){
				if(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO.equals(estado.getEstadoPublicacion().getCodigo())) {
					tipoPublicacionInicial = DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO;
					break;
				} else if(DDEstadoPublicacion.CODIGO_PUBLICADO.equals(estado.getEstadoPublicacion().getCodigo())) {
					tipoPublicacionInicial = DDEstadoPublicacion.CODIGO_PUBLICADO;
					break;
				}
			}
			
			if(!Checks.esNulo(activoHistoricoEstadoPublicacion)){
				dto.setActivo(id);
				if(!Checks.esNulo(activoHistoricoEstadoPublicacion.getEstadoPublicacion())){
					if(DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO.equals(activoHistoricoEstadoPublicacion.getEstadoPublicacion().getCodigo())){
						dto.setOcultacionForzada(true);
						dto.setPublicacionOrdinaria(true); // Se marca este check para indicar de que estado inicial viene.
						if(!Checks.esNulo(activoHistoricoEstadoPublicacion.getMotivo())){
							dto.setMotivoOcultacionForzada(activoHistoricoEstadoPublicacion.getMotivo());
						}
					} else if(DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO.equals(activoHistoricoEstadoPublicacion.getEstadoPublicacion().getCodigo()) ||
							DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO_PRECIOOCULTO.equals(activoHistoricoEstadoPublicacion.getEstadoPublicacion().getCodigo())) {
						dto.setOcultacionPrecio(true);
						
						if(DDEstadoPublicacion.CODIGO_PUBLICADO.equals(tipoPublicacionInicial)){
							dto.setPublicacionOrdinaria(true); // Se marca este check para indicar de que estado inicial viene.
						} else {
							dto.setPublicacionForzada(true); // Se marca este check para indicar de que estado inicial viene.
						}
						
						if(!Checks.esNulo(activoHistoricoEstadoPublicacion.getMotivo())){
							dto.setMotivoOcultacionPrecio(activoHistoricoEstadoPublicacion.getMotivo());
						}
						// El campo observaciones está en el funcional pero no en la DDBB.
						//if(!Checks.esNulo(activoHistoricoEstadoPublicacion.getObservaciones())) {
							//dto.setObservaciones(activoHistoricoEstadoPublicacion.getObservaciones());
						//}
					} else if(DDEstadoPublicacion.CODIGO_DESPUBLICADO.equals(activoHistoricoEstadoPublicacion.getEstadoPublicacion().getCodigo())) {
						dto.setDespublicacionForzada(true);
						dto.setPublicacionOrdinaria(true); // Se marca este check para indicar de que estado inicial viene.
						if(!Checks.esNulo(activoHistoricoEstadoPublicacion.getMotivo())){
							dto.setMotivoPublicacion(activoHistoricoEstadoPublicacion.getMotivo());
						}
					} else if(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO.equals(activoHistoricoEstadoPublicacion.getEstadoPublicacion().getCodigo())) {
						dto.setPublicacionForzada(true);
						if(!Checks.esNulo(activoHistoricoEstadoPublicacion.getMotivo())){
							dto.setMotivoPublicacion(activoHistoricoEstadoPublicacion.getMotivo());
						}
					} else if(DDEstadoPublicacion.CODIGO_PUBLICADO.equals(activoHistoricoEstadoPublicacion.getEstadoPublicacion().getCodigo())) {
						dto.setPublicacionOrdinaria(true);
						if(!Checks.esNulo(activoHistoricoEstadoPublicacion.getMotivo())){
							dto.setMotivoPublicacion(activoHistoricoEstadoPublicacion.getMotivo());
						}
					}
				}
			}
		}
		
		return dto;
	}

}