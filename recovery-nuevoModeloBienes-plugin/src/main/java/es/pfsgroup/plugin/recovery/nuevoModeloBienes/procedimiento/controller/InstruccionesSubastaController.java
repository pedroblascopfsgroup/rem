package es.pfsgroup.plugin.recovery.nuevoModeloBienes.procedimiento.controller;

import java.math.BigDecimal;
import java.sql.Date;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.WebRequest;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.capgemini.pfs.procesosJudiciales.model.DDPostores2;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBDDtipoSubasta;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBSubastaInstrucciones;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.procedimiento.Dto.DtoNotarios;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.procedimiento.Dto.DtoSubastaInstrucciones;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.recoveryapi.BienApi;

@Controller
public class InstruccionesSubastaController {
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String dictarInstrucciones(@RequestParam(value = "idBien", required = true) Long idBien, 
									  @RequestParam(value = "idProcedimiento", required = true) Long idProcedimiento,
									  @RequestParam(value = "idInstrucciones", required = false) Long idInstrucciones,
			                          @RequestParam(value = "tipoSubasta", required = false) String tipoSubasta, ModelMap map) {
		
		if (tipoSubasta.equals("notarial")){
			// lista de notarios
			ArrayList<DtoNotarios> listaNotarios = (ArrayList<DtoNotarios>) executor.execute("NMBProcedimientoManager.getNotarios");
			map.put("listaNotarios", listaNotarios);
		}
		
		// DDPostores
		List<DDPostores2> listaPostores = (List<DDPostores2>) executor.execute("dictionaryManager.getList", "DDPostores2");
		map.put("ddPostores", listaPostores);
		
		DtoSubastaInstrucciones dtoInstrucciones = new DtoSubastaInstrucciones();
		
		if (idInstrucciones != null){
			cargarDtoInstrucciones(dtoInstrucciones, idBien, idProcedimiento, tipoSubasta, idInstrucciones);
		} else {
			inicializaDtoInstrucciones(dtoInstrucciones, idBien, idProcedimiento, tipoSubasta);
		}

		map.put("dto", dtoInstrucciones);
		
		return "plugin/nuevoModeloBienes/procedimientos/instruccionesSubasta";
	}

	private void cargarDtoInstrucciones(
			DtoSubastaInstrucciones dtoInstrucciones, Long idBien,
			Long idProcedimiento, String tipoSubasta, Long idInstrucciones) {
		
		NMBSubastaInstrucciones nmbSubastaInstrucciones;
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", idInstrucciones);
		nmbSubastaInstrucciones = (NMBSubastaInstrucciones) genericDao.get(NMBSubastaInstrucciones.class, f1);
		
		dtoInstrucciones.setIdInstrucciones(idInstrucciones);
		dtoInstrucciones.setIdBien(idBien);
		dtoInstrucciones.setIdProcedimiento(idProcedimiento);
		if (nmbSubastaInstrucciones.getNotario()!=null){
			dtoInstrucciones.setNotario(nmbSubastaInstrucciones.getNotario().getId());
		}
		if (nmbSubastaInstrucciones.getTipoSubasta()!=null){
			dtoInstrucciones.setCodigoTipoSubasta(nmbSubastaInstrucciones.getTipoSubasta().getCodigo());
		}
		dtoInstrucciones.setCargasAnteriores(nmbSubastaInstrucciones.getCargasAnteriores());
		dtoInstrucciones.setFechaInscripcion(nmbSubastaInstrucciones.getFechaInscripcion());
		dtoInstrucciones.setFechaLlaves(nmbSubastaInstrucciones.getFechaLlaves());
		dtoInstrucciones.setImporteSegundaSubasta(nmbSubastaInstrucciones.getImporteSegundaSubasta());
		dtoInstrucciones.setImporteTerceraSubasta(nmbSubastaInstrucciones.getImporteTerceraSubasta());
		dtoInstrucciones.setPeritacionActual(nmbSubastaInstrucciones.getPeritacionActual());
		dtoInstrucciones.setPrimeraSubasta(nmbSubastaInstrucciones.getPrimeraSubasta());
		dtoInstrucciones.setPrincipal(nmbSubastaInstrucciones.getPrincipal());
		dtoInstrucciones.setPropuestaCapital(nmbSubastaInstrucciones.getPropuestaCapital());
		dtoInstrucciones.setPropuestaCostas(nmbSubastaInstrucciones.getPropuestaCostas());
		dtoInstrucciones.setPropuestaDemoras(nmbSubastaInstrucciones.getPropuestaDemoras());
		dtoInstrucciones.setPropuestaIntereses(nmbSubastaInstrucciones.getPropuestaIntereses());
		dtoInstrucciones.setResponsabilidadCapital(nmbSubastaInstrucciones.getResponsabilidadCapital());
		dtoInstrucciones.setResponsabilidadCostas(nmbSubastaInstrucciones.getResponsabilidadCostas());
		dtoInstrucciones.setResponsabilidadDemoras(nmbSubastaInstrucciones.getResponsabilidadDemoras());
		dtoInstrucciones.setResponsabilidadIntereses(nmbSubastaInstrucciones.getResponsabilidadIntereses());
		dtoInstrucciones.setSegundaSubasta(nmbSubastaInstrucciones.getSegundaSubasta());
		dtoInstrucciones.setTerceraSubasta(nmbSubastaInstrucciones.getTerceraSubasta());
		dtoInstrucciones.setTipoSegundaSubasta(nmbSubastaInstrucciones.getTipoSegundaSubasta());
		dtoInstrucciones.setTipoTerceraSubasta(nmbSubastaInstrucciones.getTipoTerceraSubasta());
		dtoInstrucciones.setTotalDeuda(nmbSubastaInstrucciones.getTotalDeuda());
		dtoInstrucciones.setValorSubasta(nmbSubastaInstrucciones.getValorSubasta());
		dtoInstrucciones.setObservaciones(nmbSubastaInstrucciones.getObservacion());
		
		dtoInstrucciones.setCostasProcurador(nmbSubastaInstrucciones.getCostasProcurador());
		dtoInstrucciones.setCostasLetrado(nmbSubastaInstrucciones.getCostasLetrado());
		dtoInstrucciones.setLimiteConPostores(nmbSubastaInstrucciones.getLimiteConPostores());
		if (nmbSubastaInstrucciones.getPostores()!=null){
			dtoInstrucciones.setIdPostores(nmbSubastaInstrucciones.getPostores().getId());
		}
	}

	private void inicializaDtoInstrucciones(
			DtoSubastaInstrucciones dtoInstrucciones, Long idBien, Long idProcedimiento, String tipoSubasta) {
		
		NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(idBien); 
		Procedimiento procedimiento = (Procedimiento) proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento); 
		
		if (tipoSubasta.equals("notarial")){
			dtoInstrucciones.setCodigoTipoSubasta(NMBDDtipoSubasta.NOTARIAL);
		} else {
			dtoInstrucciones.setCodigoTipoSubasta(NMBDDtipoSubasta.APREMIO);
		}
		
		dtoInstrucciones.setIdBien(idBien);
		dtoInstrucciones.setIdProcedimiento(idProcedimiento);
		if (!Checks.esNulo(bien.getImporteCargas()))
			dtoInstrucciones.setCargasAnteriores(bien.getImporteCargas().floatValue());		
		if (!Checks.esNulo(bien.getDatosRegistralesActivo())) 
			dtoInstrucciones.setFechaInscripcion(bien.getDatosRegistralesActivo().getFechaInscripcion());
		if (!Checks.esNulo(bien.getValoracionActiva()) && !Checks.esNulo(bien.getValoracionActiva().getImporteValorTasacion())) 
			dtoInstrucciones.setPeritacionActual(bien.getValoracionActiva().getImporteValorTasacion().floatValue());
		dtoInstrucciones.setPrincipal(procedimiento.getSaldoRecuperacion());
		
	}
	
	@RequestMapping
	public String guardarInstrucciones(WebRequest request, ModelMap map) throws ParseException,Exception {
		try{
		DtoSubastaInstrucciones dtoSubastaInstrucciones = creaDTOParaGuardarInstrucciones(request);
		proxyFactory.proxy(BienApi.class).saveInstruccionesNMB(dtoSubastaInstrucciones);
		}
		catch(Exception e){
			e.printStackTrace();
			throw e;
		}
		return "default";
	}

	private DtoSubastaInstrucciones creaDTOParaGuardarInstrucciones(
			WebRequest request) throws ParseException {
		
		DtoSubastaInstrucciones dto = new DtoSubastaInstrucciones();
		
		if (!Checks.esNulo(request.getParameter("idInstrucciones")))
			dto.setIdInstrucciones(Long.parseLong(request.getParameter("idInstrucciones")));
		if (!Checks.esNulo(request.getParameter("idProcedimiento")))
			dto.setIdProcedimiento(Long.parseLong(request.getParameter("idProcedimiento")));
		if (!Checks.esNulo(request.getParameter("idBien")))
			dto.setIdBien(Long.parseLong(request.getParameter("idBien")));
		if (!Checks.esNulo(request.getParameter("codigoTipoSubasta")))
			dto.setCodigoTipoSubasta(request.getParameter("codigoTipoSubasta"));
		if (!Checks.esNulo(request.getParameter("primeraSubasta")))
			dto.setPrimeraSubasta(Date.valueOf(request.getParameter("primeraSubasta").substring(0, 10)));
		if (!Checks.esNulo(request.getParameter("segundaSubasta")))
			dto.setSegundaSubasta(Date.valueOf(request.getParameter("segundaSubasta").substring(0, 10)));
		if (!Checks.esNulo(request.getParameter("terceraSubasta")))
			dto.setTerceraSubasta(Date.valueOf(request.getParameter("terceraSubasta").substring(0, 10)));
		if (!Checks.esNulo(request.getParameter("notario")))
			dto.setNotario(Long.parseLong(request.getParameter("notario")));
		if (!Checks.esNulo(request.getParameter("valorSubasta")))
			dto.setValorSubasta(new Float(request.getParameter("valorSubasta")));
		if (!Checks.esNulo(request.getParameter("totalDeuda")))
			dto.setTotalDeuda(new Float(request.getParameter("totalDeuda")));
		if (!Checks.esNulo(request.getParameter("principal")))
			dto.setPrincipal(new BigDecimal(request.getParameter("principal")));
		if (!Checks.esNulo(request.getParameter("cargasAnteriores")))
			dto.setCargasAnteriores(new Float(request.getParameter("cargasAnteriores")));
		if (!Checks.esNulo(request.getParameter("peritacionActual")))
			dto.setPeritacionActual(new Float(request.getParameter("peritacionActual")));
		if (!Checks.esNulo(request.getParameter("tipoSegundaSubasta")))
			dto.setTipoSegundaSubasta(new Float(request.getParameter("tipoSegundaSubasta")));
		if (!Checks.esNulo(request.getParameter("importeSegundaSubasta")))
			dto.setImporteSegundaSubasta(new Float(request.getParameter("importeSegundaSubasta")));
		if (!Checks.esNulo(request.getParameter("tipoTerceraSubasta")))
			dto.setTipoTerceraSubasta(new Float(request.getParameter("tipoTerceraSubasta")));
		if (!Checks.esNulo(request.getParameter("importeTerceraSubasta")))
			dto.setImporteTerceraSubasta(new Float(request.getParameter("importeTerceraSubasta")));
		if (!Checks.esNulo(request.getParameter("responsabilidadCapital")))
			dto.setResponsabilidadCapital(new Float(request.getParameter("responsabilidadCapital")));
		if (!Checks.esNulo(request.getParameter("responsabilidadIntereses")))
			dto.setResponsabilidadIntereses(new Float(request.getParameter("responsabilidadIntereses")));
		if (!Checks.esNulo(request.getParameter("responsabilidadDemoras")))
			dto.setResponsabilidadDemoras(new Float(request.getParameter("responsabilidadDemoras")));
		if (!Checks.esNulo(request.getParameter("responsabilidadCostas")))
			dto.setResponsabilidadCostas(new Float(request.getParameter("responsabilidadCostas")));
		if (!Checks.esNulo(request.getParameter("propuestaCapital")))
			dto.setPropuestaCapital(new Float(request.getParameter("propuestaCapital")));
		if (!Checks.esNulo(request.getParameter("propuestaIntereses")))
			dto.setPropuestaIntereses(new Float(request.getParameter("propuestaIntereses")));
		if (!Checks.esNulo(request.getParameter("propuestaDemoras")))
			dto.setPropuestaDemoras(new Float(request.getParameter("propuestaDemoras")));
		if (!Checks.esNulo(request.getParameter("propuestaCostas")))
			dto.setPropuestaCostas(new Float(request.getParameter("propuestaCostas")));
		if (!Checks.esNulo(request.getParameter("fechaInscripcion")))
			dto.setFechaInscripcion(Date.valueOf(request.getParameter("fechaInscripcion").substring(0, 10)));
		if (!Checks.esNulo(request.getParameter("fechaLlaves")))
			dto.setFechaLlaves(Date.valueOf(request.getParameter("fechaLlaves").substring(0, 10)));
		if (!Checks.esNulo(request.getParameter("notario")))
			dto.setNotario(Long.parseLong(request.getParameter("notario")));	
		if (!Checks.esNulo(request.getParameter("observaciones")))
			dto.setObservaciones(request.getParameter("observaciones"));
		
		if (!Checks.esNulo(request.getParameter("costasProcurador")))
			dto.setCostasProcurador(new Float(request.getParameter("costasProcurador")));
		if (!Checks.esNulo(request.getParameter("costasLetrado")))
			dto.setCostasLetrado(new Float(request.getParameter("costasLetrado")));
		if (!Checks.esNulo(request.getParameter("limiteConPostores")))
			dto.setLimiteConPostores(new Float(request.getParameter("limiteConPostores")));
		if (!Checks.esNulo(request.getParameter("postores")))
			dto.setIdPostores(Long.parseLong(request.getParameter("postores")));
		
		return dto;
	}

}
