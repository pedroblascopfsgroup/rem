package es.pfsgroup.plugin.rem.model.dd;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

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
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;

/**
 * Modelo que gestiona el diccionario de los tipos de proveedores de los activos
 * 
 * @author Anahuac de Vicente
 */
@Entity
@Table(name = "DD_TPR_TIPO_PROVEEDOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoProveedor implements Auditable, Dictionary {

	private static final long serialVersionUID = 1L;
	
	public static final String COD_ASEGURADORA = "03";
	public static final String COD_MEDIADOR = "04";
	public static final String COD_OFICINA_BANKIA = "28";
	public static final String COD_OFICINA_CAJAMAR = "29";
	public static final String COD_FUERZA_VENTA_DIRECTA="18";
	public static final String COD_GESTORIA="01";
	public static final String COD_CERTIFICADORA="06";
	public static final String COD_TASADORA="02";
	public static final String COD_MANTENIMIENTO_TECNICO = "05";
	public static final String COD_WEB_HAYA = "30";
	public static final String COD_PORTAL_WEB = "23";
	public static final String COD_CAT = "31";
	public static final String COD_HAYA = "35";
	public static final String COD_GESTIONDIRECTA = "37";
	public static final String COD_SALESFORCE = "33";
	public static final String COD_OFICINA_LIBERBANK = "38";
	public static final String COD_SUELOS_DND = "43";
	
	public static final String COD_COMUNIDAD_DE_PROPIETARIOS = "07";
	public static final String COD_COMPLEJO_INMOBILIARIO = "08";
	public static final String COD_ENTIDAD_DE_CONSERVACION = "09";
	public static final String COD_JUNTA_DE_COMPENSACION = "10";
	public static final String COD_AGRUPACION_DE_INTERES_URBANISTICO = "11";
	public static final String COD_AYUNTAMIENTO_MUNICIPAL = "13";
	public static final String COD_DIPUTACION_PROVINCIAL = "14";
	public static final String COD_CONSEJERIA_AUTONOMICO = "15";
	public static final String COD_HACIENDA_ESTATAL = "16";
	public static final String COD_OTRA_ADMINISTRACION_PUBLICA = "17";
	public static final String COD_NOTARIO = "21";
	public static final String COD_REGISTRO = "24";
	public static final String COD_SUMINISTRO = "25";
	
	public static final List<String> CODIGOS_OFICINAS = new ArrayList<String>(Arrays.asList(COD_OFICINA_BANKIA, COD_OFICINA_CAJAMAR, COD_OFICINA_LIBERBANK));



	@Id
	@Column(name = "DD_TPR_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoProveedorGenerator")
	@SequenceGenerator(name = "DDTipoProveedorGenerator", sequenceName = "S_DD_TPR_TIPO_PROVEEDOR")
	private Long id;
	    
	@Column(name = "DD_TPR_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TPR_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TPR_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	    
	@ManyToOne
	@JoinColumn(name = "DD_TEP_ID")
	private DDEntidadProveedor tipoEntidadProveedor; 
	
	@Transient
	private String tipoEntidadCodigo;
	

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

	public DDEntidadProveedor getTipoEntidadProveedor() {
		return tipoEntidadProveedor;
	}

	public void setTipoEntidadProveedor(DDEntidadProveedor tipoEntidadProveedor) {
		this.tipoEntidadProveedor = tipoEntidadProveedor;
	}
	
	public String getTipoEntidadCodigo() {
		return !Checks.esNulo(tipoEntidadProveedor) ? this.tipoEntidadCodigo = tipoEntidadProveedor.getCodigo(): null;
	}

	public void setTipoEntidadCodigo(String tipoEntidadCodigo) {
		this.tipoEntidadCodigo = !Checks.esNulo(tipoEntidadCodigo) ? tipoEntidadCodigo : tipoEntidadProveedor.getCodigo();
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

	public static boolean isTipoProveedorOficina(ActivoProveedor activoProveedor) {
		boolean esTipoOficina = false;
		
		if(activoProveedor != null && activoProveedor.getTipoProveedor() != null) {
			if(CODIGOS_OFICINAS.contains(activoProveedor.getTipoProveedor().getCodigo())) {
				esTipoOficina = true;
			}
		}
		return esTipoOficina;
	}
}



