package es.pfsgroup.concursal.concurso;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.concursal.concurso.dto.DtoConcurso;
import es.pfsgroup.concursal.concurso.dto.DtoContratoConcurso;
import es.pfsgroup.concursal.convenio.dao.ConvenioCreditoDao;
import es.pfsgroup.concursal.convenio.dao.ConvenioDao;
import es.pfsgroup.concursal.convenio.model.Convenio;
import es.pfsgroup.concursal.convenio.model.ConvenioCredito;
import es.pfsgroup.concursal.credito.dao.CreditoDao;
import es.pfsgroup.concursal.credito.dao.DDEstadoCreditoDao;
import es.pfsgroup.concursal.credito.dao.DDTipoCreditoDao;
import es.pfsgroup.concursal.credito.dto.DtoAgregarCredito;
import es.pfsgroup.concursal.credito.model.Credito;
import es.pfsgroup.concursal.credito.model.DDEstadoCredito;
import es.pfsgroup.concursal.credito.model.DDTipoCredito;
import es.pfsgroup.procedimientos.context.api.ProcedimientosProjectContext;

@Service("concursoManager")
public class ConcursoManager {

	@Autowired
	Executor executor;

	@Autowired
	private CreditoDao creditoDao;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ConvenioDao convenioDao;

	@Autowired
	private ConvenioCreditoDao convenioCreditoDao;

	@Autowired
	private DDTipoCreditoDao tipoCreditoDao;

	@Autowired
	private DDEstadoCreditoDao estadoCreditoDao;
	
	@Autowired
	private ProcedimientosProjectContext projectContext;

	@BusinessOperation("concursoManager.dameCredito")
	public Credito dameCredito(long idCredito) {
		return creditoDao.get(idCredito);
	}

	@BusinessOperation("concursoManager.borrarCredito")
	@Transactional(readOnly = false)
	public void borrarCredito(Long idCredito) {
		// hay que setear a borrado los ConvenioCredito asociados.
		List<ConvenioCredito> listaConvenioCreditos = convenioCreditoDao
				.findByIdCredito(idCredito);
		for (ConvenioCredito cc : listaConvenioCreditos)
			convenioCreditoDao.delete(cc);
		creditoDao.deleteById(idCredito);
	}

	@BusinessOperation("concursoManager.dameNumDeProcsFaseComun")
	public int dameNumDeProcsFaseComun(Long idAsunto) {
		Asunto asu = (Asunto) executor.execute(
				ExternaBusinessOperation.BO_ASU_MGR_GET, idAsunto);
		List<Procedimiento> faseConvenio = procedimientosFaseComun(asu); /*
																		 * O
																		 * ANTICIAPADA
																		 */
		return faseConvenio.size();
	}

	@BusinessOperation("concursoManager.esConcursal")
	public Boolean esConcursal(Long idProcedimiento) {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id",
				idProcedimiento);
		Procedimiento p = genericDao.get(Procedimiento.class, f1);
		if (p != null
				&& p.getTipoProcedimiento().getTipoActuacion().getCodigo()
						.equals("CO")) {
			return true;
		}
		return false;
	}

	@BusinessOperation("concursoManager.listadoFaseComun")
	public List<DtoConcurso> listadoFaseComun(Long idAsunto) {
		ArrayList<DtoConcurso> concursos = new ArrayList<DtoConcurso>();
		List<String> listaNumerosAuto = new ArrayList<String>();
		Asunto asu = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, idAsunto);
		Set<String> procedimientosPestanyaFaseComun = projectContext.getProcedimientosPestanyaFaseComun();
		/* construir lista de numeros de auto */
		for (Procedimiento p : asu.getProcedimientos()) {
			if (p.getTipoProcedimiento() != null
					&& p.getTipoActuacion() != null
					//&& "CO".equals(p.getTipoActuacion().getCodigo())
					&& procedimientosPestanyaFaseComun.contains(p.getTipoProcedimiento().getCodigo())) { //fase liquidacion
				if ((p.getCodigoProcedimientoEnJuzgado() != null) && ((listaNumerosAuto == null) || (!listaNumerosAuto.contains(p.getCodigoProcedimientoEnJuzgado())))) {
					if (!listaNumerosAuto.contains(p.getCodigoProcedimientoEnJuzgado())) {
						listaNumerosAuto.add(p.getCodigoProcedimientoEnJuzgado());
					}
				}
			}
		}
		/*----------------------------------*/

		if (listaNumerosAuto != null) { // para cada n�mero auto
			Long idProceidmientoMin;
			for (String numeroAuto : listaNumerosAuto) {
				idProceidmientoMin = null;
				// buscamos el id de procedimeinto mas bajo para el numero de
				// auto tratado
				for (Procedimiento p : asu.getProcedimientos()) {
					if ((p.getCodigoProcedimientoEnJuzgado() != null)
							&& (p.getCodigoProcedimientoEnJuzgado()
									.equals(numeroAuto)))
						if ((idProceidmientoMin == null)
								|| (p.getId() < idProceidmientoMin))
							idProceidmientoMin = p.getId();
				}
				if (idProceidmientoMin != null) {
					Procedimiento proc = (Procedimiento) executor
							.execute(
									ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,
									idProceidmientoMin);
					DtoConcurso concurso = new DtoConcurso();
					concurso.setNumeroAuto(numeroAuto);
					for (ExpedienteContrato ec : proc.getExpedienteContratos()) {
						DtoContratoConcurso con = new DtoContratoConcurso();
						con.setIdProcedimiento(idProceidmientoMin);
						con.setIdContratoExpediente(ec.getId());
						con.setContrato(ec.getContrato());
						concurso.getContratos().add(con);
						con.getCreditos().addAll(
								creditoDao.findByContratoProcedimiento(
										ec.getId(), idProceidmientoMin));
					}
					concursos.add(concurso);
				}
			}
		}
		return concursos;
	}

	/**
	 * Devuelve los creditos insinuados a partir de un procedimiento dado, para
	 * ello busca los cr�ditos registrados en los procedimientos de = numero
	 * Auto
	 * 
	 * @param idProcedimiento
	 * @return lista de creditos insinuados.
	 * 
	 **/
	@BusinessOperation
	public List<Credito> dameCreditosInsinuados(Long idProcedimiento) {
		List<Credito> creditos = new ArrayList<Credito>();

		if (idProcedimiento != null) {
			Procedimiento proc = (Procedimiento) executor.execute(
					ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,
					idProcedimiento);
			/* extraer num auto */
			String numAuto = proc.getCodigoProcedimientoEnJuzgado();
			Long idAsunto = proc.getAsunto().getId();
			List<Procedimiento> procedimientoPorAuto = procedimientosPorNumAuto(
					idAsunto, numAuto);
			/* para cada procedimiento encontrado */
			for (Procedimiento p : procedimientoPorAuto) {
				/* para cada expediente */
				for (ExpedienteContrato ec : p.getExpedienteContratos()) {
					/* busca creditos insinuados */
					for (Credito c : creditoDao.findByContratoProcedimiento(
							ec.getId(), p.getId())) {
						DDEstadoCredito estadoCredito = c.getEstadoCredito();
						if ((estadoCredito != null) && (!DDEstadoCredito.CODIGO_NO_INSINUADO.equals(estadoCredito.getCodigo()))){
							// Sólo añadimos los que tienen un estado distinto de 'No insinuado', cuyo código en bbdd es 11
							creditos.add(c);
						}
					}
				}
			}
		}

		return creditos;
	}

	/**
	 * Devuelve los creditos insinuados a partir de un procedimiento dado, para
	 * ello busca los crï¿½ditos registrados en los procedimientos de = numero
	 * Auto y cuyo estado sea distinto de 'No insinuado'
	 * 
	 * @param idProcedimiento
	 * @return lista de creditos insinuados.
	 * 
	 **/
	//FIXME Quitar este método, habrá que hacer cambios en scripts Groovy y demás del plugin de UGAS cuando quitemos este método.
	@BusinessOperation
	@Deprecated
	public List<Credito> dameCreditosInsinuadosUGAS(Long idProcedimiento) {
		List<Credito> creditos = new ArrayList<Credito>();

		if (idProcedimiento != null) {
			Procedimiento proc = (Procedimiento) executor.execute(
					ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,
					idProcedimiento);
			/* extraer num auto */
			String numAuto = proc.getCodigoProcedimientoEnJuzgado();
			Long idAsunto = proc.getAsunto().getId();
			List<Procedimiento> procedimientoPorAuto = procedimientosPorNumAuto(
					idAsunto, numAuto);
			/* para cada procedimiento encontrado */
			for (Procedimiento p : procedimientoPorAuto) {
				/* para cada expediente */
				for (ExpedienteContrato ec : p.getExpedienteContratos()) {
					/* busca creditos insinuados */
					for (Credito c : creditoDao.findByContratoProcedimiento(
							ec.getId(), p.getId())) {
						if (!c.getEstadoCredito().getCodigo().toString().equals("11")){
							// Sólo añadimos los que tienen un estado distinto de 'No insinuado', cuyo código en bbdd es 11
							creditos.add(c);
						}
					}
				}
			}
		}

		return creditos;
	}
	
	/*
	 * entrada a concurso manager en JBPMProcessUtils.java y en
	 * ac-rec-common-utils.xml
	 */
	/*-------------------------- pendiente *-------------------------*/

	/**
	 * Este m�todo nos devuelve los procedimientos del asunto con = numero de
	 * auto
	 * 
	 * @param asunto
	 *            , idProcedimiento
	 * @return lista de procedimientos
	 */
	private List<Procedimiento> procedimientosPorNumAuto(Long idAsunto,
			String numAuto) {
		String current_numAuto;
		Asunto asu = (Asunto) executor.execute(
				ExternaBusinessOperation.BO_ASU_MGR_GET, idAsunto);
		List<Procedimiento> listaProcedimientosBuscados = new ArrayList<Procedimiento>();
		List<Procedimiento> listaDeTodosLosProcedimientosAsunto = asu
				.getProcedimientos();

		if (listaDeTodosLosProcedimientosAsunto != null) {
			for (Procedimiento p : listaDeTodosLosProcedimientosAsunto) {
				current_numAuto = p.getCodigoProcedimientoEnJuzgado();
				if ((current_numAuto != null)
						&& (current_numAuto.equals(numAuto))) {
					listaProcedimientosBuscados.add(p);
				}
			}
		}
		return listaProcedimientosBuscados;
	}

	@BusinessOperation("concursoManager.tiposDeCredito")
	public List<DDTipoCredito> tiposDeCredito() {
		return tipoCreditoDao.getList();
	}

	@BusinessOperation("concursoManager.estadosCredito")
	public List<DDEstadoCredito> estadosCredito() {
		/*
		 * Ordenamos por ID para que aparezcan en la vsta en el orden en el
		 * que se han introducido. Como la descripcióne está numerada, si ordenamos
		 * por ella el orden sale incorrecto, por ejemplo: 1,10,2,20,3,4, etc ..
		 */
		return genericDao.getListOrdered(DDEstadoCredito.class, new Order(
				OrderType.ASC, "id"));
	}

	@BusinessOperation("concursoManager.editarCreditoDefinitivo")
	@Transactional(readOnly = false)
	public void editarCreditoDefinitivo(DtoAgregarCredito dto) {
		Credito credito = creditoDao.get(dto.getIdCredito());
		credito.setPrincipalDefinitivo(dto.getDefinitivoPrincipal());
		if (dto.getDefinitivoTipoCredito() != null)
			credito.setTipoDefinitivo(tipoCreditoDao.get(dto
					.getDefinitivoTipoCredito()));
		else
			credito.setTipoDefinitivo(null);
		if (dto.getEstadoCredito() != null)
			credito.setEstadoCredito(estadoCreditoDao.get(dto
					.getEstadoCredito()));
		else
			credito.setEstadoCredito(null);
		
		if(dto.getFechaVencimiento() != null) {		
			credito.setFechaVencimiento(FormatUtils.strADate(dto.getFechaVencimiento(), "yyyy-MM-dd"));
		}
		
		creditoDao.save(credito);
		agregarCreditoAconvenio(credito);
	}

	@BusinessOperation("concursoManager.editarCreditoSupervisor")
	@Transactional(readOnly = false)
	public void editarCreditoSupervisor(DtoAgregarCredito dto) {
		Credito credito = creditoDao.get(dto.getIdCredito());
		credito.setPrincipalSupervisor(dto.getSupervisorPrincipal());
		if (dto.getSupervisorTipoCredito() != null)
			credito.setTipoSupervisor(tipoCreditoDao.get(dto
					.getSupervisorTipoCredito()));
		else
			credito.setTipoSupervisor(null);
		creditoDao.save(credito);
		agregarCreditoAconvenio(credito);
	}

	@BusinessOperation("concursoManager.editarCreditoExterno")
	@Transactional(readOnly = false)
	public void editarCreditoExterno(DtoAgregarCredito dto) {
		Credito credito = creditoDao.get(dto.getIdCredito());
		credito.setPrincipalExterno(dto.getExternoPrincipal());
		if (dto.getExternoTipoCredito() != null)
			credito.setTipoExterno(tipoCreditoDao.get(dto
					.getExternoTipoCredito()));
		else
			credito.setTipoExterno(null);
		creditoDao.save(credito);
		agregarCreditoAconvenio(credito);
	}

	@BusinessOperation("concursoManager.editarCredito")
	@Transactional(readOnly = false)
	public void editarCredito(DtoAgregarCredito dto) {
		Credito credito = creditoDao.get(dto.getIdCredito());

		credito.setPrincipalSupervisor(dto.getSupervisorPrincipal());
		credito.setPrincipalExterno(dto.getExternoPrincipal());
		credito.setPrincipalDefinitivo(dto.getDefinitivoPrincipal());

		if (dto.getSupervisorTipoCredito() != null)
			credito.setTipoSupervisor(tipoCreditoDao.get(dto
					.getSupervisorTipoCredito()));
		else
			credito.setTipoSupervisor(null);

		if (dto.getExternoTipoCredito() != null)
			credito.setTipoExterno(tipoCreditoDao.get(dto
					.getExternoTipoCredito()));
		else
			credito.setTipoExterno(null);

		if (dto.getDefinitivoTipoCredito() != null)
			credito.setTipoDefinitivo(tipoCreditoDao.get(dto
					.getDefinitivoTipoCredito()));
		else
			credito.setTipoDefinitivo(null);

		if (dto.getEstadoCredito() != null)
			credito.setEstadoCredito(estadoCreditoDao.get(dto
					.getEstadoCredito()));
		else
			credito.setEstadoCredito(null);

		creditoDao.save(credito);

		agregarCreditoAconvenio(credito);
	}

	@BusinessOperation("concursoManager.agregarCredito")
	@Transactional(readOnly = false)
	public void agregarCredito(DtoAgregarCredito dto) {
		Credito credito = new Credito();
		credito.setIdProcedimiento(dto.getIdProcedimiento());
		credito.setIdContratoExpediente(dto.getIdContratoExpediente());

		if (dto.getSupervisorTipoCredito() != null)
			credito.setTipoSupervisor(tipoCreditoDao.get(dto
					.getSupervisorTipoCredito()));
		credito.setPrincipalSupervisor(dto.getSupervisorPrincipal());

		if (dto.getExternoTipoCredito() != null)
			credito.setTipoExterno(tipoCreditoDao.get(dto
					.getExternoTipoCredito()));
		credito.setPrincipalExterno(dto.getExternoPrincipal());

		if (dto.getDefinitivoTipoCredito() != null)
			credito.setTipoDefinitivo(tipoCreditoDao.get(dto
					.getDefinitivoTipoCredito()));		
		
		credito.setPrincipalDefinitivo(dto.getDefinitivoPrincipal());

		if (dto.getEstadoCredito() != null)
			credito.setEstadoCredito(estadoCreditoDao.get(dto
					.getEstadoCredito()));

		if(dto.getFechaVencimiento() != null) {		
			credito.setFechaVencimiento(FormatUtils.strADate(dto.getFechaVencimiento(), "yyyy-MM-dd"));
		}
		
		creditoDao.save(credito);

		agregarCreditoAconvenio(credito);
	}

	/**
	 * Este m�todo Agrega un cr�dito a los posibles convenios ordinarios donde
	 * pueda aparecer, siempre que el credito tenga registrados valores
	 * definitivos.
	 * 
	 * @param credito
	 * @return nada
	 */
	private void agregarCreditoAconvenio(Credito credito) {
		if (credito.getTipoDefinitivo() != null
				|| credito.getPrincipalDefinitivo() != null) {
			List<Convenio> listaConvenios = new ArrayList<Convenio>();
			List<ConvenioCredito> listaConvenioCreditos = new ArrayList<ConvenioCredito>();
			listaConvenios = convenioDao.findByProcedimiento(credito
					.getIdProcedimiento());
			if (listaConvenios != null) {
				for (Convenio c : listaConvenios) {
					if (c.getTipoConvenio().getCodigo().equals("2")) {
						listaConvenioCreditos = convenioCreditoDao
								.findByIdConvenioIdCredito(c.getId(),
										credito.getId());
						if (listaConvenioCreditos.isEmpty()) {
							ConvenioCredito convenioCredito = new ConvenioCredito();
							convenioCredito.setCredito(credito);
							convenioCredito.setConvenio(c);
							convenioCreditoDao.save(convenioCredito);
						}
					}
				}
			}
		}
	}

	/**
	 * Este m�todo nos devuelve los procedimientos del asunto que son del tipo
	 * Fase Comun O CONVENIO ANTICIPADO
	 * 
	 * @param asunto
	 * @return
	 */
	private List<Procedimiento> procedimientosFaseComun(Asunto asunto) {
		List<Procedimiento> listaProcedimientosFaseComunAsunto = new ArrayList<Procedimiento>();
		List<Procedimiento> listaDeTodosLosProcedimientosAsunto = asunto
				.getProcedimientos();
		if (listaDeTodosLosProcedimientosAsunto != null) {
			for (Procedimiento p : listaDeTodosLosProcedimientosAsunto) {
				if (p.getTipoProcedimiento().getTipoActuacion().getCodigo()
						.equals("CO"))
					// if
					// ((p.getTipoProcedimiento().getCodigo().equals("P56"))||(p.getTipoProcedimiento().getCodigo().equals("P24"))||(p.getTipoProcedimiento().getCodigo().equals("P30")))
					listaProcedimientosFaseComunAsunto.add(p);
			}
		}
		return listaProcedimientosFaseComunAsunto;
	}

	/**
	 * Este m�todo nos devuelve els estado por defecto para los cr�ditos
	 * 
	 * @param
	 * @return estado por defecto
	 */
	@BusinessOperation("concursoManager.dameEstadoCreditoPorDefecto")
	public long dameEstadoCreditoPorDefecto() {
		List<DDEstadoCredito> listaEstados = estadoCreditoDao.getList();
		if (listaEstados != null)
			for (DDEstadoCredito ec : listaEstados) {
				if (ec.getCodigo().equals("1"))
					return ec.getId();
			}
		return 2;
	}

	/****
	 * 
	 * Funci�n utilizada por el tr�mite fase com�n abreviado, en la tarea
	 * Presentar escritos e insinuaci�n de cr�ditos, para obtener el importe
	 * total de los creditos por procedimiento y tipo de cr�ditos.
	 * 
	 * @param idProcedimiento
	 *            Procedimiento del tr�mite
	 * @param tipoCredito
	 *            C�digo del tipo de cr�dito
	 * 
	 * */
	public float dameTotalImporteCreditosPorProcedimientoYTipoCredito(
			Long idProcedimiento, String tipoCredito) {
		float resultado = 0;
		if (idProcedimiento != null) {
			Procedimiento proc = (Procedimiento) executor.execute(
					ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO,
					idProcedimiento);
			/* extraer num auto */
			String numAuto = proc.getCodigoProcedimientoEnJuzgado();
			Long idAsunto = proc.getAsunto().getId();
			List<Procedimiento> procedimientoPorAuto = procedimientosPorNumAuto(
					idAsunto, numAuto);
			/* para cada procedimiento encontrado */
			for (Procedimiento p : procedimientoPorAuto) {
				/* para cada expediente */
				for (ExpedienteContrato ec : p.getExpedienteContratos()) {
					/* busca creditos insinuados */
					List<Credito> listado = creditoDao.findByContratoProcedimiento(
							ec.getId(), p.getId());
					if(!Checks.estaVacio(listado)){
						for (Credito c : listado) {
							//SUMAMOS TODOS LOS CREDITOS
							if(tipoCredito.equalsIgnoreCase("0")){
								resultado += c.getPrincipalDefinitivo();
							}
							else{
								if (c.getTipoDefinitivo() != null
										&& c.getTipoDefinitivo().getCodigo()
										.equalsIgnoreCase(tipoCredito)) {
									if (c.getPrincipalDefinitivo() != null)
										resultado += c.getPrincipalDefinitivo();
								}
							}
						}
					}
				}
			}
		}

		return resultado;
	}

}
