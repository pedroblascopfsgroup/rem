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
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.pfsgroup.commons.utils.Checks;


@Entity
@Table(name = "DD_MEB_MOTIVOS_ESTADO_BC", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDMotivosEstadoBC implements Auditable, Dictionary {
	
	public static final String CODIGO_NO_ENVIADA = "01";
	public static final String CODIGO_PDTE_VALIDACION = "02";
	public static final String CODIGO_APROBADA_BC = "03";
	public static final String CODIGO_RECHAZADA_BC = "04";
	public static final String CODIGO_ANULADA = "05";
	public static final String CODIGO_APLAZADA = "06";
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_MEB_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDMotivosEstadoBCGenerator")
	@SequenceGenerator(name = "DDMotivosEstadoBCGenerator", sequenceName = "S_DD_MEB_MOTIVOS_ESTADO_BC")
	private Long id;
	    
	@Column(name = "DD_MEB_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_MEB_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_MEB_DESCRIPCION_LARGA")   
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
	
	public static boolean isAnulado(DDMotivosEstadoBC motivoEstadoBC) {
		boolean isAnulado = false;
		if(motivoEstadoBC != null && (CODIGO_ANULADA.equals(motivoEstadoBC.getCodigo()))) {
			isAnulado = true;
		}
		
		return isAnulado;
	}
	
	public static boolean isAprobado(DDMotivosEstadoBC motivoEstadoBC) {
		boolean isAprobado = false;
		if(motivoEstadoBC != null && (CODIGO_APROBADA_BC.equals(motivoEstadoBC.getCodigo()))) {
			isAprobado = true;
		}
		
		return isAprobado;
	}
	
	public static boolean isRechazado(DDMotivosEstadoBC motivoEstadoBC) {
		boolean isRechazado = false;
		if(motivoEstadoBC != null && (CODIGO_RECHAZADA_BC.equals(motivoEstadoBC.getCodigo()))) {
			isRechazado = true;
		}
		
		return isRechazado;
	}
	
	public static boolean isNoEnviada(DDMotivosEstadoBC motivoEstadoBC) {
		boolean is = false;
		if(motivoEstadoBC != null && (CODIGO_NO_ENVIADA.equals(motivoEstadoBC.getCodigo()))) {
			is = true;
		}
		
		return is;
	}
	
	public static boolean isAprobada(DDMotivosEstadoBC motivoEstadoBC) {
		boolean is = false;
		if(motivoEstadoBC != null && (CODIGO_APROBADA_BC.equals(motivoEstadoBC.getCodigo()))) {
			is = true;
		}
		
		return is;
	}

}
