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
 * Clase de diccionario de las diferentes variables que pueden aparecer en 
 *  los informes definidos en Jasper
 *  
 * @author pedro
 *
 */
@Entity
@Table(name = "VBL_VARIABLES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class GENINFVariable implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5908632303825805691L;

	@Id
    @Column(name = "VBL_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "VBLVariableGenerator")
    @SequenceGenerator(name = "VBLVariableGenerator", sequenceName = "S_VBL_VARIABLES")
    private Long id;

    @Column(name = "VBL_CODIGO")
    private String codigo;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "PVB_PARRAFOS_VARIABLES", joinColumns = { @JoinColumn(name = "VBL_ID", unique = true) }, 
    	inverseJoinColumns = { @JoinColumn(name = "PRF_PARRAFO_ID") })
    private List<GENINFParrafo> parrafos;

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

	public List<GENINFParrafo> getParrafos() {
		return parrafos;
	}

	public void setParrafos(List<GENINFParrafo> parrafos) {
		this.parrafos = parrafos;
	}

}
