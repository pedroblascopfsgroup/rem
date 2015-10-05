package es.pfsgroup.concursal.credito.manager;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.concursal.concurso.dto.DtoConcurso;
import es.pfsgroup.concursal.concurso.dto.DtoContratoConcurso;
import es.pfsgroup.concursal.credito.api.CreditoApi;
import es.pfsgroup.concursal.credito.dto.DtoCreditosContratoEdicion;
import es.pfsgroup.concursal.credito.model.Credito;
import es.pfsgroup.concursal.credito.model.DDEstadoCredito;

@Component
public class CreditoManager implements CreditoApi {

	@Autowired
	private Executor executor;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@SuppressWarnings("unchecked")
	@Override
	@BusinessOperation(GET_CREDITOS_CONCURSO_ASUNTO)
	public List<DtoCreditosContratoEdicion> getCreditosAsunto(Long idAsunto) {
		List<DtoConcurso> lista = (List<DtoConcurso>) executor.execute("concursoManager.listadoFaseComun",idAsunto);
		List<DtoCreditosContratoEdicion> listaDto = new ArrayList<DtoCreditosContratoEdicion>();
		
		for(DtoConcurso dtoConcurso:lista){
			List<DtoContratoConcurso> listaContratoConcurso =  dtoConcurso.getContratos();
			for(DtoContratoConcurso dtoContratoConcurso:listaContratoConcurso){
				
				Contrato cnt = dtoContratoConcurso.getContrato();
				String codigoContrato = cnt.getCodigoContrato();
				List<Credito> listaCreditos = dtoContratoConcurso.getCreditos();
				
				for(Credito credito:listaCreditos){
					String estadoCredito = credito.getEstadoCredito().getDescripcion();
					DtoCreditosContratoEdicion dto = new DtoCreditosContratoEdicion();
					dto.setIdContrato(cnt.getId());
					dto.setIdCredito(credito.getId());
					dto.setCodigoContrato(codigoContrato);
					dto.setEstadoCredito(estadoCredito);
					listaDto.add(dto);
				}
				
			}
		}
		
		return listaDto;
	}
	
	@Override
	@Transactional
	@BusinessOperation(MODIFICAR_ESTADO_CREDITOS_CONCURSO_ASUNTO)
	public void guardarCambioEstadoCreditos(Long idAsunto,
			String estadoCredito, String creditos) {
		
		DDEstadoCredito estado = genericDao.get(DDEstadoCredito.class, 
									genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(estadoCredito)),
									genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado",false));
		
		String[] creditosV = creditos.split(",");
		for(String idCredito:creditosV){
			Credito credito = genericDao.get(Credito.class,
					genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(idCredito)),
					genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado",false));
			
			if(credito != null){
				credito.setEstadoCredito(estado);
				genericDao.save(Credito.class, credito);
			}
		}
		
	}


	public void setExecutor(Executor executor) {
		this.executor = executor;
	}

	public Executor getExecutor() {
		return executor;
	}

	public GenericABMDao getGenericDao() {
		return genericDao;
	}

	public void setGenericDao(GenericABMDao genericDao) {
		this.genericDao = genericDao;
	}

	public Credito getCreditoByGuid(String guid) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "guid", guid);
		Credito valor = genericDao.get(Credito.class, filter);
		return valor;
	}
	
}
