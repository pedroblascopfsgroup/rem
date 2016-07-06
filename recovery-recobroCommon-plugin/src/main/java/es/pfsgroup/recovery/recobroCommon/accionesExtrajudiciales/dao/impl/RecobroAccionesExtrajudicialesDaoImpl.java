package es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dao.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dao.api.RecobroAccionesExtrajudicialesDaoApi;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dto.RecobroAccionesExtrajudicialesDto;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.dto.RecobroAccionesExtrajudicialesExpedienteDto;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroAccionesExtrajudiciales;
import es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model.RecobroDDResultadoGestionTelefonica;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.utils.RecobroConfigConstants.RecobroCommonAccionesExtrajudicialesConstants;

/**
 * Implementación de métodos para la persistencia de datos de las acciones extrajudiciales
 * @author Guillem
 *
 */
@Repository
public class RecobroAccionesExtrajudicialesDaoImpl extends AbstractEntityDao<RecobroAccionesExtrajudiciales, Long> 
	implements	RecobroAccionesExtrajudicialesDaoApi {

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_UNCHECKED)
	@Override
	public List<RecobroAccionesExtrajudiciales> getAccionesPorAgenciaResultadoFechaGestion(RecobroAgencia agencia, 
			Date fechaGestion, RecobroDDResultadoGestionTelefonica resultadoGestionTelefonica){
		
		return getHibernateTemplate().find(generaHQLAccionesPorAgenciaResultadoFechaGestion(agencia, fechaGestion, resultadoGestionTelefonica));

	}

	private String generaHQLAccionesPorAgenciaResultadoFechaGestion(RecobroAgencia agencia, Date fechaGestion, 
			RecobroDDResultadoGestionTelefonica resultadoGestionTelefonica){

		StringBuffer query = new StringBuffer();
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_1);
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_2 + agencia.getId());
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_3 + resultadoGestionTelefonica.getId());
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_4 + fechaGestion +
				RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_COMILLA);
		return query.toString();

	}

	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_UNCHECKED)
	@Override
	public List<RecobroAccionesExtrajudiciales> getAccionesPorAgenciaContratoResultadoFechaGestion(
			RecobroAgencia agencia, Contrato contrato, Date fechaGestion,
			RecobroDDResultadoGestionTelefonica resultadoGestionTelefonica) {

		return getHibernateTemplate().find(generaHQLAccionesPorAgenciaContratoResultadoFechaGestion(agencia, contrato, fechaGestion, resultadoGestionTelefonica));
		
	}

	private String generaHQLAccionesPorAgenciaContratoResultadoFechaGestion(RecobroAgencia agencia, Contrato contrato, Date fechaGestion, 
			RecobroDDResultadoGestionTelefonica resultadoGestionTelefonica){

		StringBuffer query = new StringBuffer();
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_1);
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_2 + agencia.getId());
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_3 + resultadoGestionTelefonica.getId());
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_4 + fechaGestion+
				RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_COMILLA);
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_CONTRATO + contrato.getId());
		return query.toString();

	}
	
	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_UNCHECKED)
	@Override
	public List<RecobroAccionesExtrajudiciales> getAccionesPorAgenciaContratoIntervaloFechaGestion(
			RecobroAgencia agencia, Contrato contrato, Date fechaGestionInicial, Date fechaGestionFinal) {
		
		return getHibernateTemplate().find(generaHQLAccionesPorAgenciaContratoIntervaloFechaGestion(agencia, 
				contrato, fechaGestionInicial, fechaGestionFinal));
		
	}
	
	private String generaHQLAccionesPorAgenciaContratoIntervaloFechaGestion(RecobroAgencia agencia, Contrato contrato, 
			Date fechaGestionInicial, Date fechaGestionFinal) {

		StringBuffer query = new StringBuffer();
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_1);
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_2 + agencia.getId());
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_CONTRATO + contrato.getId());
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_CONTRATO_INTERVALO_FECHA_1 + fechaGestionInicial +
				RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_COMILLA_AND_COMILLA + fechaGestionFinal +
				RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_COMILLA);

		return query.toString();

	}
	
	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_UNCHECKED)
	@Override
	public List<RecobroAccionesExtrajudiciales> getAccionesPorAgenciaContratoIntervaloFechaGestionResultados(
			RecobroAgencia agencia, Contrato contrato, Date fechaGestionInicial, 
			Date fechaGestionFinal, List<String> codigosResultadosGestionTelefonica) {
		
		return getHibernateTemplate().find(generaHQLAccionesPorAgenciaContratoIntervaloFechaGestion(agencia, 
				contrato, fechaGestionInicial, fechaGestionFinal, codigosResultadosGestionTelefonica));
		
	}
	
	private String generaHQLAccionesPorAgenciaContratoIntervaloFechaGestion(RecobroAgencia agencia, Contrato contrato, 
			Date fechaGestionInicial, Date fechaGestionFinal, List<String> codigosResultadosGestionTelefonica) {

		StringBuffer query = new StringBuffer();
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_1);
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_2 + agencia.getId());
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_CONTRATO + contrato.getId());
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_CONTRATO_INTERVALO_FECHA_1 + fechaGestionInicial +
				RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_COMILLA_AND_COMILLA + fechaGestionFinal +
				RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_COMILLA);
		query.append(obtenerResultadosWhereIn("ae.resultadoGestionTelefonica.id", codigosResultadosGestionTelefonica));

		return query.toString();

	}
	
	/**
	 * {@inheritDoc}
	 */
	@SuppressWarnings(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_UNCHECKED)
	@Override
	public List<RecobroAccionesExtrajudiciales> getAccionesPorAgenciaPersonaIntervaloFechaGestionResultados(
			RecobroAgencia agencia, Persona persona, Date fechaGestionInicial, 
			Date fechaGestionFinal, List<String> codigosResultadosGestionTelefonica) {
		
		return getHibernateTemplate().find(generaHQLAccionesPorAgenciaPersonaIntervaloFechaGestion(agencia, 
				persona, fechaGestionInicial, fechaGestionFinal, codigosResultadosGestionTelefonica));
		
	}
	
	private String generaHQLAccionesPorAgenciaPersonaIntervaloFechaGestion(RecobroAgencia agencia, Persona persona, 
			Date fechaGestionInicial, Date fechaGestionFinal, List<String> codigosResultadosGestionTelefonica) {

		StringBuffer query = new StringBuffer();
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_1);
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_2 + agencia.getId());
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_RESULTADO_FECHA_PERSONA + persona.getId());
		query.append(RecobroCommonAccionesExtrajudicialesConstants.
				PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_SELECT_OBTENER_ACCIONES_POR_AGENCIA_CONTRATO_INTERVALO_FECHA_1 + fechaGestionInicial +
				RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_COMILLA_AND_COMILLA + fechaGestionFinal +
				RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_COMILLA);
		query.append(obtenerResultadosWhereIn("ae.resultadoGestionTelefonica.id", codigosResultadosGestionTelefonica));

		return query.toString();

	}
	
	/**
	 * Método para obtener la clausula where in de una lista de resultados de gestión telefonica
	 * @param field
	 * @param resultadosGestionTelefonica
	 * @return
	 */
	private String obtenerResultadosWhereIn(String field, List<String> codigosResultadosGestionTelefonica){
		StringBuilder sb = new StringBuilder();
		sb.append(" and " + field).append(" in (");
		boolean first = true;
		for (String codigoResultadosGestionTelefonica : codigosResultadosGestionTelefonica) {
			if (!first) {
				sb.append(", ");
			} else {
				first = false;
			}
			sb.append(RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_COMILLA + codigoResultadosGestionTelefonica +
					RecobroCommonAccionesExtrajudicialesConstants.PLUGIN_RECOBRO_ACCIONESEXTRAJUDICIALES_COMILLA);
		}
		sb.append(")");
		return sb.toString();
	}

	@Override
	public Page getPageAccionesCicloRecobroContrato(RecobroAccionesExtrajudicialesDto dto) {
		Assertions.assertNotNull(dto.getIdCicloRecobroCnt(), "RecobroAccionesExtrajudicialesDaoImpl: El id de contrato no puede ser null");
		
		HQLBuilder hb = new HQLBuilder(generaHQLAccionesDelContrato(dto));
		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public Page getPageAccionesCicloRecobroPersona(RecobroAccionesExtrajudicialesDto dto) {
		Assertions.assertNotNull(dto.getIdCicloRecobroPer(), "RecobroAccionesExtrajudicialesDaoImpl: El id de la persona no puede ser null");
		
		HQLBuilder hb = new HQLBuilder(generaHQLAccionesDelCliente(dto));
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

	private String generaHQLAccionesDelCliente(
			RecobroAccionesExtrajudicialesDto dto) {
		StringBuffer query = new StringBuffer();
		
		//Antigua
//		query.append(" SELECT DISTINCT ace from RecobroAccionesExtrajudiciales ace ");		
//		query.append(" WHERE ace.persona.id IN (");
//				query.append(" SELECT crp_join.persona.id FROM CicloRecobroPersona crp_join where crp_join.id = " + dto.getIdCicloRecobroPer());
//				query.append(" AND crp_join.fechaAlta <= ace.fechaGestion AND (crp_join.fechaBaja IS NULL OR crp_join.fechaBaja >= ace.fechaGestion)) ");
//		query.append(" OR ace.contrato.id IN (" );
//				query.append(" SELECT cpe.contrato.id FROM ContratoPersona cpe WHERE cpe.persona.id IN (SELECT crp_join.persona.id FROM CicloRecobroPersona crp_join where crp_join.id = " + dto.getIdCicloRecobroPer());
//				query.append(" AND crp_join.fechaAlta <= ace.fechaGestion AND (crp_join.fechaBaja IS NULL OR crp_join.fechaBaja >= ace.fechaGestion))");
				
				
		//Nueva
		query.append(" SELECT DISTINCT ace from RecobroAccionesExtrajudiciales ace, CicloRecobroPersona crp, ContratoPersona cpe ");
		query.append(" WHERE crp.persona.id = ace.persona.id ");
		query.append(" AND cpe.contrato.id = ace.contrato.id ");
		query.append(" AND crp.id = " + dto.getIdCicloRecobroPer());
		query.append(" AND ace.fechaGestion >= crp.fechaAlta AND (ace.fechaGestion <= crp.fechaBaja OR crp.fechaBaja IS NULL ) ");
		query.append(" AND cpe.persona.id = crp.persona.id ");
				
		return query.toString();
	}

	@Override
	public Page getPageAccionesRecobroExpediente(RecobroAccionesExtrajudicialesExpedienteDto dto) {

		HQLBuilder hb = new HQLBuilder("select aex from RecobroAccionesExtrajudiciales aex ");

		hb.appendWhere(" aex.auditoria.borrado=0");

		hb.appendWhere(this.creaQueryAccionesInicial(dto));

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aex.agencia.id", dto.getIdAgencia());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aex.resultadoGestionTelefonica.id", dto.getIdResultado());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "aex.tipoGestion.id", dto.getIdTipo());
		if (!Checks.esNulo(dto.getListaAgencias())){
			HQLBuilder.addFiltroWhereInSiNotNull(hb, "aex.agencia.id", dto.getListaAgencias());
		}

		if (StringUtils.hasText(dto.getFechaDesde()) || StringUtils.hasText(dto.getFechaHasta())) {
			SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			try {
				Date fechaMin = StringUtils.hasText(dto.getFechaDesde()) ? df.parse(dto.getFechaDesde() + " 00:00:00") : null;
				Date fechaMax = StringUtils.hasText(dto.getFechaHasta()) ? df.parse(dto.getFechaHasta() + " 23:59:59") : null;
				HQLBuilder.addFiltroBetweenSiNotNull(hb, "aex.fechaGestion", fechaMin, fechaMax);

			} catch (ParseException e) {
				logger.error("Error parseando la fecha de alta: ", e);
			}
		}

		return HibernateQueryUtils.page(this, hb, dto);
	}

	private String creaQueryAccionesInicial(RecobroAccionesExtrajudicialesExpedienteDto dto) {
		StringBuilder sb = new StringBuilder();

		sb.append(" aex.idEnvio in (");
		sb.append(" select crc.idEnvio from CicloRecobroContrato crc where crc.cicloRecobroExpediente.expediente.id = " + dto.getIdExpediente());

		if (dto.getIdCicloRecobroExp() != null) {
			sb.append(" and crc.cicloRecobroExpediente.id = " + dto.getIdCicloRecobroExp());
		}
		sb.append(" ) ");
		// sb.append(" or ");
		// sb.append(" aex.idEnvio in (");
		// sb.append(" select crp.idEnvio from CicloRecobroPersona crp where crp.cicloRecobroExpediente.expediente.id = "
		// + dto.getIdExpediente());
		// if(dto.getIdCicloRecobroExp() != null)
		// {
		// sb.append(" and crp.cicloRecobroExpediente.id = " +
		// dto.getIdCicloRecobroExp());
		// }
		// sb.append(" )");

		return sb.toString();
	}
	
	private String generaHQLAccionesDelContrato(RecobroAccionesExtrajudicialesDto dto) {
		StringBuffer query = new StringBuffer();
		
		//Antigua
//		query.append(" SELECT DISTINCT ace from RecobroAccionesExtrajudiciales ace ");		
//		query.append(" WHERE ace.contrato.id IN (");
//				query.append(" SELECT crc_join.contrato.id FROM CicloRecobroContrato crc_join where crc_join.id = " + dto.getIdCicloRecobroCnt());
//				query.append(" AND crc_join.fechaAlta <= ace.fechaGestion AND (crc_join.fechaBaja IS NULL OR crc_join.fechaBaja >= ace.fechaGestion)) ");
//		query.append(" OR ace.persona.id IN (" );
//				query.append(" SELECT cpe.persona.id FROM ContratoPersona cpe WHERE cpe.contrato.id IN (SELECT crc_join.contrato.id FROM CicloRecobroContrato crc_join where crc_join.id = " + dto.getIdCicloRecobroCnt());
//				query.append(" AND crc_join.fechaAlta <= ace.fechaGestion AND (crc_join.fechaBaja IS NULL OR crc_join.fechaBaja >= ace.fechaGestion))");
				
				
		//Nueva
		query.append(" SELECT DISTINCT ace from RecobroAccionesExtrajudiciales ace, CicloRecobroPersona crp, ContratoPersona cpe ");
		query.append(" WHERE crp.persona.id = ace.persona.id ");
		query.append(" AND cpe.contrato.id = ace.contrato.id ");
		query.append(" AND crp.id = " + dto.getIdCicloRecobroPer());
		query.append(" AND ace.fechaGestion >= crp.fechaAlta AND (ace.fechaGestion <= crp.fechaBaja OR crp.fechaBaja IS NULL ) ");
		query.append(" AND cpe.persona.id = crp.persona.id ");
		
		return query.toString();
		
	}
	
}
