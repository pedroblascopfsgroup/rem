package es.pfsgroup.plugin.recovery.procuradores.categorias.api.imp;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoJuicio;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoResolucion;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.CategoriaApi;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.RelacionCategoriaResolucionApi;
import es.pfsgroup.plugin.recovery.procuradores.categorias.api.RelacionCategoriasApi;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dao.CategoriaDao;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dao.RelacionCategoriaResolucionDao;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dao.RelacionCategoriasDao;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriaResolucionDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriasDto;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categoria;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategoriaResolucion;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategorias;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategoriasTareaProcedimiento;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategoriasTipoResolucion;

/**
 * Implementación de la api de {@link RelacionCategoriasApi}
 * @author anahuac
 *
 */
@Service("CategoriaResolucion")
@Transactional(readOnly = false)
public class RelacionCategoriaResolucionManager  implements RelacionCategoriaResolucionApi{
	
	@Autowired
	private RelacionCategoriaResolucionDao relacionCategoriaResolucionDao;
	
	@Override
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIAS_GUARDAR_RELACION_CATEGORIAS_RESOLUCION)
	public RelacionCategoriaResolucion guardarRelacionCategoriaResolucion(RelacionCategoriaResolucionDto dto) throws BusinessOperationException{
			
		RelacionCategoriaResolucion rel= null;
		
		if (Checks.esNulo(dto.getResolucion())){	
			throw new BusinessOperationException("No se ha pasado la resolucion.");
			
		}else if (Checks.esNulo(dto.getCategoria())){
			throw new BusinessOperationException("No se ha pasado la categoría.");
			
		}else{
			
			///Buscamos las relaciones de la resolucion
			RelacionCategoriaResolucionDto dtores = new RelacionCategoriaResolucionDto();
			dtores.setResolucion(dto.getResolucion());
			
			rel = relacionCategoriaResolucionDao.getRelacionCategoriaResolucion(dtores);
			
			if(!Checks.esNulo(rel)){
				////Update relacion
				rel.setCategoria(dto.getCategoria());
				relacionCategoriaResolucionDao.saveOrUpdate(rel);
				
			}else{
				////Nueva relacion
				rel = new RelacionCategoriaResolucion();
				rel.setResolucion(dto.getResolucion());
				rel.setCategoria(dto.getCategoria());
				relacionCategoriaResolucionDao.save(rel);
			}

		}
		
		return rel;
		
	}
	
	@Override
	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIAS_BORRAR_RELACION_CATEGORIAS_RESOLUCION)
	public RelacionCategoriaResolucion borrarRelacionCategoriaResolucion(RelacionCategoriaResolucionDto dto) throws BusinessOperationException{
			
		RelacionCategoriaResolucion rel= null;
		
		if (Checks.esNulo(dto.getResolucion())){	
			throw new BusinessOperationException("No se ha pasado la resolucion.");
			
		}else{
			
			rel = relacionCategoriaResolucionDao.getRelacionCategoriaResolucion(dto);
			if(!Checks.esNulo(rel)){
				relacionCategoriaResolucionDao.deleteById(rel.getId());
			}
			
		}
		
		return rel;
		
	}

//	@Autowired
//	private RelacionCategoriasDao relacionCategoriasDao;
//	
//	@Autowired
//	private CategoriaApi categoriaApi;
//	
//	@Autowired
//	private GenericABMDao genericDao;
//
//
//	
//	/* (non-Javadoc)
//	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.RelacionCategoriasApi#getListaProcedimientos()
//	 */
//	@Override
//	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_PROCEDIMIENTOS)
//	public List<TipoProcedimiento>  getListaProcedimientos(){
//		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", new Boolean(false));
//		Order orden = new Order(OrderType.ASC,"descripcion");
//		List<TipoProcedimiento> lista = genericDao.getListOrdered(TipoProcedimiento.class, orden, filtro);
//		return lista;	
//	}
//	
//	
//	/* (non-Javadoc)
//	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.RelacionCategoriasApi#getListaProcedimientos()
//	 */
//	@Override
//	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_PROCEDIMIENTOS_CATEGORIZABLES)
//	public List<TipoProcedimiento>  getListaProcedimientosCategorizables(){
//		
//		List<TipoProcedimiento> lista = new ArrayList<TipoProcedimiento>();
//
//		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "categorizar", new Boolean(true));
//		Order orden = new Order(OrderType.ASC,"codigo");
//		List<MSVDDTipoResolucion> resoluciones = genericDao.getListOrdered(MSVDDTipoResolucion.class, orden, filtro);
//		
//		for(MSVDDTipoResolucion res : resoluciones){
//			lista.add(res.getTipoJuicio().getTipoProcedimiento());
//		}
//		
//		return lista;	
//	}
//	
//	
//	/* (non-Javadoc)
//	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.RelacionCategoriasApi#getTareasProcedimiento(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriasDto)
//	 */
//	@Override
//	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_GET_TAREAS_PROCEDIMIENTO)
//	public List<TareaProcedimiento>  getTareasProcedimiento(RelacionCategoriasDto dto){
//		
//		List<TareaProcedimiento> lista = null;
//		
//		if (!Checks.esNulo(dto.getIdtramite())){	
//			Filter filtroProc = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdtramite());
//			TipoProcedimiento procedimiento = genericDao.get(TipoProcedimiento.class, filtroProc);
//	
//			if(procedimiento != null){
//				Filter f = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimiento", procedimiento);
//				Order orden = new Order(OrderType.ASC,"descripcion");
//				lista = genericDao.getListOrdered(TareaProcedimiento.class, orden, f);		
//			}
//		}
//		
//		return lista;
//	}
//
//	
//	/* (non-Javadoc)
//	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.RelacionCategoriasApi#getListaTareasConRelacionCategorias(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriasDto)
//	 */
//	@Override
//	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_TAREAS_CON_RELACION_CATEGORIAS)
//	public List<TareaProcedimiento>  getListaTareasConRelacionCategorias(RelacionCategoriasDto dto){
//		
//		List<TareaProcedimiento> listaTareasAsignadas = new ArrayList<TareaProcedimiento>();
//		
//		List<RelacionCategorias> listaRelacion = relacionCategoriasDao.getListaRelacionCategorias(dto);
//		
//		for(int j=0; j <listaRelacion.size(); j++){
//			RelacionCategorias tareaAsig = listaRelacion.get(j);
//			TareaProcedimiento task = (TareaProcedimiento)tareaAsig.getEntity();				
//			listaTareasAsignadas.add(task);
//		}
//		return listaTareasAsignadas;				
//	}
//
//	
//	
//	/* (non-Javadoc)
//	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.RelacionCategoriasApi#getListaTareasSinRelacionCategorias(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriasDto)
//	 */
//	@Override
//	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_TAREAS_SIN_RELACION_CATEGORIAS)
//	public List<TareaProcedimiento> getListaTareasSinRelacionCategorias(RelacionCategoriasDto dto){
//
//		List<TareaProcedimiento> lista = new ArrayList<TareaProcedimiento>();
//		List<TareaProcedimiento> listaTareasAsignadas = new ArrayList<TareaProcedimiento>();
//		
//		if(dto.getTipoRelacion() != null && RelacionCategoriasDto.TIPO_RELACION_TAREASPROC.equals(dto.getTipoRelacion())){
//			
//			//Obtenemos todas las tareas del procedimiento elegido
//			lista = this.getTareasProcedimiento(dto);		
//			
//			//Obtenemos las RelacionesCategorias del procedimiento elegido
//			List<RelacionCategorias> tareasTramiteAsignadas = relacionCategoriasDao.getListaRelacionCategorias(dto);
//
//			for(int j=0; j <tareasTramiteAsignadas.size(); j++){
//				RelacionCategorias tareaAsig = tareasTramiteAsignadas.get(j);
//				TareaProcedimiento task = (TareaProcedimiento)tareaAsig.getEntity();				
//				listaTareasAsignadas.add(task);
//			}
//			
//			//Quitamos de la lista de tareas del procedimiento elegido las tareas asignadas
//			lista.removeAll(listaTareasAsignadas);
//						
//		}
//		
//		return lista;
//	}
//
//	
//	
//	
//	
//	/* (non-Javadoc)
//	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.RelacionCategoriasApi#guardarRelacionCategorias(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriasDto)
//	 */
//	@Override
//	@BusinessOperationDefinition(PLUGIN_PROCURADORES_CATEGORIZACION_GUARDAR_RELACION_CATEGORIAS)
//	public RelacionCategorias guardarRelacionCategorias(RelacionCategoriasDto dto) throws BusinessOperationException{
//			
//		RelacionCategorias relCategoria = null;
//		
//		if (Checks.esNulo(dto.getIdcategoria())){	
//			throw new BusinessOperationException("No se ha pasado el id de la categoría.");
//			
//		}else if (Checks.esNulo(dto.getTipoRelacion())){
//			throw new BusinessOperationException("No se ha pasado el id del tipo de relación.");
//			
//		}else{
//			
//			//Guardar RelacionCategoriasTareasProc
//			if (RelacionCategoriasDto.TIPO_RELACION_TAREASPROC.equals(dto.getTipoRelacion())) {			
//			 
//				if(Checks.esNulo(dto.getIdtap())) {	
//					throw new BusinessOperationException("No se ha pasado el id de la tarea.");
//					
//				}else{				
//					Categoria categoria = categoriaApi.getCategoria(dto.getIdcategoria());					
//					Filter f = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdtap());
//					TareaProcedimiento tareaProc = genericDao.get(TareaProcedimiento.class, f);	
//					
//					if(!Checks.esNulo(categoria) && !Checks.esNulo(tareaProc)){										
//						RelacionCategoriasTareaProcedimiento relCategoriaTP = new RelacionCategoriasTareaProcedimiento();							
//						relCategoriaTP.setCategoria(categoria);
//						relCategoriaTP.setTareaProcedimiento(tareaProc);						
//						relacionCategoriasDao.save(relCategoriaTP);
//						relCategoria = relCategoriaTP;
//					}
//				}	
//			}
//			
//			//Guardar RelacionCategoriasTipoResolucion
//			if (RelacionCategoriasDto.TIPO_RELACION_TIPORESOL.equals(dto.getTipoRelacion())) {			
//				
//				if(Checks.esNulo(dto.getIdtiporesolucion())) {	
//					throw new BusinessOperationException("No se ha pasado el id de la resolucion.");
//					
//				}else{
//					Categoria categoria = categoriaApi.getCategoria(dto.getIdcategoria());					
//					Filter f = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdtiporesolucion());
//					MSVDDTipoResolucion tipoRes = genericDao.get(MSVDDTipoResolucion.class, f);	
//					
//					if(!Checks.esNulo(categoria) && !Checks.esNulo(tipoRes)){										
//						RelacionCategoriasTipoResolucion relCategoriaTR = new RelacionCategoriasTipoResolucion();							
//						relCategoriaTR.setCategoria(categoria);
//						relCategoriaTR.setMSVDDTipoResolucion(tipoRes);						
//						relacionCategoriasDao.save(relCategoriaTR);
//						relCategoria = relCategoriaTR;
//					}
//				}
//			}
//		}
//		
//		return relCategoria;
//		
//	}
//
//
//
//	
//	/* (non-Javadoc)
//	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.RelacionCategoriasApi#borrarRelacionCategorias(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriasDto)
//	 */
//	@Override
//	public RelacionCategorias borrarRelacionCategorias(RelacionCategoriasDto dto) throws BusinessOperationException {
//		
//		RelacionCategorias relCategoria = null;
//		
//		if (Checks.esNulo(dto.getIdcategoria())){	
//			throw new BusinessOperationException("No se ha pasado el id de la categoría.");
//			
//		}else if (Checks.esNulo(dto.getTipoRelacion())){
//			throw new BusinessOperationException("No se ha pasado el id del tipo de relación.");
//			
//		}else{
//			
//			//Borrar RelacionCategorias
//			if (RelacionCategoriasDto.TIPO_RELACION_TAREASPROC.equals(dto.getTipoRelacion()) && Checks.esNulo(dto.getIdtap())) {			
//				throw new BusinessOperationException("No se ha pasado el id de la tarea.");
//			
//			}else if (RelacionCategoriasDto.TIPO_RELACION_TIPORESOL.equals(dto.getTipoRelacion()) && Checks.esNulo(dto.getTipoRelacion())) {	
//				throw new BusinessOperationException("No se ha pasado el id de la resolucion.");
//			
//			}else{
//				
//				List<RelacionCategorias> listaRelacion = relacionCategoriasDao.getListaRelacionCategorias(dto);					
//				if(listaRelacion != null && listaRelacion.size()>0){
//					for(int i=0; i<listaRelacion.size(); i++){
//						if(listaRelacion.get(i) !=null){
//							relCategoria = listaRelacion.get(i);
//							relacionCategoriasDao.deleteRelacionCategorias(relCategoria);
//						}
//					}
//				}		
//			}					
//		}
//		
//		return relCategoria;
//		
//	}
//
//	
//	
//	/* (non-Javadoc)
//	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.RelacionCategoriasApi#borrarRelacionCategoriasByIdCategoria(java.lang.Long)
//	 */
//	@Override
//	public void borrarRelacionCategoriasByIdCategoria(Long idcategoria) throws BusinessOperationException {	
//		
//		if (Checks.esNulo(idcategoria)){	
//			throw new BusinessOperationException("No se ha pasado el id de la categoría.");
//			
//		}else{
//				
//			Filter f = genericDao.createFilter(FilterType.EQUALS, "id", idcategoria);
//			Categoria cat = genericDao.get(Categoria.class, f);	
//			if(cat != null){
//				
//				RelacionCategoriasDto dto = new RelacionCategoriasDto();
//				dto.setIdcategoria(cat.getId());
//				
//				List<RelacionCategorias> listaRelaciones = relacionCategoriasDao.getListaRelacionCategorias(dto);					
//				if(listaRelaciones != null && listaRelaciones.size()>0){
//					for(int i=0; i<listaRelaciones.size(); i++){
//						if(listaRelaciones.get(i) !=null){
//							relacionCategoriasDao.deleteRelacionCategorias(listaRelaciones.get(i));
//						}
//					}
//				}
//			}
//		}	
//	}
//
//
//	
//	
//	/* (non-Javadoc)
//	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.RelacionCategoriasApi#getTiposResoluciones(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriasDto)
//	 */
//	@Override
//	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_GET_TIPOS_RESOLUCIONES)
//	public List<MSVDDTipoResolucion> getTiposResoluciones(RelacionCategoriasDto dto){
//		
//		List<MSVDDTipoResolucion> lista = null;
//				
//		Filter filtroProc = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdtramite());
//		TipoProcedimiento procedimiento = genericDao.get(TipoProcedimiento.class, filtroProc);
//
//		if(procedimiento != null){
//						
//			Filter f = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimiento", procedimiento);
//			MSVDDTipoJuicio tipoJuicio = genericDao.get(MSVDDTipoJuicio.class, f);
//			
//			if(tipoJuicio != null){
//				Filter f2 = genericDao.createFilter(FilterType.EQUALS, "tipoJuicio", tipoJuicio);
//				Order orden = new Order(OrderType.ASC,"descripcion");
//				lista = genericDao.getListOrdered(MSVDDTipoResolucion.class, orden, f2);	
//			}
//		}
//		
//		return lista;
//	}
//
//	
//	
//	
//	/* (non-Javadoc)
//	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.RelacionCategoriasApi#getListaTiposResolConRelacionCategorias(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriasDto)
//	 */
//	@Override
//	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_TIPOSRESOL_CON_RELACION_CATEGORIAS)
//	public List<MSVDDTipoResolucion> getListaTiposResolConRelacionCategorias(RelacionCategoriasDto dto) {
//		List<MSVDDTipoResolucion> listaTiposResolAsignadas = new ArrayList<MSVDDTipoResolucion>();
//		
//		List<RelacionCategorias> listaRelacion = relacionCategoriasDao.getListaRelacionCategorias(dto);
//		
//		for(int j=0; j <listaRelacion.size(); j++){
//			RelacionCategorias tipoResolAsig = listaRelacion.get(j);
//			MSVDDTipoResolucion resol = (MSVDDTipoResolucion)tipoResolAsig.getEntity();				
//			listaTiposResolAsignadas.add(resol);
//		}
//		return listaTiposResolAsignadas;		
//	}
//
//
//
//	/* (non-Javadoc)
//	 * @see es.pfsgroup.plugin.recovery.procuradores.categorias.api.RelacionCategoriasApi#getListaTiposResolSinRelacionCategorias(es.pfsgroup.plugin.recovery.procuradores.categorias.dto.RelacionCategoriasDto)
//	 */
//	@Override
//	@BusinessOperation(PLUGIN_PROCURADORES_CATEGORIZACION_GET_LISTA_TIPOSRESOL_SIN_RELACION_CATEGORIAS)
//	public List<MSVDDTipoResolucion> getListaTiposResolSinRelacionCategorias(RelacionCategoriasDto dto) {
//		List<MSVDDTipoResolucion> lista = new ArrayList<MSVDDTipoResolucion>();
//		
//		List<MSVDDTipoResolucion> listaTiposResolAsignadas = new ArrayList<MSVDDTipoResolucion>();
//		
//		if(dto.getTipoRelacion() != null && RelacionCategoriasDto.TIPO_RELACION_TIPORESOL.equals(dto.getTipoRelacion())){
//			
//			//Obtenemos todas las tipos de resoluciones del procedimiento elegido
//			lista = this.getTiposResoluciones(dto);
//			List<MSVDDTipoResolucion> listaClonada = new ArrayList<MSVDDTipoResolucion>();
//			if (lista != null && lista.size() > 0){
//				for(int i=0; i <lista.size(); i++){
//					MSVDDTipoResolucion tipoResol = lista.get(i);				
//					if(!tipoResol.getCategorizar()){
//						listaClonada.add(tipoResol);
//					}
//				}
//				
//				lista.removeAll(listaClonada);
//				
//				//Obtenemos las RelacionesCategorias del procedimiento elegido
//				List<RelacionCategorias> tiposResolTramiteAsignadas = relacionCategoriasDao.getListaRelacionCategorias(dto);
//	
//				for(int j=0; j <tiposResolTramiteAsignadas.size(); j++){
//					RelacionCategorias tiposResolAsig = tiposResolTramiteAsignadas.get(j);
//					MSVDDTipoResolucion tipoResol = (MSVDDTipoResolucion)tiposResolAsig.getEntity();				
//					listaTiposResolAsignadas.add(tipoResol);
//				}
//				
//				//Quitamos de la lista de tipos de resoluciones del procedimiento elegido los tipos de resoluciones asignados
//				lista.removeAll(listaTiposResolAsignadas);
//							
//			}
//		}
//		
//		return lista;
//	}
//
//	


}
