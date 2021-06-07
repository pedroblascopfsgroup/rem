

package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
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
 * Modelo que gestiona el diccionario de tipos de precios.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "DD_TPC_TIPO_PRECIO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
@SuppressWarnings("unused")
public class DDTipoPrecio implements Auditable, Dictionary {

	/**
	 * 
	 */
	
	public static final String CODIGO_TPC_VALOR_NETO_CONT = "01";	  	//	Valor Neto Contable
	public static final String CODIGO_TPC_APROBADO_VENTA = "02";		//	Precio aprobado de venta
	public static final String CODIGO_TPC_APROBADO_RENTA = "03";		//	Precio aprobado de renta
	public static final String CODIGO_TPC_MIN_AUTORIZADO = "04";		//	Precio mínimo autorizado
	public static final String CODIGO_TPC_MIN_AUT_PROP_RENTA = "05";	//	Precio mínimo del propietario para alquiler
	public static final String CODIGO_TPC_PUBLICACION_WEB = "06";		//	Precio publicación web
	public static final String CODIGO_TPC_DESC_APROBADO = "07";			//	Precio de descuento aprobado
	public static final String CODIGO_TPC_PRECIO_SUBASTA = "08";		//	Precio subasta
	public static final String CODIGO_TPC_VALOR_LEGAL_VPO = "09";		//	Valor legal para VPO
	public static final String CODIGO_TPC_TASAC_VENTA_INMED = "10";		//	Valor tasación para venta inmediata
	public static final String CODIGO_TPC_ESTIMADO_VENTA = "11";		//	Valor estimado de venta
	public static final String CODIGO_TPC_ESTIMADO_RENTA = "12";		//	Valor estimado de renta
	public static final String CODIGO_TPC_DESC_PUBLICADO = "13";		//	Precio de descuento publicado
	public static final String CODIGO_TPC_VALOR_REFERENCIA = "14";		//	Valor de referencia
	public static final String CODIGO_TPC_PT = "15";					//	PT
	public static final String CODIGO_TPC_ASESORA_LIQUID = "16";		//	Valor asesoramiento liquidativo
	public static final String CODIGO_TPC_VACBE = "17";					//	VACBE
	public static final String CODIGO_TPC_COSTE_ADQUISICION = "18";		//	Coste de adquisición
	public static final String CODIGO_TPC_FSV_VENTA = "19";				//	FSV venta
	public static final String CODIGO_TPC_FSV_RENTA = "20";				//	FSV renta
	public static final String CODIGO_TPC_DEUDA_BRUTA = "21";           //  Deuda Bruta
	public static final String CODIGO_TPC_VALOR_RAZONABLE = "22";       //  Valor Razonable del propietario
	public static final Double MAX_DEUDA_BRUTA_LIBERBANK = 500000d;
	public static final String CODIGO_TPC_VALOR_NETO_CONT_LIBERBANK = "25";
	public static final String CODIGO_TPC_DEUDA_BRUTA_LIBERBANK = "24"; 
	public static final String CODIGO_TPC_VALOR_RAZONABLE_LBK = "23"; 	// Valor Razonable
	public static final String CODIGO_TPC_FSV_VENTA_ORIGEN= "26"; 	// FSV Venta Origen
	public static final String CODIGO_TPC_FSV_RENTA_ORIGEN = "27"; 	// FSV Renta origen
	public static final String CODIGO_TPC_DES_APR_ALQ = "DAA"; 	// De descuento aprobado alquiler
	public static final String CODIGO_TPC_DES_PUB_ALQ = "DPA"; 	// De descuento publicado alquiler (web)
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "DD_TPC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoPrecioGenerator")
	@SequenceGenerator(name = "DDTipoPrecioGenerator", sequenceName = "S_DD_TPC_TIPO_PRECIO")
	private Long id;
	    
	@Column(name = "DD_TPC_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TPC_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TPC_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@Column(name = "DD_TPC_TIPO")
	private String tipo;
	    

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

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
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

	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

}



