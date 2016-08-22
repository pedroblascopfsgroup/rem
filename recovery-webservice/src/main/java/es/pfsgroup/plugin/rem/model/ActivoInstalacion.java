package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;



/**
 * Modelo que gestiona la informacion de la calidad de las instalaciones de los activos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_INS_INSTALACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoInstalacion implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "INS_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoInstalacionGenerator")
    @SequenceGenerator(name = "ActivoInstalacionGenerator", sequenceName = "S_ACT_INS_INSTALACION")
    private Long id;
	
	@OneToOne
    @JoinColumn(name = "ICO_ID")
    private ActivoInfoComercial infoComercial;
	
	@Column(name = "INS_ELECTR")
    private Integer electricidad;   
	
	@Column(name = "INS_ELECTR_CON_CONTADOR")
	private Integer electricidadConContador;
	 
	@Column(name = "INS_ELECTR_BUEN_ESTADO")
	private Integer electricidadBuenEstado;
	
	@Column(name = "INS_ELECTR_DEFECTUOSA_ANTIGUA")
	private Integer electricidadDefectuosa;
	
	@Column(name = "INS_AGUA")
    private Integer agua;   
	
	@Column(name = "INS_AGUA_CON_CONTADOR")
	private Integer aguaConContador;
	 
	@Column(name = "INS_AGUA_BUEN_ESTADO")
	private Integer aguaBuenEstado;
	
	@Column(name = "INS_AGUA_DEFECTUOSA_ANTIGUA")
	private Integer aguaDefectuosa;
	
	@Column(name = "INS_AGUA_CALIENTE_CENTRAL")
    private Integer aguaCalienteCentral;   
	
	@Column(name = "INS_AGUA_CALIENTE_GAS_NATURAL")
	private Integer aguaCalienteGasNat;
	 
	@Column(name = "INS_GAS")
	private Integer gas;
	
	@Column(name = "INS_GAS_CON_CONTADOR")
	private Integer gasConContador;

	@Column(name = "INS_GAS_INST_BUEN_ESTADO")
	private Integer gasBuenEstado;

	@Column(name = "INS_GAS_DEFECTUOSA_ANTIGUA")
	private Integer gasDefectuosa;

	@Column(name = "INS_CALEF")
	private Integer calefaccion;

	@Column(name = "INS_CALEF_CENTRAL")
	private Integer calefaccionCentral;

	@Column(name = "INS_CALEF_GAS_NATURAL")
	private Integer calefaccionGasNat;

	@Column(name = "INS_CALEF_RADIADORES_ALU")
	private Integer calefaccionRadiadorAlu;

	@Column(name = "INS_CALEF_PREINSTALACION")
	private Integer calefaccionPreinstalacion;

	@Column(name = "INS_AIRE")
	private Integer aire;

	@Column(name = "INS_AIRE_PREINSTALACION")
	private Integer airePreinstalacion;

	@Column(name = "INS_AIRE_INSTALACION")
	private Integer aireInstalacion;

	@Column(name = "INS_AIRE_FRIO_CALOR")
	private Integer aireFrioCalor;
	
	@Column(name = "INS_INST_OTROS")
	private String instalacionOtros;

	
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

	public ActivoInfoComercial getInfoComercial() {
		return infoComercial;
	}

	public void setInfoComercial(ActivoInfoComercial infoComercial) {
		this.infoComercial = infoComercial;
	}

	public Integer getElectricidad() {
		return electricidad;
	}

	public void setElectricidad(Integer electricidad) {
		this.electricidad = electricidad;
	}

	public Integer getElectricidadConContador() {
		return electricidadConContador;
	}

	public void setElectricidadConContador(Integer electricidadConContador) {
		this.electricidadConContador = electricidadConContador;
	}

	public Integer getElectricidadBuenEstado() {
		return electricidadBuenEstado;
	}

	public void setElectricidadBuenEstado(Integer electricidadBuenEstado) {
		this.electricidadBuenEstado = electricidadBuenEstado;
	}

	public Integer getElectricidadDefectuosa() {
		return electricidadDefectuosa;
	}

	public void setElectricidadDefectuosa(Integer electricidadDefectuosa) {
		this.electricidadDefectuosa = electricidadDefectuosa;
	}

	public Integer getAgua() {
		return agua;
	}

	public void setAgua(Integer agua) {
		this.agua = agua;
	}

	public Integer getAguaConContador() {
		return aguaConContador;
	}

	public void setAguaConContador(Integer aguaConContador) {
		this.aguaConContador = aguaConContador;
	}

	public Integer getAguaBuenEstado() {
		return aguaBuenEstado;
	}

	public void setAguaBuenEstado(Integer aguaBuenEstado) {
		this.aguaBuenEstado = aguaBuenEstado;
	}

	public Integer getAguaDefectuosa() {
		return aguaDefectuosa;
	}

	public void setAguaDefectuosa(Integer aguaDefectuosa) {
		this.aguaDefectuosa = aguaDefectuosa;
	}

	public Integer getAguaCalienteCentral() {
		return aguaCalienteCentral;
	}

	public void setAguaCalienteCentral(Integer aguaCalienteCentral) {
		this.aguaCalienteCentral = aguaCalienteCentral;
	}

	public Integer getAguaCalienteGasNat() {
		return aguaCalienteGasNat;
	}

	public void setAguaCalienteGasNat(Integer aguaCalienteGasNat) {
		this.aguaCalienteGasNat = aguaCalienteGasNat;
	}

	public Integer getGas() {
		return gas;
	}

	public void setGas(Integer gas) {
		this.gas = gas;
	}

	public Integer getGasConContador() {
		return gasConContador;
	}

	public void setGasConContador(Integer gasConContador) {
		this.gasConContador = gasConContador;
	}

	public Integer getGasBuenEstado() {
		return gasBuenEstado;
	}

	public void setGasBuenEstado(Integer gasBuenEstado) {
		this.gasBuenEstado = gasBuenEstado;
	}

	public Integer getGasDefectuosa() {
		return gasDefectuosa;
	}

	public void setGasDefectuosa(Integer gasDefectuosa) {
		this.gasDefectuosa = gasDefectuosa;
	}

	public Integer getCalefaccion() {
		return calefaccion;
	}

	public void setCalefaccion(Integer calefaccion) {
		this.calefaccion = calefaccion;
	}

	public Integer getCalefaccionCentral() {
		return calefaccionCentral;
	}

	public void setCalefaccionCentral(Integer calefaccionCentral) {
		this.calefaccionCentral = calefaccionCentral;
	}

	public Integer getCalefaccionGasNat() {
		return calefaccionGasNat;
	}

	public void setCalefaccionGasNat(Integer calefaccionGasNat) {
		this.calefaccionGasNat = calefaccionGasNat;
	}

	public Integer getCalefaccionRadiadorAlu() {
		return calefaccionRadiadorAlu;
	}

	public void setCalefaccionRadiadorAlu(Integer calefaccionRadiadorAlu) {
		this.calefaccionRadiadorAlu = calefaccionRadiadorAlu;
	}

	public Integer getCalefaccionPreinstalacion() {
		return calefaccionPreinstalacion;
	}

	public void setCalefaccionPreinstalacion(Integer calefaccionPreinstalacion) {
		this.calefaccionPreinstalacion = calefaccionPreinstalacion;
	}

	public Integer getAire() {
		return aire;
	}

	public void setAire(Integer aire) {
		this.aire = aire;
	}

	public Integer getAirePreinstalacion() {
		return airePreinstalacion;
	}

	public void setAirePreinstalacion(Integer airePreinstalacion) {
		this.airePreinstalacion = airePreinstalacion;
	}

	public Integer getAireInstalacion() {
		return aireInstalacion;
	}

	public void setAireInstalacion(Integer aireInstalacion) {
		this.aireInstalacion = aireInstalacion;
	}

	public Integer getAireFrioCalor() {
		return aireFrioCalor;
	}

	public void setAireFrioCalor(Integer aireFrioCalor) {
		this.aireFrioCalor = aireFrioCalor;
	}

	public String getInstalacionOtros() {
		return instalacionOtros;
	}

	public void setInstalacionOtros(String instalacionOtros) {
		this.instalacionOtros = instalacionOtros;
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
