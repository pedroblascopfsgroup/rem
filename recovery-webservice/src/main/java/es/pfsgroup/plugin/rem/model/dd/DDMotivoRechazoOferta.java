package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de motivos de anulacion de un expediente comercial
 * 
 * @author Bender
 *
 */
@Entity
@Table(name = "DD_MRO_MOTIVO_RECHAZO_OFERTA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDMotivoRechazoOferta implements Auditable, Dictionary {

	private static final long serialVersionUID = 1L;
	
	public static final String CODIGO_DECISION_COMITE = "18";
	public static final String CODIGO_PBC_DENEGADO = "902";
	public static final String CODIGO_ACTIVO_VENDIDO = "705";
	public static final String CODIGO_OTROS = "20";

	public static final String COD_CAIXA_CAMBIO_TITULAR = "1000";
	public static final String COD_CAIXA_CLIENTE_ARREPENTIDO = "2000";
	public static final String COD_CAIXA_OTRA_OFR = "3000";
	public static final String COD_CAIXA_HIPOTECA_PROMOTOR = "4000";
	public static final String COD_CAIXA_INCI_REGISTRADA = "5000";
	public static final String COD_CAIXA_MOD_DATOS_NUEVA_OFR = "6000";
	public static final String COD_CAIXA_MOD_DATOS = "7000";
	public static final String COD_CAIXA_NO_FINANCIA = "8000";
	public static final String COD_CAIXA_NO_FINANCIA_CAIXA = "9000";
	public static final String COD_CAIXA_OCUPA_ILEGAL = "10000";
	public static final String COD_CAIXA_ERROR_DATOS = "11000";
	public static final String COD_CAIXA_RECHAZADO_PBC = "12000";
	public static final String COD_CAIXA_RECHAZADO_NO_DOC_PLAZO = "13000";
	public static final String COD_CAIXA_INCI_TECNICAS = "14000";
	public static final String COD_CAIXA_INC_FECHAS = "15000";
	public static final String COD_CAIXA_RECH_COMITE = "16000";
	public static final String COD_CAIXA_RECH_PROPIEDAD = "17000";
	public static final String COD_CAIXA_RECARGA_OFERTA = "18000";
	public static final String COD_CAIXA_RECH_SCORING = "19000";
	public static final String COD_CAIXA_RECH_GARANTIAS = "20000";
	public static final String COD_CAIXA_LISTA_ESPERA_ALQ = "21000";
	public static final String COD_CAIXA_CLIENTE_ARREPENTIDO_2 = "22000";
	public static final String COD_CAIXA_DATOS_ERR = "23000";
	public static final String COD_CAIXA_MOD_CLAUSULAS = "24000";
	public static final String COD_CAIXA_INM_NO_ADECUADO = "25000";
	public static final String COD_CAIXA_DOC_RESERVA_CAD = "26000";
	public static final String COD_CAIXA_FALTA_BOLETINES = "27000";
	public static final String COD_CAIXA_INCI_TECNICA = "28000";
	public static final String COD_CAIXA_FALTAN_LLAVES = "29000";
	public static final String COD_CAIXA_COND_GARANTIAS_ADIC = "30000";
	public static final String COD_CAIXA_COND_OBLIGADO_CUMP = "31000";
	public static final String COD_CAIXA_GEN_CONTRATO = "32000";
	public static final String COD_CAIXA_INM_BAJA = "33000";
	public static final String COD_CAIXA_FALTA_CEE = "34000";
	public static final String COD_CAIXA_INM_NO_ADEC = "35000";
	public static final String COD_CAIXA_CLI_ALQ_OTRO_INM = "36000";
	public static final String COD_CAIXA_CLI_DES_ZONA = "37000";
	public static final String COD_CAIXA_CLI_DES_PRECIO = "38000";

	@Id
	@Column(name = "DD_MRO_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDMotivoRechazoOfertaGenerator")
	@SequenceGenerator(name = "DDMotivoRechazoOfertaGenerator", sequenceName = "S_DD_MRO_MOTIVO_RECHAZO_OFERTA")
	private Long id;
	
	@JoinColumn(name = "DD_TRO_ID")  
    @ManyToOne(fetch = FetchType.LAZY)
	private DDTipoRechazoOferta tipoRechazo;
	    
	@Column(name = "DD_MRO_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_MRO_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_MRO_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@Column(name = "DD_MRO_VENTA")   
	private Boolean venta;

	@Column(name = "DD_MRO_ALQUILER")   
	private Boolean alquiler;

	@Column(name = "DD_MRO_CODIGO_C4C")
	private String codigoC4C;

	@Column(name = "DD_MRO_VISIBLE_CAIXA")
	private Boolean visibleCaixa;
	
	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
	public DDTipoRechazoOferta getTipoRechazo() {
		return tipoRechazo;
	}

	public void setTipoRechazo(DDTipoRechazoOferta tipoRechazo) {
		this.tipoRechazo = tipoRechazo;
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
	
	public Boolean getVenta() {
		return venta;
	}

	public void setVenta(Boolean venta) {
		this.venta = venta;
	}
	
	public Boolean getAlquiler() {
		return alquiler;
	}

	public void setAlquiler(Boolean alquiler) {
		this.alquiler = alquiler;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public String getCodigoC4C() {
		return codigoC4C;
	}

	public void setCodigoC4C(String codigoC4C) {
		this.codigoC4C = codigoC4C;
	}

	public Boolean getVisibleCaixa() {
		return visibleCaixa;
	}

	public void setVisibleCaixa(Boolean visibleCaixa) {
		this.visibleCaixa = visibleCaixa;
	}
}