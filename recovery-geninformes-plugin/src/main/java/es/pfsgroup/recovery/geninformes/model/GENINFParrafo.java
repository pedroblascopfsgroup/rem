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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

/**
 * Clase de los diferentes párrafos que pueden ser definidos en Jasper
 * @author pedro
 *
 */
@Entity
@Table(name = "PRF_PARRAFOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class GENINFParrafo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3528651748503577123L;

	@Id
    @Column(name = "PRF_PARRAFO_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "PRFParrafoGenerator")
    @SequenceGenerator(name = "PRFParrafoGenerator", sequenceName = "S_PRF_PARRAFOS")
    private Long id;

    @Column(name = "PRF_PARRAFO_CODIGO")
    private String codigo;

    @Column(name = "PRF_PARRAFO_CONTENIDO")
    private String contenido;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "IPA_INFORME_PARRAFOS", 
	joinColumns = { @JoinColumn(name = "PRF_PARRAFO_ID", unique = true) }, 
		inverseJoinColumns = { @JoinColumn(name = "DD_INFORME_ID") })
    private List<GENINFInforme> informes;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "PVB_PARRAFOS_VARIABLES", joinColumns = { @JoinColumn(name = "PRF_PARRAFO_ID", unique = true) }, 
    	inverseJoinColumns = { @JoinColumn(name = "VBL_ID") })
    private List<GENINFVariable> variables;

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

	public List<GENINFInforme> getInformes() {
		return informes;
	}

	public void setInformes(List<GENINFInforme> informes) {
		this.informes = informes;
	}

	public String getContenido() {
		return contenido;
	}

	public void setContenido(String contenido) {
		this.contenido = contenido;
	}

	public List<GENINFVariable> getVariables() {
		return variables;
	}

	public void setVariables(List<GENINFVariable> variables) {
		this.variables = variables;
	}

}
