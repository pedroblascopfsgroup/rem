package es.pfsgroup.plugin.recovery.plazasJuzgados.juzgado;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.scripting.ScriptEvaluator;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.Conversiones;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.plazasJuzgados.PluginPlazasJuzgadosBusinessOperations;
import es.pfsgroup.plugin.recovery.plazasJuzgados.api.web.DynamicElementApi;
import es.pfsgroup.plugin.recovery.plazasJuzgados.juzgado.dao.JUZJuzgadoDao;
import es.pfsgroup.plugin.recovery.plazasJuzgados.juzgado.dto.JUZDtoAltaJuzgado;
import es.pfsgroup.plugin.recovery.plazasJuzgados.juzgado.dto.JUZDtoAltaPlaza;
import es.pfsgroup.plugin.recovery.plazasJuzgados.juzgado.dto.JUZDtoBusquedaPlaza;
import es.pfsgroup.plugin.recovery.plazasJuzgados.procedimiento.dao.JUZProcedimientoDao;
import es.pfsgroup.plugin.recovery.plazasJuzgados.tipoPlaza.dao.JUZTipoPlazaDao;

@Service("JUZJuzgadoManager")
public class JUZJuzgadoManager {
	
	public class JUZDtoRetornoJuzgados  {
		
		private TipoJuzgado juzgado;
		private boolean esUltimo = false;

		public boolean getEsUltimo() {
			return esUltimo;
		}
	

		public void setEsUltimo(boolean esUltimo) {
			this.esUltimo = esUltimo;
		}

		public void setJuzgado(TipoJuzgado juzgado) {
			this.juzgado = juzgado;
		}

		public TipoJuzgado getJuzgado() {
			return juzgado;
		}
	}

	private static class Pagina implements Page{
        List<?> resultados;
        
        private int totalCount;
        
        public Pagina (List<?> resultados){
              this.resultados = resultados;
        }

        @Override
        public List<?> getResults() {
              return resultados;
        }

		public void setTotalCount(int totalCount) {
			this.totalCount = totalCount;
		}

		public int getTotalCount() {
			return totalCount;
		}

        
        
  }

	@Autowired
	GenericABMDao genericDao;
	
	@Autowired
	JUZProcedimientoDao procedimientoDao;
	
	@Autowired
	JUZJuzgadoDao juzgadoDao;
	
	@Autowired
	JUZTipoPlazaDao tipoPlazaDao;
	
	@Autowired
	ScriptEvaluator evaluator;
	
	@Autowired
	ApiProxyFactory proxyFactory;
	
	@BusinessOperation(PluginPlazasJuzgadosBusinessOperations.JUZ_MGR_BUSCAJUZGADOSPLAZA)
	public Page buscaJuzgados(JUZDtoBusquedaPlaza dto){
		EventFactory.onMethodStart(this.getClass());
		Page p = juzgadoDao.findJuzgados(dto);
		
		ArrayList<JUZDtoRetornoJuzgados> dtos = new ArrayList<JUZDtoRetornoJuzgados>();
		for (Object o : p.getResults()){
			JUZDtoRetornoJuzgados d = new JUZDtoRetornoJuzgados();
			TipoJuzgado j = (TipoJuzgado) o;
			d.setJuzgado(j);
			if (juzgadoDao.findByPlaza(j.getPlaza().getId()).size() == 1){
				d.setEsUltimo(true);
			}
			dtos.add(d);
		}
		Pagina resultado = new Pagina(dtos);
		resultado.setTotalCount(p.getTotalCount());
		
		EventFactory.onMethodStop(this.getClass());
		return resultado;
		
	}

	@Transactional(readOnly=false)
	@BusinessOperation(PluginPlazasJuzgadosBusinessOperations.JUZ_MGR_GUARDAPLAZA)
	public void guardaPlazaJuzgado(JUZDtoAltaPlaza dto){
		TipoPlaza tipoPlaza;
		if(Checks.esNulo(dto.getId())){
			tipoPlaza= tipoPlazaDao.createNewTipoPlaza();
			Filter filtroCodigo= genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getCodigo());
			TipoPlaza existe = genericDao.get(TipoPlaza.class, filtroCodigo);
			if(Checks.esNulo(existe)){
				tipoPlaza.setCodigo(dto.getCodigo());
			}else{
				throw new BusinessOperationException("plugin.plazasJuzgados.juzgadoManager.alta.codigoExistePlaza");
			}
		}else{
			Filter filtroPlaza=genericDao.createFilter(FilterType.EQUALS, "id", dto.getId());
			tipoPlaza = genericDao.get(TipoPlaza.class, filtroPlaza);
		}
		tipoPlaza.setDescripcion(dto.getDescripcion());
		tipoPlaza.setDescripcionLarga(dto.getDescripcionLarga());
		genericDao.save(TipoPlaza.class, tipoPlaza);
	}
	
	private TipoPlaza creaPlazaJuzgado(String descripcion, String descripcionLarga){
		TipoPlaza plaza = tipoPlazaDao.createNewTipoPlaza();
		Long longCodigo= plaza.getId()-this.calculaCodigoPlaza();
		String codigo= longCodigo.toString();
		Filter filtroCodigoExiste=genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
		TipoPlaza plazaExiste=genericDao.get(TipoPlaza.class, filtroCodigoExiste);
		if(Checks.esNulo(plazaExiste)){
			plaza.setCodigo(codigo);
		}else{
			throw new BusinessOperationException("plugin.plazasJuzgados.juzgadoManager.alta.codigoExiste");
		}
		plaza.setDescripcion(descripcion);
		plaza.setDescripcionLarga(descripcionLarga);
		genericDao.save(TipoPlaza.class, plaza);
		return plaza;
	}
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginPlazasJuzgadosBusinessOperations.JUZ_MGR_GUARDAJUZGADO)
	public void guardaJuzgado(JUZDtoAltaJuzgado dto){
		TipoJuzgado juzgado;
		if(Checks.esNulo(dto.getId())){
			juzgado= juzgadoDao.createNewJuzgado();
			Long resta=this.calculaCodigoJuzgado();
			Long longCodigo= juzgado.getId()- resta;
			String codigo=longCodigo.toString();
			Filter filtroCodigoExiste=genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
			TipoJuzgado juzgadoExiste= genericDao.get(TipoJuzgado.class, filtroCodigoExiste);
			if (Checks.esNulo(juzgadoExiste)){
				juzgado.setCodigo(codigo);
			}else{
				throw new BusinessOperationException("plugin.plazasJuzgados.juzgadoManager.alta.codigoExiste");
			}
			
			if (!dto.getExistePlaza()){
				if(Checks.esNulo(dto.getDescripcionPlaza())){
					throw new BusinessOperationException(
							"plugin.plazasJuzgados.juzgadoManager.descripcionPlaza");
				}else{
					TipoPlaza plaza = this.creaPlazaJuzgado(dto.getDescripcionPlaza(), dto.getDescripcionLargaPlaza());
					juzgado.setPlaza(plaza);
				}
			}else{
				if(Checks.esNulo(dto.getPlaza())){
					throw new BusinessOperationException(
							"plugin.plazasJuzgados.juzgadoManager.seleccionarPlaza");
				}
				Filter filtroPlaza=genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getPlaza());
				TipoPlaza plaza= genericDao.get(TipoPlaza.class, filtroPlaza);
				juzgado.setPlaza(plaza);
			}
		}else{
			Filter filtroJuzgado=genericDao.createFilter(FilterType.EQUALS, "id", dto.getId());
			juzgado = genericDao.get(TipoJuzgado.class, filtroJuzgado);
		}
		
		juzgado.setDescripcion(dto.getDescripcion());
		juzgado.setDescripcionLarga(dto.getDescripcionLarga());
		genericDao.save(TipoJuzgado.class, juzgado);
	}
	
	@BusinessOperation(PluginPlazasJuzgadosBusinessOperations.JUZ_MGR_GETJUZGADO)
	public TipoJuzgado getJuzgado(Long id){
		EventFactory.onMethodStart(this.getClass());
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", id);
		TipoJuzgado juzgado = genericDao.get(TipoJuzgado.class, filtro);
		
		EventFactory.onMethodStop(this.getClass());
		return juzgado;
	}
	
	@BusinessOperation(PluginPlazasJuzgadosBusinessOperations.JUZ_MGR_GETPLAZA)
	public TipoPlaza getPlaza(Long id){
		Filter filtro=genericDao.createFilter(FilterType.EQUALS, "id", id);
		TipoPlaza plaza=genericDao.get(TipoPlaza.class, filtro);
		return plaza;
	}
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginPlazasJuzgadosBusinessOperations.JUZ_MGR_BORRAJUZGADO)
	public void borraJuzgado(Long id){
		Filter filtroJuzgado=genericDao.createFilter(FilterType.EQUALS, "id", id);
		TipoJuzgado juzgado=genericDao.get(TipoJuzgado.class, filtroJuzgado);
		Long idPlaza= juzgado.getPlaza().getId();
		checkJuzgadoConProcedimiento(id);
		genericDao.deleteById(TipoJuzgado.class, id);
		List<TipoJuzgado> listaJuzgadosConPlaza = juzgadoDao.findByPlaza(idPlaza);
		if(Checks.estaVacio(listaJuzgadosConPlaza)){
			genericDao.deleteById(TipoPlaza.class, idPlaza);
			
		}
	}
	
	private void checkJuzgadoConProcedimiento(Long id) {
		/*
		Filter filtroJuzgado=genericDao.createFilter(FilterType.EQUALS, "juzgado.id", id);
		
		Filter filtroPropuesto=genericDao.createFilter(FilterType.EQUALS, "estadoProcedimiento.codigo", "01");
		Filter filtroConfirmado=genericDao.createFilter(FilterType.EQUALS, "estadoProcedimiento.codigo", "02");
		Filter filtroAceptado=genericDao.createFilter(FilterType.EQUALS, "estadoProcedimiento.codigo", "03");
		Filter filtroDerivado=genericDao.createFilter(FilterType.EQUALS, "estadoProcedimiento.codigo", "06");
		Filter filtroConformacion=genericDao.createFilter(FilterType.EQUALS, "estadoProcedimiento.codigo", "07");
		*/
		
		List<Procedimiento> tieneProcedimientos=procedimientoDao.findPorJuzgado(id);
		
		if(!Checks.estaVacio(tieneProcedimientos)){
			throw new BusinessOperationException("plugin.plazasJuzgados.juzgadoManager.juzgadoConProcedimientos");
		}
	}

	private Long calculaCodigoJuzgado(){
		Long restaCodigo=null;
		List<TipoJuzgado> juzgados = genericDao.getList(TipoJuzgado.class);
		if (!Checks.estaVacio(juzgados)){
			TipoJuzgado juz = juzgados.get(0);
			Long codigo = Conversiones.convierteLong(juz.getCodigo());
			restaCodigo=juz.getId()-codigo;
				
		}
		return restaCodigo;
	}
	
	private Long calculaCodigoPlaza(){
		Long restaCodigo=0L;
		List<TipoPlaza> plazas = genericDao.getList(TipoPlaza.class);
		if (!Checks.estaVacio(plazas)){
			TipoPlaza plz = plazas.get(0);
			Long codigo = Conversiones.convierteLong(plz.getCodigo());
			restaCodigo=plz.getId()-codigo;
				
		}
		return restaCodigo;
	}
	
	@BusinessOperation(PluginPlazasJuzgadosBusinessOperations.JUZ_MGR_PUNTO_ENGANCHE_BUTTON_LEFT)
	List<DynamicElement> getButtonJuzgadosLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.plazasJuzgados.web.buttons.left",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation(PluginPlazasJuzgadosBusinessOperations.JUZ_MGR_PUNTO_ENGANCHE_BUTTON_RIGHT)
	List<DynamicElement> getButtonsJuzgadosRight() {
		List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
				"plugin.plazasJuzgados.web.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}
	
}
