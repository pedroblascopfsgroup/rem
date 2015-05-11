package es.pfsgroup.concursal.credito.web;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.concursal.concurso.dto.DtoConcurso;
import es.pfsgroup.concursal.concurso.dto.DtoContratoConcurso;
import es.pfsgroup.concursal.credito.api.CreditoApi;
import es.pfsgroup.concursal.credito.dto.DtoCreditosContratoEdicion;
import es.pfsgroup.concursal.credito.model.Credito;
import es.pfsgroup.concursal.credito.model.DDEstadoCredito;

@Controller
public class CreditoController {

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private Executor executor;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String editarEstadoTodosLosCreditos(Long idAsunto, ModelMap model){
		
		
		List<DDEstadoCredito> estados = (List<DDEstadoCredito>) executor.execute("concursoManager.estadosCredito");
		model.put("idAsunto", idAsunto);
		model.put("estados", estados);
		return "plugin/procedimientos/concursal/editarCreditoTodos";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String editarEstadoTodosLosCreditosUGAS(Long idAsunto, ModelMap model){
		
		
		List<DDEstadoCredito> estados = (List<DDEstadoCredito>) executor.execute("ugasconcursoManager.estadosCreditoUGAS");
		model.put("idAsunto", idAsunto);
		model.put("estados", estados);
		return "plugin/procedimientos/concursal/editarCreditoTodos";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getCreditosAsunto(Long idAsunto, ModelMap model){
		List<DtoCreditosContratoEdicion> listaDto = proxyFactory.proxy(CreditoApi.class).getCreditosAsunto(idAsunto);
		model.put("lista",listaDto);
		return "plugin/procedimientos/concursal/listadoCreditosTodosJSON";
	}
	
	@RequestMapping
	public String guardarCambioEstadoCreditos(Long idAsunto, String  estadoCredito, String creditos){
		proxyFactory.proxy(CreditoApi.class).guardarCambioEstadoCreditos(idAsunto, estadoCredito, creditos);
		return "default";
	}

	public void setProxyFactory(ApiProxyFactory proxyFactory) {
		this.proxyFactory = proxyFactory;
	}

	public ApiProxyFactory getProxyFactory() {
		return proxyFactory;
	}

	public void setExecutor(Executor executor) {
		this.executor = executor;
	}

	public Executor getExecutor() {
		return executor;
	}
	
}
