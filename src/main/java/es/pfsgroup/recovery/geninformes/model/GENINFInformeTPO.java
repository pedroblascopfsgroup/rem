package es.pfsgroup.recovery.geninformes.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;

/**
 * Clase de relación entre dd_informes y dd_tpo_tipo_procedimiento
 * @author Carlos
 *
 */
@Entity
@Table(name = "ITP_INFORMES_TPO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class GENINFInformeTPO implements Serializable, Dictionary {

	private static final long serialVersionUID = 8166415523645895203L;

	@Id
    @Column(name = "ITP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDInformeTPOGenerator")
    @SequenceGenerator(name = "DDInformeTPOGenerator", sequenceName = "S_ITP_INFORMES_TPO")
    private Long id;

    @Column(name = "ITP_CODIGO")
    private String codigo;

    @Column(name = "ITP_DESCRIPCION")
    private String descripcion;

    @Column(name = "ITP_DESCRIPCION_LARGA")
    private String descripcionLarga;

    @ManyToOne
   	@JoinColumn(name = "DD_TPO_ID", nullable = true)
   	private TipoProcedimiento tipoProcedimiento;

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

	public TipoProcedimiento getTipoProcedimiento() {
		return tipoProcedimiento;
	}

	public void setTipoProcedimiento(TipoProcedimiento tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}
	
}
