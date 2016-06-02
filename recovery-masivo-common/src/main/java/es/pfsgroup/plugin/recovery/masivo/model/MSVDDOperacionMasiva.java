package es.pfsgroup.plugin.recovery.masivo.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.users.domain.Funcion;


@Entity
@Table(name = "DD_OPM_OPERACION_MASIVA", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class MSVDDOperacionMasiva implements Serializable, Auditable, Dictionary {

	public static final String CODIGO_ALTA_ASUNTOS = "AAS";
	public static final String CODIGO_ALTA_LOTES = "ALO";
	public static final String CODIGO_ALTA_CARTERA_JUDICIALIZADA = "ACJ";
	public static final String CODIGO_CONFIRMAR_RECEPCION_ORIGINAL = "CRCO";
	public static final String CODIGO_SOLICITAR_TESTIMONIO = "STO";
	public static final String CODIGO_CONFIRMAR_RECEPCION_TESTIMONIO = "CRT";
	public static final String CODIGO_REGENERAR_DOCUMENTACION = "RDO";
	public static final String CODIGO_GENERAR_FICHERO_TASAS = "GFT";
	public static final String CODIGO_VALIDAR_FICHERO_TASAS = "VFT";
	public static final String CODIGO_SOLICITAR_PAGO_TASAS ="SPT";
	public static final String CODIGO_CONFIRMAR_RECEPCION_JUSTIFICANTE_TASAS = "CRJT";
	public static final String CODIGO_IMPRESION_DOCUMENTACION = "IMD";
	public static final String CODIGO_CONFIRMAR_RECEPCION_DOCUMENTACION_IMPRESA = "CRDI";
	public static final String CODIGO_ENVIO_JUZGADO = "EJZ";
	public static final String CODIGO_REORGANIZACION_ASUNTOS = "RAS";
	public static final String CODIGO_CANCELACION_ASUNTOS = "CAS";
	public static final String CODIGO_PARALIZACION_ASUNTOS = "PAS";
	public static final String CODIGO_AUTOPRORROGA = "AUP";
	public static final String CODIGO_IMPULSO_PROCESAL = "IMP";
	public static final String CODIGO_REDACCION_DEMANDA = "REDACC_DEM";
	public static final String CODIGO_ENVIO_DEMANDA = "ENVIO_DEMANDA";
	public static final String CODIGO_LANZAMIENTO_ETJ_DESDE_FM = "LEFM";
	public static final String CODIGO_ADMISION_DEMANDA = "ADM_DEM";
	public static final String CODIGO_PRESENTACION_DEMANDA = "PRE_DEM";
	public static final String CODIGO_CARTERIZACION_ACREDITADOS = "CA_AC"; //Añadido


	public static final String CODIGO_ENVIO_IMPRESION = "IMP_MASIVO";

	// C�DIGOS DE TIPOS DE INPUTS QUE GENERARA CADA TIPO DE OPERACION
	
	public static final String CODIGO_INPUT_CONTRATO_ORIGINAL_RECIBIDO = "CNT_ORIGINAL_RECIBIDO";
	public static final String CODIGO_INPUT_CONTRATO_ORIGINAL_NO_RECIBIDO = "CNT_ORIGINAL_NO_RECIBIDO";
	public static final String CODIGO_INPUT_TESTIMONIO_SOLICITADO = "TEST_SOLICITADO";
	public static final String CODIGO_INPUT_TESTIMONIO_RECIBIDO = "TEST_RECIBIDO";
	public static final String CODIGO_INPUT_REGENERAR_DOCUMENTACION = "REGENERAR_DOC";
	public static final String CODIGO_INPUT_FICHERO_TASAS_GENERADO="FICHERO_TASAS_GENERADO";
	public static final String CODIGO_INPUT_FICHERO_TASAS_VALIDADO="FICHERO_TASAS_VALIDADO";
	public static final String CODIGO_INPUT_FICHERO_TASAS_NO_VALIDADO="FICHERO_TASAS_NO_VALIDADO";
	public static final String CODIGO_INPUT_FICHERO_TASAS_MANUAL="FICHERO_TASAS_MANUAL";
	public static final String CODIGO_INPUT_PAGO_TASAS_SOLICITADO="PAGO_TASAS_SOLICITADO";
	public static final String CODIGO_INPUT_JUSTIFICANTE_TASAR_RECIBIDO="JUSTIF_TASAS_RECIBIDO";
	public static final String CODIGO_INPUT_IMPRESO="IMP";
	public static final String CODIGO_INPUT_DOCUMENTACION_RECIBIDA="DOC_RECIBIDA";
	public static final String CODIGO_INPUT_ENVIADO_JUZGADO="ENVIADO";
	
	
	// TIPOS DE INPUTS DE MONITORIO
	
	public static final String CODIGO_INPUT_INADMISION_CON_PROC_LEGAL = "INADM_CON_PROC_LEGAL";
	public static final String CODIGO_INPUT_INADMISION_SIN_PROC_LEGAL = "INADM_SIN_PROC_LEGAL";
	public static final String CODIGO_INPUT_REQUERIMIENTO_PAGO_POSITIVO_LEGAL_CON_PROC = "REQ_PAG_POS_CON_PROC_LEG";
	public static final String CODIGO_INPUT_REQUERIMIENTO_PAGO_POSITIVO_LEGAL_SIN_PROC = "REQ_PAG_POS_SIN_PROC_LEG";
	public static final String CODIGO_INPUT_REQUERIMIENTO_PAGO_NEGATIVO_CON_PROCURADOR_LEGAL = "REQ_PAG_NEG_CON_PROC_LEG";
	public static final String CODIGO_INPUT_REQUERIMIENTO_PAGO_NEGATIVO_SIN_PROCURADOR_LEGAL = "REQ_PAG_NEG_SIN_PROC_LEG";
	public static final String CODIGO_INPUT_AVERIGUACION_POSITIVA_CON_PROC_LEGAL = "AVERIG_POS_CON_PROC_LEG";
	public static final String CODIGO_INPUT_AVERIGUACION_POSITIVA_SIN_PROC_LEGAL = "AVERIG_POS_SIN_PROC_LEG";
	public static final String CODIGO_INPUT_AVERIGUACION_NEGATIVA_CON_PROC_LEGAL = "AVERIG_NEG_CON_PROC_LEG";
	public static final String CODIGO_INPUT_AVERIGUACION_NEGATIVA_SIN_PROC_LEGAL = "AVERIG_NEG_SIN_PROC_LEG";
	public static final String CODIGO_INPUT_AVERIGUACION_REPETIDA_CON_PROC_LEGAL = "AVERIG_REP_CON_PROC_LEG";
	public static final String CODIGO_INPUT_AVERIGUACION_REPETIDA_SIN_PROC_LEGAL = "AVERIG_REP_SIN_PROC_LEG";
	public static final String CODIGO_INPUT_SOLICITAR_CTA_INGR_CON_PROC_LEGAL = "SOL_CTA_INGRESO_CON_PROC_LEG";
	public static final String CODIGO_INPUT_SOLICITAR_CTA_INGR_SIN_PROC_LEGAL = "SOL_CTA_INGRESO_SIN_PROC_LEG";
	public static final String CODIGO_INPUT_COMUNIC_PAGO_CTA_LEGAL = "COMUNIC_PAGO_CTA_LEG";
	public static final String CODIGO_INPUT_CONTINUAR_CON_PROC_LEGAL = "CONTINUAR_PRC_CON_PROC";
	public static final String CODIGO_INPUT_CONTINUAR_SIN_PROC_LEGAL = "CONTINUAR_PRC_SIN_PROC";
	   
	public static final String CODIGO_INPUT_IMPULSO_PROCESAL_BATCH = "IMPULSO_PROC_BATCH";
	public static final String CODIGO_INPUT_REDACC_DEM_BATCH = "REDACC_DEM_BATCH";
	public static final String CODIGO_INPUT_ENVIO_DEMANDA_BATCH = "ENVIO_DEMANDA_BATCH";
	public static final String CODIGO_INPUT_LANZAR_ETJ_DESDE_FM = "LANZAR_ETJ_DESDE_FM";

	public static final String CODIGO_INPUT_PRESENTACION_DEMANDA_BATCH="DEM_PRESENTA_BATCH";
	
	public static final String CODIGO_INPUT_ADMISION_TOTAL_DEMANDA_BATCH="DEM_ADM_TOTAL_BATCH";
	public static final String CODIGO_INPUT_ADMISION_PARCIAL_DEMANDA_BATCH="DEM_ADM_PARCIAL_BATCH";
	public static final String CODIGO_INPUT_AUTO_DESPACHANDO_TOTAL_BATCH="AUDE_TOTAL_BATCH";
	public static final String CODIGO_INPUT_AUTO_DESPACHANDO_PARCIAL_BATCH="AUDE_PARCIAL_BATCH";
	
	private static final long serialVersionUID = 5938440720826995243L;

	
	
	@Id
    @Column(name = "DD_OPM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MSVDDOperacionMasivaGenerator")
    @SequenceGenerator(name = "MSVDDOperacionMasivaGenerator", sequenceName = "S_DD_OPM_OPERACION_MASIVA")
    private Long id;

    @Column(name = "DD_OPM_CODIGO")
    private String codigo;

    @Column(name = "DD_OPM_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_OPM_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @ManyToOne
    @JoinColumn(name = "FUN_ID")
    private Funcion funcion;
    
    @Column(name="DD_OPM_VALIDACION_FORMATO")
    private String validacionFormato;
    
    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	public Funcion getFuncion() {
		return funcion;
	}

	public void setFuncion(Funcion funcion) {
		this.funcion = funcion;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public void setValidacionFormato(String validacionFormato) {
		this.validacionFormato = validacionFormato;
	}

	public String getValidacionFormato() {
		return validacionFormato;
	}

}
