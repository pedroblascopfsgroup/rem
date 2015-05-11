package es.capgemini.pfs.batch.configuracion.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinition;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;
import es.pfsgroup.recovery.recobroCommon.cartera.model.RecobroCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDEstadoEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDModeloTransicion;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroDDTipoRepartoSubcartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubcarteraAgencia;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubcarteraRanking;
import es.pfsgroup.recovery.recobroCommon.facturacion.model.RecobroModeloFacturacion;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroMetaVolante;
import es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model.RecobroPoliticaDeAcuerdos;
import es.pfsgroup.recovery.recobroCommon.ranking.model.RecobroModeloDeRanking;

@Entity
@Table(name="BATCH_RCF_ENTRADA", schema="${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ConfiguracionEntrada implements Serializable {

	/**
	 * SERIALUID
	 */
	private static final long serialVersionUID = -5584061141850091602L;
	
	@Id
	@Column(name="ROWID")
	private String rowId;
	
	/*
	@OneToOne
	@JoinColumn(name="RCF_ESQ_ID")
	private RecobroEsquema esquema;
	*/
	
	@Column(name="RCF_ESQ_ID")
	private Long esquemaId;
	
	@Column(name="RCF_ESQ_PLAZO")
	private Long esquemaPlazo;

	@Column(name="RCF_ESQ_FECHA_LIB")
	private Date esquemaFechaLiberacion;
	
	@Column(name="RCF_ESQ_BORRADO")
	private Boolean esquemaBorrado;
	
	/*
	@OneToOne
	@JoinColumn(name="RCF_DD_EES_ID")
	private RecobroDDEstadoEsquema estadoEsquema;
	*/
	
	@Column(name="RCF_DD_EES_ID")
	private Long estadoEsquemaId;

	@Column(name="RCF_DD_EES_CODIGO")
	private String estadoEsquemaCodigo;
	
	@Column(name="RCF_DD_EES_BORRADO")
	private Boolean estadoEsquemaBorrado;
	
	/*
	@OneToOne
	@JoinColumn(name="RCF_DD_MTR_ID")
	private RecobroDDModeloTransicion modeloTransicion;
	*/
	
	@Column(name="RCF_DD_MTR_ID")
	private Long modeloTransicionId;
	
	@Column(name="RCF_DD_MTR_CODIGO")
	private String modeloTransicionCodigo;
	
	@Column(name="RCF_DD_MTR_BORRADO")
	private Boolean modeloTransicionBorrado;
	
	/*
	@OneToOne
	@JoinColumn(name="RCF_CAR_ID")
	private RecobroCartera cartera;
	*/
	
	@Column(name="RCF_CAR_ID")
	private Long carteraId;
	
	@Column(name="RCF_CAR_NOMBRE")
	private String carteraNombre;
	
	@Column(name="RCF_CAR_BORRADO")
	private Boolean carteraBorrado;
	
	/*
	@Column(name="RCF_DD_ECA_ID")
	private Long estadoCarteraId;
	*/
	
	@Column(name="RCF_DD_ECA_CODIGO")
	private String estadoCarteraCodigo;
	
	@Column(name="RCF_DD_ECA_BORRADO")
	private Boolean estadoCarteraBorrado;
	
	/*
	@OneToOne
	@JoinColumn(name="RD_ID")
	private RuleDefinition ruleDefinition;
	*/
	
	@Column(name="RD_ID")
	private Long ruleDefinitionId;
	
	@Column(name="RD_NAME")
	private String ruleDefinitionName;
	
	@Column(name="RD_DEFINITION")
	private String ruleDefinitionRule;
	
	/*
	@OneToOne
	@JoinColumn(name="RCF_AGE_ID")
	private RecobroAgencia agencia;
	*/
	
	@Column(name="RCF_AGE_ID")
	private Long agenciaId;
	
	@Column(name="RCF_AGE_NOMBRE")
	private String agenciaNombre;
	
	@Column(name="RCF_AGE_CODIGO")
	private String agenciaCodigo;
	
	@Column(name="RCF_AGE_BORRADO")
	private Boolean agenciaBorrado;

	@Column(name="RCF_ESC_ID")
	private Long esquemaCarterasId;
	
	@Column(name="RCF_ESC_PRIORIDAD")
	private Long esquemaCarterasPrioridad;
	
	@Column(name="RCF_ESC_BORRADO")
	private Boolean esquemaCarterasBorrado;
	
	@Column(name="RCF_DD_TCE_ID")
	private Long tipoCarteraEsquemaId; 
	
	@Column(name="RCF_DD_TCE_CODIGO")
	private String tipoCarteraEsquemaCodigo;
	
	@Column(name="RCF_DD_TCE_BORRADO")
	private Boolean tipoCarteraEsquemaBorrado;
	
	@Column(name="RCF_DD_TGC_ID")
	private Long tipoGestionCarteraId;
	
	@Column(name="RCF_DD_TGC_CODIGO")
	private String tipoGestionCarteraCodigo;
	
	@Column(name="RCF_DD_TGC_BORRADO")
	private Boolean tipoGestionCarteraBorrado;
	
	@Column(name="RCF_DD_AER_ID")
	private Long ambitoExpedienteRecobroId;
	
	@Column(name="RCF_DD_AER_CODIGO")
	private String ambitoExpedienteRecobroCodigo;
	
	@Column(name="RCF_DD_AER_BORRADO")
	private Boolean ambitoExpedienteRecobroBorrado;
	
	/*
	@OneToOne
	@JoinColumn(name="RCF_SCA_ID")
	private RecobroSubCartera subcartera;
	*/
	
	@Column(name="RCF_SCA_ID")
	private Long subcarteraId;
	
	@Column(name="RCF_SCA_NOMBRE")
	private String subcarteraNombre;
	
	@Column(name="RCF_SCA_PARTICION")
	private Long subcarteraParticion;
	
	@Column(name="RCF_SCA_BORRADO")
	private Boolean subcarteraBorrado;
	
	/*
	@OneToOne
	@JoinColumn(name="RCF_DD_TPR_ID")
	private RecobroDDTipoRepartoSubcartera tipoRepartoSubcartera;
	*/
	
	@Column(name="RCF_DD_TPR_ID")
	private Long tipoRepartoSubcarteraId;
	
	@Column(name="RCF_DD_TPR_CODIGO")
	private String tipoRepartoSubcarteraCodigo;
	
	@Column(name="RCF_DD_TPR_BORRADO")
	private Boolean tipoRepartoSubcarteraBorrado;
	
	/*
	@OneToOne
	@JoinColumn(name="RCF_ITV_ID")
	private RecobroMetaVolante metaVolante;
	*/
	
	@Column(name="RCF_ITV_ID")
	private Long metaVolanteId;
	
	@Column(name="RCF_ITV_NOMBRE")
	private String metaVolanteNombre;
	
	@Column(name="RCF_ITV_FECHA_ALTA")
	private Date metaVolanteFechaAlta;
	
	@Column(name="RCF_ITV_PLAZO_MAX")
	private Long metaVolantePlazoMax;
	
	@Column(name="RCF_ITV_NO_GEST")
	private Long metaVolanteNoGest;
	
	@Column(name="RCF_ITV_BORRADO")
	private Boolean metaVolanteBorrado;
	
	/*
	@OneToOne
	@JoinColumn(name="RCF_MFA_ID")
	private RecobroModeloFacturacion modeloFacturacion;
	*/
	
	@Column(name="RCF_MFA_ID")
	private Long modeloFacturacionId;
	
	@Column(name="RCF_MFA_NOMBRE")
	private String modeloFacturacionNombre;
	
	@Column(name="RCF_MFA_BORRADO")
	private Boolean modeloFacturacionBorrado;
	
	/*
	@OneToOne
	@JoinColumn(name="RCF_POA_ID")
	private RecobroPoliticaDeAcuerdos politicaDeAcuerdo;
	*/
	
	@Column(name="RCF_POA_ID")
	private Long politicaDeAcuerdoId;
	
	@Column(name="RCF_POA_CODIGO")
	private String politicaDeAcuerdoCodigo;
	
	@Column(name="RCF_POA_BORRADO")
	private Boolean politicaDeAcuerdoBorrado;
	
	/*
	@OneToOne
	@JoinColumn(name="RCF_MOR_ID")
	private RecobroModeloDeRanking modeloRanking;
	*/
	
	@Column(name="RCF_MOR_ID")
	private Long modeloRankingId;
	
	@Column(name="RCF_MOR_NOMBRE")
	private String modeloRankingNombre;
	
	@Column(name="RCF_MOR_BORRADO")
	private Boolean modeloRankingBorrado;
	
	/*
	@OneToOne
	@JoinColumn(name="RCF_SUA_ID")
	private RecobroSubcarteraAgencia subcarteraAgencia;
	*/
	
	@Column(name="RCF_SUA_ID")
	private Long subcarteraAgenciaId;
	
	@Column(name="RCF_SUA_COEFICIENTE")
	private Long subcarteraAgenciaCoeficiente;
	
	@Column(name="RCF_SUA_BORRADO")
	private Boolean subcarteraAgenciaBorrado;
	
	/*
	@OneToOne
	@JoinColumn(name="RCF_SUR_ID")
	private RecobroSubcarteraRanking subcarteraRanking;
	*/
	
	@Column(name="RCF_SUR_ID")
	private Long subcarteraRankingId;
	
	@Column(name="RCF_SUR_POSICION")
	private Long subcarteraRankingPosicion;
	
	@Column(name="RCF_SUR_PORCENTAJE")
	private Long subcarteraRankingPorcentaje;
	
	@Column(name="RCF_SUR_BORRADO")
	private Boolean subcarteraRankingBorrado;

	public String getRowId() {
		return rowId;
	}

	public void setRowId(String rowId) {
		this.rowId = rowId;
	}

	public Long getEsquemaId() {
		return esquemaId;
	}

	public void setEsquemaId(Long esquemaId) {
		this.esquemaId = esquemaId;
	}

	public Long getEsquemaPlazo() {
		return esquemaPlazo;
	}

	public void setEsquemaPlazo(Long esquemaPlazo) {
		this.esquemaPlazo = esquemaPlazo;
	}

	public Date getEsquemaFechaLiberacion() {
		return esquemaFechaLiberacion;
	}

	public void setEsquemaFechaLiberacion(Date esquemaFechaLiberacion) {
		this.esquemaFechaLiberacion = esquemaFechaLiberacion;
	}

	public Boolean getEsquemaBorrado() {
		return esquemaBorrado;
	}

	public void setEsquemaBorrado(Boolean esquemaBorrado) {
		this.esquemaBorrado = esquemaBorrado;
	}

	public Long getEstadoEsquemaId() {
		return estadoEsquemaId;
	}

	public void setEstadoEsquemaId(Long estadoEsquemaId) {
		this.estadoEsquemaId = estadoEsquemaId;
	}

	public String getEstadoEsquemaCodigo() {
		return estadoEsquemaCodigo;
	}

	public void setEstadoEsquemaCodigo(String estadoEsquemaCodigo) {
		this.estadoEsquemaCodigo = estadoEsquemaCodigo;
	}

	public Boolean getEstadoEsquemaBorrado() {
		return estadoEsquemaBorrado;
	}

	public void setEstadoEsquemaBorrado(Boolean estadoEsquemaBorrado) {
		this.estadoEsquemaBorrado = estadoEsquemaBorrado;
	}

	public Long getModeloTransicionId() {
		return modeloTransicionId;
	}

	public void setModeloTransicionId(Long modeloTransicionId) {
		this.modeloTransicionId = modeloTransicionId;
	}

	public String getModeloTransicionCodigo() {
		return modeloTransicionCodigo;
	}

	public void setModeloTransicionCodigo(String modeloTransicionCodigo) {
		this.modeloTransicionCodigo = modeloTransicionCodigo;
	}

	public Boolean getModeloTransicionBorrado() {
		return modeloTransicionBorrado;
	}

	public void setModeloTransicionBorrado(Boolean modeloTransicionBorrado) {
		this.modeloTransicionBorrado = modeloTransicionBorrado;
	}

	public Long getCarteraId() {
		return carteraId;
	}

	public void setCarteraId(Long carteraId) {
		this.carteraId = carteraId;
	}

	public String getCarteraNombre() {
		return carteraNombre;
	}

	public void setCarteraNombre(String carteraNombre) {
		this.carteraNombre = carteraNombre;
	}

	public Boolean getCarteraBorrado() {
		return carteraBorrado;
	}

	public void setCarteraBorrado(Boolean carteraBorrado) {
		this.carteraBorrado = carteraBorrado;
	}

	public String getEstadoCarteraCodigo() {
		return estadoCarteraCodigo;
	}

	public void setEstadoCarteraCodigo(String estadoCarteraCodigo) {
		this.estadoCarteraCodigo = estadoCarteraCodigo;
	}

	public Boolean getEstadoCarteraBorrado() {
		return estadoCarteraBorrado;
	}

	public void setEstadoCarteraBorrado(Boolean estadoCarteraBorrado) {
		this.estadoCarteraBorrado = estadoCarteraBorrado;
	}

	public Long getRuleDefinitionId() {
		return ruleDefinitionId;
	}

	public void setRuleDefinitionId(Long ruleDefinitionId) {
		this.ruleDefinitionId = ruleDefinitionId;
	}

	public String getRuleDefinitionName() {
		return ruleDefinitionName;
	}

	public void setRuleDefinitionName(String ruleDefinitionName) {
		this.ruleDefinitionName = ruleDefinitionName;
	}

	public String getRuleDefinitionRule() {
		return ruleDefinitionRule;
	}

	public void setRuleDefinitionRule(String ruleDefinitionRule) {
		this.ruleDefinitionRule = ruleDefinitionRule;
	}

	public Long getAgenciaId() {
		return agenciaId;
	}

	public void setAgenciaId(Long agenciaId) {
		this.agenciaId = agenciaId;
	}

	public String getAgenciaNombre() {
		return agenciaNombre;
	}

	public void setAgenciaNombre(String agenciaNombre) {
		this.agenciaNombre = agenciaNombre;
	}

	public String getAgenciaCodigo() {
		return agenciaCodigo;
	}

	public void setAgenciaCodigo(String agenciaCodigo) {
		this.agenciaCodigo = agenciaCodigo;
	}

	public Boolean getAgenciaBorrado() {
		return agenciaBorrado;
	}

	public void setAgenciaBorrado(Boolean agenciaBorrado) {
		this.agenciaBorrado = agenciaBorrado;
	}

	public Long getEsquemaCarterasId() {
		return esquemaCarterasId;
	}

	public void setEsquemaCarterasId(Long esquemaCarterasId) {
		this.esquemaCarterasId = esquemaCarterasId;
	}

	public Long getEsquemaCarterasPrioridad() {
		return esquemaCarterasPrioridad;
	}

	public void setEsquemaCarterasPrioridad(Long esquemaCarterasPrioridad) {
		this.esquemaCarterasPrioridad = esquemaCarterasPrioridad;
	}

	public Boolean getEsquemaCarterasBorrado() {
		return esquemaCarterasBorrado;
	}

	public void setEsquemaCarterasBorrado(Boolean esquemaCarterasBorrado) {
		this.esquemaCarterasBorrado = esquemaCarterasBorrado;
	}

	public Long getTipoCarteraEsquemaId() {
		return tipoCarteraEsquemaId;
	}

	public void setTipoCarteraEsquemaId(Long tipoCarteraEsquemaId) {
		this.tipoCarteraEsquemaId = tipoCarteraEsquemaId;
	}

	public String getTipoCarteraEsquemaCodigo() {
		return tipoCarteraEsquemaCodigo;
	}

	public void setTipoCarteraEsquemaCodigo(String tipoCarteraEsquemaCodigo) {
		this.tipoCarteraEsquemaCodigo = tipoCarteraEsquemaCodigo;
	}

	public Boolean getTipoCarteraEsquemaBorrado() {
		return tipoCarteraEsquemaBorrado;
	}

	public void setTipoCarteraEsquemaBorrado(Boolean tipoCarteraEsquemaBorrado) {
		this.tipoCarteraEsquemaBorrado = tipoCarteraEsquemaBorrado;
	}

	public Long getTipoGestionCarteraId() {
		return tipoGestionCarteraId;
	}

	public void setTipoGestionCarteraId(Long tipoGestionCarteraId) {
		this.tipoGestionCarteraId = tipoGestionCarteraId;
	}

	public String getTipoGestionCarteraCodigo() {
		return tipoGestionCarteraCodigo;
	}

	public void setTipoGestionCarteraCodigo(String tipoGestionCarteraCodigo) {
		this.tipoGestionCarteraCodigo = tipoGestionCarteraCodigo;
	}

	public Boolean getTipoGestionCarteraBorrado() {
		return tipoGestionCarteraBorrado;
	}

	public void setTipoGestionCarteraBorrado(Boolean tipoGestionCarteraBorrado) {
		this.tipoGestionCarteraBorrado = tipoGestionCarteraBorrado;
	}

	public Long getAmbitoExpedienteRecobroId() {
		return ambitoExpedienteRecobroId;
	}

	public void setAmbitoExpedienteRecobroId(Long ambitoExpedienteRecobroId) {
		this.ambitoExpedienteRecobroId = ambitoExpedienteRecobroId;
	}

	public String getAmbitoExpedienteRecobroCodigo() {
		return ambitoExpedienteRecobroCodigo;
	}

	public void setAmbitoExpedienteRecobroCodigo(
			String ambitoExpedienteRecobroCodigo) {
		this.ambitoExpedienteRecobroCodigo = ambitoExpedienteRecobroCodigo;
	}

	public Boolean getAmbitoExpedienteRecobroBorrado() {
		return ambitoExpedienteRecobroBorrado;
	}

	public void setAmbitoExpedienteRecobroBorrado(
			Boolean ambitoExpedienteRecobroBorrado) {
		this.ambitoExpedienteRecobroBorrado = ambitoExpedienteRecobroBorrado;
	}

	public Long getSubcarteraId() {
		return subcarteraId;
	}

	public void setSubcarteraId(Long subcarteraId) {
		this.subcarteraId = subcarteraId;
	}

	public String getSubcarteraNombre() {
		return subcarteraNombre;
	}

	public void setSubcarteraNombre(String subcarteraNombre) {
		this.subcarteraNombre = subcarteraNombre;
	}

	public Long getSubcarteraParticion() {
		return subcarteraParticion;
	}

	public void setSubcarteraParticion(Long subcarteraParticion) {
		this.subcarteraParticion = subcarteraParticion;
	}

	public Boolean getSubcarteraBorrado() {
		return subcarteraBorrado;
	}

	public void setSubcarteraBorrado(Boolean subcarteraBorrado) {
		this.subcarteraBorrado = subcarteraBorrado;
	}

	public Long getTipoRepartoSubcarteraId() {
		return tipoRepartoSubcarteraId;
	}

	public void setTipoRepartoSubcarteraId(Long tipoRepartoSubcarteraId) {
		this.tipoRepartoSubcarteraId = tipoRepartoSubcarteraId;
	}

	public String getTipoRepartoSubcarteraCodigo() {
		return tipoRepartoSubcarteraCodigo;
	}

	public void setTipoRepartoSubcarteraCodigo(String tipoRepartoSubcarteraCodigo) {
		this.tipoRepartoSubcarteraCodigo = tipoRepartoSubcarteraCodigo;
	}

	public Boolean getTipoRepartoSubcarteraBorrado() {
		return tipoRepartoSubcarteraBorrado;
	}

	public void setTipoRepartoSubcarteraBorrado(Boolean tipoRepartoSubcarteraBorrado) {
		this.tipoRepartoSubcarteraBorrado = tipoRepartoSubcarteraBorrado;
	}

	public Long getMetaVolanteId() {
		return metaVolanteId;
	}

	public void setMetaVolanteId(Long metaVolanteId) {
		this.metaVolanteId = metaVolanteId;
	}

	public String getMetaVolanteNombre() {
		return metaVolanteNombre;
	}

	public void setMetaVolanteNombre(String metaVolanteNombre) {
		this.metaVolanteNombre = metaVolanteNombre;
	}

	public Date getMetaVolanteFechaAlta() {
		return metaVolanteFechaAlta;
	}

	public void setMetaVolanteFechaAlta(Date metaVolanteFechaAlta) {
		this.metaVolanteFechaAlta = metaVolanteFechaAlta;
	}

	public Long getMetaVolantePlazoMax() {
		return metaVolantePlazoMax;
	}

	public void setMetaVolantePlazoMax(Long metaVolantePlazoMax) {
		this.metaVolantePlazoMax = metaVolantePlazoMax;
	}

	public Long getMetaVolanteNoGest() {
		return metaVolanteNoGest;
	}

	public void setMetaVolanteNoGest(Long metaVolanteNoGest) {
		this.metaVolanteNoGest = metaVolanteNoGest;
	}

	public Boolean getMetaVolanteBorrado() {
		return metaVolanteBorrado;
	}

	public void setMetaVolanteBorrado(Boolean metaVolanteBorrado) {
		this.metaVolanteBorrado = metaVolanteBorrado;
	}

	public Long getModeloFacturacionId() {
		return modeloFacturacionId;
	}

	public void setModeloFacturacionId(Long modeloFacturacionId) {
		this.modeloFacturacionId = modeloFacturacionId;
	}

	public String getModeloFacturacionNombre() {
		return modeloFacturacionNombre;
	}

	public void setModeloFacturacionNombre(String modeloFacturacionNombre) {
		this.modeloFacturacionNombre = modeloFacturacionNombre;
	}

	public Boolean getModeloFacturacionBorrado() {
		return modeloFacturacionBorrado;
	}

	public void setModeloFacturacionBorrado(Boolean modeloFacturacionBorrado) {
		this.modeloFacturacionBorrado = modeloFacturacionBorrado;
	}

	public Long getPoliticaDeAcuerdoId() {
		return politicaDeAcuerdoId;
	}

	public void setPoliticaDeAcuerdoId(Long politicaDeAcuerdoId) {
		this.politicaDeAcuerdoId = politicaDeAcuerdoId;
	}

	public String getPoliticaDeAcuerdoCodigo() {
		return politicaDeAcuerdoCodigo;
	}

	public void setPoliticaDeAcuerdoCodigo(String politicaDeAcuerdoCodigo) {
		this.politicaDeAcuerdoCodigo = politicaDeAcuerdoCodigo;
	}

	public Boolean getPoliticaDeAcuerdoBorrado() {
		return politicaDeAcuerdoBorrado;
	}

	public void setPoliticaDeAcuerdoBorrado(Boolean politicaDeAcuerdoBorrado) {
		this.politicaDeAcuerdoBorrado = politicaDeAcuerdoBorrado;
	}

	public Long getModeloRankingId() {
		return modeloRankingId;
	}

	public void setModeloRankingId(Long modeloRankingId) {
		this.modeloRankingId = modeloRankingId;
	}

	public String getModeloRankingNombre() {
		return modeloRankingNombre;
	}

	public void setModeloRankingNombre(String modeloRankingNombre) {
		this.modeloRankingNombre = modeloRankingNombre;
	}

	public Boolean getModeloRankingBorrado() {
		return modeloRankingBorrado;
	}

	public void setModeloRankingBorrado(Boolean modeloRankingBorrado) {
		this.modeloRankingBorrado = modeloRankingBorrado;
	}

	public Long getSubcarteraAgenciaId() {
		return subcarteraAgenciaId;
	}

	public void setSubcarteraAgenciaId(Long subcarteraAgenciaId) {
		this.subcarteraAgenciaId = subcarteraAgenciaId;
	}

	public Long getSubcarteraAgenciaCoeficiente() {
		return subcarteraAgenciaCoeficiente;
	}

	public void setSubcarteraAgenciaCoeficiente(Long subcarteraAgenciaCoeficiente) {
		this.subcarteraAgenciaCoeficiente = subcarteraAgenciaCoeficiente;
	}

	public Boolean getSubcarteraAgenciaBorrado() {
		return subcarteraAgenciaBorrado;
	}

	public void setSubcarteraAgenciaBorrado(Boolean subcarteraAgenciaBorrado) {
		this.subcarteraAgenciaBorrado = subcarteraAgenciaBorrado;
	}

	public Long getSubcarteraRankingId() {
		return subcarteraRankingId;
	}

	public void setSubcarteraRankingId(Long subcarteraRankingId) {
		this.subcarteraRankingId = subcarteraRankingId;
	}

	public Long getSubcarteraRankingPosicion() {
		return subcarteraRankingPosicion;
	}

	public void setSubcarteraRankingPosicion(Long subcarteraRankingPosicion) {
		this.subcarteraRankingPosicion = subcarteraRankingPosicion;
	}

	public Long getSubcarteraRankingPorcentaje() {
		return subcarteraRankingPorcentaje;
	}

	public void setSubcarteraRankingPorcentaje(Long subcarteraRankingPorcentaje) {
		this.subcarteraRankingPorcentaje = subcarteraRankingPorcentaje;
	}

	public Boolean getSubcarteraRankingBorrado() {
		return subcarteraRankingBorrado;
	}

	public void setSubcarteraRankingBorrado(Boolean subcarteraRankingBorrado) {
		this.subcarteraRankingBorrado = subcarteraRankingBorrado;
	}

}
