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
 * Modelo que gestiona el diccionario de carteras.
 * 
 * @author Viorel Remus Ovidiu
 *
 */
@Entity
@Table(name = "DD_SCG_SUBESTADO_CARGA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSubestadoCarga implements Auditable, Dictionary {

	public static final String COD_SCG_SIN_INICIAR = "01";
	public static final String COD_SCG_EN_ANALISIS = "02";
	public static final String COD_SCG_SOLICITA_PROV_FONDOS = "03";
	public static final String COD_SCG_SOLICITA_CARTA_PAGO = "04";
	public static final String COD_SCG_CANCELADO_ECONOMICO = "05";
	public static final String COD_SCG_SOLICITA_CERT_SALDO_CERO = "06";
	public static final String COD_SCG_PARALIZADO_PROPIEDAD = "07";
	public static final String COD_SCG_SOLICITA_CONFICUON_TITULO = "08";
	public static final String COD_SCG_SOLICITA_INSTANCIA_CONFUSION = "09";
	public static final String COD_SCG_SOLICITA_INSTANCIA_CADUCIDAD = "10";
	public static final String COD_SCG_SOLICITA_ESCRITURA_CANCELACION = "11";
	public static final String COD_SCG_RECIBIDA_INSTANCIA_GESTORIA = "12";
	public static final String COD_SCG_PRESENTADO_RP = "13";
	public static final String COD_SCG_DEFECTO = "14";
	public static final String COD_SCG_SOLICITA_MANDAMIENTOS_CLIENTE = "15";
	public static final String COD_SCG_SOLICITA_MANDAMIENTOS_PROCURADOR_LETRADO = "16";
	public static final String COD_SCG_RECIBIDOS_MANDAMIENTOS_GESTORIA = "17";
	public static final String COD_SCG_DEFECTO_SUBSANADO = "18";
	public static final String COD_SCG_CANCELADA_CARGA = "19";
	public static final String COD_SCG_ASUME_COMPRADOR = "20";
	public static final String COD_SCG_NO_CANCELABLE = "21";
	public static final String COD_SCG_CADUCADA_PENDIENTE = "22";
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_SCG_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubestadoCargaGenerator")
	@SequenceGenerator(name = "DDSubestadoCargaGenerator", sequenceName = "S_DD_SCG_SUBESTADO_CARGA")
	private Long id;
	 
	@Column(name = "DD_SCG_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_SCG_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_SCG_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	    
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

}
