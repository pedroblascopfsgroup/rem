package es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.manager;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.dao.AsuntoDao;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDTiposAsunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.api.AnalisisContratosApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.dao.AnalisisContratoDao;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.dto.AnalisisContratosBienesDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.dto.AnalisisContratosDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.model.AnalisisContratos;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.model.NMBAnalisisContratosBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;

/**
 *
 */
@Service("analisisContratoManagerDelegated")
public class AnalisisContratosManager implements AnalisisContratosApi {

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private Executor executor;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private AsuntoDao asuntoDao;

	@Autowired
	private AnalisisContratoDao analisisContratoDao;

	@Override
	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_GET_CONTRATO)
	public AnalisisContratos getAnalisisContrato(Long idAnalisisContrato) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idAnalisisContrato);
		AnalisisContratos objeto = genericDao.get(AnalisisContratos.class, filtro);
		return objeto;
	}

	@Override
	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_GET_BIEN)
	public NMBAnalisisContratosBien getAnalisisContratoBien(Long idAnalisisContratoBien) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "id", idAnalisisContratoBien);
		NMBAnalisisContratosBien objeto = genericDao.get(NMBAnalisisContratosBien.class, filtro);
		return objeto;
	}

	private NMBAnalisisContratosBien getAnalisisContratoBienParaBien(Long idBien) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "bien.id", idBien);
		NMBAnalisisContratosBien objeto = genericDao.get(NMBAnalisisContratosBien.class, filtro);
		return objeto;
	}

	private AnalisisContratos getAnalisisContratoIdContrato(Long idContrato) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "contrato.id", idContrato);
		AnalisisContratos objeto = genericDao.get(AnalisisContratos.class, filtro);
		return objeto;
	}

	@Override
	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_LISTADO_DTO)
	public List<AnalisisContratos> getListadoAnalisisContratos(Long idAsunto) {
		List<AnalisisContratos> listado = new ArrayList<AnalisisContratos>();
		Asunto asu = asuntoDao.get(idAsunto);
		Set<Contrato> contratos = asu.getContratos();

		for (Contrato contrato : contratos) {
			AnalisisContratos anc = getAnalisisContratoIdContrato(contrato.getId());
			if (anc == null) {
				Asunto asunto = new Asunto();
				asunto.setId(idAsunto);
				anc = new AnalisisContratos();
				anc.setContrato(contrato);
				anc.setAsunto(asunto);

			}
			anc.setEjecucionIniciada(existeContratoEnLitigio(contrato));
			listado.add(anc);
		}
		return listado;
		/*
		 * 
		 * List<AnalisisContratos> listaRetorno = new
		 * ArrayList<AnalisisContratos>(); PageHibernate page = (PageHibernate)
		 * analisisContratoDao.getListadoAnalisisContratos(dto); if (page !=
		 * null) { listaRetorno.addAll((List<AnalisisContratos>)
		 * page.getResults()); for(AnalisisContratos anc:
		 * (List<AnalisisContratos>)page.getResults()){
		 * anc.setEjecucionIniciada(existeContratoEnLitigio(anc.getContrato()));
		 * }
		 * 
		 * page.setResults(listaRetorno); } return page;
		 */
	}

	/**
	 * Método que comprueba si el contrato está litigiado
	 * 
	 * @param contrato
	 * @return
	 */
	private Boolean existeContratoEnLitigio(Contrato contrato) {

		for (ExpedienteContrato exp : contrato.getExpedienteContratos()) {
			for (Procedimiento prc : exp.getProcedimientos()) {
				Asunto asunto = prc.getAsunto();
				DDTiposAsunto tipoAsunto = asunto.getTipoAsunto();
				if (tipoAsunto != null && DDTiposAsunto.LITIGIO.equals(tipoAsunto.getCodigo())) {
					return true;
				}
			}
		}

		return false;
	}

	@SuppressWarnings("unchecked")
	@Override
	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_LISTADO_BIENES)
	public List<NMBAnalisisContratosBien> getBienesContratos(Long cntId) {

		List<NMBAnalisisContratosBien> listado = new ArrayList<NMBAnalisisContratosBien>();
		NMBAnalisisContratosBien anc = new NMBAnalisisContratosBien();

		List<NMBContratoBien> listaBienes = (List<NMBContratoBien>) executor.execute("plugin.nuevoModeloBienes.contratos.NMBContratoManager.getBienes", cntId);
		if (!Checks.estaVacio(listaBienes)) {
			for (NMBContratoBien cb : listaBienes) {
				// Recupera el Bien de Analisis de contrato.
				anc = getAnalisisContratoBienParaBien(cb.getBien().getId());
				if (anc == null) {
					anc = new NMBAnalisisContratosBien();
					anc.setBien(cb.getBien());
				}
				listado.add(anc);
			}
		}
		return listado;
	}

	@Override
	@Transactional
	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_GUARDAR_AC)
	public void guardar(AnalisisContratos analisisContratos) {
		genericDao.save(AnalisisContratos.class, analisisContratos);
	}

	@Override
	@Transactional
	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_GUARDAR_AC_BIEN)
	public void guardar(NMBAnalisisContratosBien analisisContratosBien) {
		genericDao.save(NMBAnalisisContratosBien.class, analisisContratosBien);
	}

	// ////////////////////////////////////////////////////////////////////
	// //////// Funciones para BPM ////////////////////////////////////////

	@Override
	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_BPM_ABC)
	public Boolean[] bpmGetValoresRamas(Long idAsunto) {
		Boolean[] resultado = { false, false, false };
		List<AnalisisContratos> contratos = getListadoAnalisisContratosPorAsunto(idAsunto);
		for (AnalisisContratos anc : contratos) {
			if (anc.getRevisadoA() != null && anc.getRevisadoA())
				resultado[0] = true;
			if (anc.getRevisadoB() != null && anc.getRevisadoB())
				resultado[1] = true;
			if (anc.getRevisadoC() != null && anc.getRevisadoC())
				resultado[2] = true;
		}
		return resultado;
	}

	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_LISTADO_POR_ASUNTO)
	public List<AnalisisContratos> getListadoAnalisisContratosPorAsunto(Long idAsunto) {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "asunto.id", idAsunto);
		Filter f2 = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List<AnalisisContratos> listado = genericDao.getList(AnalisisContratos.class, f1, f2);
		return listado;
	}

	@Override
	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_LISTADO_POR_PROCEDIMIENTO)
	public List<AnalisisContratos> getListadoAnalisisContratosPorProcedimiento(Long idProcedimiento) {
		Procedimiento proc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, idProcedimiento);
		Long idAsunto = proc.getAsunto().getId();
		return getListadoAnalisisContratosPorAsunto(idAsunto);
	}

	/**
	 * Comprueba que se han realizado el análisis de garantías. Al menos se ha
	 * marcado como revisado por cada contrato una opción A,B,C
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	public List<AnalisisContratos> bpmDameListadoAnalisisContrato(Long idProcedimiento) {
		Procedimiento proc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, idProcedimiento);
		Long idAsunto = proc.getAsunto().getId();
		List<AnalisisContratos> listado = getListadoAnalisisContratos(idAsunto);
		return listado;
	}

	/**
	 * Indica si se ha completado el análisis marcando el campo revisión.
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	public Boolean analisisDeGarantiasCompletado(Long idProcedimiento) {
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoA() == null || contrato.getRevisadoB() == null || contrato.getRevisadoC() == null) {
				return false;
			}
			;
		}
		return true;
	}

	/**
	 * Indica si se ha completado el campo "propuesta de ejecucición A" en todos
	 * los contratos.
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	public Boolean comprobarPropuestaEjecuciones(Long idProcedimiento) {
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoA() == null || !contrato.getRevisadoA())
				continue; // saltamos los que no están en A
			if (contrato.getPropuestaEjecucion() == null) {
				return false;
			}
			;
		}
		return true;
	}

	/**
	 * Indica si se ha consignado el campo Iniciar ejecución (Si/No) para todos
	 * los contratos.
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	public Boolean comprobarInicioEjecuciones(Long idProcedimiento) {
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoA() == null || !contrato.getRevisadoA())
				continue; // saltamos los que no están en A
			if (contrato.getIniciarEjecucion() == null) {
				return false;
			}
			;
		}
		return true;
	}

	/**
	 * Indica si hay discrepancias entre la propuesta de ejecución y iniciar
	 * ejecución indicado por el supervisor.
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	public Boolean existenGarantiasConDiscrepancia(Long idProcedimiento) {
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoA() == null || !contrato.getRevisadoA())
				continue; // saltamos los que no están en A
			if (contrato.getIniciarEjecucion() != null && contrato.getPropuestaEjecucion() != null && contrato.getIniciarEjecucion() != contrato.getPropuestaEjecucion()) {
				return true;
			}
			;
		}
		return false;
	}

	/**
	 * Devuelve el listado de Ids de los contratos con el flag iniciar
	 * ejecución.
	 */
	@Override
	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_LISTADO_CONTRATOS_ITERADOR_A)
	public List<Long> bpmDameContratosConIniciarEjecucionA(Long idProcedimiento) {
		List<Long> listadoIds = new ArrayList<Long>();
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoA() == null || !contrato.getRevisadoA())
				continue; // saltamos los que no están en A
			if (contrato.getIniciarEjecucion() != null && contrato.getIniciarEjecucion()) {
				listadoIds.add(contrato.getContrato().getId());
			}
			;
		}
		return listadoIds;
	}

	/**
	 * Garantías tienen informado el flag Solicitar solvencia y en caso de ser
	 * afirmativo tienen que tener la fecha de sol. solvencia.
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	public Boolean garantiasTienenSolicitudSolvencia(Long idProcedimiento) {
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoB() == null || !contrato.getRevisadoB())
				continue; // saltamos los que no están en B
			if (contrato.getSolicitarSolvencia() == null || (contrato.getSolicitarSolvencia() && contrato.getFechaSolicitarSolvencia() == null)) {
				return false;
			}
			;
		}
		return true;
	}

	/**
	 * Indica si hay garantías con el flag de solicitud de solvencia activado
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	public Boolean existeGarantiaConSolicitudSolvenciaSI(Long idProcedimiento) {
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoB() == null || !contrato.getRevisadoB())
				continue; // saltamos los que no están en B
			if (contrato.getSolicitarSolvencia() != null && contrato.getSolicitarSolvencia()) {
				return true;
			}
			;
		}
		return false;
	}

	/**
	 * Garantías que tienen solicitud de solvencia a true deben tener indicado
	 * la fecha de recepción, resultado y decisión
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	public Boolean garantiasTienenResultadoSolvencia(Long idProcedimiento) {
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoB() == null || !contrato.getRevisadoB())
				continue; // saltamos los que no están en B
			if (contrato.getSolicitarSolvencia() != null && contrato.getSolicitarSolvencia()
					&& (contrato.getFechaRecepcion() == null || contrato.getResultado() == null || contrato.getDecisionB() == null)) {
				return false;
			}
			;
		}
		return true;
	}

	/**
	 * Bienes que tienen solicitud de solvencia NEGATIVA o POSITIVA Y SIN
	 * INICIAR EJECUCION
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	public Boolean existeSolvenciaNegOPosNoIniciarEjecucion(Long idProcedimiento) {
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoB() == null || !contrato.getRevisadoB())
				continue; // saltamos los que no están en B
			if (contrato.getResultado() != null && (!contrato.getResultado() || (contrato.getResultado() && contrato.getDecisionB() != null && !contrato.getDecisionB()))) {
				return true;
			}
			;
		}
		return false;
	}

	/**
	 * Devuelve el listado de Ids de los contratos con el flag iniciar
	 * ejecución.
	 */
	@Override
	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_LISTADO_CONTRATOS_ITERADOR_B)
	public List<Long> bpmDameContratosConIniciarEjecucionB(Long idProcedimiento) {
		List<Long> listadoIds = new ArrayList<Long>();
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoB() == null || !contrato.getRevisadoB())
				continue; // saltamos los que no están en B
			if (contrato.getResultado() != null && contrato.getResultado() && contrato.getDecisionB() != null && contrato.getDecisionB()) {
				listadoIds.add(contrato.getContrato().getId());
			}
			;
		}
		return listadoIds;
	}

	/**
	 * Los bienes tienen que tener indicado la solicitud de afección/no afección
	 * así como la fecha de solicitud
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	public Boolean bienesTienenSolicitudNoAfeccion(Long idProcedimiento) {
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoC() == null || !contrato.getRevisadoC())
				continue; // saltamos los que no están en C
			// Recupera bienes para este contrato.
			List<NMBAnalisisContratosBien> listadoBienes = getBienesContratos(contrato.getContrato().getId());
			for (NMBAnalisisContratosBien bien : listadoBienes) {
				if (bien.getSolicitarNoAfeccion() == null || bien.getFechaSolicitarNoAfeccion() == null) {
					return false;
				}
				;
			}
		}
		return true;
	}

	/**
	 * Los bienes tienen que tener indicado la resolución de afección/no
	 * afección así como la fecha de solicitud
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	public Boolean bienesTienenResolucionNoAfeccion(Long idProcedimiento) {
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoC() == null || !contrato.getRevisadoC())
				continue; // saltamos los que no están en C
			// Recupera bienes para este contrato.
			List<NMBAnalisisContratosBien> listadoBienes = getBienesContratos(contrato.getContrato().getId());
			for (NMBAnalisisContratosBien bien : listadoBienes) {
				if (bien.getSolicitarNoAfeccion() != null && bien.getSolicitarNoAfeccion() && (bien.getResolucion() == null || bien.getFechaResolucion() == null)) {
					return false;
				}
				;
			}
		}
		return true;
	}

	/**
	 * existe algun bien/garantía que exista alguna garantía con Solicitud de
	 * NoAfección
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	public Boolean existeBienConSolicitudNoAfeccionSI(Long idProcedimiento) {
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoC() == null || !contrato.getRevisadoC())
				continue; // saltamos los que no están en C
			// Recupera bienes para este contrato.
			List<NMBAnalisisContratosBien> listadoBienes = getBienesContratos(contrato.getContrato().getId());
			for (NMBAnalisisContratosBien bien : listadoBienes) {
				if (bien.getSolicitarNoAfeccion() != null && bien.getSolicitarNoAfeccion()) {
					return true;
				}
				;
			}
		}
		return false;
	}

	/**
	 * existe algun bien/garantía que exista alguna garantía con decisión de
	 * NoAfección
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	public Boolean existeBienResolucionNoAfeccionFavorable(Long idProcedimiento) {
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);

		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoC() == null || !contrato.getRevisadoC())
				continue; // saltamos los que no están en C
			// Recupera bienes para este contrato.
			List<NMBAnalisisContratosBien> listadoBienes = getBienesContratos(contrato.getContrato().getId());
			for (NMBAnalisisContratosBien bien : listadoBienes) {
				if (bien.getResolucion() != null && bien.getResolucion()) {
					return true;
				}
				;
			}
		}

		// Las resoluciones de no afección son desfavorables todas, actualizamos
		// la fecha a un año.
		Calendar today_plus_year = Calendar.getInstance();
		today_plus_year.add(Calendar.YEAR, 1);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoC() == null || !contrato.getRevisadoC())
				continue; // saltamos los que no están en C
			contrato.setFechaProximaRevision(today_plus_year.getTime());
			guardar(contrato);
		}
		return false;
	}

	/**
	 * Las garantías tienen informado si es necesario ejecutar o no. Para esto
	 * debe informar la decisión de ejecutar o no en cada uno de los contratos
	 * en los que tenga alguna resolución favorable.
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	public Boolean garantiasTienenEsNecesarioEjecutar(Long idProcedimiento) {
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoC() == null || !contrato.getRevisadoC())
				continue; // saltamos los que no están en C
			List<NMBAnalisisContratosBien> listadoBienes = getBienesContratos(contrato.getContrato().getId());
			boolean comprobar = false;
			for (NMBAnalisisContratosBien bien : listadoBienes) {
				if (bien.getResolucion() == null)
					return false;
				if (bien.getResolucion()) {
					comprobar = true;
				}
				;
			}
			if (!comprobar)
				continue;
			if (contrato.getDecisionC() == null) {
				return false;
			}
			;
		}
		return true;
	}

	/**
	 * En caso que haya alguna ejecución paralizada (decisionC=false) y alguno
	 * de sus bienes tenga resolucion favorable.
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	public Boolean existeEjecucionParalizadaConAfeccionFavorable(Long idProcedimiento) {
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoC() == null || !contrato.getRevisadoC())
				continue; // saltamos los que no están en C
			if (contrato.getDecisionC() != null && contrato.getDecisionC())
				continue; // saltamos las inicar ejecución para centrarnos en
							// las NO
			// Recupera bienes para este contrato.
			List<NMBAnalisisContratosBien> listadoBienes = getBienesContratos(contrato.getContrato().getId());
			for (NMBAnalisisContratosBien bien : listadoBienes) {
				if (bien.getResolucion() != null && bien.getResolucion()) {
					return true;
				}
				;
			}
		}
		return false;
	}

	/**
	 * Devuelve el listado de Ids de los contratos con el flag iniciar ejecución
	 * C1.
	 */
	@Override
	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_LISTADO_CONTRATOS_ITERADOR_C1)
	public List<Long> bpmDameContratosConIniciarEjecucionC1(Long idProcedimiento) {
		List<Long> listadoIds = new ArrayList<Long>();
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoC() == null || !contrato.getRevisadoC())
				continue; // saltamos los que no están en B
			if (contrato.getDecisionC() != null && contrato.getDecisionC()) {
				listadoIds.add(contrato.getContrato().getId());
			}
			;
		}
		return listadoIds;
	}

	/**
	 * Todas las garantías tienen informado la decisión de revisión y
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	public Boolean garantiasTienenDecisionRevision(Long idProcedimiento) {
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoC() == null || !contrato.getRevisadoC())
				continue; // saltamos los que no están en C
			if (contrato.getFechaProximaRevision() == null)
				continue; // saltamos las que no estan a la espera de próxima
							// ejecució (no tienen fecha)
			if (contrato.getDecisionRevision() == null) {
				return false;
			}
			;
		}
		return true;
	}

	/**
	 * Indica si hay una orden de iniciar ejecución en la revisión
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	public Boolean existeContratosConDecisionRevSIEjecIniciada(Long idProcedimiento) {
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			// saltamos los que no están en C y ejecucion NO iniciada
			if (contrato.getRevisadoC() == null || !contrato.getRevisadoC() || !contrato.getEjecucionIniciada())
				continue;
			if (contrato.getDecisionRevision() != null && contrato.getDecisionRevision())
				return true;
		}
		return false;
	}

	/**
	 * Indica si hay una orden de iniciar ejecución en la revisión
	 * 
	 * @param idProcedimiento
	 * @return
	 */
	public Boolean existeContratosConDecisionRevSIEjecNoIniciada(Long idProcedimiento) {
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			// saltamos los que no están en C y ejecucion iniciada
			if (contrato.getRevisadoC() == null || !contrato.getRevisadoC() || contrato.getEjecucionIniciada())
				continue;
			if (contrato.getDecisionRevision() != null && contrato.getDecisionRevision())
				return true;
		}
		return false;
	}

	/**
	 * Devuelve el listado de Ids de los contratos con el flag iniciar ejecución
	 * C2.
	 */
	@Override
	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_LISTADO_CONTRATOS_ITERADOR_C2)
	public List<Long> bpmDameContratosConIniciarEjecucionC2(Long idProcedimiento) {
		List<Long> listadoIds = new ArrayList<Long>();
		List<AnalisisContratos> listado = bpmDameListadoAnalisisContrato(idProcedimiento);
		for (AnalisisContratos contrato : listado) {
			if (contrato.getRevisadoC() == null || !contrato.getRevisadoC())
				continue; // saltamos los que no están en B
			if (contrato.getDecisionRevision() != null && contrato.getDecisionRevision()) {
				listadoIds.add(contrato.getContrato().getId());
			}
			;
		}
		return listadoIds;
	}

	@Override
	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_GUARDAR_AC_DTO)
	@Transactional(readOnly = false)
	public void guardarAnalisisContratos(AnalisisContratosDto dto) {

		SimpleDateFormat formatoDeFecha = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

		AnalisisContratos contrato = new AnalisisContratos();
		if(!Checks.esNulo(dto.getId())){
			contrato = genericDao.get(AnalisisContratos.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId())));
			contrato.setId(Long.parseLong(dto.getId()));
		}
		if (!Checks.esNulo(contrato)) {

			contrato.setContrato(genericDao.get(Contrato.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getContratoId()))));

			if (!Checks.esNulo(dto.getRevisadoA())) {
				contrato.setRevisadoA(Boolean.parseBoolean(dto.getRevisadoA()) ? true : false);
			} else {
				contrato.setRevisadoA(null);
			}

			if (!Checks.esNulo(dto.getEjecucionIniciada())) {
				contrato.setEjecucionIniciada(Boolean.parseBoolean(dto.getEjecucionIniciada()) ? true : false);
			} else {
				contrato.setEjecucionIniciada(null);
			}

			if (!Checks.esNulo(dto.getPropuestaEjecucion())) {
				contrato.setPropuestaEjecucion(Boolean.parseBoolean(dto.getPropuestaEjecucion()) ? true : false);
			} else {
				contrato.setPropuestaEjecucion(null);
			}

			if (!Checks.esNulo(dto.getIniciarEjecucion())) {
				contrato.setIniciarEjecucion(Boolean.parseBoolean(dto.getIniciarEjecucion()) ? true : false);
			} else {
				contrato.setIniciarEjecucion(null);
			}

			if (!Checks.esNulo(dto.getRevisadoB())) {
				contrato.setRevisadoB(Boolean.parseBoolean(dto.getRevisadoB()) ? true : false);
			} else {
				contrato.setRevisadoB(null);
			}

			if (!Checks.esNulo(dto.getSolicitarSolvencia())) {
				contrato.setSolicitarSolvencia(Boolean.parseBoolean(dto.getSolicitarSolvencia()) ? true : false);
			} else {
				contrato.setSolicitarSolvencia(null);
			}

			if (!Checks.esNulo(dto.getResultado())) {
				contrato.setResultado(Boolean.parseBoolean(dto.getResultado()) ? true : false);
			} else {
				contrato.setResultado(null);
			}

			if (!Checks.esNulo(dto.getDecisionB())) {
				contrato.setDecisionB(Boolean.parseBoolean(dto.getDecisionB()) ? true : false);
			} else {
				contrato.setDecisionB(null);
			}

			if (!Checks.esNulo(dto.getRevisadoC())) {
				contrato.setRevisadoC(Boolean.parseBoolean(dto.getRevisadoC()) ? true : false);
			} else {
				contrato.setRevisadoC(null);
			}

			if (!Checks.esNulo(dto.getDecisionC())) {
				contrato.setDecisionC(Boolean.parseBoolean(dto.getDecisionC()) ? true : false);
			} else {
				contrato.setDecisionC(null);
			}
			
			if (!Checks.esNulo(dto.getDecisionRevision())) {
				contrato.setDecisionRevision(Boolean.parseBoolean(dto.getDecisionRevision()) ? true : false);
			} else {
				contrato.setDecisionRevision(null);
			}

			try {
				contrato.setFechaSolicitarSolvencia(!Checks.esNulo(dto.getFechaSolicitarSolvencia()) ? formatoDeFecha.parse(dto.getFechaSolicitarSolvencia()) : null);
				contrato.setFechaRecepcion(!Checks.esNulo(dto.getFechaRecepcion()) ? formatoDeFecha.parse(dto.getFechaRecepcion()) : null);
				contrato.setFechaProximaRevision(!Checks.esNulo(dto.getFechaProximaRevision()) ? formatoDeFecha.parse(dto.getFechaProximaRevision()) : null);
			} catch (Exception e) {
				e.printStackTrace();
			}

			genericDao.save(AnalisisContratos.class, contrato);
		}

	}

	@Override
	@BusinessOperation(BO_NMB_ANALISIS_CONTRATOS_BIENES_GUARDAR_AC)
	@Transactional(readOnly = false)
	public void guardarAnalisisContratosBienes(AnalisisContratosBienesDto dto) {

		SimpleDateFormat formatoDeFecha = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
		
		NMBAnalisisContratosBien NMBAnc = new NMBAnalisisContratosBien();
		
		if(!Checks.esNulo(dto.getId())){
			NMBAnc = genericDao.get(NMBAnalisisContratosBien.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getId())));
			NMBAnc.setId(Long.parseLong(dto.getId()));
		}


		NMBBien NMBBien = genericDao.get(NMBBien.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getBieId())));
		NMBAnc.setBien(NMBBien);

		AnalisisContratos anc = new AnalisisContratos();
		if(!Checks.esNulo(dto.getAncId())){
			anc = genericDao.get(AnalisisContratos.class, genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(dto.getAncId())));
		}
		NMBAnc.setAnalisisContrato(anc);
				
		if (!Checks.esNulo(dto.getSolicitarNoAfeccion())) {
			NMBAnc.setSolicitarNoAfeccion(Boolean.parseBoolean(dto.getSolicitarNoAfeccion()) ? true : false);
		} else {
			NMBAnc.setSolicitarNoAfeccion(null);
		}

		if (!Checks.esNulo(dto.getResolucion())) {
			NMBAnc.setResolucion(Boolean.parseBoolean(dto.getResolucion()) ? true : false);
		} else {
			NMBAnc.setResolucion(null);
		}

		try {
			NMBAnc.setFechaSolicitarNoAfeccion(!Checks.esNulo(dto.getFechaSolicitarNoAfeccion()) ? formatoDeFecha.parse(dto.getFechaSolicitarNoAfeccion()) : null);
			NMBAnc.setFechaResolucion(!Checks.esNulo(dto.getFechaResolucion()) ? formatoDeFecha.parse(dto.getFechaResolucion()) : null);
		} catch (Exception e) {
			e.printStackTrace();
		}

		genericDao.save(NMBAnalisisContratosBien.class, NMBAnc);

	}

}
