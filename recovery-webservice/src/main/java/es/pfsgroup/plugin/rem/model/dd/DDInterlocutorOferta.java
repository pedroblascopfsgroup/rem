package es.pfsgroup.plugin.rem.model.dd;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import javax.persistence.*;

/**
 * Modelo que gestiona el diccionario de InterlocutorOferta
 *
 * 
 * @author Jesus Jativa
 *
 */
@Entity
@Table(name = "DD_FIO_FUN_INTERLOCUTOR_OFERTA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDInterlocutorOferta implements Auditable, Dictionary {
	
	private static final long serialVersionUID = 1L;

	public static final String CODIGO_ACCIONISTA = "Z55";
	public static final String CODIGO_APODERADO_PROPIETARIO = "Z10";
	public static final String CODIGO_GESTORIA_OFERTAS_VENTA = "Z41";
	public static final String CODIGO_API_SOCIO_COMERCIAL = "Z56";
	public static final String CODIGO_GESTORIA_FORMALIZACION_VENTAS = "Z42";
	public static final String CODIGO_NOTARIO = "Z43";
	public static final String CODIGO_ADMINISTRADOR_COMUNIDAD = "Z44";
	public static final String CODIGO_GESTOR_INQUILINOS = "Z45";
	public static final String CODIGO_PORTFOLIO_MANAGER = "Z46";
	public static final String CODIGO_BROKER = "Z11";
	public static final String CODIGO_CORREDURIA_DE_SEGUROS = "Z30";
	public static final String CODIGO_GARANTE_BANCARIO_BANCO_PARA_AVAL = "Z24";
	public static final String CODIGO_GARANTE_PUBLICO = "Z49";
	public static final String CODIGO_GESTORIA_FIANZA = "Z50";
	public static final String CODIGO_DEPOSITARIO_FIANZA = "Z31";
	public static final String CODIGO_GARANTE_SOLIDARIO = "Z51";
	public static final String CODIGO_SERVICER_VENTAS = "Z52";
	public static final String CODIGO_GESTORIA_PLUSVALIA = "Z53";
	
	public static final String CODIGO_COMPRADOR_PRINCIPAL = "01";
	public static final String CODIGO_ARRENDATARIO_PRINCIPAL = "08";
	public static final String CODIGO_USUFRUCTUARIO = "07";
	public static final String CODIGO_TUTOR = "06";
	public static final String CODIGO_COMPRADOR_SECUNDARIO = "02";
	public static final String CODIGO_SUBARRENDATARIO = "11";

	public static final String CODIGO_C4C_ACCIONISTA = "Z55";
	public static final String CODIGO_C4C_APODERADO_PROPIETARIO = "Z10";
	public static final String CODIGO_C4C_GESTORIA_OFERTAS_VENTA = "Z41";
	public static final String CODIGO_C4C_API_SOCIO_COMERCIAL = "Z56";
	public static final String CODIGO_C4C_GESTORIA_FORMALIZACION_VENTAS = "Z42";
	public static final String CODIGO_C4C_NOTARIO = "Z43";
	public static final String CODIGO_C4C_ADMINISTRADOR_COMUNIDAD = "Z44";
	public static final String CODIGO_C4C_GESTOR_INQUILINOS = "Z45";
	public static final String CODIGO_C4C_PORTFOLIO_MANAGER = "Z46";
	public static final String CODIGO_C4C_BROKER = "Z11";
	public static final String CODIGO_C4C_CORREDURIA_DE_SEGUROS = "Z30";
	public static final String CODIGO_C4C_GARANTE_BANCARIO_BANCO_PARA_AVAL = "Z24";
	public static final String CODIGO_C4C_GARANTE_PUBLICO = "Z49";
	public static final String CODIGO_C4C_GESTORIA_FIANZA = "Z50";
	public static final String CODIGO_C4C_DEPOSITARIO_FIANZA = "Z31";
	public static final String CODIGO_C4C_GARANTE_SOLIDARIO = "Z51";
	public static final String CODIGO_C4C_SERVICER_VENTAS = "Z52";
	public static final String CODIGO_C4C_GESTORIA_PLUSVALIA = "Z53";
	public static final String CODIGO_C4C_COMPRADOR_PRINCIPAL = "1001";
	public static final String CODIGO_C4C_USUFRUCTUARIO = "Z39";
	public static final String CODIGO_C4C_TUTOR = "Z38";
	public static final String CODIGO_C4C_COMPRADOR_SECUNDARIO = "Z34";
	public static final String CODIGO_C4C_SUBARRENDATARIO = "Z47";
	public static final String CODIGO_C4C_APODERADO_EMPRESA = "Z35";


	
	@Id
	@Column(name = "DD_FIO_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDInterlocutorOferta")
	@SequenceGenerator(name = "DDInterlocutorOferta", sequenceName = "S_DD_FIO_FUN_INTERLOCUTOR_OFERTA")
	private Long id;

	@Column(name = "DD_FIO_CODIGO")
	private String codigo;

	@Column(name = "DD_FIO_CODIGO_C4C")
	private String codigoC4C;

	@Column(name = "DD_FIO_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_FIO_DESCRIPCION_LARGA")
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

	public String getCodigoC4C() {
		return codigoC4C;
	}

	public void setCodigoC4C(String codigoC4C) {
		this.codigoC4C = codigoC4C;
	}

}