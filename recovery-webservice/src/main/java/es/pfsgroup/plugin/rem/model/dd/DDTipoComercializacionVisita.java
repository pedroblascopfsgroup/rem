package es.pfsgroup.plugin.rem.model.dd;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import javax.persistence.*;

/**
 * Modelo que gestiona el diccionario de comercializacion de visitas.
 * 
 * @author Benjamín Guerrero
 *
 */
@Entity
@Table(name = "DD_TCV_TIPO_COM_VISITA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoComercializacionVisita implements Auditable, Dictionary {

	public static final String CODIGO_VENTA = "01";
	public static final String CODIGO_ALQUILER = "02";
	public static final String CODIGO_VENTA_C4C = "SALE";
	public static final String CODIGO_ALQUILER_C4C = "RENT";
	public static final String CODIGO_VENTA_BUSINESS = "BDCNIN";
	public static final String CODIGO_ALQUILER_BUSINESS = "BDCPAT";
		/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_TCV_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoComercializacionVisitaGenerator")
	@SequenceGenerator(name = "DDTipoComercializacionVisitaGenerator", sequenceName = "S_DD_TCV_TIPO_COM_VISITA")
	private Long id;
	 
	@Column(name = "DD_TCV_CODIGO")
	private String codigo;
	 
	@Column(name = "DD_TCV_DESCRIPCION")
	private String descripcion;
	    
	@Column(name = "DD_TCV_DESCRIPCION_LARGA")
	private String descripcionLarga;

	@Column(name = "DD_TCV_CODIGO_C4C")
	private String codigoC4C;

	@Column(name = "DD_TCV_CODIGO_C4C_BUSINESS")
	private String codigoC4CBusiness;

	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	@Override
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@Override
	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	@Override
	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	@Override
	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	public String getCodigoC4C() {
		return codigoC4C;
	}

	public void setCodigoC4C(String codigoC4C) {
		this.codigoC4C = codigoC4C;
	}

	public String getCodigoC4CBusiness() {
		return codigoC4CBusiness;
	}

	public void setCodigoC4CBusiness(String codigoC4CBusiness) {
		this.codigoC4CBusiness = codigoC4CBusiness;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
}
