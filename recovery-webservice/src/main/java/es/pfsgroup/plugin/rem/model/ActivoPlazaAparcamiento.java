package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.pfsgroup.plugin.rem.model.dd.DDSubtipoPlazaGaraje;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUbicaAparcamiento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVivienda;



/**
 * Modelo que gestiona la información comercial de las plazas de aparcamiento de los activos
 * 
 * @author Anahuac de Vicente
 * 
 */
@Entity
@Table(name = "ACT_APR_PLAZA_APARCAMIENTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@PrimaryKeyJoinColumn(name="ICO_ID")
public class ActivoPlazaAparcamiento extends ActivoInfoComercial implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;


	@Column(name = "APR_DESTINO_COCHE")
    private Boolean destinoCoche;
    
	@Column(name = "APR_DESTINO_MOTO")
	private Boolean destinoMoto;
	
	@Column(name = "APR_DESTINO_DOBLE")
	private Boolean destinoDoble;
	
	@ManyToOne
    @JoinColumn(name = "DD_TUA_ID")
	private DDTipoUbicaAparcamiento ubicacionAparcamiento;
	
	@ManyToOne
    @JoinColumn(name = "DD_TCA_ID")
	private DDTipoCalidad tipoCalidad;
	
	@Column(name = "APR_ANCHURA")
	private Float anchura;
	
	@Column(name = "APR_PROFUNDIDAD")
	private Float profundidad;
	
	@Column(name = "APR_FORMA_IRREGULAR")
	private Boolean formaIrregular;
	
	@Column(name = "APR_ALTURA")
	private Float aparcamientoAltura;
	
	@ManyToOne
    @JoinColumn(name = "DD_SPG_ID")
	private DDSubtipoPlazaGaraje subtipoPlazagaraje;
	

	@ManyToOne
    @JoinColumn(name = "DD_TPV_ID")
	private DDTipoVivienda aparcamientoTipoVario;
	
	@Column(name = "APR_LICENCIA")
	private Integer aparcamientoLicencia;
	
	@Column(name = "APR_SERVIDUMBRE")
	private Integer aparcamientoSerbidumbre;
	
	@Column(name = "APR_ASCENSOR_MONTACARGA")
	private Integer aparcamientoMontacarga;
	
	@Column(name = "APR_COLUMNAS")
	private Integer aparcamientoColumnas;
	
	@Column(name = "APR_SEGURIDAD")
	private Integer aparcamientoSeguridad;

	public Float getAparcamientoAltura() {
		return aparcamientoAltura;
	}

	public void setAparcamientoAltura(Float aparcamientoAltura) {
		this.aparcamientoAltura = aparcamientoAltura;
	}

	public DDTipoVivienda getAparcamientoTipoVario() {
		return aparcamientoTipoVario;
	}

	public void setAparcamientoTipoVario(DDTipoVivienda aparcamientoTipoVario) {
		this.aparcamientoTipoVario = aparcamientoTipoVario;
	}

	public Boolean getDestinoCoche() {
		return destinoCoche;
	}

	public void setDestinoCoche(Boolean destinoCoche) {
		this.destinoCoche = destinoCoche;
	}

	public Boolean getDestinoMoto() {
		return destinoMoto;
	}

	public void setDestinoMoto(Boolean destinoMoto) {
		this.destinoMoto = destinoMoto;
	}

	public Boolean getDestinoDoble() {
		return destinoDoble;
	}

	public void setDestinoDoble(Boolean destinoDoble) {
		this.destinoDoble = destinoDoble;
	}

	public DDTipoUbicaAparcamiento getUbicacionAparcamiento() {
		return ubicacionAparcamiento;
	}

	public void setUbicacionAparcamiento(
			DDTipoUbicaAparcamiento ubicacionAparcamiento) {
		this.ubicacionAparcamiento = ubicacionAparcamiento;
	}

	public DDTipoCalidad getTipoCalidad() {
		return tipoCalidad;
	}

	public void setTipoCalidad(DDTipoCalidad tipoCalidad) {
		this.tipoCalidad = tipoCalidad;
	}

	public Float getAnchura() {
		return anchura;
	}

	public void setAnchura(Float anchura) {
		this.anchura = anchura;
	}

	public Float getProfundidad() {
		return profundidad;
	}

	public void setProfundidad(Float profundidad) {
		this.profundidad = profundidad;
	}

	public Boolean getFormaIrregular() {
		return formaIrregular;
	}

	public void setFormaIrregular(Boolean formaIrregular) {
		this.formaIrregular = formaIrregular;
	}

	public Integer getAparcamientoLicencia() {
		return aparcamientoLicencia;
	}

	public void setAparcamientoLicencia(Integer aparcamientoLicencia) {
		this.aparcamientoLicencia = aparcamientoLicencia;
	}

	public Integer getAparcamientoSerbidumbre() {
		return aparcamientoSerbidumbre;
	}

	public void setAparcamientoSerbidumbre(Integer aparcamientoSerbidumbre) {
		this.aparcamientoSerbidumbre = aparcamientoSerbidumbre;
	}

	public Integer getAparcamientoMontacarga() {
		return aparcamientoMontacarga;
	}

	public void setAparcamientoMontacarga(Integer aparcamientoMontacarga) {
		this.aparcamientoMontacarga = aparcamientoMontacarga;
	}

	public Integer getAparcamientoColumnas() {
		return aparcamientoColumnas;
	}

	public void setAparcamientoColumnas(Integer aparcamientoColumnas) {
		this.aparcamientoColumnas = aparcamientoColumnas;
	}

	public Integer getAparcamientoSeguridad() {
		return aparcamientoSeguridad;
	}

	public void setAparcamientoSeguridad(Integer aparcamientoSeguridad) {
		this.aparcamientoSeguridad = aparcamientoSeguridad;
	}

	public DDSubtipoPlazaGaraje getSubtipoPlazagaraje() {
		return subtipoPlazagaraje;
	}

	public void setSubtipoPlazagaraje(DDSubtipoPlazaGaraje subtipoPlazagaraje) {
		this.subtipoPlazagaraje = subtipoPlazagaraje;
	}

	
	
}
