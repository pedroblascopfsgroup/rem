package es.capgemini.pfs.persona.model;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Formula;

import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.DDTipoExpediente;

@Entity
@Table(name = "PER_PERSONAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class PersonaFormulas {
	
	@Id
	@Column(name = "PER_ID")
	private Long id;
	
	@Formula(value = "(select est.dd_ecv_descripcion from per_personas c, DD_ECV_ESTADO_CICLO_VIDA est "
			+ " WHERE trim(c.per_ecv) = trim(est.dd_ecv_codigo) and c.borrado = 0 "
			+ " and c.per_id = PER_ID)")
	private String estadoCicloVida;
	
	@Formula(value = "(select FLOOR(SYSDATE-MIN(MOV.MOV_FECHA_POS_VENCIDA)) FROM CPE_CONTRATOS_PERSONAS CPE, CNT_CONTRATOS CNT, MOV_MOVIMIENTOS MOV "
			+ " WHERE CPE.CNT_ID = CNT.CNT_ID AND CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION "
			+ " and cpe.dd_tin_id in (select tipo.dd_tin_id from dd_tin_tipo_intervencion tipo where tipo.dd_tin_titular = 1) "
			+ " AND CPE.PER_ID = PER_ID)")
	private Integer diasVencidoRiegoDirecto;
	
	@Formula(value = "(select FLOOR(SYSDATE-MIN(MOV.MOV_FECHA_POS_VENCIDA)) FROM CPE_CONTRATOS_PERSONAS CPE, CNT_CONTRATOS CNT, MOV_MOVIMIENTOS MOV "
			+ " WHERE CPE.CNT_ID = CNT.CNT_ID AND CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION "
			+ " and cpe.dd_tin_id in (select tipo.dd_tin_id from dd_tin_tipo_intervencion tipo where tipo.dd_tin_titular = 0) "
			+ " AND CPE.PER_ID = PER_ID)")
	private Integer diasVencidoRiegoIndirecto;

	@Formula(value = "(select sum(MOV.mov_pos_viva_vencida + MOV.mov_pos_viva_no_vencida)"
			+ " FROM CPE_CONTRATOS_PERSONAS CPE, CNT_CONTRATOS CNT, MOV_MOVIMIENTOS MOV"
			+ " WHERE CPE.CNT_ID = CNT.CNT_ID AND CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION"
			+ " and cpe.per_id = PER_ID)")
	private Float riesgoTot;

	@Formula(value = "(select sum(MOV.mov_pos_viva_vencida + MOV.mov_pos_viva_no_vencida)"
			+ " FROM CPE_CONTRATOS_PERSONAS CPE, CNT_CONTRATOS CNT, MOV_MOVIMIENTOS MOV"
			+ " WHERE CPE.CNT_ID = CNT.CNT_ID AND CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION"
			+ " and cpe.dd_tin_id in (select tipo.dd_tin_id from dd_tin_tipo_intervencion tipo where tipo.dd_tin_titular = 1)"
			+ " and cpe.per_id = PER_ID)")
	private Float riesgoTotalDirecto;

	@Formula(value = "(select sum(MOV.mov_pos_viva_vencida + MOV.mov_pos_viva_no_vencida)"
			+ " FROM CPE_CONTRATOS_PERSONAS CPE, CNT_CONTRATOS CNT, MOV_MOVIMIENTOS MOV"
			+ " WHERE CPE.CNT_ID = CNT.CNT_ID AND CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION"
			+ " and cpe.dd_tin_id in (select tipo.dd_tin_id from dd_tin_tipo_intervencion tipo where tipo.dd_tin_titular = 0)"
			+ " and cpe.per_id = PER_ID)")
	private Float riesgoTotalIndirecto;

	@Formula(value = "(select est.dd_est_descripcion from cli_clientes c,${master.schema}.DD_EST_ESTADOS_ITINERARIOS est "
			+ " WHERE c.dd_est_id = est.dd_est_id and c.borrado = 0 "
			+ " and c.per_id = PER_ID)")
	private String situacionCliente;
	
	// ************************************** //
		// *** F�RMULAS *** //
		// ************************************** //

		@Formula(value = "(select FLOOR(SYSDATE-MIN(MOV.MOV_FECHA_POS_VENCIDA)) FROM CPE_CONTRATOS_PERSONAS CPE, CNT_CONTRATOS CNT, MOV_MOVIMIENTOS MOV "
				+ " WHERE CPE.CNT_ID = CNT.CNT_ID AND CNT.CNT_ID = MOV.CNT_ID AND CNT.CNT_FECHA_EXTRACCION = MOV.MOV_FECHA_EXTRACCION "
				+ " AND CPE.PER_ID = PER_ID)")
		private Integer diasVencido;

		@Formula(value = "(select count(distinct exp.exp_id) from EXP_EXPEDIENTES exp "
				+ " JOIN PEX_PERSONAS_EXPEDIENTE pex ON pex.exp_id = exp.exp_id "
				+ " JOIN ${master.schema}.DD_EEX_ESTADO_EXPEDIENTE dd_eex ON exp.dd_eex_id = dd_eex.dd_eex_id "
				+ " WHERE pex.borrado = 0 and exp.borrado = 0 and dd_eex.dd_eex_codigo in ('"
				+ DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO
				+ "','"
				+ DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO
				+ "','"
				+ DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO
				+ "') and pex.per_id = PER_ID)")
		private Integer numExpedientesActivos;

		@Formula(value = "(SELECT COUNT (DISTINCT asu.asu_id) FROM ASU_ASUNTOS asu JOIN PRC_PROCEDIMIENTOS prc ON prc.asu_id = asu.asu_id "
				+ " JOIN PRC_CEX pc ON pc.prc_id = prc.prc_id JOIN CEX_CONTRATOS_EXPEDIENTE cex ON pc.cex_id = cex.cex_id "
				+ " JOIN CNT_CONTRATOS cnt ON cex.cnt_id = cnt.cnt_id JOIN CPE_CONTRATOS_PERSONAS cpe ON cpe.cnt_id = cnt.cnt_id "
				+ " JOIN ${master.schema}.dd_eas_estado_asuntos dd_eas ON asu.dd_eas_id = dd_eas.dd_eas_id "
				+ " WHERE asu.borrado = 0 and prc.borrado = 0 and dd_eas.dd_eas_codigo in ('"
				+ DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO
				+ "','"
				+ DDEstadoAsunto.ESTADO_ASUNTO_CONFIRMADO
				+ "','"
				+ DDEstadoAsunto.ESTADO_ASUNTO_PROPUESTO
				+ "') and cpe.per_id = PER_ID)")
		private Integer numAsuntosActivos;
		
		@Formula(value = "(SELECT COUNT (DISTINCT asu.asu_id) FROM ASU_ASUNTOS asu JOIN PRC_PROCEDIMIENTOS prc ON prc.asu_id = asu.asu_id "
				+ " JOIN PRC_PER PRCPER ON PRC.PRC_ID = PRCPER.PRC_ID "
				+ " WHERE asu.borrado = 0 and prc.borrado = 0 and PRCPER.PER_ID = PER_ID)")
		private Integer numAsuntosActivosPorPrc;

		/**
		 * Situaci�n de gesti�n: Cliente (todos los que no son ni expediente, ni
		 * asunto), expediente, asunto.
		 */
		// FIXME Corregir esto se est� hardcodeando texto no internacionalizado en
		// esta f�rmula como resultado.
		public static final String FORMULA_SITUACION = "(SELECT COALESCE ((SELECT CASE WHEN COUNT (DISTINCT asu.asu_id) > 0 "
				+ " THEN 'En Asunto' ELSE NULL END FROM ASU_ASUNTOS asu JOIN PRC_PROCEDIMIENTOS prc ON prc.asu_id = asu.asu_id "
				+ " JOIN PRC_CEX pc ON pc.prc_id = prc.prc_id JOIN CEX_CONTRATOS_EXPEDIENTE cex ON pc.cex_id = cex.cex_id "
				+ " JOIN CNT_CONTRATOS cnt ON cex.cnt_id = cnt.cnt_id JOIN CPE_CONTRATOS_PERSONAS cpe ON cpe.cnt_id = cnt.cnt_id "
				+ " JOIN ${master.schema}.dd_eas_estado_asuntos dd_eas ON asu.dd_eas_id = dd_eas.dd_eas_id "
				+ " WHERE asu.borrado = 0 and prc.borrado = 0 and dd_eas.dd_eas_codigo IN ('"
				+ DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO
				+ "','"
				+ DDEstadoAsunto.ESTADO_ASUNTO_CONFIRMADO
				+ "','"
				+ DDEstadoAsunto.ESTADO_ASUNTO_PROPUESTO
				+ "') and cpe.per_id = PER_ID), "
				+ " (SELECT CASE WHEN COUNT (EXP.exp_id) > 0 THEN 'Expediente interno' ELSE NULL END "
				+ " from EXP_EXPEDIENTES exp "
				+ " JOIN PEX_PERSONAS_EXPEDIENTE pex ON pex.exp_id = exp.exp_id "
				+ "JOIN DD_TPX_TIPO_EXPEDIENTE tpx on TPX.DD_TPX_ID=EXP.DD_TPX_ID and TPX.DD_TPX_CODIGO='"
				+ DDTipoExpediente.TIPO_EXPEDIENTE_INTERNO
				+ "'"
				+ " JOIN ${master.schema}.DD_EEX_ESTADO_EXPEDIENTE dd_eex ON exp.dd_eex_id = dd_eex.dd_eex_id "
				+ " WHERE pex.borrado = 0 and exp.borrado = 0 "
				+ " and dd_eex.dd_eex_codigo in ('"
				+ DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO
				+ "','"
				+ DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO
				+ "','"
				+ DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO
				+ "')  "
				+ " and pex.per_id = PER_ID), "
				+ "(SELECT CASE WHEN COUNT (EXP.exp_id) > 0 "
				+ "THEN 'Expediente de recobro' ELSE NULL END "
				+ "from EXP_EXPEDIENTES exp "
				+ "JOIN PEX_PERSONAS_EXPEDIENTE pex ON pex.exp_id = exp.exp_id "
				+ "JOIN DD_TPX_TIPO_EXPEDIENTE tpx on TPX.DD_TPX_ID=EXP.DD_TPX_ID and TPX.DD_TPX_CODIGO='"
				+ DDTipoExpediente.TIPO_EXPEDIENTE_RECOBRO
				+ "'"
				+ "JOIN ${master.schema}.DD_EEX_ESTADO_EXPEDIENTE dd_eex ON exp.dd_eex_id = dd_eex.dd_eex_id "
				+ "WHERE pex.borrado = 0 and exp.borrado = 0 "
				+ "and dd_eex.dd_eex_codigo in  ('"
				+ DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO
				+ "','"
				+ DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO
				+ "','"
				+ DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO
				+ "')  "
				+ "and pex.per_id = PER_ID), "
				+ " (SELECT est.dd_est_descripcion "
				+ " FROM ${master.schema}.dd_est_estados_itinerarios est "
				+ " WHERE est.dd_est_id = COALESCE (cli.dd_est_id, NULL)), 'Normal') "
				+ " FROM cpe_contratos_personas cpe "
				+ " LEFT JOIN cli_clientes cli ON cpe.per_id = cli.per_id AND cli.borrado = 0 WHERE cpe.per_id = PER_ID AND ROWNUM = 1)";

		@Formula(value = FORMULA_SITUACION)
		private String situacion;

		public static final String FORMULA_RELACION_EXPEDIENTE = "(SELECT COALESCE("
				+ "(SELECT CASE "
				+ " WHEN COUNT (*) > 0"
				+ "     THEN 'Titular CP'"
				+ "  ELSE NULL "
				+ " END "
				+ " FROM EXP_EXPEDIENTES exp, CEX_CONTRATOS_EXPEDIENTE cex, CPE_CONTRATOS_PERSONAS cpe, DD_TIN_TIPO_INTERVENCION tin, ${master.schema}.dd_eex_estado_expediente dd_eex "
				+ " where exp.exp_id = cex.exp_id and cex.cnt_id = cpe.cnt_id and cpe.dd_tin_id = tin.dd_tin_id and exp.dd_eex_id = dd_eex.dd_eex_id  and cpe.per_id = per.per_id "
				+ "  and cex.borrado = 0 and cpe.borrado = 0 and exp.borrado = 0  and dd_eex.dd_eex_codigo in ('1', '2', '4')  and cex.cex_pase = 1 and tin.dd_tin_titular = 1 "
				+ " ), "
				+ " (SELECT CASE "
				+ " WHEN COUNT (*) > 0 "
				+ "    THEN 'Titular OC'"
				+ "  ELSE NULL "
				+ " END "
				+ " FROM EXP_EXPEDIENTES exp, CEX_CONTRATOS_EXPEDIENTE cex, CPE_CONTRATOS_PERSONAS cpe, DD_TIN_TIPO_INTERVENCION tin, ${master.schema}.dd_eex_estado_expediente dd_eex "
				+ " where exp.exp_id = cex.exp_id and cex.cnt_id = cpe.cnt_id and cpe.dd_tin_id = tin.dd_tin_id and exp.dd_eex_id = dd_eex.dd_eex_id  and cpe.per_id = per.per_id "
				+ "   and cex.borrado = 0 and cpe.borrado = 0 and exp.borrado = 0  and dd_eex.dd_eex_codigo in ('1', '2', '4')  and cex.cex_pase = 0 and tin.dd_tin_titular = 1 "
				+ " ), "
				+ " (SELECT CASE"
				+ "  WHEN COUNT (*) > 0 "
				+ "     THEN 'Avalista' "
				+ "  ELSE NULL "
				+ " END "
				+ " FROM EXP_EXPEDIENTES exp, CEX_CONTRATOS_EXPEDIENTE cex, CPE_CONTRATOS_PERSONAS cpe, DD_TIN_TIPO_INTERVENCION tin, ${master.schema}.dd_eex_estado_expediente dd_eex "
				+ " where exp.exp_id = cex.exp_id and cex.cnt_id = cpe.cnt_id and cpe.dd_tin_id = tin.dd_tin_id and exp.dd_eex_id = dd_eex.dd_eex_id  and cpe.per_id = per.per_id "
				+ "    and cex.borrado = 0 and cpe.borrado = 0 and exp.borrado = 0  and dd_eex.dd_eex_codigo in ('1', '2', '4') and tin.dd_tin_avalista = 1 "
				+ " ), '') "
				+ " FROM PER_PERSONAS per "
				+ " WHERE per.per_id = PER_ID AND ROWNUM = 1)";
		/**
		 * Grado de relaci�n con el expediente (s�lo para los que est�n en
		 * expedientes): Titular CP. Titular OC, Avalista
		 */
		@Formula(value = FORMULA_RELACION_EXPEDIENTE)
		@Basic(fetch = FetchType.LAZY)
		private String relacionExpediente;

		// ******************************************************
		// **********AMPLIACIÓN INTERFAZ PER_PERSONAS 29-04-2014
		// ******************************************************

		@Formula("(select icc.icc_value from EXT_ICC_INFO_EXTRA_CLI icc where icc.per_id = per_id "
				+ "  and icc.dd_ifx_id = ("
				+ "select ifx.dd_ifx_id from EXT_DD_IFX_INFO_EXTRA_CLI ifx where ifx.dd_ifx_codigo = '"
				+ DDTipoInfoCliente.TIPO_INFO_ADICIONAL_CLIENTE_NOMINA_PENSION
				+ "'))")
		private String servicioNominaPension;

		@Formula("(select icc.icc_value from EXT_ICC_INFO_EXTRA_CLI icc where icc.per_id = per_id "
				+ "  and icc.dd_ifx_id = ("
				+ "select ifx.dd_ifx_id from EXT_DD_IFX_INFO_EXTRA_CLI ifx where ifx.dd_ifx_codigo = '"
				+ DDTipoInfoCliente.TIPO_INFO_ADICIONAL_CLIENTE_ULTIMA_ACTUACION
				+ "'))")
		private String ultimaActuacion;

		
		// Vienen aprovisionados en estos campos
		@Formula("(select icc.icc_value from EXT_ICC_INFO_EXTRA_CLI icc where icc.per_id = per_id "
				+ "  and icc.dd_ifx_id = ("
				+ "select ifx.dd_ifx_id from EXT_DD_IFX_INFO_EXTRA_CLI ifx where ifx.dd_ifx_codigo = '"
				+ DDTipoInfoCliente.NUM_EXTRA1
				+ "'))")
		private String dispuestoNoVencido;

		@Formula("(select icc.icc_value from EXT_ICC_INFO_EXTRA_CLI icc where icc.per_id = per_id "
				+ "  and icc.dd_ifx_id = ("
				+ "select ifx.dd_ifx_id from EXT_DD_IFX_INFO_EXTRA_CLI ifx where ifx.dd_ifx_codigo = '"
				+ DDTipoInfoCliente.NUM_EXTRA2
				+ "'))")
		private String dispuestoVencido;

		
		@Formula("(select tcn.dd_tcn_descripcion from EXT_ICC_INFO_EXTRA_CLI icc, ${master.schema}.DD_TCN_TIPO_CNAE tcn"
				+ "  where icc.per_id = per_id "
				+ "  and icc.icc_value = tcn.dd_tcn_codigo"
				+ "  and icc.dd_ifx_id = ("
				+ "select ifx.dd_ifx_id from EXT_DD_IFX_INFO_EXTRA_CLI ifx where ifx.dd_ifx_codigo = '"
				+ DDTipoInfoCliente.CHAR_EXTRA1
				+ "'))")
		private String descripcionCnae;


		public Long getId() {
			return id;
		}


		public String getEstadoCicloVida() {
			return estadoCicloVida;
		}


		public Integer getDiasVencidoRiegoDirecto() {
			return diasVencidoRiegoDirecto;
		}


		public Integer getDiasVencidoRiegoIndirecto() {
			return diasVencidoRiegoIndirecto;
		}


		public Float getRiesgoTot() {
			return riesgoTot;
		}


		public Float getRiesgoTotalDirecto() {
			return riesgoTotalDirecto;
		}


		public Float getRiesgoTotalIndirecto() {
			return riesgoTotalIndirecto;
		}


		public String getSituacionCliente() {
			return situacionCliente;
		}


		public Integer getDiasVencido() {
			return diasVencido;
		}


		public Integer getNumExpedientesActivos() {
			return numExpedientesActivos;
		}


		public Integer getNumAsuntosActivos() {
			return numAsuntosActivos;
		}


		public Integer getNumAsuntosActivosPorPrc() {
			return numAsuntosActivosPorPrc;
		}


		public static String getFormulaSituacion() {
			return FORMULA_SITUACION;
		}


		public String getSituacion() {
			return situacion;
		}


		public static String getFormulaRelacionExpediente() {
			return FORMULA_RELACION_EXPEDIENTE;
		}


		public String getRelacionExpediente() {
			return relacionExpediente;
		}


		public String getServicioNominaPension() {
			return servicioNominaPension;
		}


		public String getUltimaActuacion() {
			return ultimaActuacion;
		}


		public String getDispuestoNoVencido() {
			return dispuestoNoVencido;
		}


		public String getDispuestoVencido() {
			return dispuestoVencido;
		}


		public String getDescripcionCnae() {
			return descripcionCnae;
		}	

}
