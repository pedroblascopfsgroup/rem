package es.capgemini.pfs.persona.model;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.OrderBy;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Formula;
import org.hibernate.annotations.Where;
import org.springframework.context.support.AbstractMessageSource;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.antecedente.model.Antecedente;
import es.capgemini.pfs.antecedenteinterno.model.AntecedenteInterno;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.cirbe.model.Cirbe;
import es.capgemini.pfs.cirbe.model.DDPais;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.contrato.model.DDEstadoFinanciero;
import es.capgemini.pfs.contrato.model.DDTipoProducto;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.DDTipoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.grupoCliente.model.PersonaGrupo;
import es.capgemini.pfs.ingreso.model.Ingreso;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.oficina.model.Oficina;
import es.capgemini.pfs.politica.model.CicloMarcadoPolitica;
import es.capgemini.pfs.politica.model.DDTipoPolitica;
import es.capgemini.pfs.politica.model.Politica;
import es.capgemini.pfs.scoring.model.PuntuacionTotal;
import es.capgemini.pfs.segmento.model.DDSegmento;
import es.capgemini.pfs.segmento.model.DDSegmentoEntidad;
import es.capgemini.pfs.telefonos.model.Telefono;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.utils.Describible;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.ext.impl.visibilidad.model.EXTVisibilidad;

/**
 * Entida que representa la tabla de personas.
 * 
 * @author omedrano
 * 
 */

@Entity
@Table(name = "PER_PERSONAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Persona implements Serializable, Auditable, Describible {

	private static final long serialVersionUID = -8396558940802574504L;
	public static final String PERSONA_ID_KEY = "personaId";

	@Id
	@Column(name = "PER_ID")
	private Long id;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TPE_ID")
	private DDTipoPersona tipoPersona;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TDI_ID")
	private DDTipoDocumento tipoDocumento;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_SCL_ID")
	private DDSegmento segmento;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_SCE_ID")
	private DDSegmentoEntidad segmentoEntidad;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ANT_ID")
	private Antecedente antecedente;

	@OneToMany(mappedBy = "persona", fetch = FetchType.LAZY)
	@JoinColumn(name = "PER_ID")
	@OrderBy("id ASC")
	private List<Cliente> clientes;

	@OneToMany(mappedBy = "persona", fetch = FetchType.LAZY)
	@JoinColumn(name = "PER_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<ContratoPersona> contratosPersona;

	@OneToMany(mappedBy = "persona", fetch = FetchType.LAZY)
	@JoinColumn(name = "PER_ID")
	private List<CicloMarcadoPolitica> ciclosMarcadoPolitica;

	@Column(name = "PER_FECHA_EXTRACCION")
	private Date fechaExtraccion;

	@Column(name = "PER_COD_ENTIDAD")
	private String codigoEntidad;

	@Column(name = "PER_COD_CLIENTE_ENTIDAD")
	private Long codClienteEntidad;

	@Column(name = "PER_DOC_ID")
	private String docId;

	@Column(name = "PER_NOMBRE")
	private String nombre;

	@Column(name = "PER_APELLIDO1")
	private String apellido1;

	@Column(name = "PER_APELLIDO2")
	private String apellido2;

	@Column(name = "PER_FECHA_CREACION")
	private Date fechaCreacion;

	// @OneToOne(fetch = FetchType.LAZY)
	// @JoinColumn(name = "PER_ECV",referencedColumnName="DD_ECV_ID")
	// @Column(name = "PER_ECV")
	@Formula(value = "(select est.dd_ecv_descripcion from per_personas c, DD_ECV_ESTADO_CICLO_VIDA est "
			+ " WHERE trim(c.per_ecv) = trim(est.dd_ecv_codigo) and c.borrado = 0 "
			+ " and c.per_id = PER_ID)")
	private String estadoCicloVida;

	@Column(name = "PER_ECV")
	private String ecv;

	@Column(name = "PER_NOM50")
	private String nom50;

	@Column(name = "PER_TELEFONO_1")
	private String telefono1;

	@Column(name = "PER_TELEFONO_2")
	private String telefono2;

	@Column(name = "PER_MOVIL_1")
	private String movil1;

	@Column(name = "PER_MOVIL_2")
	private String movil2;

	@Column(name = "PER_EMAIL")
	private String email;

	@Column(name = "PER_EXP_UMBRAL_IMPORTE")
	private Float importeUmbral;

	@Column(name = "PER_EXP_UMBRAL_FECHA")
	private Date fechaUmbral;

	@Column(name = "PER_EXP_UMBRAL_COMENTARIO")
	private String comentarioUmbral;

	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "DIR_PER", joinColumns = { @JoinColumn(name = "PER_ID", unique = true) }, inverseJoinColumns = { @JoinColumn(name = "DIR_ID") })
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<Direccion> direcciones;

	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "BIE_PER", joinColumns = { @JoinColumn(name = "PER_ID", unique = true) }, inverseJoinColumns = { @JoinColumn(name = "BIE_ID") })
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<Bien> bienes;

	@Column(name = "PER_FECHA_CARGA")
	private Date fechaCarga;

	@Column(name = "PER_FICHERO_CARGA")
	private String ficheroCarga;

	@OneToMany(mappedBy = "persona", fetch = FetchType.LAZY)
	@JoinColumn(name = "PER_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<Ingreso> ingresos;

	@Column(name = "PER_SOLV_OBSERVACIONES")
	private String observacionesSolvencia;

	@Column(name = "PER_SOLV_FECHA_VERIF")
	private Date fechaVerifSolvencia;

	@OneToMany(mappedBy = "persona", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@Cascade({ org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
	private Set<AdjuntoPersona> adjuntos;

	@OneToMany(mappedBy = "persona", fetch = FetchType.LAZY)
	@JoinColumn(name = "PER_ID")
	@OrderBy("id ASC")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<Cirbe> cirbe;

	@Column(name = "PER_CONTACTO")
	private String personaContacto;

	@Column(name = "PER_NRO_SOCIOS")
	private Integer nroSocios;

	@Column(name = "PER_TELEFONO_5")
	private String telefono5;

	@Column(name = "PER_TELEFONO_6")
	private String telefono6;

	@Column(name = "PER_VR_OTRAS_ENT")
	private Float riesgoVencidoOtrasEnt;

	@Column(name = "PER_EXTRA_1")
	private Float extra1;

	@Column(name = "PER_EXTRA_2")
	private Float extra2;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PER_NACIONALIDAD")
	private DDPais nacionalidad;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PER_PAIS_NACIMIENTO")
	private DDPais paisNacimiento;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PER_SEXO")
	private DDSexo sexo;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TIPO_TELEFONO_1")
	private DDTipoTelefono tipoTelefono1;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TIPO_TELEFONO_2")
	private DDTipoTelefono tipoTelefono2;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TIPO_TELEFONO_3")
	private DDTipoTelefono tipoTelefono3;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TIPO_TELEFONO_4")
	private DDTipoTelefono tipoTelefono4;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TIPO_TELEFONO_5")
	private DDTipoTelefono tipoTelefono5;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TIPO_TELEFONO_6")
	private DDTipoTelefono tipoTelefono6;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_POL_ID")
	private DDPolitica politicaEntidad;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "OFI_ID")
	private Oficina oficinaGestora;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ZON_ID")
	private DDZona centroGestor;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PEF_ID")
	private Perfil perfilGestor;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "USU_ID")
	private Usuario usuarioGestor;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_GGE_ID")
	private DDGrupoGestor grupoGestor;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_REX_ID")
	private DDRatingExterno ratingExterno;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_RAX_ID")
	private DDRatingAuxiliar ratingAuxiliar;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_PX3_ID")
	private DDPersonaExtra3 extra3;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_PX4_ID")
	private DDPersonaExtra4 extra4;

	@Column(name = "PER_FECHA_CONSTITUCION")
	private Date fechaConstitucion;

	@Column(name = "PER_NRO_EMPLEADOS")
	private Long numEmpleados;

	@Column(name = "PER_EXTRA_5")
	private Date extra5;

	@Column(name = "PER_EXTRA_6")
	private Date extra6;

	/**
	 * Ahora se utiliza la tabla ARR_ARQ_RECUPERACION_PERSONA<BR><BR>
	 *  <i>SELECT DISTINCT PER_ID, ARQ_ID FROM (<br>
          SELECT PER_ID, ARQ_ID, ROW_NUMBER() OVER (PARTITION BY PER_ID ORDER BY ARQ_DATE DESC) ORD<br>
          FROM ARR_ARQ_RECUPERACION_PERSONA<br>
        ) WHERE ORD = 1</i>
	 */
	@Deprecated
	@Column(name = "ARQ_ID")
	private Long arquetipo;

	/**
	 * Ahora se utiliza la tabla ARR_ARQ_RECUPERACION_PERSONA<br><br>
	 * 
	 * <i>WITH ARR_TMP AS (<br>
		  SELECT DISTINCT PER_ID, ARQ_ID, ORD FROM (<br>
		              SELECT PER_ID, ARQ_ID, ROW_NUMBER() OVER (PARTITION BY PER_ID ORDER BY ARQ_DATE DESC) ORD<br>
		              FROM ARR_ARQ_RECUPERACION_PERSONA<br>
		            ) WHERE ORD <=2<br>
		)<br>
		, ARR_1 AS (SELECT * FROM ARR_TMP WHERE ORD=1)<br>
		, ARR_2 AS (SELECT * FROM ARR_TMP WHERE ORD=2)<br>
		, VARR AS (<br>
			SELECT A1.PER_ID, A1.ARQ_ID ARQ_ID_CALCULADO, A2.ARQ_ID<br>
				FROM ARR_1 A1 LEFT JOIN ARR_2 A2 ON A1.PER_ID = A2.PER_ID<br>
				inner join per_personas p on a1.per_id = p.per_id<br>
		)</i>
	 * 
	 */
	@Deprecated
	@Column(name = "ARQ_ID_CALCULADO")
	private Long arquetipoCalculado;

	@OneToMany(mappedBy = "persona", fetch = FetchType.LAZY)
	@JoinColumn(name = "PER_ID")
	private List<PuntuacionTotal> puntuacionTotal;

	@Column(name = "PER_RIESGO")
	private Float riesgoDirecto;

	@Column(name = "PER_RIESGO_IND")
	private Float riesgoIndirecto;

	/*
	 * [Bruno] A partir de la versión 2.7.0_sencha_rc4 se soporta que una
	 * persona esté en varios grupos
	 */
	@OneToMany(mappedBy = "persona", fetch = FetchType.LAZY)
	@JoinColumn(name = "PER_ID")
	private List<PersonaGrupo> grupos;

	@Transient
	private PersonaGrupo grupo;

	@Column(name = "PER_VR_DANIADO_OTRAS_ENT")
	private Float riesgoDirectoNoVencidoDanyado;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_EFC_ID")
	private DDEstadoFinanciero situacionFinanciera;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "TPL_ID")
	private DDTipoPolitica prepolitica;

	@OneToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "VSB_ID")
	private EXTVisibilidad visibilidad;

	@Column(name = "PER_FECHA_REV_SOLVENCIA")
	private Date fechaRevisionSolvencia;

	@Column(name = "PER_OBS_REV_SOLVENCIA")
	private String observacionesRevisionSolvencia;

	@Column(name = "PER_FINCA_REV_SOLVENCIA")
	private boolean noTieneFincabilidad;

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

	@Transient
	private static final long DAY_MILISECONDS = 1000 * 60 * 60 * 24;

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	// ************************************** //
	// *** AUTOCALCULADOS *** //
	// ************************************** //

	@Column(name = "PER_ULTIMA_OPERACION")
	private Date ultimaOperacionConcedida;

	@Column(name = "PER_RIESGO_DIR_DANYADO")
	private Float riesgoDirectoDanyado;

	@Column(name = "PER_RIESGO_DIR_VENCIDO")
	private Float riesgoDirectoVencido;

	@Column(name = "PER_TOTAL_SALDO")
	private Float totalSaldo;

	@Column(name = "PER_RIESGO_TOTAL")
	private Float riesgoTotal;

	@Column(name = "PER_DEUDA_IRREGULAR")
	private Float deudaIrregular;

	@Column(name = "PER_DEUDA_IRREGULAR_DIR")
	private Float deudaIrregularDirecta;

	@Column(name = "PER_DEUDA_IRREGULAR_IND")
	private Float deudaIrregularIndirecta;

	@Column(name = "PER_FECHA_VENCIDA_TOTAL")
	private Date ultimaFechaVencida;

	@Column(name = "PER_FECHA_VENCIDA_DIRECTA")
	private Date ultimaFechaVencidaDirecta;

	@Column(name = "PER_FECHA_VENCIDA_INDIRECTA")
	private Date ultimaFechaVencidaIndirecta;

	@Column(name = "PER_NUM_CONTRATOS")
	private Integer numContratos;

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

	@Column(name = "PER_FECHA_DATO")
	private Date fechaDato;

	@OneToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "DD_PRO_ID")
	private DDPropietario propietario;

	@Column(name = "PER_FECHA_ECV")
	private Date fechaEstadoCicloVida;

	@OneToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "DD_OTE_ID")
	private DDOrigenTelefono origenTelefono;

	@Column(name = "PER_CONSENT_TELEFONO_1")
	private Boolean consitimientoTelefono1;

	@Column(name = "PER_FECHA_VIG_TELEFONO_1")
	private Date fechaVigilanciaTelefono1;

	@Column(name = "PER_FECHA_NACIMIENTO")
	private Date fechaNacimiento;

	@Column(name = "PER_REX_FECHA")
	private Date fechaReferenciaRating;

	@OneToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "DD_PNV_ID")
	private DDTipoPersonaNivel tipoPersonaNivel;

	@Column(name = "PER_RIESGO_AUTORIZADO")
	private Float riesgoAutorizado;

	@Column(name = "PER_RIESGO_DISPUESTO")
	private Float riesgoDispuesto;

	@Column(name = "PER_PASIVO_VISTA")
	private Float pasivoVista;

	@Column(name = "PER_PASIVO_PLAZO")
	private Float pasivoPlazo;

	@Column(name = "PER_EMPLEADO")
	private Boolean esEmpleado;

	@Column(name = "PER_SITUACION_CONCURSAL")
	private Boolean situacionConcursal;
	
	@OneToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "DD_COS_ID")
	private DDColectivoSingular colectivoSingular;

	@Column(name = "PER_INGRESOS_DOMICILIADOS")
	private Boolean tieneIngresosDomiciliados;

	@Column(name = "PER_VOL_FACTURACION")
	private Float volumenFacturacion;

	@Column(name = "PER_VOL_FACTURACION_FECHA")
	private Date fechaVolumenFacturacion;

	@OneToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "DD_TPG_ID")
	private DDTipoGestorEntidad tipoGestorEntidad;

	@OneToOne(fetch = FetchType.LAZY)
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	@JoinColumn(name = "DD_ARG_ID")
	private DDAreaGestion areaGestion;

	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "TEL_PER", joinColumns = { @JoinColumn(name = "PER_ID", unique = true) }, inverseJoinColumns = { @JoinColumn(name = "TEL_ID") })
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<Telefono> telefonos;

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

	// ***************************************
	// *******HASTA AQUI 29-04-2014
	// **************************************
	
	@Formula("(select tcn.dd_tcn_descripcion from EXT_ICC_INFO_EXTRA_CLI icc, ${master.schema}.DD_TCN_TIPO_CNAE tcn"
			+ "  where icc.per_id = per_id "
			+ "  and icc.icc_value = tcn.dd_tcn_codigo"
			+ "  and icc.dd_ifx_id = ("
			+ "select ifx.dd_ifx_id from EXT_DD_IFX_INFO_EXTRA_CLI ifx where ifx.dd_ifx_codigo = '"
			+ DDTipoInfoCliente.CHAR_EXTRA1
			+ "'))")
	private String descripcionCnae;
	
	@Formula("(SELECT icc.icc_value FROM ext_icc_info_extra_cli icc WHERE icc.per_id = per_id "
			+ " and icc.dd_ifx_id = ("
			+ "SELECT ifx.dd_ifx_id FROM ext_dd_ifx_info_extra_cli ifx WHERE ifx.dd_ifx_codigo = '"
			+ DDTipoInfoCliente.DATE_EXTRA1
			+ "'))")
	private String fechaSituacionConcursal;
	
	@Formula("(SELECT icc.icc_value FROM ext_icc_info_extra_cli icc WHERE icc.per_id = per_id "
			+ " and icc.dd_ifx_id = ("
			+ "SELECT ifx.dd_ifx_id FROM ext_dd_ifx_info_extra_cli ifx WHERE ifx.dd_ifx_codigo = '"
			+ DDTipoInfoCliente.FLAG_EXTRA1
			+ "'))")
	private Boolean clienteReestructurado;
	
	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id
	 *            the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the segmento
	 */
	public DDSegmento getSegmento() {
		return segmento;
	}

	/**
	 * @param segmento
	 *            the segmento to set
	 */
	public void setSegmento(DDSegmento segmento) {
		this.segmento = segmento;
	}

	/**
	 * @return the antecedente
	 */
	public Antecedente getAntecedente() {
		return antecedente;
	}

	/**
	 * @param antecedente
	 *            the antecedente to set
	 */
	public void setAntecedente(Antecedente antecedente) {
		this.antecedente = antecedente;
	}

	/**
	 * Lista de clientes, el activo, y los no activos.
	 * 
	 * @return List de Cliente
	 */
	public List<Cliente> getClientes() {
		return clientes;
	}

	/**
	 * @param clientes
	 *            the clientes to set
	 */
	public void setClientes(List<Cliente> clientes) {
		this.clientes = clientes;
	}

	/**
	 * @return the docId
	 */
	public String getDocId() {
		return docId;
	}

	/**
	 * @param docId
	 *            the docId to set
	 */
	public void setDocId(String docId) {
		this.docId = docId;
	}

	/**
	 * @return the nombre
	 */
	public String getNombre() {
		return nombre;
	}

	/**
	 * @param nombre
	 *            the nombre to set
	 */
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	/**
	 * @return the apellido1
	 */
	public String getApellido1() {
		return apellido1;
	}

	/**
	 * @param apellido1
	 *            the apellido1 to set
	 */
	public void setApellido1(String apellido1) {
		this.apellido1 = apellido1;
	}

	/**
	 * @return the apellido2
	 */
	public String getApellido2() {
		return apellido2;
	}

	/**
	 * @param apellido2
	 *            the apellido2 to set
	 */
	public void setApellido2(String apellido2) {
		this.apellido2 = apellido2;
	}

	/**
	 * @return the telefono1
	 */
	public String getTelefono1() {
		return telefono1;
	}

	/**
	 * @param telefono1
	 *            the telefono1 to set
	 */
	public void setTelefono1(String telefono1) {
		this.telefono1 = telefono1;
	}

	/**
	 * @return the telefono2
	 */
	public String getTelefono2() {
		return telefono2;
	}

	/**
	 * @param telefono2
	 *            the telefono2 to set
	 */
	public void setTelefono2(String telefono2) {
		this.telefono2 = telefono2;
	}

	/**
	 * @return the movil1
	 */
	public String getMovil1() {
		return movil1;
	}

	/**
	 * @param movil1
	 *            the movil1 to set
	 */
	public void setMovil1(String movil1) {
		this.movil1 = movil1;
	}

	/**
	 * @return the movil2
	 */
	public String getMovil2() {
		return movil2;
	}

	/**
	 * @param movil2
	 *            the movil2 to set
	 */
	public void setMovil2(String movil2) {
		this.movil2 = movil2;
	}

	/**
	 * @return the email
	 */
	public String getEmail() {
		return email;
	}

	/**
	 * @param email
	 *            the email to set
	 */
	public void setEmail(String email) {
		this.email = email;
	}

	/**
	 * @return the direcciones
	 */
	public List<Direccion> getDirecciones() {
		return direcciones;
	}

	/**
	 * @param direcciones
	 *            the direcciones to set
	 */
	public void setDirecciones(List<Direccion> direcciones) {
		this.direcciones = direcciones;
	}

	/**
	 * @return the bienes
	 */
	public List<Bien> getBienes() {
		return bienes;
	}

	/**
	 * retorna el monto total de bienes.
	 * 
	 * @return monto
	 */
	public Float getTotalBienes() {
		Float totalBien = 0F;
		for (Bien b : getBienes()) {
			if (b.getValorActual() != null && b.getParticipacion() != null) {
				totalBien += b.getValorActual().floatValue()
						* b.getParticipacion().floatValue() / 100;
			}
		}
		return totalBien;
	}

	/**
	 * retorna el monto total carga de bienes.
	 * 
	 * @return monto
	 */
	public Float getTotalCargaBienes() {
		Float totalBien = 0F;
		for (Bien b : getBienes()) {
			if (b.getImporteCargas() != null && b.getParticipacion() != null) {
				totalBien += b.getImporteCargas().floatValue()
						* b.getParticipacion().floatValue() / 100;
			}
		}
		return totalBien;
	}

	/**
	 * retorna el monto total del saldo de bienes.
	 * 
	 * @return monto
	 */
	public Float getTotalSaldoBienes() {
		Float totalBien = getTotalBienes() - getTotalCargaBienes();
		return totalBien;
	}

	/**
	 * @param bienes
	 *            the bienes to set
	 */
	public void setBienes(List<Bien> bienes) {
		this.bienes = bienes;
	}

	/**
	 * @return the fechaCarga
	 */
	public Date getFechaCarga() {
		return fechaCarga;
	}

	/**
	 * @param fechaCarga
	 *            the fechaCarga to set
	 */
	public void setFechaCarga(Date fechaCarga) {
		this.fechaCarga = fechaCarga;
	}

	/**
	 * @return the ficheroCarga
	 */
	public String getFicheroCarga() {
		return ficheroCarga;
	}

	/**
	 * @param ficheroCarga
	 *            the ficheroCarga to set
	 */
	public void setFicheroCarga(String ficheroCarga) {
		this.ficheroCarga = ficheroCarga;
	}

	/**
	 * @return the ingresos
	 */
	public List<Ingreso> getIngresos() {
		return ingresos;
	}

	/**
	 * @param ingresos
	 *            the ingresos to set
	 */
	public void setIngresos(List<Ingreso> ingresos) {
		this.ingresos = ingresos;
	}

	/**
	 * devuelve el ingreso anual de la persona.
	 * 
	 * @return ingreso
	 */
	public Float getIngresoAnual() {
		Float ingreso = 0F;
		for (Ingreso i : getIngresos()) {
			ingreso += i.getTotalAnual();
		}
		return ingreso;
	}

	/**
	 * @return the auditoria
	 */
	public Auditoria getAuditoria() {
		return auditoria;
	}

	/**
	 * @param auditoria
	 *            the auditoria to set
	 */
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	/**
	 * getSitacion.
	 * 
	 * @return situacion
	 */
	public String getSituacion() {
		/*
		 * if (getClienteActivo() != null) { return
		 * this.getClienteActivo().getEstadoItinerario().getDescripcion(); }
		 * return "REGULAR";
		 */
		/*
		 * if (getNumAsuntosActivos()>0){ return "ASUNTO"; } if
		 * (getNumExpedientesActivos()>0){ return "EXPEDIENTADO"; }
		 */
		return situacion;
	}

	/**
	 * getEstadoCliente.
	 * 
	 * @return estado
	 */
	public String getEstadoCliente() {
		if (getClienteActivo() != null) {
			String estado = this.getClienteActivo().getEstadoCliente()
					.getDescripcion();

			if (getClienteActivo().isTelecobro()) {
				AbstractMessageSource ms = MessageUtils.getMessageSource();
				estado = ms.getMessage("clientes.estados.telecobro", null,
						MessageUtils.DEFAULT_LOCALE);
			}
			return estado;
		}
		return "";
	}

	/**
	 * get posicion antigua.
	 * 
	 * @return posicion
	 */
	public String getPosicionAntigua() {

		String ret = "";
		if (getClienteActivo() != null) {
			long from = getClienteActivo().getFechaCreacion().getTime();
			long to = new Date().getTime();
			double difference = to - from;
			long days = Math.round((difference / DAY_MILISECONDS));
			if (days > 0) {
				return "" + days;
			}
		}
		return ret;
	}

	/**
	 * Sumatoria de las posiciones vivas y vencidas de todos los contratos de la
	 * persona.
	 * 
	 * @return Float
	 */
	public Float getTotalSaldo() {
		/*
		 * Float saldo = 0.0f; if (getContratosPersona() != null) { for
		 * (ContratoPersona cp : contratosPersona) { // if
		 * (DDTipoIntervencion.CODIGO_TITULAR
		 * .equalsIgnoreCase(cp.getTipoIntervencion().getCodigo())) { Contrato
		 * cont = cp.getContrato(); saldo +=
		 * Math.abs(cont.getLastMovimiento().getPosVivaVencida()) +
		 * Math.abs(cont.getLastMovimiento().getPosVivaNoVencida()); // } } }
		 * return saldo;
		 */
		return totalSaldo;
	}

	/**
	 * @return Float: suma de la posici�n vencida de todos los contratos
	 *         vencidos
	 */
	public Float getTotalPosicionAntiguaContratos() {
		float deuda = 0;
		for (ContratoPersona contratoPersona : contratosPersona) {
			Contrato contrato = contratoPersona.getContrato();
			if (contrato.isVencido()) {
				deuda += contrato.getLastMovimiento().getPosVivaVencida();
			}
		}
		return deuda;
	}

	/**
	 * obtener cantidad de contratos.
	 * 
	 * @return cantidad
	 */
	public int getCantContratos() {
		if (contratosPersona != null) {
			return contratosPersona.size();
		}
		return 0;
	}

	/**
	 * @return the version
	 */
	public Integer getVersion() {
		return version;
	}

	/**
	 * @param version
	 *            the version to set
	 */
	public void setVersion(Integer version) {
		this.version = version;
	}

	/**
	 * @return the tipoPersona
	 */
	public DDTipoPersona getTipoPersona() {
		return tipoPersona;
	}

	/**
	 * @param tipoPersona
	 *            the tipoPersona to set
	 */
	public void setTipoPersona(DDTipoPersona tipoPersona) {
		this.tipoPersona = tipoPersona;
	}

	/**
	 * @return the tipoDocumento
	 */
	public DDTipoDocumento getTipoDocumento() {
		return tipoDocumento;
	}

	/**
	 * @param tipoDocumento
	 *            the tipoDocumento to set
	 */
	public void setTipoDocumento(DDTipoDocumento tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}

	/**
	 * @return the contratosPersona
	 */
	public List<ContratoPersona> getContratosPersona() {
		return contratosPersona;
	}

	/**
	 * @param contratosPersona
	 *            the contratosPersona to set
	 */
	public void setContratosPersona(List<ContratoPersona> contratosPersona) {
		this.contratosPersona = contratosPersona;
	}

	/**
	 * @return List: Solo los contratos con incidencias internas.
	 */
	public List<ContratoPersona> getContratosPersonaConIncidenciaInterna() {
		List<ContratoPersona> contratos = new ArrayList<ContratoPersona>();
		for (ContratoPersona contratoPersona : getContratosPersona()) {
			if (contratoPersona.getContrato().getAntecendenteInterno() != null) {
				contratos.add(contratoPersona);
			}
		}
		if (contratos.size() > 0) {
			return contratos;
		}
		return null;

	}

	/**
	 * @return Integer: Número de contratos de la persona
	 */
	public Integer getNumContratos() {
		// return getContratosPersona().size();
		return numContratos;
	}

	/**
	 * @return the codClienteEntidad
	 */
	public Long getCodClienteEntidad() {
		return codClienteEntidad;
	}

	/**
	 * @param codClienteEntidad
	 *            the codClienteEntidad to set
	 */
	public void setCodClienteEntidad(Long codClienteEntidad) {
		this.codClienteEntidad = codClienteEntidad;
	}

	/**
	 * @return the fechaCreacion
	 */
	public Date getFechaCreacion() {
		return fechaCreacion;
	}

	/**
	 * @param fechaCreacion
	 *            the fechaCreacion to set
	 */
	public void setFechaCreacion(Date fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}

	/**
	 * @return the ecv
	 */
	public String getEcv() {
		return ecv;
	}

	/**
	 * @param ecv
	 *            the ecv to set
	 */
	public void setEcv(String ecv) {
		this.ecv = ecv;
	}

	/**
	 * @return the segmentoEntidad
	 */
	public DDSegmentoEntidad getSegmentoEntidad() {
		return segmentoEntidad;
	}

	/**
	 * @param segmentoEntidad
	 *            the segmentoEntidad to set
	 */
	public void setSegmentoEntidad(DDSegmentoEntidad segmentoEntidad) {
		this.segmentoEntidad = segmentoEntidad;
	}

	/**
	 * @return the fechaExtraccion
	 */
	public Date getFechaExtraccion() {
		return fechaExtraccion;
	}

	/**
	 * @param fechaExtraccion
	 *            the fechaExtraccion to set
	 */
	public void setFechaExtraccion(Date fechaExtraccion) {
		this.fechaExtraccion = fechaExtraccion;
	}

	/**
	 * @return the codigoEntidad
	 */
	public String getCodigoEntidad() {
		return codigoEntidad;
	}

	/**
	 * @param codigoEntidad
	 *            the codigoEntidad to set
	 */
	public void setCodigoEntidad(String codigoEntidad) {
		this.codigoEntidad = codigoEntidad;
	}

	/**
	 * @return the nom50
	 */
	public String getNom50() {
		return nom50;
	}

	/**
	 * @param nom50
	 *            the nom50 to set
	 */
	public void setNom50(String nom50) {
		this.nom50 = nom50;
	}

	/**
	 * Metodo para devolver los contratos vencidos de la persona.
	 * 
	 * @return contratos List
	 */
	public List<Contrato> getContratosVencidos() {
		List<Contrato> contratos = new ArrayList<Contrato>();
		for (ContratoPersona cp : contratosPersona) {
			if (cp.isTitular()) {
				contratos.add(cp.getContrato());
			}

		}
		return contratos;
	}

	/**
	 * Metodo para devolver los contratos no vencidos de la persona.
	 * 
	 * @return contratos List
	 */
	public List<Contrato> getContratosNoVencidos() {
		List<Contrato> contratos = new ArrayList<Contrato>();
		for (ContratoPersona cp : contratosPersona) {
			if (cp.isTitular()) {
				contratos.add(cp.getContrato());
			}

		}
		return contratos;
	}

	/**
	 * Devuelve los contratos de la persona.
	 * 
	 * @return contratos List
	 */
	public List<Contrato> getContratos() {
		List<Contrato> contratos = new ArrayList<Contrato>();
		for (ContratoPersona cp : contratosPersona) {
			contratos.add(cp.getContrato());
		}
		return contratos;
	}

	/**
	 * Devuelve los contratos en los que la persona es titular.
	 * 
	 * @return contratos List
	 */
	public List<Contrato> getContratosTitular() {
		List<Contrato> contratos = new ArrayList<Contrato>();
		for (ContratoPersona cp : contratosPersona) {
			if (cp.isTitular()) {
				contratos.add(cp.getContrato());
			}

		}
		return contratos;
	}

	/**
	 * retorna los contratos de activo.
	 * 
	 * @return contratos
	 */
	public List<Contrato> getContratosRiesgoDirectoActivo() {
		List<Contrato> contratos = new ArrayList<Contrato>();
		for (ContratoPersona cp : contratosPersona) {
			if (cp.isTitular()) {
				if (cp.getContrato().getLastMovimiento().getRiesgo() > 0) {
					contratos.add(cp.getContrato());
				}
			}
		}
		agregarTotalizador(contratos);
		return contratos;
	}

	/**
	 * obtiene el monto total de riesgos directos.
	 * 
	 * @return monto
	 */
	public Float getMontoTotalRiesgosDirectos() {
		Float monto = 0F;
		for (ContratoPersona cp : contratosPersona) {
			if (cp.isTitular()) {
				if (cp.getContrato().getLastMovimiento().getRiesgo() > 0) {
					monto += Math.abs(cp.getContrato().getLastMovimiento()
							.getSaldoTotal());
				}
			}
		}
		return monto;
	}

	/**
	 * retorna los contratos de pasivo.
	 * 
	 * @return contratos
	 */
	public List<Contrato> getContratosRiesgoDirectoPasivo() {
		List<Contrato> contratos = new ArrayList<Contrato>();
		for (ContratoPersona cp : contratosPersona) {
			if (cp.isTitular()) {
				if (cp.getContrato().getLastMovimiento().getRiesgo() == 0) {
					contratos.add(cp.getContrato());
				}
			}
		}
		agregarTotalizador(contratos);
		return contratos;
	}

	/**
	 * agrega un totalizador si corresponde.
	 * 
	 * @param contratos
	 *            contratos
	 */
	private void agregarTotalizador(List<Contrato> contratos) {
		if (contratos.size() > 0) {
			Contrato contrato = new Contrato();
			Movimiento mov = new Movimiento();
			float saldoIrregular = 0F;
			float saldoNoVencido = 0F;
			for (Contrato c : contratos) {
				saldoIrregular += Math.abs(c.getLastMovimiento()
						.getPosVivaVencida());
				saldoNoVencido += Math.abs(c.getLastMovimiento()
						.getPosVivaNoVencida());
			}
			mov.setPosVivaNoVencida(saldoNoVencido);
			mov.setPosVivaVencida(saldoIrregular);
			List<Movimiento> movimientos = new ArrayList<Movimiento>();
			movimientos.add(mov);
			contrato.setMovimientos(movimientos);
			DDTipoProducto tp = new DDTipoProducto();
			tp.setCodigo("Total: ");
			contrato.setTipoProducto(tp);
			contrato.setCodigoContrato(" ");
			contratos.add(contrato);
		}
	}

	/**
	 * Devuelve los contratos que no son de la persona, pero representan un
	 * riesgo indirecto por ser contratos en los que el titular o intervinientes
	 * están relacionados como titulares o intervinientes en sus contratos.
	 * 
	 * @return contratos List
	 */
	public List<Contrato> getContratosRiesgosIndirectos() {
		List<Contrato> contratos = new ArrayList<Contrato>();
		if (!Checks.estaVacio(contratos)) {
			for (ContratoPersona cp : contratosPersona) {
				if (!cp.isTitular()) {
					if (cp.getContrato().getLastMovimiento().getRiesgo() > 0) {
						contratos.add(cp.getContrato());
					}
				}
			}
		}
		agregarTotalizador(contratos);
		return contratos;
	}

	/**
	 * obtiene el monto total de riesgos ila
	 * irectos.
	 * 
	 * @return monto
	 */
	public Float getMontoTotalRiesgosIndirectos() {
		List<Contrato> contratos = getContratosRiesgosIndirectos();
		Float monto = 0F;
		if (contratos != null && contratos.size() > 1) {
			Contrato con = contratos.get(contratos.size() - 1);
			if (con.getLastMovimiento() != null) {
				monto = con.getLastMovimiento().getSaldoTotal();
			}
		}
		return monto;
	}

	/**
	 * Devuelve los contratos en los que la persona no es titular.
	 * 
	 * @return contratos List
	 */
	public List<Contrato> getContratosNoTitular() {
		List<Contrato> contratos = new ArrayList<Contrato>();
		for (ContratoPersona cp : contratosPersona) {
			if (cp.isTitular()) {
				contratos.add(cp.getContrato());
			}

		}
		return contratos;
	}

	/**
	 * Dias pasados desde la fecha de extracci�n del contrato vencido m�s
	 * antiguo.
	 * 
	 * @return Long: (Fecha del sistema - Fecha de contrato vencido m�s antiguo)
	 *         en días
	 */
	public Long getDiasPosMasAntigua() {
		Date fechaContratoMasAntiguo = null;
		for (ContratoPersona contratoPersona : getContratosPersona()) {
			Contrato contrato = contratoPersona.getContrato();
			if (contrato.isVencido()) {
				if (fechaContratoMasAntiguo == null
						|| fechaContratoMasAntiguo.compareTo(contrato
								.getFechaExtraccion()) < 0) {
					fechaContratoMasAntiguo = contrato.getFechaExtraccion();
				}
			}
		}
		if (fechaContratoMasAntiguo == null) {
			return null;
		}
		long milisegundos = (new Date()).getTime()
				- fechaContratoMasAntiguo.getTime();
		return milisegundos / DAY_MILISECONDS;

	}

	/**
	 * Compara si ambas personas son el mismo.
	 * 
	 * @param persona
	 *            Persona
	 * @return boolean
	 */
	public boolean equals(Persona persona) {
		if (id == null || persona == null || persona.getId() == null) {
			throw new RuntimeException("No se puede comparar personas null");
		}
		if (id.longValue() == persona.getId().longValue()) {
			return true;
		}
		return false;
	}

	// TODO Revisar si es necesario la sobrecarga del equals
	/**
	 * Compara si ambas personas son el mismo.
	 * 
	 * @param persona
	 *            Persona
	 * @return boolean
	 */
	@Override
	public boolean equals(Object persona) {
		Persona p = (Persona) persona;
		return equals(p);
	}

	/**
	 * hashcode.
	 * 
	 * @return hashcode
	 */
	/*
	 * @Override public int hashCode() { return this.getId().hashCode(); }
	 */
	/**
	 * obtiene la fecha de creacion formateada.
	 * 
	 * @return fecha
	 */
	public String getFechaCreacionFormateada() {
		SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
		return df.format(auditoria.getFechaCrear());
	}

	/**
	 * @return the clienteActivo
	 */
	public Cliente getClienteActivo() {
		if (clientes == null || clientes.size() == 0) {
			return null;
		}
		for (int j=clientes.size()-1; j>=0; j--) {
			if (!clientes.get(j).getAuditoria().isBorrado()) {
				return clientes.get(j);
			}
		}
		return null;
	}

	/**
	 * Devuelve la pol�tica vigente de la persona
	 * 
	 * @return
	 */
	public Politica getPoliticaVigente() {
		for (CicloMarcadoPolitica cmp : ciclosMarcadoPolitica) {
			Politica p = cmp.getUltimaPolitica();
			if (p != null && p.getEsVigente())
				return p;
		}

		return null;
	}

	/**
	 * @param clienteActivo
	 *            the clienteActivo to set
	 */
	public void setClienteActivo(Cliente clienteActivo) {
		if (clientes == null) {
			clientes = new ArrayList<Cliente>();
		}
		this.clientes.add(clienteActivo);
	}

	/**
	 * @return the observacionesSolvencia
	 */
	public String getObservacionesSolvencia() {
		return observacionesSolvencia;
	}

	/**
	 * @param observacionesSolvencia
	 *            the observacionesSolvencia to set
	 */
	public void setObservacionesSolvencia(String observacionesSolvencia) {
		this.observacionesSolvencia = observacionesSolvencia;
	}

	/**
	 * @return the fechaVerifSolvencia
	 */
	public Date getFechaVerifSolvencia() {
		return fechaVerifSolvencia;
	}

	/**
	 * @param fechaVerifSolvencia
	 *            the fechaVerifSolvencia to set
	 */
	public void setFechaVerifSolvencia(Date fechaVerifSolvencia) {
		this.fechaVerifSolvencia = fechaVerifSolvencia;
	}

	/**
	 * obtiene el apellido y el nombre.
	 * 
	 * @return apellido nombre
	 */
	public String getApellidoNombre() {
		String r = "";
		if (apellido1 != null && apellido1.trim().length() > 0) {
			r += apellido1.trim() + " ";
		}
		if (apellido2 != null && apellido2.trim().length() > 0) {
			r += apellido2.trim();
		}
		if (r.trim().length() > 0) {
			r += ", ";
		}
		if (nombre != null && nombre.trim().length() > 0) {
			r += nombre.trim();
		}
		return r;
	}

	/**
	 * Retorna la cantidad de incidencias internas de sus contratos.
	 * 
	 * @return int
	 */
	public int getNumIncidenciasInternas() {
		return getAntecedentesInternos().size();
	}

	/**
	 * Retorna de todas la fecha de regularizacion mas acutal de las incidencias
	 * internas.
	 * 
	 * @return date.
	 */
	public Date getUltimaFechaRegularizacion() {
		if (getAntecedentesInternos() != null
				&& getAntecedentesInternos().size() > 0) {
			return getAntecedentesInternos().first()
					.getFechaUltimaRegularizacion();
		}
		return null;
	}

	/**
	 * Retorna las incidencias internas relacionadas a sus contratos ordenados
	 * por fecha de regularizacion.
	 * 
	 * @return set
	 */
	public TreeSet<AntecedenteInterno> getAntecedentesInternos() {
		TreeSet<AntecedenteInterno> antInternos = new TreeSet<AntecedenteInterno>(
				new Comparator<AntecedenteInterno>() {

					@Override
					public int compare(AntecedenteInterno a1,
							AntecedenteInterno a2) {
						return a2.getFechaUltimaRegularizacion().compareTo(
								a1.getFechaUltimaRegularizacion());
					}

				});
		for (Contrato contrato : getContratos()) {
			if (contrato.getAntecendenteInterno() != null) {
				antInternos.add(contrato.getAntecendenteInterno());
			}
		}
		return antInternos;
	}

	/**
	 * Agrega un adjunto a la persona, tomando los datos de un FileItem.
	 * 
	 * @param fileItem
	 *            file
	 */
	public void addAdjunto(FileItem fileItem) {
		AdjuntoPersona adjuntoPersona = new AdjuntoPersona(fileItem);
		adjuntoPersona.setPersona(this);
		Auditoria.save(adjuntoPersona);
		getAdjuntos().add(adjuntoPersona);
	}

	/**
	 * devuelve el adjunto por Id.
	 * 
	 * @param id
	 *            Long
	 * @return AdjuntoPersona
	 */
	public AdjuntoPersona getAdjunto(Long id) {
		for (AdjuntoPersona adj : getAdjuntos()) {
			if (adj.getId().equals(id)) {
				return adj;
			}
		}
		return null;
	}

	/**
	 * @return the numExpedientesActivos
	 */
	public Integer getNumExpedientesActivos() {
		return numExpedientesActivos;
	}

	/**
	 * @return the numAsuntosActivos
	 */
	public Integer getNumAsuntosActivos() {
		return numAsuntosActivos;
	}
	
	public Integer getNumAsuntosActivosPorPrc() {
		return numAsuntosActivosPorPrc;
	}	

	/**
	 * @return the diasVencido
	 */
	public Integer getDiasVencido() {
		return diasVencido;
	}

	/**
	 * @return the importeUmbral
	 */
	public Float getImporteUmbral() {
		return importeUmbral;
	}

	/**
	 * @param importeUmbral
	 *            the importeUmbral to set
	 */
	public void setImporteUmbral(Float importeUmbral) {
		this.importeUmbral = importeUmbral;
	}

	/**
	 * @return the fechaUmbral
	 */
	public Date getFechaUmbral() {
		return fechaUmbral;
	}

	/**
	 * @param fechaUmbral
	 *            the fechaUmbral to set
	 */
	public void setFechaUmbral(Date fechaUmbral) {
		this.fechaUmbral = fechaUmbral;
	}

	/**
	 * @return the comentarioUmbral
	 */
	public String getComentarioUmbral() {
		return comentarioUmbral;
	}

	/**
	 * @param comentarioUmbral
	 *            the comentarioUmbral to set
	 */
	public void setComentarioUmbral(String comentarioUmbral) {
		this.comentarioUmbral = comentarioUmbral;
	}

	/**
	 * @return the adjuntos
	 */
	public Set<AdjuntoPersona> getAdjuntos() {
		return adjuntos;
	}

	/**
	 * @param adjuntos
	 *            the adjuntos to set
	 */
	public void setAdjuntos(Set<AdjuntoPersona> adjuntos) {
		this.adjuntos = adjuntos;
	}

	/**
	 * Devuelve los adjuntos (que est�n en un Set) como una lista para que pueda
	 * ser accedido aleatoreamente.
	 * 
	 * @return List AdjuntoPersona
	 */
	public List<AdjuntoPersona> getAdjuntosAsList() {
		return new ArrayList<AdjuntoPersona>(adjuntos);
	}

	/**
	 * {@inheritDoc}
	 */
	public String getDescripcion() {
		return getApellidoNombre();
	}

	/**
	 * @return the cirbe
	 */
	public List<Cirbe> getCirbe() {
		return cirbe;
	}

	/**
	 * @param cirbe
	 *            the cirbe to set
	 */
	public void setCirbe(List<Cirbe> cirbe) {
		this.cirbe = cirbe;
	}

	/**
	 * @return the grupo
	 */
	/*
	 * [Bruno] A partir de la versión 2.7.0_sencha_rc4 se soporta que una
	 * persona esté en varios grupos
	 */
	public PersonaGrupo getGrupo() {
		if (grupo == null && (grupos != null) && (grupos.size() > 0)) {
			grupo = grupos.get(0);
		}
		return grupo;
	}

	public List<PersonaGrupo> getGrupos() {
		return grupos;
	}

	public void setGrupos(List<PersonaGrupo> grupos) {
		this.grupos = grupos;
	}

	/**
	 * Devuelve el nombre de la oficina. o Si es regular la oficina con mayor
	 * riesgo o Si es cliente-> Oficina del contrato de pase o Si es expediente
	 * -> Oficina del contrato de pase
	 * 
	 * @return el nombre de la oficina
	 */
	public Long getOficina() {
		Long oficina = null;
		Cliente cli = getClienteActivo();
		if (cli == null) {
			// verifico que no tenga expediente
			for (Contrato cnt : getContratos()) {
				if (cnt.getExpedienteContratoActivo() != null) {
					return cnt.getOficina().getCodigo();
				}
			}
			// TODO en un futuro existira la clase de diccionarios
			// DD_DATOS_PERSONAS, del cual se recoger� la oficina
		} else {
			oficina = cli.getOficina().getCodigo();
		}

		return oficina;
	}

	/**
	 * Recupera la oficina del cliente si existe y si no devuelve la oficina
	 * gestora de la persona
	 * 
	 * @return
	 */
	public Oficina getOficinaCliente() {
		Cliente cli = getClienteActivo();
		if (cli == null) {
			return oficinaGestora;
		} else {
			return cli.getOficina();
		}
	}

	/**
	 * @param arquetipo
	 *            the arquetipo to set
	 */
	public void setArquetipo(Long arquetipo) {
		this.arquetipo = arquetipo;
	}

	/**
	 * @param arquetipoCalculado
	 *            the arquetipoCalculado to set
	 */
	public void setArquetipoCalculado(Long arquetipoCalculado) {
		this.arquetipoCalculado = arquetipoCalculado;
	}

	/**
	 * @return the arquetipoCalculado
	 */
	public Long getArquetipoCalculado() {
		return arquetipoCalculado;
	}

	/**
	 * @return the arquetipo
	 */
	public Long getArquetipo() {
		return arquetipo;
	}

	/**
	 * @param numEmpleados
	 *            the numEmpleados to set
	 */
	public void setNumEmpleados(Long numEmpleados) {
		this.numEmpleados = numEmpleados;
	}

	/**
	 * @return the numEmpleados
	 */
	public Long getNumEmpleados() {
		return numEmpleados;
	}

	/**
	 * @param oficinaGestora
	 *            the oficinaGestora to set
	 */
	public void setOficinaGestora(Oficina oficinaGestora) {
		this.oficinaGestora = oficinaGestora;
	}

	/**
	 * @return the oficinaGestora
	 */
	public Oficina getOficinaGestora() {
		return oficinaGestora;
	}

	/**
	 * @param riesgoDirectoVencido
	 *            the riesgoDirectoVencido to set
	 */
	public void setRiesgoDirectoVencido(Float riesgoDirectoVencido) {
		this.riesgoDirectoVencido = riesgoDirectoVencido;
	}

	/**
	 * @return the riesgoDirectoVencido
	 */
	public Float getRiesgoDirectoVencido() {
		return riesgoDirectoVencido;
	}

	/**
	 * @param riesgoDirectoDanyado
	 *            the riesgoDirectoDanyado to set
	 */
	public void setRiesgoDirectoDanyado(Float riesgoDirectoDanyado) {
		this.riesgoDirectoDanyado = riesgoDirectoDanyado;
	}

	/**
	 * @return the riesgoDirectoDanyado
	 */
	public Float getRiesgoDirectoDanyado() {
		return riesgoDirectoDanyado;
	}

	/**
	 * @param ultimaOperacionConcedida
	 *            the ultimaOperacionConcedida to set
	 */
	public void setUltimaOperacionConcedida(Date ultimaOperacionConcedida) {
		this.ultimaOperacionConcedida = ultimaOperacionConcedida;
	}

	/**
	 * @return the ultimaOperacionConcedida
	 */
	public Date getUltimaOperacionConcedida() {
		return ultimaOperacionConcedida;
	}

	/**
	 * @param usuarioGestor
	 *            the usuarioGestor to set
	 */
	public void setUsuarioGestor(Usuario usuarioGestor) {
		this.usuarioGestor = usuarioGestor;
	}

	/**
	 * @return the usuarioGestor
	 */
	public Usuario getUsuarioGestor() {
		return usuarioGestor;
	}

	/**
	 * @param perfilGestor
	 *            the perfilGestor to set
	 */
	public void setPerfilGestor(Perfil perfilGestor) {
		this.perfilGestor = perfilGestor;
	}

	/**
	 * @return the perfilGestor
	 */
	public Perfil getPerfilGestor() {
		return perfilGestor;
	}

	/**
	 * @param centroGestor
	 *            the centroGestor to set
	 */
	public void setCentroGestor(DDZona centroGestor) {
		this.centroGestor = centroGestor;
	}

	/**
	 * @return the centroGestor
	 */
	public DDZona getCentroGestor() {
		return centroGestor;
	}

	/**
	 * @return expediente Activo
	 */
	public Expediente getExpedienteActivo() {
		for (Contrato contrato : getContratos()) {
			for (ExpedienteContrato cex : contrato.getExpedienteContratos()) {
				Expediente exp = cex.getExpediente();
				if (exp.getEstaEstadoActivo() || exp.getEstaCongelado()
						|| exp.getEstaBloqueado()) {
					return exp;
				}
			}
		}
		return null;
	}

	/**
	 * @return PuntuacionTotal
	 */
	public PuntuacionTotal getPuntuacionTotalActiva() {
		for (PuntuacionTotal pt : this.puntuacionTotal) {
			if (pt.isActivo()) {
				return pt;
			}
		}
		return null;
	}

	/**
	 * @param riesgoDirecto
	 *            the riesgoDirecto to set
	 */
	public void setRiesgoDirecto(Float riesgoDirecto) {
		this.riesgoDirecto = riesgoDirecto;
	}

	/**
	 * @return the riesgoDirecto
	 */
	public Float getRiesgoDirecto() {
		if (riesgoDirecto != null) {
			return riesgoDirecto;
		}
		return 0f;
	}

	/**
	 * @param riesgoTotal
	 *            the riesgoTotal to set
	 */
	public void setRiesgoTotal(Float riesgoTotal) {
		this.riesgoTotal = riesgoTotal;
	}

	/**
	 * @return the riesgoTotal
	 */
	public Float getRiesgoTotal() {
		if (riesgoTotal != null) {
			return riesgoTotal;
		}
		return 0f;
	}

	/**
	 * @param deudaIrregular
	 *            the deudaIrregular to set
	 */
	public void setDeudaIrregular(Float deudaIrregular) {
		this.deudaIrregular = deudaIrregular;
	}

	/**
	 * @return the deudaIrregular
	 */
	public Float getDeudaIrregular() {
		if (deudaIrregular != null) {
			return deudaIrregular;
		}
		return 0f;
	}

	/**
	 * @return the personaContacto
	 */
	public String getPersonaContacto() {
		return personaContacto;
	}

	/**
	 * @param personaContacto
	 *            the personaContacto to set
	 */
	public void setPersonaContacto(String personaContacto) {
		this.personaContacto = personaContacto;
	}

	/**
	 * @return the nroSocios
	 */
	public Integer getNroSocios() {
		return nroSocios;
	}

	/**
	 * @param nroSocios
	 *            the nroSocios to set
	 */
	public void setNroSocios(Integer nroSocios) {
		this.nroSocios = nroSocios;
	}

	/**
	 * @return the telefono5
	 */
	public String getTelefono5() {
		return telefono5;
	}

	/**
	 * @param telefono5
	 *            the telefono5 to set
	 */
	public void setTelefono5(String telefono5) {
		this.telefono5 = telefono5;
	}

	/**
	 * @return the telefono6
	 */
	public String getTelefono6() {
		return telefono6;
	}

	/**
	 * @param telefono6
	 *            the telefono6 to set
	 */
	public void setTelefono6(String telefono6) {
		this.telefono6 = telefono6;
	}

	/**
	 * @return the riesgoVencidoOtrasEnt
	 */
	public Float getRiesgoVencidoOtrasEnt() {
		return riesgoVencidoOtrasEnt;
	}

	/**
	 * @param riesgoVencidoOtrasEnt
	 *            the riesgoVencidoOtrasEnt to set
	 */
	public void setRiesgoVencidoOtrasEnt(Float riesgoVencidoOtrasEnt) {
		this.riesgoVencidoOtrasEnt = riesgoVencidoOtrasEnt;
	}

	/**
	 * @return the extra1
	 */
	public Float getExtra1() {
		return extra1;
	}

	/**
	 * @param extra1
	 *            the extra1 to set
	 */
	public void setExtra1(Float extra1) {
		this.extra1 = extra1;
	}

	/**
	 * @return the extra2
	 */
	public Float getExtra2() {
		return extra2;
	}

	/**
	 * @param extra2
	 *            the extra2 to set
	 */
	public void setExtra2(Float extra2) {
		this.extra2 = extra2;
	}

	/**
	 * @return the nacionalidad
	 */
	public DDPais getNacionalidad() {
		return nacionalidad;
	}

	/**
	 * @param nacionalidad
	 *            the nacionalidad to set
	 */
	public void setNacionalidad(DDPais nacionalidad) {
		this.nacionalidad = nacionalidad;
	}

	/**
	 * @return the paisNacimiento
	 */
	public DDPais getPaisNacimiento() {
		return paisNacimiento;
	}

	/**
	 * @param paisNacimiento
	 *            the paisNacimiento to set
	 */
	public void setPaisNacimiento(DDPais paisNacimiento) {
		this.paisNacimiento = paisNacimiento;
	}

	/**
	 * @return the sexo
	 */
	public DDSexo getSexo() {
		return sexo;
	}

	/**
	 * @param sexo
	 *            the sexo to set
	 */
	public void setSexo(DDSexo sexo) {
		this.sexo = sexo;
	}

	/**
	 * @return the tipoTelefono1
	 */
	public DDTipoTelefono getTipoTelefono1() {
		return tipoTelefono1;
	}

	/**
	 * @param tipoTelefono1
	 *            the tipoTelefono1 to set
	 */
	public void setTipoTelefono1(DDTipoTelefono tipoTelefono1) {
		this.tipoTelefono1 = tipoTelefono1;
	}

	/**
	 * @return the tipoTelefono2
	 */
	public DDTipoTelefono getTipoTelefono2() {
		return tipoTelefono2;
	}

	/**
	 * @param tipoTelefono2
	 *            the tipoTelefono2 to set
	 */
	public void setTipoTelefono2(DDTipoTelefono tipoTelefono2) {
		this.tipoTelefono2 = tipoTelefono2;
	}

	/**
	 * @return the tipoTelefono3
	 */
	public DDTipoTelefono getTipoTelefono3() {
		return tipoTelefono3;
	}

	/**
	 * @param tipoTelefono3
	 *            the tipoTelefono3 to set
	 */
	public void setTipoTelefono3(DDTipoTelefono tipoTelefono3) {
		this.tipoTelefono3 = tipoTelefono3;
	}

	/**
	 * @return the tipoTelefono4
	 */
	public DDTipoTelefono getTipoTelefono4() {
		return tipoTelefono4;
	}

	/**
	 * @param tipoTelefono4
	 *            the tipoTelefono4 to set
	 */
	public void setTipoTelefono4(DDTipoTelefono tipoTelefono4) {
		this.tipoTelefono4 = tipoTelefono4;
	}

	/**
	 * @return the tipoTelefono5
	 */
	public DDTipoTelefono getTipoTelefono5() {
		return tipoTelefono5;
	}

	/**
	 * @param tipoTelefono5
	 *            the tipoTelefono5 to set
	 */
	public void setTipoTelefono5(DDTipoTelefono tipoTelefono5) {
		this.tipoTelefono5 = tipoTelefono5;
	}

	/**
	 * @return the tipoTelefono6
	 */
	public DDTipoTelefono getTipoTelefono6() {
		return tipoTelefono6;
	}

	/**
	 * @param tipoTelefono6
	 *            the tipoTelefono6 to set
	 */
	public void setTipoTelefono6(DDTipoTelefono tipoTelefono6) {
		this.tipoTelefono6 = tipoTelefono6;
	}

	/**
	 * @return the politicaEntidad
	 */
	public DDPolitica getPoliticaEntidad() {
		return politicaEntidad;
	}

	/**
	 * @param politicaEntidad
	 *            the politicaEntidad to set
	 */
	public void setPoliticaEntidad(DDPolitica politicaEntidad) {
		this.politicaEntidad = politicaEntidad;
	}

	/**
	 * @return the grupoGestor
	 */
	public DDGrupoGestor getGrupoGestor() {
		return grupoGestor;
	}

	/**
	 * @param grupoGestor
	 *            the grupoGestor to set
	 */
	public void setGrupoGestor(DDGrupoGestor grupoGestor) {
		this.grupoGestor = grupoGestor;
	}

	/**
	 * @return the ratingExterno
	 */
	public DDRatingExterno getRatingExterno() {
		return ratingExterno;
	}

	/**
	 * @param ratingExterno
	 *            the ratingExterno to set
	 */
	public void setRatingExterno(DDRatingExterno ratingExterno) {
		this.ratingExterno = ratingExterno;
	}

	/**
	 * @return the ratingAuxiliar
	 */
	public DDRatingAuxiliar getRatingAuxiliar() {
		return ratingAuxiliar;
	}

	/**
	 * @param ratingAuxiliar
	 *            the ratingAuxiliar to set
	 */
	public void setRatingAuxiliar(DDRatingAuxiliar ratingAuxiliar) {
		this.ratingAuxiliar = ratingAuxiliar;
	}

	/**
	 * @return the extra3
	 */
	public DDPersonaExtra3 getExtra3() {
		return extra3;
	}

	/**
	 * @param extra3
	 *            the extra3 to set
	 */
	public void setExtra3(DDPersonaExtra3 extra3) {
		this.extra3 = extra3;
	}

	/**
	 * @return the extra4
	 */
	public DDPersonaExtra4 getExtra4() {
		return extra4;
	}

	/**
	 * @param extra4
	 *            the extra4 to set
	 */
	public void setExtra4(DDPersonaExtra4 extra4) {
		this.extra4 = extra4;
	}

	/**
	 * @return the fechaConstitucion
	 */
	public Date getFechaConstitucion() {
		return fechaConstitucion;
	}

	/**
	 * @param fechaConstitucion
	 *            the fechaConstitucion to set
	 */
	public void setFechaConstitucion(Date fechaConstitucion) {
		this.fechaConstitucion = fechaConstitucion;
	}

	/**
	 * @return the extra5
	 */
	public Date getExtra5() {
		return extra5;
	}

	/**
	 * @param extra5
	 *            the extra5 to set
	 */
	public void setExtra5(Date extra5) {
		this.extra5 = extra5;
	}

	/**
	 * @return the extra6
	 */
	public Date getExtra6() {
		return extra6;
	}

	/**
	 * @param extra6
	 *            the extra6 to set
	 */
	public void setExtra6(Date extra6) {
		this.extra6 = extra6;
	}

	/**
	 * @return the riesgoDirectoNoVencidoDanyado
	 */
	public Float getRiesgoDirectoNoVencidoDanyado() {
		return riesgoDirectoNoVencidoDanyado;
	}

	/**
	 * @param riesgoDirectoNoVencidoDanyado
	 *            the riesgoDirectoNoVencidoDanyado to set
	 */
	public void setRiesgoDirectoNoVencidoDanyado(
			Float riesgoDirectoNoVencidoDanyado) {
		this.riesgoDirectoNoVencidoDanyado = riesgoDirectoNoVencidoDanyado;
	}

	/**
	 * @return the situacionFinanciera
	 */
	public DDEstadoFinanciero getSituacionFinanciera() {
		return situacionFinanciera;
	}

	/**
	 * @param situacionFinanciera
	 *            the situacionFinanciera to set
	 */
	public void setSituacionFinanciera(DDEstadoFinanciero situacionFinanciera) {
		this.situacionFinanciera = situacionFinanciera;
	}

	/**
	 * @return the relacionExpediente
	 */
	public String getRelacionExpediente() {
		return relacionExpediente;
	}

	/**
	 * @param relacionExpediente
	 *            the relacionExpediente to set
	 */
	public void setRelacionExpediente(String relacionExpediente) {
		this.relacionExpediente = relacionExpediente;
	}

	/**
	 * @param totalSaldo
	 *            the totalSaldo to set
	 */
	public void setTotalSaldo(Float totalSaldo) {
		this.totalSaldo = totalSaldo;
	}

	/**
	 * @param numContratos
	 *            the numContratos to set
	 */
	public void setNumContratos(Integer numContratos) {
		this.numContratos = numContratos;
	}

	/**
	 * @param diasVencido
	 *            the diasVencido to set
	 */
	public void setDiasVencido(Integer diasVencido) {
		this.diasVencido = diasVencido;
	}

	/**
	 * @param numExpedientesActivos
	 *            the numExpedientesActivos to set
	 */
	public void setNumExpedientesActivos(Integer numExpedientesActivos) {
		this.numExpedientesActivos = numExpedientesActivos;
	}

	/**
	 * @param numAsuntosActivos
	 *            the numAsuntosActivos to set
	 */
	public void setNumAsuntosActivos(Integer numAsuntosActivos) {
		this.numAsuntosActivos = numAsuntosActivos;
	}
	
	/**
	 * @param numAsuntosActivosPorPrc
	 *            the numAsuntosActivosPorPrc to set
	 */
	public void setNumAsuntosActivosPorPrc(Integer numAsuntosActivosPorPrc) {
		this.numAsuntosActivosPorPrc = numAsuntosActivosPorPrc;
	}

	/**
	 * @param situacion
	 *            the situacion to set
	 */
	public void setSituacion(String situacion) {
		this.situacion = situacion;
	}

	/**
	 * @return the puntuacionTotal
	 */
	public List<PuntuacionTotal> getPuntuacionTotal() {
		return puntuacionTotal;
	}

	/**
	 * @param puntuacionTotal
	 *            the puntuacionTotal to set
	 */
	public void setPuntuacionTotal(List<PuntuacionTotal> puntuacionTotal) {
		this.puntuacionTotal = puntuacionTotal;
	}

	/**
	 * @return the riesgoIndirecto
	 */
	public Float getRiesgoIndirecto() {
		return riesgoIndirecto;
	}

	/**
	 * @param riesgoIndirecto
	 *            the riesgoIndirecto to set
	 */
	public void setRiesgoIndirecto(Float riesgoIndirecto) {
		this.riesgoIndirecto = riesgoIndirecto;
	}

	/**
	 * @param prepolitica
	 *            the prepolitica to set
	 */
	public void setPrepolitica(DDTipoPolitica prepolitica) {
		this.prepolitica = prepolitica;
	}

	/**
	 * @return the prepolitica
	 */
	public DDTipoPolitica getPrepolitica() {
		return prepolitica;
	}

	/**
	 * @param deudaIrregularDirecta
	 *            the deudaIrregularDirecta to set
	 */
	public void setDeudaIrregularDirecta(Float deudaIrregularDirecta) {
		this.deudaIrregularDirecta = deudaIrregularDirecta;
	}

	/**
	 * @return the deudaIrregularDirecta
	 */
	public Float getDeudaIrregularDirecta() {
		return deudaIrregularDirecta;
	}

	/**
	 * @param deudaIrregularIndirecta
	 *            the deudaIrregularIndirecta to set
	 */
	public void setDeudaIrregularIndirecta(Float deudaIrregularIndirecta) {
		this.deudaIrregularIndirecta = deudaIrregularIndirecta;
	}

	/**
	 * @return the deudaIrregularIndirecta
	 */
	public Float getDeudaIrregularIndirecta() {
		return deudaIrregularIndirecta;
	}

	/**
	 * @param ultimaFechaVencida
	 *            the ultimaFechaVencida to set
	 */
	public void setUltimaFechaVencida(Date ultimaFechaVencida) {
		this.ultimaFechaVencida = ultimaFechaVencida;
	}

	/**
	 * @return the ultimaFechaVencida
	 */
	public Date getUltimaFechaVencida() {
		return ultimaFechaVencida;
	}

	/**
	 * @param ultimaFechaVencidaDirecta
	 *            the ultimaFechaVencidaDirecta to set
	 */
	public void setUltimaFechaVencidaDirecta(Date ultimaFechaVencidaDirecta) {
		this.ultimaFechaVencidaDirecta = ultimaFechaVencidaDirecta;
	}

	/**
	 * @return the ultimaFechaVencidaDirecta
	 */
	public Date getUltimaFechaVencidaDirecta() {
		return ultimaFechaVencidaDirecta;
	}

	/**
	 * @param ultimaFechaVencidaIndirecta
	 *            the ultimaFechaVencidaIndirecta to set
	 */
	public void setUltimaFechaVencidaIndirecta(Date ultimaFechaVencidaIndirecta) {
		this.ultimaFechaVencidaIndirecta = ultimaFechaVencidaIndirecta;
	}

	/**
	 * @return the ultimaFechaVencidaIndirecta
	 */
	public Date getUltimaFechaVencidaIndirecta() {
		return ultimaFechaVencidaIndirecta;
	}

	/**
	 * Recupera el riesgo garantizado de la persona
	 * 
	 * @return
	 */
	public Float getRiesgoGarantizadoPersona() {
		List<Contrato> contratos = getContratos();
		Float rg = 0f;
		for (Contrato c : contratos) {
			rg += c.getLastMovimiento().getRiesgoGarantizado();
		}
		return rg;
	}

	/**
	 * Recupera el riesgo NO garantizado de la persona
	 * 
	 * @return
	 */
	public Float getRiesgoNoGarantizadoPersona() {
		List<Contrato> contratos = getContratos();
		Float rng = 0f;
		for (Contrato c : contratos) {
			rng += c.getLastMovimiento().getRiesgoNoGarantizado();
		}
		return rng;
	}

	/**
	 * @return the ciclosMarcadoPolitica
	 */
	public List<CicloMarcadoPolitica> getCiclosMarcadoPolitica() {
		return ciclosMarcadoPolitica;
	}

	/**
	 * @param ciclosMarcadoPolitica
	 *            the ciclosMarcadoPolitica to set
	 */
	public void setCiclosMarcadoPolitica(
			List<CicloMarcadoPolitica> ciclosMarcadoPolitica) {
		this.ciclosMarcadoPolitica = ciclosMarcadoPolitica;
	}

	public void setVisibilidad(EXTVisibilidad visibilidad) {
		this.visibilidad = visibilidad;
	}

	public EXTVisibilidad getVisibilidad() {
		return visibilidad;
	}

	public void setFechaRevisionSolvencia(Date fechaRevisionSolvencia) {
		this.fechaRevisionSolvencia = fechaRevisionSolvencia;
	}

	public Date getFechaRevisionSolvencia() {
		return fechaRevisionSolvencia;
	}

	public void setObservacionesRevisionSolvencia(
			String observacionesRevisionSolvencia) {
		this.observacionesRevisionSolvencia = observacionesRevisionSolvencia;
	}

	public String getObservacionesRevisionSolvencia() {
		return observacionesRevisionSolvencia;
	}

	public void setDiasVencidoRiegoDirecto(Integer diasVencidoRiegoDirecto) {
		this.diasVencidoRiegoDirecto = diasVencidoRiegoDirecto;
	}

	public Integer getDiasVencidoRiegoDirecto() {
		return diasVencidoRiegoDirecto;
	}

	public void setDiasVencidoRiegoIndirecto(Integer diasVencidoRiegoIndirecto) {
		this.diasVencidoRiegoIndirecto = diasVencidoRiegoIndirecto;
	}

	public Integer getDiasVencidoRiegoIndirecto() {
		return diasVencidoRiegoIndirecto;
	}

	public void setRiesgoTot(Float riesgoTot) {
		this.riesgoTot = riesgoTot;
	}

	public Float getRiesgoTot() {
		return riesgoTot;
	}

	public void setRiesgoTotalDirecto(Float riesgoTotalDirecto) {
		this.riesgoTotalDirecto = riesgoTotalDirecto;
	}

	public Float getRiesgoTotalDirecto() {
		return riesgoTotalDirecto;
	}

	public void setRiesgoTotalIndirecto(Float riesgoTotalIndirecto) {
		this.riesgoTotalIndirecto = riesgoTotalIndirecto;
	}

	public Float getRiesgoTotalIndirecto() {
		return riesgoTotalIndirecto;
	}

	public void setSituacionCliente(String situacionCliente) {
		this.situacionCliente = situacionCliente;
	}

	public String getSituacionCliente() {
		return situacionCliente;
	}

	public boolean getNoTieneFincabilidad() {
		return noTieneFincabilidad;
	}

	public void setNoTieneFincabilidad(boolean noTieneFincabilidad) {
		this.noTieneFincabilidad = noTieneFincabilidad;
	}

	public Date getFechaDato() {
		return fechaDato;
	}

	public void setFechaDato(Date fechaDato) {
		this.fechaDato = fechaDato;
	}

	public DDPropietario getPropietario() {
		return propietario;
	}

	public void setPropietario(DDPropietario propietario) {
		this.propietario = propietario;
	}

	public Date getFechaEstadoCicloVida() {
		return fechaEstadoCicloVida;
	}

	public void setFechaEstadoCicloVida(Date fechaEstadoCicloVida) {
		this.fechaEstadoCicloVida = fechaEstadoCicloVida;
	}

	public DDOrigenTelefono getOrigenTelefono() {
		return origenTelefono;
	}

	public void setOrigenTelefono(DDOrigenTelefono origenTelefono) {
		this.origenTelefono = origenTelefono;
	}

	public Boolean getConsitimientoTelefono1() {
		return consitimientoTelefono1;
	}

	public void setConsitimientoTelefono1(Boolean consitimientoTelefono1) {
		this.consitimientoTelefono1 = consitimientoTelefono1;
	}

	public Date getFechaVigilanciaTelefono1() {
		return fechaVigilanciaTelefono1;
	}

	public void setFechaVigilanciaTelefono1(Date fechaVigilanciaTelefono1) {
		this.fechaVigilanciaTelefono1 = fechaVigilanciaTelefono1;
	}

	public Date getFechaNacimiento() {
		return fechaNacimiento;
	}

	public void setFechaNacimiento(Date fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}

	public Date getFechaReferenciaRating() {
		return fechaReferenciaRating;
	}

	public void setFechaReferenciaRating(Date fechaReferenciaRating) {
		this.fechaReferenciaRating = fechaReferenciaRating;
	}

	public DDTipoPersonaNivel getTipoPersonaNivel() {
		return tipoPersonaNivel;
	}

	public void setTipoPersonaNivel(DDTipoPersonaNivel tipoPersonaNivel) {
		this.tipoPersonaNivel = tipoPersonaNivel;
	}

	public Float getRiesgoAutorizado() {
		return riesgoAutorizado;
	}

	public void setRiesgoAutorizado(Float riesgoAutorizado) {
		this.riesgoAutorizado = riesgoAutorizado;
	}

	public Float getRiesgoDispuesto() {
		return riesgoDispuesto;
	}

	public void setRiesgoDispuesto(Float riesgoDispuesto) {
		this.riesgoDispuesto = riesgoDispuesto;
	}
	
	public Float getRiesgoDirectoNoVencido() {
		return (this.riesgoDispuesto != null && this.riesgoDirectoVencido != null) ? this.riesgoDispuesto
				- this.riesgoDirectoVencido
				: 0F;
	}

	public Float getPasivoVista() {
		return pasivoVista;
	}

	public void setPasivoVista(Float pasivoVista) {
		this.pasivoVista = pasivoVista;
	}

	public Float getPasivoPlazo() {
		return pasivoPlazo;
	}

	public void setPasivoPlazo(Float pasivoPlazo) {
		this.pasivoPlazo = pasivoPlazo;
	}

	public Boolean getEsEmpleado() {
		return esEmpleado;
	}

	public void setEsEmpleado(Boolean esEmpleado) {
		this.esEmpleado = esEmpleado;
	}

	public DDColectivoSingular getColectivoSingular() {
		return colectivoSingular;
	}

	public void setColectivoSingular(DDColectivoSingular colectivoSingular) {
		this.colectivoSingular = colectivoSingular;
	}

	public Boolean getTieneIngresosDomiciliados() {
		return tieneIngresosDomiciliados;
	}

	public void setTieneIngresosDomiciliados(Boolean tieneIngresosDomiciliados) {
		this.tieneIngresosDomiciliados = tieneIngresosDomiciliados;
	}

	public Float getVolumenFacturacion() {
		return volumenFacturacion;
	}

	public void setVolumenFacturacion(Float volumenFacturacion) {
		this.volumenFacturacion = volumenFacturacion;
	}

	public Date getFechaVolumenFacturacion() {
		return fechaVolumenFacturacion;
	}

	public void setFechaVolumenFacturacion(Date fechaVolumenFacturacion) {
		this.fechaVolumenFacturacion = fechaVolumenFacturacion;
	}

	public DDTipoGestorEntidad getTipoGestorEntidad() {
		return tipoGestorEntidad;
	}

	public void setTipoGestorEntidad(DDTipoGestorEntidad tipoGestorEntidad) {
		this.tipoGestorEntidad = tipoGestorEntidad;
	}

	public DDAreaGestion getAreaGestion() {
		return areaGestion;
	}

	public void setAreaGestion(DDAreaGestion areaGestion) {
		this.areaGestion = areaGestion;
	}

	public List<Telefono> getTelefonos() {
		return telefonos;
	}

	public void setTelefonos(List<Telefono> telefonos) {
		this.telefonos = telefonos;
	}

	public String getServicioNominaPension() {
		return servicioNominaPension;
	}

	public void setServicioNominaPension(String servicioNominaPension) {
		this.servicioNominaPension = servicioNominaPension;
	}

	public String getUltimaActuacion() {
		return ultimaActuacion;
	}

	public void setUltimaActuacion(String ultimaActuacion) {
		this.ultimaActuacion = ultimaActuacion;
	}
	
	public String getDispuestoNoVencido() {
		return Checks.esNulo(dispuestoNoVencido) ? null : dispuestoNoVencido.replaceAll(",", ".");
	}

	public void setDispuestoNoVencido(String dispuestoNoVencido) {
		this.dispuestoNoVencido = dispuestoNoVencido;
	}

	public String getDispuestoVencido() {
		return (Checks.esNulo(dispuestoVencido)) ? null : dispuestoVencido.replaceAll(",", ".");
	}

	public void setDispuestoVencido(String dispuestoVencido) {
		this.dispuestoVencido = dispuestoVencido;
	}

	public String getEstadoCicloVida() {
		return estadoCicloVida;
	}

	public void setEstadoCicloVida(String estadoCicloVida) {
		this.estadoCicloVida = estadoCicloVida;
	}
	
	public String getDescripcionCnae() {
		return descripcionCnae;
	}

	public void setDescripcionCnae(String descripcionCnae) {
		this.descripcionCnae = descripcionCnae;
	}

	public Boolean getSituacionConcursal() {
		return situacionConcursal;
	}

	public void setSituacionConcursal(Boolean situacionConcursal) {
		this.situacionConcursal = situacionConcursal;
	}

	public String getFechaSituacionConcursal() {
		return fechaSituacionConcursal;
	}

	public void setFechaSituacionConcursal(String fechaSituacionConcursal) {
		this.fechaSituacionConcursal = fechaSituacionConcursal;
	}

	public Boolean getClienteReestructurado() {
		return clienteReestructurado;
	}

	public void setClienteReestructurado(Boolean clienteReestructurado) {
		this.clienteReestructurado = clienteReestructurado;
	}

}
