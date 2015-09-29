package es.capgemini.pfs.contrato.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "CNT_CONTRATOS_FORMULAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class ContratoFormulas {

	@Id
	@Column(name = "CNT_ID")
	private Long id;
	
	@Column(name ="TITULIZADO")
	private String titulizado;
	
	@Column(name ="FONDO")
	private String fondo;
	
	@Column(name ="NUMEXTRA1")
	private String numExtra1;
	
	@Column(name ="NUMEXTRA2")
	private String numExtra2;
	
	@Column(name ="NUMEXTRA3")
	private String numExtra3;
	
	@Column(name = "DATEEXTRA1")
	private String dateExtra1; 
	
	@Column(name ="CHAREXTRA1")
	private String charExtra1;
	
	@Column(name ="CHAREXTRA2")
	private String charExtra2;
	
	@Column(name ="CHAREXTRA3")
	private String charExtra3;
	
	@Column(name ="CHAREXTRA4")
	private String charExtra4;
	
	@Column(name ="CHAREXTRA5")
	private String charExtra5;
	
	@Column(name ="CHAREXTRA6")
	private String charExtra6;
	
	@Column(name ="CHAREXTRA7")
	private String charExtra7;
	
	@Column (name = "CHAREXTRA8")
	private String charExtra8;
	
	@Column(name ="FLAGEXTRA1")
	private String flagExtra1;
	
	@Column(name ="FLAGEXTRA2")
	private String flagExtra2;
	
	@Column(name ="FLAGEXTRA3")
	private String flagExtra3;
	
	@Column(name ="MARCAOPERACION")
	private String marcaOperacion;
	
	
	@Column(name ="MOTIVOMARCA")
	private String motivoMarca;
	
	@Column(name ="INDICADORNOMINAPENSION")
	private String indicadorNominaPension;
	
	@Column(name="NUEVOCODIGOOFICINA")
	private String nuevoCodigoOficina;
	
	@Column(name ="ENTIDADORIGEN")
	private String entidadOrigen;
		
	@Column(name ="CONTRATOORIGEN")
	private String contratoOrigen;
	
	@Column(name ="TIPOPRODUCTOORIGEN")
	private String tipoProductoOrigen;
	
	@Column(name ="CONTRATOPRINCIPAL")
	private String contratoPrincipal;
	
	@Column(name ="ESTADOLITIGIO")
	private String estadoLitigio;
	
	@Column(name="FASERECUPERACION")
	private String faseRecuperacion;
	
	@Column(name ="GASTOS")
	private String gastos;
	
	@Column(name ="PROVISIONPROCURADOR")
	private String provisionProcurador;
	
	@Column(name ="INTERESESDEMORA")
	private String interesesDemora;
		
	@Column(name ="MINUTALETRADO")
	private String minutaLetrado;
	
	@Column(name ="ENTREGAS")
	private String entregas;
	
	@Column(name ="ESTADOCONTRATOENTIDAD")
	private String estadoContratoEntidad;
	
	@Column(name="CREDITOR")
	private String creditor;
	
	@Column(name ="CODENTIDADPROPIETARIA")
	private String codEntidadPropietaria;
	
	@Column(name ="CONDICIONESESPECIALES")
	private String condicionesEspeciales;
	
	@Column(name ="SEGMENTOCARTERA")
	private String segmentoCartera;

	public Long getId() {
		return id;
	}

	public String getTitulizado() {
		return titulizado;
	}

	public String getFondo() {
		return fondo;
	}

	public String getNumExtra1() {
		return numExtra1;
	}

	public String getNumExtra2() {
		return numExtra2;
	}

	public String getNumExtra3() {
		return numExtra3;
	}

	public String getDateExtra1() {
		return dateExtra1;
	}

	public String getCharExtra1() {
		return charExtra1;
	}

	public String getCharExtra2() {
		return charExtra2;
	}

	public String getCharExtra3() {
		return charExtra3;
	}

	public String getCharExtra4() {
		return charExtra4;
	}

	public String getCharExtra5() {
		return charExtra5;
	}

	public String getCharExtra6() {
		return charExtra6;
	}

	public String getCharExtra7() {
		return charExtra7;
	}

	public String getCharExtra8() {
		return charExtra8;
	}

	public String getFlagExtra1() {
		return flagExtra1;
	}

	public String getFlagExtra2() {
		return flagExtra2;
	}

	public String getFlagExtra3() {
		return flagExtra3;
	}

	public String getMarcaOperacion() {
		return marcaOperacion;
	}

	public String getMotivoMarca() {
		return motivoMarca;
	}

	public String getIndicadorNominaPension() {
		return indicadorNominaPension;
	}

	public String getNuevoCodigoOficina() {
		return nuevoCodigoOficina;
	}

	public String getEntidadOrigen() {
		return entidadOrigen;
	}

	public String getContratoOrigen() {
		return contratoOrigen;
	}

	public String getTipoProductoOrigen() {
		return tipoProductoOrigen;
	}

	public String getContratoPrincipal() {
		return contratoPrincipal;
	}

	public String getEstadoLitigio() {
		return estadoLitigio;
	}

	public String getFaseRecuperacion() {
		return faseRecuperacion;
	}

	public String getGastos() {
		return gastos;
	}

	public String getProvisionProcurador() {
		return provisionProcurador;
	}

	public String getInteresesDemora() {
		return interesesDemora;
	}

	public String getMinutaLetrado() {
		return minutaLetrado;
	}

	public String getEntregas() {
		return entregas;
	}

	public String getEstadoContratoEntidad() {
		return estadoContratoEntidad;
	}

	public String getCreditor() {
		return creditor;
	}

	public String getCodEntidadPropietaria() {
		return codEntidadPropietaria;
	}

	public String getCondicionesEspeciales() {
		return condicionesEspeciales;
	}

	public String getSegmentoCartera() {
		return segmentoCartera;
	}
	

}
