package es.pfsgroup.recovery.geninformes.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.diccionarios.Dictionary;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

/**
 * Clase de diccionario de los diferentes informes definidos en Jasper
 * @author pedro
 *
 */
@Entity
@Table(name = "DD_INFORMES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class GENINFInforme implements Serializable, Dictionary {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8166415523645895203L;

	@Id
    @Column(name = "DD_INFORME_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDInformeGenerator")
    @SequenceGenerator(name = "DDInformeGenerator", sequenceName = "S_DD_INFORMES")
    private Long id;

    @Column(name = "DD_INFORME_CODIGO")
    private String codigo;

    @Column(name = "DD_INFORME_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_INFORME_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "IPA_INFORME_PARRAFOS", 
    	joinColumns = { @JoinColumn(name = "DD_INFORME_ID", unique = true) }, 
    		inverseJoinColumns = { @JoinColumn(name = "PRF_PARRAFO_ID") })
    private List<GENINFParrafo> parrafos;

    @Column(name = "DD_INFORME_ENVIAR_EMAIL")
    private boolean enviarPorEmail;

    @Column(name = "DD_INFORME_DEMORA_ENVIO")
    private Integer demoraEnvioEmail;

    @ManyToOne
	@JoinColumn(name = "DD_TFA_ID", nullable = true)
	private DDTipoFicheroAdjunto tipoFichero;
    
    @Column(name = "DD_INFORME_SUFIJO")
    private String sufijoInforme;
    
    @Column(name = "DD_DOCUMENTO_ADICIONAL")
    private boolean generarDocumentoAdicional;

    @ManyToOne
    @JoinColumn(name = "DD_GENERADO_ADICIONAL", nullable = true)
    private GENINFInforme documentoGeneradoAdicional;

	@Override
	public Long getId() {
		return id;
	}

	@Override
	public String getCodigo() {
		return codigo;
	}

	@Override
	public String getDescripcion() {
		return descripcion;
	}

	@Override
	public String getDescripcionLarga() {
		return descripcionLarga;
	}

    public void setId(Long id) {
		this.id = id;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

    
	public List<GENINFParrafo> getParrafos() {
		return parrafos;
	}

	public void setParrafos(List<GENINFParrafo> parrafos) {
		this.parrafos = parrafos;
	}

	public boolean isEnviarPorEmail() {
		return enviarPorEmail;
	}

	public void setEnviarPorEmail(boolean enviarPorEmail) {
		this.enviarPorEmail = enviarPorEmail;
	}

	public Integer getDemoraEnvioEmail() {
		return demoraEnvioEmail;
	}

	public void setDemoraEnvioEmail(Integer demoraEnvioEmail) {
		this.demoraEnvioEmail = demoraEnvioEmail;
	}

	public DDTipoFicheroAdjunto getTipoFichero() {
		return tipoFichero;
	}

	public void setTipoFichero(DDTipoFicheroAdjunto tipoFichero) {
		this.tipoFichero = tipoFichero;
	}

	public String getSufijoInforme() {
		return sufijoInforme;
	}

	public void setSufijoInforme(String sufijoInforme) {
		this.sufijoInforme = sufijoInforme;
	}

	public boolean isGenerarDocumentoAdicional() {
		return generarDocumentoAdicional;
	}

	public void setGenerarDocumentoAdicional(boolean generarDocumentoAdicional) {
		this.generarDocumentoAdicional = generarDocumentoAdicional;
	}

	public GENINFInforme getDocumentoGeneradoAdicional() {
		return documentoGeneradoAdicional;
	}

	public void setDocumentoGeneradoAdicional(GENINFInforme documentoGeneradoAdicional) {
		this.documentoGeneradoAdicional = documentoGeneradoAdicional;
	}
	
}
