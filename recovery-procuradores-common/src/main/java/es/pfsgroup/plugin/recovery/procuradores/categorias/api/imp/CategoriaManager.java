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
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategoriaApi;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategorizacionApi;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.RelacionCategoriasApi;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dao.CategoriaDao;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategoriaDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categoria;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categorizacion;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategorias;
import es.pfsgroup.plugin.recovery.procuradores.configuracion.api.ConfiguracionDespachoExternoApi;

/**
 * Implementación de la api de {@link Categoria}
 * @author anahuac
 *
 */
@Service("Categoria")
@Transactional(readOnly = false)
public class CategoriaManager implements CategoriaApi {

	@Autowired
	private CategoriaDao categoriaDao;
	
	@Autowired
	private CategorizacionApi categorizacionApi;
	
	@Autowired
	private RelacionCategoriasApi relacionCategoriasApi;
	
	@Autowired
	private ConfiguracionDespachoExternoApi configuracionDespachoExternoApi;

	@Autowired
	private GenericABMDao genericDao;

	
	

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategoriaApi#getListaCategorias(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategoriaDto)
	 */
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIA_GET_LISTA_CATEGORIAS)
	public Page getListaCategorias(CategoriaDto dto) {

		return categoriaDao.getListaCategorias(dto);
	}

	
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategoriaApi#getCategoria(java.lang.Long)
	 */
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIA_GET_CATEGORIA_POR_ID)
	public Categoria getCategoria(Long Id) {
		Filter f = genericDao.createFilter(FilterType.EQUALS, "id", Id);
		return genericDao.get(Categoria.class, f);
		
	}

	
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategoriaApi#getCategoriasByIdcategorizacion(java.lang.Long)
	 */
	@Override
	public List<Categoria> getCategoriasByIdcategorizacion(Long Idcategorizacion) {
		Filter f = genericDao.createFilter(FilterType.EQUALS, "idcategorizacion", Idcategorizacion);
		Order orden = new Order(OrderType.ASC,"orden");
		return genericDao.getListOrdered(Categoria.class,orden, f);		
	}
	
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategorizacionApi#setCategorizacion(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategorizacionDto)
	 */
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIA_SET_CATEGORIA)
	public Categoria setCategoria(CategoriaDto dto) throws BusinessOperationException {

		Categoria categoria = null;

		if(Checks.esNulo(dto.getIdcategorizacion())){
			throw new BusinessOperationException("No se puede crear la categoría porque no se ha pasado el id de la categorización.");
			
		}else{				
			Categorizacion ctg = categorizacionApi.getCategorizacion(dto.getIdcategorizacion());
			if(Checks.esNulo(ctg)){
				throw new BusinessOperationException("No se puede crear la categoría porque no se ha podido obtener la categorización.");
				
			}else{	
				if (Checks.esNulo(dto.getId())) {					
					categoria = new Categoria();
					categoria.setNombre(dto.getNombre());
					categoria.setDescripcion(dto.getDescripcion());
					categoria.setOrden(dto.getOrden());
					categoria.setCategorizacion(ctg);
					categoriaDao.save(categoria);
					
				} else {					
					categoria = getCategoria(dto.getId());
					categoria.setNombre(dto.getNombre());
					categoria.setDescripcion(dto.getDescripcion());
					categoria.setOrden(dto.getOrden());
					categoria.setCategorizacion(ctg);
					categoriaDao.saveOrUpdate(categoria);
					
				}
			}			
		}
		return categoria;
	}
	
	
	
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategoriaApi#comprobarBorradoCategoria(java.lang.Long)
	 */
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIA_COMPROBAR_BORRADO_CATEGORIA)
	public Boolean comprobarBorradoCategoria(Long idcategoria) throws BusinessOperationException{
		Boolean borrar = false;
		
		//Comprobar si tiene elementos relacionados
		if(!Checks.esNulo(idcategoria)){
				
			Filter f = genericDao.createFilter(FilterType.EQUALS, "categoria.id", idcategoria);
			List<RelacionCategorias> listarelcategorias = genericDao.getList(RelacionCategorias.class, f);		
			if(Checks.esNulo(listarelcategorias) || (!Checks.esNulo(listarelcategorias) && listarelcategorias.size()==0)){
				borrar = true;
			}
		}	
		return borrar;
	}
	
	
	
	
	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategoriaApi#borrarCategoria(java.lang.Long)
	 */
	@Override
	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIA_BORRAR_CATEGORIA)
	public void borrarCategoria(Long id) throws BusinessOperationException{
		
		if (Checks.esNulo(id) || (!Checks.esNulo(id) && Checks.esNulo(getCategoria(id)))) {
			throw new BusinessOperationException("No se puede eliminar la categoría porque no se ha pasado el id de la categoría.");
			
		}else{
			//Borramos las Relaciones y la Categoria
			relacionCategoriasApi.borrarRelacionCategoriasByIdCategoria(id);
			categoriaDao.deleteById(id);			
		}	
	}



	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategoriaApi#getListaTotalCategorias(java.lang.Long)
	 */
	@Override
	@BusinessOperation(CategoriaApi.PLUGIN_PROCURADORES_CATEGORIA_GET_LISTA_TOTAL_CATEGORIAS)
	public List<Categoria> getListaTotalCategorias(Long idUsuario) {
		
		List<Categoria> lcategorias = null;
		
		if (!Checks.esNulo(idUsuario)){
			List<GestorDespacho> gestorDespacho = configuracionDespachoExternoApi.buscaDespachosPorUsuarioYTipo(idUsuario, DDTipoDespachoExterno.CODIGO_DESPACHO_EXTERNO);
			
			if((!Checks.esNulo(gestorDespacho) && gestorDespacho.size()>0)){
				DespachoExterno despacho = gestorDespacho.get(0).getDespachoExterno();
				
				if(!Checks.esNulo(despacho)){
					Categorizacion categorizacion = configuracionDespachoExternoApi.getCategorizacionResoluciones(despacho.getId());
				
					if(!Checks.esNulo(categorizacion)){					
						lcategorias = categoriaDao.getListaCategoriasByCategorizacion(categorizacion.getId());
						
					}
				}				
			}			
		}	
		return lcategorias;
	}

}
