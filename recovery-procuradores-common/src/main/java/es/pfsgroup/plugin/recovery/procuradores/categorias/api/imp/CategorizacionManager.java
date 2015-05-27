package es.pfsgroup.plugin.recovery.procuradores.categorias.api.imp;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategoriaApi;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategorizacionApi;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dao.CategorizacionDao;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategorizacionDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categoria;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categorizacion;
import es.pfsgroup.plugin.recovery.procuradores.despachoExternoPro.api.DespachoExternoProApi;

/**
 * Implementación de la api de {@link Categorizacion}
 * @author manuel
 *
 */
@Service("Categorizacion")
@Transactional(readOnly = false)
public class CategorizacionManager  implements CategorizacionApi {

	@Autowired
	private CategorizacionDao categorizacionDao;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private CategoriaApi categoriaApi;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategorizacionApi#getListaCategorizaciones(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategorizacionDto)
	 */
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_CATEGORIZACIONES)
	public Page getListaCategorizaciones(CategorizacionDto dto) {

		return categorizacionDao.getListaCategorizaciones(dto);
	}

	
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategorizacionApi#getCategorizacion(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategorizacionDto)
	 */
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_GET_CATEGORIZACION_POR_ID)
	public Categorizacion getCategorizacion(Long Id) {
		Filter f = genericDao.createFilter(FilterType.EQUALS, "id", Id);
		return genericDao.get(Categorizacion.class, f);
		
	}

	
	
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategorizacionApi#setCategorizacion(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategorizacionDto)
	 */
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_SET_CATEGORIZACION)
	public Categorizacion setCategorizacion(CategorizacionDto dto) throws BusinessOperationException {

		Categorizacion categorizacion = null;
		
		if(Checks.esNulo(dto.getIdDespExt())){
			throw new BusinessOperationException("No se puede crear la categorizacion porque no se ha pasado el despacho externo.");
			
		}else{	
			DespachoExterno desp = this.getDespachoExterno(dto.getIdDespExt());
			if(Checks.esNulo(desp)){
				throw new BusinessOperationException("No se puede crear la categorizacion porque no se ha podido obtener el despacho externo.");
				
			}else{	
				
		
				if (Checks.esNulo(dto.getId())) {
					
					categorizacion = new Categorizacion();
					categorizacion.setNombre(dto.getNombre());
					categorizacion.setCodigo(dto.getCodigo());
					categorizacion.setDespachoExterno(desp);;
					categorizacionDao.save(categorizacion);
					
				} else {
					
					categorizacion = getCategorizacion(dto.getId());
					categorizacion.setNombre(dto.getNombre());
					categorizacion.setCodigo(dto.getCodigo());
					categorizacion.setDespachoExterno(desp);;
					categorizacionDao.saveOrUpdate(categorizacion);
					
				}
				
			}
		}
		
		return categorizacion;
	}
	
	
	
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategorizacionApi#borrarCategorizacion(java.lang.Long)
	 */
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_COMPROBAR_BORRADO_CATEGORIZACION)
	public Boolean comprobarBorradoCategorizacion(Long idcategorizacion) throws BusinessOperationException {
		Boolean borrar = false;
		
		//Comprobar si tiene categorías relacionados
		if(!Checks.esNulo(idcategorizacion)){
				
			Filter f = genericDao.createFilter(FilterType.EQUALS, "categorizacion.id", idcategorizacion);	
			List<Categoria> listactg = genericDao.getList(Categoria.class, f);
			
			if(Checks.esNulo(listactg) || (!Checks.esNulo(listactg) && listactg.size()==0)){
				borrar = true;
			}
		}	
		return borrar;			
	}
		
	
	
	
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategorizacionApi#borrarCategorizacion(java.lang.Long)
	 */
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_BORRAR_CATEGORIZACION)
	public void borrarCategorizacion(Long idCategorizacion) throws BusinessOperationException {
		
		if (Checks.esNulo(idCategorizacion) || (!Checks.esNulo(idCategorizacion) && Checks.esNulo(getCategorizacion(idCategorizacion)))) {
			throw new BusinessOperationException("No se ha pasado el id de la categorización.");
			
		}else{
				
			//Borramos las categorías asociadas a la categorización
			Filter f = genericDao.createFilter(FilterType.EQUALS, "categorizacion.id", idCategorizacion);	
			List<Categoria> listacategorias = genericDao.getList(Categoria.class, f);
			
			if(listacategorias != null && listacategorias.size()>0){			
				for(int i=0; i<listacategorias.size(); i++){
					if(listacategorias.get(i) != null && listacategorias.get(i).getId() != null)
					categoriaApi.borrarCategoria(listacategorias.get(i).getId());
				}
			}
			
			//Borramos la Categorización
			categorizacionDao.deleteById(idCategorizacion);				
		}
	}

	

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategorizacionApi#getListaDespachosExternos(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategorizacionDto)
	 */
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_DESPACHOS_EXTERNOS)
	public List<DespachoExterno>  getListaDespachosExternos(CategorizacionDto dto){

		Filter filtroTipoDespacho = genericDao.createFilter(FilterType.EQUALS,"tipoDespacho.codigo", DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO);		
		Order orderTipoDespacho = new Order(OrderType.ASC,"despacho");
		return genericDao.getListOrdered(DespachoExterno.class,orderTipoDespacho, filtroTipoDespacho);		
	}
	
	
	
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategorizacionApi#getDespachoExterno(java.lang.Long)
	 */
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_GET_DESPACHO_EXTERNO)
	public DespachoExterno getDespachoExterno(Long idDespachoExt){
		Filter filtroTipoDespacho = genericDao.createFilter(FilterType.EQUALS,"id", idDespachoExt);		
		return genericDao.get(DespachoExterno.class, filtroTipoDespacho);		

	}

	
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_GET_PAGE_DESPACHO_EXTERNO)
	public Page getPageDespachoExterno(CategorizacionDto dto, String nombre){
		return proxyFactory.proxy(DespachoExternoProApi.class).getPageDespachoExterno(dto,nombre);
	}

}
