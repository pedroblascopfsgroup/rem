package es.pfsgroup.plugin.rem.model.dd;

import java.io.Serializable;

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


@Entity
@Table(name = "DD_LES_LISTADO_ERRORES_SAP", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDListadoErrores implements Auditable, Serializable {
	
	
	public static final String CODIGO_GASTO_OK_PDTE_APROBACION = "01";
	public static final String CODIGO_GASTO_KO_SUBSANA_SAPBC = "02";
	public static final String CODIGO_GASTO_CONTABILIZADO = "03";
	public static final String CODIGO_GASTO_RECHAZADO = "04";
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_LES_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDListadoErroresGenerator")
	@SequenceGenerator(name = "DDListadoErroresGenerator", sequenceName = "S_DD_LES_LISTADO_ERRORES_SAP")
	private Long id;
	 
	@Column(name = "DD_LES_CODIGO")   
	private String codigo;
	
	@Column(name = "DD_RETORNO_SAPBC")
	private String retornoSAPBC;
	
	@Column(name = "DD_TEXT_MENSAJE_SAP")
	private String textoMensajeSAPBC;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EGA_ID")
	private DDEstadoGasto estadoGasto;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="DD_EAH_ID")
	private DDEstadoAutorizacionHaya estadoAutorizacionHaya;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="DD_EAP_ID")
	private DDEstadoAutorizacionPropietario estadoAutorizacionPropietario;
	
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

	public String getRetornoSAPBC() {
		return retornoSAPBC;
	}

	public void setRetornoSAPBC(String retornoSAPBC) {
		this.retornoSAPBC = retornoSAPBC;
	}

	public String getTextoMensajeSAPBC() {
		return textoMensajeSAPBC;
	}

	public void setTextoMensajeSAPBC(String textoMensajeSAPBC) {
		this.textoMensajeSAPBC = textoMensajeSAPBC;
	}

	public DDEstadoGasto getEstadoGasto() {
		return estadoGasto;
	}

	public void setEstadoGasto(DDEstadoGasto estadoGasto) {
		this.estadoGasto = estadoGasto;
	}

	public DDEstadoAutorizacionHaya getEstadoAutorizacionHaya() {
		return estadoAutorizacionHaya;
	}

	public void setEstadoAutorizacionHaya(DDEstadoAutorizacionHaya estadoAutorizacionHaya) {
		this.estadoAutorizacionHaya = estadoAutorizacionHaya;
	}

	public DDEstadoAutorizacionPropietario getEstadoAutorizacionPropietario() {
		return estadoAutorizacionPropietario;
	}

	public void setEstadoAutorizacionPropietario(DDEstadoAutorizacionPropietario estadoAutorizacionPropietario) {
		this.estadoAutorizacionPropietario = estadoAutorizacionPropietario;
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
