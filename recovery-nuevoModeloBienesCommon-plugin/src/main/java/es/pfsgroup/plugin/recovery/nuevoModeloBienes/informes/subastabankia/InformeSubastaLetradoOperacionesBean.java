package es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.subastabankia;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.pfsgroup.commons.utils.Conversiones;

@Entity
@Table(name="VINFSUBLET_OPERACIONES" ,schema="${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class InformeSubastaLetradoOperacionesBean implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Column(name="SUB_ID")
	private Long idSubasta;
	
	@Id
	@Column(name="OPER_ID")
	private Long idOperacion;
	
	@Column(name="NUM_OPERACION")
	private String numero;
	
	@Column(name="TITU_FIADORES")
	private String titFia;
	
	@Column(name="RECLAMADO")
	private BigDecimal reclamado;
	
	@Column(name="AUTOS")
	private String autos;
	
	@Column(name="OBSERVACIONES")
	private String observaciones;
	
	public Long getIdSubasta() {
		return idSubasta;
	}

	public void setIdSubasta(Long idSubasta) {
		this.idSubasta = idSubasta;
	}

	public Long getIdOperacion() {
		return idOperacion;
	}

	public void setIdOperacion(Long idOperacion) {
		this.idOperacion = idOperacion;
	}

	public String getNumero() {
		return numero;
	}

	public void setNumero(String numero) {
		this.numero = numero;
	}

	public String getTitFia() {
		return titFia;
	}

	public void setTitFia(String titFia) {
		this.titFia = titFia;
	}

	public BigDecimal getReclamado() {
		return reclamado;
	}

	public void setReclamado(BigDecimal reclamado) {
		this.reclamado = reclamado;
	}

	public String getAutos() {
		return Conversiones.delSeparadoresSobrantes(autos,"/");
	}

	public void setAutos(String autos) {
		this.autos = autos;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

}
