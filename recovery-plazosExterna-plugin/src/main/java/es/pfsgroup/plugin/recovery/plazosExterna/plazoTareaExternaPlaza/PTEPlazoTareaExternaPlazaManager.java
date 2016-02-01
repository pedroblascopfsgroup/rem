package es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.scripting.ScriptEvaluator;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.plazosExterna.PluginPlazosExternaBusinessOperations;
import es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.dao.PTEPlazoTareaExternaPlazaDao;
import es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.dto.PTEDtoBusquedaPlazo;
import es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.dto.PTEDtoPlazoTarea;
import es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.dto.PTEDtoQuery;
import es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.model.PTEPlazoTareaExternaPlaza;
import es.pfsgroup.plugin.recovery.plazosExterna.tipoJuzgado.dao.PTETipoJuzgadoDao;

@Service("PTEPlazaTareaExternaPlazaManager")
public class PTEPlazoTareaExternaPlazaManager {
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ScriptEvaluator evaluator;
	
	@Autowired
	private PTEPlazoTareaExternaPlazaDao plazoTareaExternaDao;
	
	@Autowired
	private PTETipoJuzgadoDao tipoJuzgadoDao;
	
	private static class Pagina implements Page{
        List<?> resultados;
        
        public Pagina (List<?> resultados){
              this.resultados = resultados;
        }

        @Override
        public List<?> getResults() {
              return resultados;
        }

        @Override
        public int getTotalCount() {
              if (resultados == null) return 0;
              return resultados.size();
        }
        
  }

	
	@BusinessOperation(PluginPlazosExternaBusinessOperations.PTE_MGR_GETTIPOSPROC)
	public List<TipoProcedimiento> listaTiposProcedimiento(){
		EventFactory.onMethodStart(this.getClass());
		List<TipoProcedimiento> lista = genericDao.getList(TipoProcedimiento.class);
		EventFactory.onMethodStop(this.getClass());
		return lista;
	}
	
	@BusinessOperation(PluginPlazosExternaBusinessOperations.PTE_MGR_GETTAREASPROCEDIMIENTO)
	public List<TareaProcedimiento> listaSubTiposTarea(){
		List<TareaProcedimiento> lista = genericDao.getList(TareaProcedimiento.class);
		return lista;
	}
	
	@BusinessOperation(PluginPlazosExternaBusinessOperations.PTE_MGR_LISTAJUZGADOS)
	public List<TipoJuzgado> listaJuzgados(){
		List<TipoJuzgado> lista= genericDao.getList(TipoJuzgado.class);
		return lista;
	}
	
	@BusinessOperation(PluginPlazosExternaBusinessOperations.PTE_MGR_LISTAPLAZAS)
	public List<TipoPlaza> listaPlazas(){
		List<TipoPlaza> lista = genericDao.getList(TipoPlaza.class);
		return lista;
	}
	
	/*
	@BusinessOperation(PluginPlazosExternaBusinessOperations.PTE_MGR_BUSCAPLAZOS)
	public List<PTEDtoPlazoTarea> buscaPlazos(PTEDtoBusquedaPlazo dto){
		List<PlazoTareaExternaPlaza> resultado = plazoTareaExternaDao.findPlazos(dto);
		//List<PlazoTareaExternaPlaza> resultado = genericDao.getList(PlazoTareaExternaPlaza.class);
		List<PTEDtoPlazoTarea> listaMapeada = new ArrayList<PTEDtoPlazoTarea>();
		for(PlazoTareaExternaPlaza plazo : resultado ){
			PTEDtoPlazoTarea dtoPlazo = new PTEDtoPlazoTarea();
			dtoPlazo.setId(plazo.getId());
			Filter filtroTareaProcedimiento = genericDao.createFilter(FilterType.EQUALS, "id", plazo.getIdTareaProcedimiento());
			TareaProcedimiento tarea =genericDao.get(TareaProcedimiento.class, filtroTareaProcedimiento);
			dtoPlazo.setIdTareaProcedimiento(tarea.getId());
			dtoPlazo.setNombreTareaProcedimiento(tarea.getDescripcion());
			Filter filtroProcedimiento = genericDao.createFilter(FilterType.EQUALS, "id", tarea.getTipoProcedimiento().getId() );
			TipoProcedimiento tipoProcedimiento = genericDao.get(TipoProcedimiento.class, filtroProcedimiento);
			dtoPlazo.setIdProcedimiento(tipoProcedimiento.getId());
			dtoPlazo.setNombreProcedimiento(tipoProcedimiento.getDescripcion());
			if (!Checks.esNulo(plazo.getIdTipoJuzgado())){
				dtoPlazo.setIdTipoJuzgado(plazo.getIdTipoJuzgado());
				Filter filtroTipoJuzgado = genericDao.createFilter(FilterType.EQUALS, "id", plazo.getIdTipoJuzgado());
				TipoJuzgado tipoJuzgado= genericDao.get(TipoJuzgado.class, filtroTipoJuzgado);
				dtoPlazo.setNombreTipoJuzgado(tipoJuzgado.getDescripcion());
			}
			if(!Checks.esNulo(plazo.getIdTipoPlaza())){
				dtoPlazo.setIdTipoPlaza(plazo.getIdTipoPlaza());
				Filter filtroTipoPlaza = genericDao.createFilter(FilterType.EQUALS, "id", plazo.getIdTipoPlaza());
				TipoPlaza tipoPlaza = genericDao.get(TipoPlaza.class, filtroTipoPlaza);
				dtoPlazo.setNombreTipoPlaza(tipoPlaza.getDescripcion());
				
			}
			dtoPlazo.setScriptPlazo(plazo.getScriptPlazo());
			listaMapeada.add(dtoPlazo);
		}
		return listaMapeada;
		
	}*/
	
	

	
	
	
	@BusinessOperation(PluginPlazosExternaBusinessOperations.PTE_MGR_BUSCAPLAZOS)
	public Page buscaPlazos(PTEDtoBusquedaPlazo dto){
		EventFactory.onMethodStart(this.getClass());
		
		List<PTEPlazoTareaExternaPlaza> listaPlazos = plazoTareaExternaDao.findPlazos(dto);
		List<PTEDtoPlazoTarea> listaMapeada = new ArrayList<PTEDtoPlazoTarea>();
		for(PTEPlazoTareaExternaPlaza pte : listaPlazos){
			PTEDtoPlazoTarea dtoPlazo = new PTEDtoPlazoTarea();
			dtoPlazo.setId( pte.getId());
			dtoPlazo.setIdTareaProcedimiento(pte.getTareaProcedimiento().getId());
			dtoPlazo.setNombreTareaProcedimiento(pte.getTareaProcedimiento().getDescripcion());
			dtoPlazo.setIdProcedimiento(pte.getTareaProcedimiento().getTipoProcedimiento().getId());
			dtoPlazo.setNombreProcedimiento(pte.getTareaProcedimiento().getTipoProcedimiento().getDescripcion());
			if(!Checks.esNulo(pte.getTipoJuzgado())){
				dtoPlazo.setIdTipoJuzgado(pte.getTipoJuzgado().getId());
				dtoPlazo.setNombreTipoJuzgado(pte.getTipoJuzgado().getDescripcion());
			}
			if(!Checks.esNulo(pte.getTipoPlaza())){
				dtoPlazo.setIdTipoPlaza(pte.getTipoPlaza().getCodigo());
				dtoPlazo.setNombreTipoPlaza(pte.getTipoPlaza().getDescripcion());
			}
			dtoPlazo.setObservaciones(pte.getObservaciones());
			dtoPlazo.setAbsoluto(pte.getAbsoluto());
			String plazo = pte.getScriptPlazo();
			try {
				Long l = ((Long)evaluator.evaluate(plazo, null)) / (24*60*60*1000L);
				dtoPlazo.setScriptPlazo(l+"");
			} catch (Exception e) {
				dtoPlazo.setScriptPlazo("Tiene dependencia con otras tareas");
			}
			listaMapeada.add(dtoPlazo);
		}
		Pagina pagina = new Pagina(listaMapeada);
		
		EventFactory.onMethodStop(this.getClass());
		return pagina;
		
	}
	
	@BusinessOperation(PluginPlazosExternaBusinessOperations.PTE_MGR_BUSCAJUZGADOSPLAZA)
	public List<TipoJuzgado> buscaJuzgadosPorPlaza(String codigo){
		Filter filtroJuzgado = genericDao.createFilter(FilterType.EQUALS, "plaza.codigo", codigo);
		List<TipoJuzgado> listaJuzgados = genericDao.getList(TipoJuzgado.class, filtroJuzgado);
		return listaJuzgados;
	}
	
		/*
	@BusinessOperation(PluginPlazosExternaBusinessOperations.PTE_MGR_BUSCAPLAZOS)
	public Page buscaPlazos(PTEDtoBusquedaPlazo dto){
		Page sinMapeo = plazoTareaExternaDao.findPlazos(dto);
		for(PTEPlazoTareaExternaPlaza pte : sinMapeo.getResults())
	}}*/
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginPlazosExternaBusinessOperations.PTE_MGR_GUARDAPLAZO)
	public void guardaPlazoTareaExterna(PTEDtoPlazoTarea dto){
		PTEPlazoTareaExternaPlaza plazo ;
		
		if (Checks.esNulo(dto.getId())){
			List<PTEPlazoTareaExternaPlaza> existe = plazoTareaExternaDao.compruebaExistePlazo(dto);
			if (!Checks.estaVacio(existe)){
				throw new IllegalArgumentException("Ya existe el plazo que desea crear");
			}
			plazo = new PTEPlazoTareaExternaPlaza();
			if(!Checks.esNulo(dto.getIdTipoPlaza())){
				Filter filtroPlaza = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getIdTipoPlaza());
				TipoPlaza tipoPlaza = genericDao.get(TipoPlaza.class, filtroPlaza);	
				plazo.setTipoPlaza(tipoPlaza);
			}
			if(!Checks.esNulo(dto.getIdTipoJuzgado())){
				Filter filtroJuzgado = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdTipoJuzgado());
				TipoJuzgado tipoJuzgado = genericDao.get(TipoJuzgado.class, filtroJuzgado);
				plazo.setTipoJuzgado(tipoJuzgado);
			}
			Filter filtroTarea = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdTareaProcedimiento());
			TareaProcedimiento tareaProcedimiento = genericDao.get(TareaProcedimiento.class, filtroTarea);	
			plazo.setTareaProcedimiento(tareaProcedimiento);
			
		}else{
			
			Filter filtroPlazoId = genericDao.createFilter(FilterType.EQUALS, "id", dto.getId());
			plazo = genericDao.get(PTEPlazoTareaExternaPlaza.class, filtroPlazoId);	
			if(!Checks.esNulo(plazo.getTipoPlaza())|| !Checks.esNulo(plazo.getTipoJuzgado())){
				if(!Checks.esNulo(dto.getIdTipoPlaza())){
					Filter filtroPlaza = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getIdTipoPlaza());
					TipoPlaza tipoPlaza = genericDao.get(TipoPlaza.class, filtroPlaza);	
					plazo.setTipoPlaza(tipoPlaza);
				}
				if(!Checks.esNulo(dto.getIdTipoJuzgado())){
					Filter filtroJuzgado = genericDao.createFilter(FilterType.EQUALS, "id", dto.getIdTipoJuzgado());
					TipoJuzgado tipoJuzgado = genericDao.get(TipoJuzgado.class, filtroJuzgado);
					plazo.setTipoJuzgado(tipoJuzgado);
				}
			}
		}
		if (dto.getScriptPlazo().length()<20){
			plazo.setAbsoluto(true);
		}else{
			plazo.setAbsoluto(false);
		}
		if (dto.getScriptPlazo().length()<5){
			plazo.setScriptPlazo(dto.getScriptPlazo()+"*24*60*60*1000L");
		}else{
			plazo.setScriptPlazo(dto.getScriptPlazo());
		}
		
		plazo.setObservaciones(dto.getObservaciones());
		genericDao.save(PTEPlazoTareaExternaPlaza.class, plazo);
	}
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginPlazosExternaBusinessOperations.PTE_MGR_BORRAPLAZO)
	public void borraPlazo(Long id){
		if (id==null){
			throw new IllegalArgumentException("El id no puede ser null");
		}
		Filter filtroPlazoId = genericDao.createFilter(FilterType.EQUALS, "id", id);
		PTEPlazoTareaExternaPlaza plazo =genericDao.get(PTEPlazoTareaExternaPlaza.class, filtroPlazoId);
		if(plazo==null){
			throw new BusinessOperationException("no existe el plazo que se desea borrar");
		}
		if (Checks.esNulo(plazo.getTipoJuzgado())&& Checks.esNulo(plazo.getTipoPlaza()) ){
			throw new BusinessOperationException("El plazo no se puede eliminar porque es el plazo por defecto");
		}else{
			genericDao.deleteById(PTEPlazoTareaExternaPlaza.class, id);
		}
	}
	
	/**
	 * 
	 * @param id del procedimiento
	 * @return lista de todas las tareas que pertenecen a ese procedimiento
	 */
	@BusinessOperation(PluginPlazosExternaBusinessOperations.PTE_MGR_BUSCATAREAS)
	public List<TareaProcedimiento> buscaTareas (Long id){
		Filter filtroProcedimiento = genericDao.createFilter(FilterType.EQUALS, "tipoProcedimiento.id", id);
		List<TareaProcedimiento> listaTareas = genericDao.getList(TareaProcedimiento.class,filtroProcedimiento);
		return listaTareas;
	}
	
	/**
	 * 
	 * @param id de la tarea
	 * @return lista de todos los tipos date que pertenecen a ese tarea
	 */
	@BusinessOperation(PluginPlazosExternaBusinessOperations.PTE_MGR_BUSCATFI)
	public List<GenericFormItem> buscaTareasTfi (Long idTarea){
		Filter filtroTarea = genericDao.createFilter(FilterType.EQUALS, "tareaProcedimiento.id", idTarea);
		Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "type", "date");
		
		List<GenericFormItem> items = genericDao.getList(GenericFormItem.class, filtroTarea, filtroTipo);
		return items;
	}
	
	@BusinessOperation(PluginPlazosExternaBusinessOperations.PTE_MGR_GETPLAZO)
	public PTEPlazoTareaExternaPlaza getPlazo(Long id){
		EventFactory.onMethodStart(this.getClass());
		
		if (id == null){
			throw new IllegalArgumentException(
					"El argumento de entrada no es válido");
		}
		Filter filtroPlazo = genericDao.createFilter(FilterType.EQUALS, "id", id);
		PTEPlazoTareaExternaPlaza plazo = genericDao.get(PTEPlazoTareaExternaPlaza.class, filtroPlazo);
		if(plazo==null){
			throw new BusinessOperationException(
					"No existe el plazo buscado");
		}
		
		EventFactory.onMethodStop(this.getClass());
		return plazo;
	}
	
	@BusinessOperation(PluginPlazosExternaBusinessOperations.PTE_MGR_GETPROCEDIMIENTO)
	public TipoProcedimiento getProcedimiento(Long idPlazo){
		PTEPlazoTareaExternaPlaza plazo= this.getPlazo(idPlazo);
		Long idTipoProcedimiento=plazo.getTareaProcedimiento().getTipoProcedimiento().getId();
		Filter filtroTipoProcedimiento = genericDao.createFilter(FilterType.EQUALS, "id", idTipoProcedimiento);
		TipoProcedimiento tipoProcedimiento= genericDao.get(TipoProcedimiento.class,filtroTipoProcedimiento);
		
		return tipoProcedimiento;
	}
	
	@BusinessOperation(PluginPlazosExternaBusinessOperations.PTE_MGR_GETPLAZAPLAZO)
	public TipoPlaza getTipoPlazaPlazo(Long idPlazo){
		PTEPlazoTareaExternaPlaza plazo= this.getPlazo(idPlazo);
		Long idPlaza= plazo.getTipoPlaza().getId();
		Filter filtroTipoPlaza = genericDao.createFilter(FilterType.EQUALS, "id", idPlaza);
		TipoPlaza tipoPlaza= genericDao.get(TipoPlaza.class,filtroTipoPlaza);
		
		return tipoPlaza;
	}
	
	@BusinessOperation(PluginPlazosExternaBusinessOperations.PTE_MGR_FINDJUZGDESCPLAZA)
	public List<TipoJuzgado> juzgadosPorPlazaYDescripcion(PTEDtoQuery dto){
		return tipoJuzgadoDao.findJuzPlazaYDescrip(dto);
	}

}
