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
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoCambioEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
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
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
    BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
    
    public DtoCambioEstadoPublicacion getState(Long idActivo){
    	DtoCambioEstadoPublicacion dtoCambioEstadoPublicacion = new DtoCambioEstadoPublicacion();
    	Activo activo = activoApi.get(idActivo);
    	dtoCambioEstadoPublicacion.setActivo(idActivo);
    	
    	DDEstadoPublicacion estadoPublicacion = activo.getEstadoPublicacion();
    	if(DDEstadoPublicacion.CODIGO_PUBLICADO.equals(estadoPublicacion.getCodigo())){
    		dtoCambioEstadoPublicacion.setPublicacionOrdinaria(true);
    	} else if(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO.equals(estadoPublicacion.getCodigo())){
    		dtoCambioEstadoPublicacion.setPublicacionForzada(true);
    	} else if(DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO.equals(estadoPublicacion.getCodigo())){
    		dtoCambioEstadoPublicacion.setPublicacionOrdinaria(true);
    		dtoCambioEstadoPublicacion.setOcultacionForzada(true);
    	} else if(DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO.equals(estadoPublicacion.getCodigo())){
    		dtoCambioEstadoPublicacion.setPublicacionOrdinaria(true);
    		dtoCambioEstadoPublicacion.setOcultacionPrecio(true);
    	}else if(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO_PRECIOOCULTO.equals(estadoPublicacion.getCodigo())){
    		dtoCambioEstadoPublicacion.setPublicacionForzada(true);
    		dtoCambioEstadoPublicacion.setOcultacionPrecio(true);
    	} else if(DDEstadoPublicacion.CODIGO_DESPUBLICADO.equals(estadoPublicacion.getCodigo())){
    		dtoCambioEstadoPublicacion.setDespublicacionForzada(true);
    	} else if(DDEstadoPublicacion.CODIGO_NO_PUBLICADO.equals(estadoPublicacion.getCodigo())){
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
		DDEstadoPublicacion estadoPublicacionActual = null;
		String motivo = null;
		
		//Iniciativa: Si el activo no tuviera estado de publicación (null), debe tomarse como "NO PUBLICADO"
		estadoPublicacionActual = activo.getEstadoPublicacion();
		if(Checks.esNulo(estadoPublicacionActual)){
			estadoPublicacionActual = (DDEstadoPublicacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPublicacion.class, DDEstadoPublicacion.CODIGO_NO_PUBLICADO);
		}
		
		// Establecer la fecha de hoy en el campo 'Fecha Hasta' del anterior/último histórico y el usuario que lo ha modificado.
		// Situado al principio en caso de que todavía no existan historicos para el el Activo en concreto.
		ActivoHistoricoEstadoPublicacion ultimoHistorico = activoApi.getUltimoHistoricoEstadoPublicacion(dtoCambioEstadoPublicacion.getIdActivo());
		if(!Checks.esNulo(ultimoHistorico)){
			Date ahora = new Date(System.currentTimeMillis());
			ultimoHistorico.setFechaHasta(ahora);
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			ultimoHistorico.getAuditoria().setUsuarioModificar(usuarioLogado.getUsername());
		}
		
		if(!Checks.esNulo(dtoCambioEstadoPublicacion.getOcultacionForzada()) && dtoCambioEstadoPublicacion.getOcultacionForzada()) { // Publicación oculto.
			if(!Checks.esNulo(estadoPublicacionActual) && estadoPublicacionActual.getCodigo().equals(DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO)){
				return true; // Enviar True, pero no realizar nada. De otro modo no sigue guardando otros modelos.
			}
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_OCULTO);
			motivo = dtoCambioEstadoPublicacion.getMotivoOcultacionForzada();

		} else if(!Checks.esNulo(dtoCambioEstadoPublicacion.getOcultacionPrecio()) && dtoCambioEstadoPublicacion.getOcultacionPrecio()) { // Publicación precio oculto.
			if(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO.equals(estadoPublicacionActual.getCodigo())){ // Si viene de publicación forzada.
				if(!Checks.esNulo(estadoPublicacionActual) && estadoPublicacionActual.getCodigo().equals(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO_PRECIOOCULTO)){
					return true; // Enviar True, pero no realizar nada. De otro modo no sigue guardando otros modelos.
				}
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO_PRECIOOCULTO);
			} else { // Si viene de publicación ordinaria.
				if(!Checks.esNulo(estadoPublicacionActual) && estadoPublicacionActual.getCodigo().equals(DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO)){
					return true; // Enviar True, pero no realizar nada. De otro modo no sigue guardando otros modelos.
				}
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_PRECIOOCULTO);
			}
			motivo = dtoCambioEstadoPublicacion.getMotivoOcultacionPrecio();

		} else if(!Checks.esNulo(dtoCambioEstadoPublicacion.getDespublicacionForzada()) && dtoCambioEstadoPublicacion.getDespublicacionForzada()) { // Despublicación forzada.
			if(!Checks.esNulo(estadoPublicacionActual) && estadoPublicacionActual.getCodigo().equals(DDEstadoPublicacion.CODIGO_DESPUBLICADO)){
				return true; // Enviar True, pero no realizar nada. De otro modo no sigue guardando otros modelos.
			}
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_DESPUBLICADO);
			motivo = dtoCambioEstadoPublicacion.getMotivoDespublicacionForzada();

		} else if(!Checks.esNulo(dtoCambioEstadoPublicacion.getPublicacionForzada()) && dtoCambioEstadoPublicacion.getPublicacionForzada()) { // Publicación forzada.
			if(!Checks.esNulo(estadoPublicacionActual) && estadoPublicacionActual.getCodigo().equals(DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO)){
				return true; // Enviar True, pero no realizar nada. De otro modo no sigue guardando otros modelos.
			}
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO_FORZADO);
			motivo = dtoCambioEstadoPublicacion.getMotivoPublicacion();

		} else if(!Checks.esNulo(dtoCambioEstadoPublicacion.getPublicacionOrdinaria()) && dtoCambioEstadoPublicacion.getPublicacionOrdinaria()){ // Publicación ordinaria.
			// Obtener fecha 'fechaPublicable' del activo para contrastar si ya lo estaba y no repetir acción.
			// Además, una vez publicado, aunque se despublique mantiene la fecha. Así que para permitirle pasar en ese caso se comprueba si su estado actual es despublicado.
			if(Checks.esNulo(activo.getFechaPublicable())) { // Si no tiene fecha de publicación asignarle una y dejarlo en manos del automatismo nocturno.
				activo.setFechaPublicable(new Date());
			} else if(!Checks.esNulo(activo.getFechaPublicable()) && // Si tiene fecha de publicación.
					(!Checks.esNulo(estadoPublicacionActual) && estadoPublicacionActual.getCodigo().equals(DDEstadoPublicacion.CODIGO_PUBLICADO))) { // Y tiene estado anterior.
				return true; // Enviar True, pero no realizar nada. De otro modo no sigue guardando otros modelos.
			} else if(!Checks.esNulo(activo.getFechaPublicable()) && // Si tiene fecha de publicación.
					(!Checks.esNulo(estadoPublicacionActual) && !estadoPublicacionActual.getCodigo().equals(DDEstadoPublicacion.CODIGO_PUBLICADO))) { // Y viene de cualquier otro estado anterior.
				filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_PUBLICADO); // Cambiar estado activo obligatoriamente.
				motivo = dtoCambioEstadoPublicacion.getMotivoPublicacion();
			}
			
		} else { // Deseleccionada cualquier opción.
			if(!Checks.esNulo(estadoPublicacionActual) && estadoPublicacionActual.getCodigo().equals(DDEstadoPublicacion.CODIGO_NO_PUBLICADO)){
				return true; // Enviar True, pero no realizar nada. De otro modo no sigue guardando otros modelos.
			}
			filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoPublicacion.CODIGO_NO_PUBLICADO);
		}

		if(!Checks.esNulo(filtro)){
			estadoPublicacion = genericDao.get(DDEstadoPublicacion.class, filtro);
			activo.setEstadoPublicacion(estadoPublicacion);
		} else {
			// Si no hay filtro seleccionado es por que se quiere publicar ordinariamente.
			// Por lo que las operaciones pertienentes se han realizado antes y no habrá histórico.
			return true;
		}
		
		activoHistoricoEstadoPublicacion.setActivo(activo);
		
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
					dto.setMotivoPublicacion(estado.getMotivo());
					break;
				} else if(DDEstadoPublicacion.CODIGO_PUBLICADO.equals(estado.getEstadoPublicacion().getCodigo())) {
					tipoPublicacionInicial = DDEstadoPublicacion.CODIGO_PUBLICADO;
					dto.setMotivoPublicacion(estado.getMotivo());
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
		} else {
			// Si la lista de historico viene vacia, aun así, comprobar la fecha de publicación del activo. Si está rellena poner estado publicación ordinaria.
			Activo activo = activoApi.get(id);
			if(!Checks.esNulo(activo.getFechaPublicable())) {
				dto.setPublicacionOrdinaria(true);
			}
		}

		return dto;
	}

}