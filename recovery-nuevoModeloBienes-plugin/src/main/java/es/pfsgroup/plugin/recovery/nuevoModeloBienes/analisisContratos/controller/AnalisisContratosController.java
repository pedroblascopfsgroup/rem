package es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.HtmlUtils;

import com.fasterxml.jackson.databind.ObjectMapper;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.asunto.AsuntoApi;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.DDFavorable;
import es.capgemini.pfs.procesosJudiciales.model.DDPositivoNegativo;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.AnalisisContratosApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.dto.AnalisisContratosBienesDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.dto.AnalisisContratosDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.model.AnalisisContratos;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.model.NMBAnalisisContratosBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.serder.JSONAnalisisContrato;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.serder.JSONAnalisisContratoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.serder.JSONAnalisisContratoBienes;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.serder.JSONAnalisisContratos;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.recoveryapi.BienApi;

@Controller
public class AnalisisContratosController {

	public static final String GET_ANALISIS_CONTRATOS_PAGINADO_JSON = "plugin/nuevoModeloBienes/analisisContratos/analisisContratosJSON";
	public static final String GET_LISTADO_BIENES_BY_CNT_ID_JSON = "plugin/nuevoModeloBienes/analisisContratos/bienesContratosJSON";

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private Executor executor;

	@Autowired
	private GenericABMDao genericDao;

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getAnalisisContratos(@RequestParam(value = "asuId", required = true) Long asuId, @RequestParam(value = "limit", required = true) Integer limit,
			@RequestParam(value = "start", required = true) Integer start, ModelMap map) {

		List<AnalisisContratos> listado = proxyFactory.proxy(AnalisisContratosApi.class).getListadoAnalisisContratos(asuId);

		map.put("listado", listado);

		return GET_ANALISIS_CONTRATOS_PAGINADO_JSON;

	}

	@SuppressWarnings({ "unchecked" })
	@RequestMapping
	public String getBienesContrato(Long cntId, ModelMap map) {

		List<NMBAnalisisContratosBien> listado = proxyFactory.proxy(AnalisisContratosApi.class).getBienesContratos(cntId);
		for (NMBAnalisisContratosBien bien : listado) {
//			AnalisisContratos analisisContrato = new AnalisisContratos();
//			analisisContrato.setId(cntId);
//			bien.setAnalisisContrato(analisisContrato);
		}
		map.put("listado", listado);
		return GET_LISTADO_BIENES_BY_CNT_ID_JSON;
	}

	/**
	 * Guarda la infomación de la pestaña análisis de contratos,
	 * 
	 * @param contratos
	 * @param bienes
	 * @param map
	 * @return
	 */
	@RequestMapping
	public String saveAnalisisContratos(@RequestParam(value = "contratos", required = true) String contratos, @RequestParam(value = "bienes", required = true) String bienes,
			@RequestParam(value = "ancId", required = false) Long ancId, ModelMap map) {

		ObjectMapper mapper = new ObjectMapper();
		JSONAnalisisContratos jsonAnalisisContratos = null;
		JSONAnalisisContratoBienes jsonAnalisisContratosBienes = null;
		try {
			if (!Checks.esNulo(contratos)) {
				jsonAnalisisContratos = mapper.readValue(HtmlUtils.htmlUnescape(contratos), JSONAnalisisContratos.class);
			}
			if (!Checks.esNulo(bienes)) {
				jsonAnalisisContratosBienes = mapper.readValue(HtmlUtils.htmlUnescape(bienes), JSONAnalisisContratoBienes.class);
			}
		} catch (Throwable t) {
			t.printStackTrace();
			return null;
		}

		if (jsonAnalisisContratos != null) {
			guardaAnalisisContratos(jsonAnalisisContratos);
		}
		if (jsonAnalisisContratosBienes != null) {
			guardaAnalisisContratosBienes(jsonAnalisisContratosBienes, ancId);
		}
		return "default";
	}

	private void guardaAnalisisContratos(JSONAnalisisContratos jsonAnalisisContratos) {

		AnalisisContratos analisisContrato = new AnalisisContratos();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss");
		// 1901-05-23T00:00:00
		for (JSONAnalisisContrato jsonContrato : jsonAnalisisContratos.getArrayItems()) {

			if (!Checks.esNulo(jsonContrato.getId())) {
				analisisContrato = (AnalisisContratos) proxyFactory.proxy(AnalisisContratosApi.class).getAnalisisContrato(Long.parseLong(jsonContrato.getId()));
			} else {

				analisisContrato = new AnalisisContratos();
				Auditoria auditoria = Auditoria.getNewInstance();
				analisisContrato.setAuditoria(auditoria);

				Long idAsunto = Long.parseLong(jsonContrato.getAsuId());
				Asunto asunto = (Asunto) proxyFactory.proxy(AsuntoApi.class).get(idAsunto);
				analisisContrato.setAsunto(asunto);

				Long idContrato = Long.parseLong(jsonContrato.getContratoId());
				Contrato contrato = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET, idContrato);
				analisisContrato.setContrato(contrato);
			}

			// --A---
			if (!Checks.esNulo(jsonContrato.getRevisadoA())) {
				analisisContrato.setRevisadoA(Boolean.parseBoolean(jsonContrato.getRevisadoA()) || DDSiNo.SI.equals(jsonContrato.getRevisadoA()));
			}
			if (!Checks.esNulo(jsonContrato.getPropuestaEjecucion())) {
				analisisContrato.setPropuestaEjecucion(Boolean.parseBoolean(jsonContrato.getPropuestaEjecucion()) || DDSiNo.SI.equals(jsonContrato.getPropuestaEjecucion()));
			}
			if (!Checks.esNulo(jsonContrato.getIniciarEjecucion())) {
				analisisContrato.setIniciarEjecucion(Boolean.parseBoolean(jsonContrato.getIniciarEjecucion()) || DDSiNo.SI.equals(jsonContrato.getIniciarEjecucion()));
			}

			// --B---
			if (!Checks.esNulo(jsonContrato.getRevisadoB())) {
				analisisContrato.setRevisadoB(Boolean.parseBoolean(jsonContrato.getRevisadoB()) || DDSiNo.SI.equals(jsonContrato.getRevisadoB()));
			}
			if (!Checks.esNulo(jsonContrato.getSolicitarSolvencia())) {
				analisisContrato.setSolicitarSolvencia(Boolean.parseBoolean(jsonContrato.getSolicitarSolvencia()) || DDSiNo.SI.equals(jsonContrato.getSolicitarSolvencia()));
			}
			if (!Checks.esNulo(jsonContrato.getFechaSolicitarSolvencia())) {
				try {
					analisisContrato.setFechaSolicitarSolvencia(format.parse(jsonContrato.getFechaSolicitarSolvencia()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			if (!Checks.esNulo(jsonContrato.getFechaRecepcion())) {
				try {
					analisisContrato.setFechaRecepcion(format.parse(jsonContrato.getFechaRecepcion()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			if (!Checks.esNulo(jsonContrato.getResultado())) {
				analisisContrato.setResultado(Boolean.parseBoolean(jsonContrato.getResultado()) || DDPositivoNegativo.POSITIVO.equals(jsonContrato.getResultado()));
			}
			if (!Checks.esNulo(jsonContrato.getDecisionB())) {
				analisisContrato.setDecisionB(Boolean.parseBoolean(jsonContrato.getDecisionB()) || DDSiNo.SI.equals(jsonContrato.getDecisionB()));
			}

			// -- C--
			if (!Checks.esNulo(jsonContrato.getRevisadoC())) {
				analisisContrato.setRevisadoC(Boolean.parseBoolean(jsonContrato.getRevisadoC()) || DDSiNo.SI.equals(jsonContrato.getRevisadoC()));
			}
			if (!Checks.esNulo(jsonContrato.getDecisionC())) {
				analisisContrato.setDecisionC(Boolean.parseBoolean(jsonContrato.getDecisionC()) || DDSiNo.SI.equals(jsonContrato.getDecisionC()));
			}
			if (!Checks.esNulo(jsonContrato.getFechaProximaRevision())) {
				try {
					analisisContrato.setFechaProximaRevision(format.parse(jsonContrato.getFechaProximaRevision()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			if (!Checks.esNulo(jsonContrato.getDecisionRevision())) {
				analisisContrato.setDecisionRevision(Boolean.parseBoolean(jsonContrato.getDecisionRevision()) || DDSiNo.SI.equals(jsonContrato.getDecisionRevision()));
			}

			proxyFactory.proxy(AnalisisContratosApi.class).guardar(analisisContrato);
		}
	}

	private void guardaAnalisisContratosBienes(JSONAnalisisContratoBienes jsonAnalisisContratosBienes, Long ancId) {

		if (ancId == null)
			return;

		NMBAnalisisContratosBien analisisContratoBien = new NMBAnalisisContratosBien();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss");
		// 1901-05-23T00:00:00
		for (JSONAnalisisContratoBien jsonContratoBien : jsonAnalisisContratosBienes.getArrayItems()) {

			if (!Checks.esNulo(jsonContratoBien.getId())) {
				analisisContratoBien = (NMBAnalisisContratosBien) proxyFactory.proxy(AnalisisContratosApi.class).getAnalisisContratoBien(Long.parseLong(jsonContratoBien.getId()));
			} else {
				analisisContratoBien = new NMBAnalisisContratosBien();
				Auditoria auditoria = Auditoria.getNewInstance();
				analisisContratoBien.setAuditoria(auditoria);

				AnalisisContratos analsisContrato = (AnalisisContratos) proxyFactory.proxy(AnalisisContratosApi.class).getAnalisisContrato(ancId);
				analisisContratoBien.setAnalisisContrato(analsisContrato);

				// Bien.
				Long idBien = Long.parseLong(jsonContratoBien.getBienId());
				NMBBien bien = (NMBBien) proxyFactory.proxy(BienApi.class).get(idBien);
				analisisContratoBien.setBien(bien);
			}

			if (!Checks.esNulo(jsonContratoBien.getSolicitarNoAfeccion())) {
				analisisContratoBien.setSolicitarNoAfeccion(Boolean.parseBoolean(jsonContratoBien.getSolicitarNoAfeccion()) || DDSiNo.SI.equals(jsonContratoBien.getSolicitarNoAfeccion()));
			}
			if (!Checks.esNulo(jsonContratoBien.getFechaSolicitarNoAfeccion())) {
				try {
					analisisContratoBien.setFechaSolicitarNoAfeccion(format.parse(jsonContratoBien.getFechaSolicitarNoAfeccion()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			if (!Checks.esNulo(jsonContratoBien.getFechaResolucion())) {
				try {
					analisisContratoBien.setFechaResolucion(format.parse(jsonContratoBien.getFechaResolucion()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			if (!Checks.esNulo(jsonContratoBien.getResolucion())) {
				analisisContratoBien.setResolucion(Boolean.parseBoolean(jsonContratoBien.getResolucion()) || DDFavorable.FAVORABLE.equals(jsonContratoBien.getResolucion()));
			}
			proxyFactory.proxy(AnalisisContratosApi.class).guardar(analisisContratoBien);
		}
	}

	@RequestMapping
	public String editAnalisisContratos(ModelMap map, Long asuId, Long ancId, Long contratoId) {

		AnalisisContratos anc = new AnalisisContratos();
		if(ancId != null){ 
			 anc = genericDao.get(AnalisisContratos.class, genericDao.createFilter(FilterType.EQUALS, "id", ancId));
		}	
		map.put("anc", anc);
		map.put("contratoId", contratoId );

		return "plugin/nuevoModeloBienes/analisisContratos/tab2/editAnalisisContratos";

	}

	@RequestMapping
	public String editAnalisisContratosBienes(ModelMap map, Long id, String bieId, String ancId) {

		NMBAnalisisContratosBien bien = new NMBAnalisisContratosBien();
		if (!Checks.esNulo(id)) {
			bien = genericDao.get(NMBAnalisisContratosBien.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
			map.put("bie", bien);
		}
		map.put("bieId", bieId);
		map.put("ancId", ancId);

		return "plugin/nuevoModeloBienes/analisisContratos/tab2/editAnalisisContratosBienes";

	}
	


	@RequestMapping
	public String guardarAnalisisContratos(ModelMap map, AnalisisContratosDto dto) {

		proxyFactory.proxy(AnalisisContratosApi.class).guardarAnalisisContratos(dto);
		
		return "default";
	}

	@RequestMapping
	public String guardarAnalisisContratosBienes(ModelMap map, AnalisisContratosBienesDto dto) {

		proxyFactory.proxy(AnalisisContratosApi.class).guardarAnalisisContratosBienes(dto);
		
		return "default";
	}

}
