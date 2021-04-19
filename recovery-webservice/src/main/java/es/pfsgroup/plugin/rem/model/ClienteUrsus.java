package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosCiviles;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosPbc;
import es.pfsgroup.plugin.rem.model.dd.DDPaises;
import es.pfsgroup.plugin.rem.model.dd.DDRegimenesMatrimoniales;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGradoPropiedad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoInquilino;
import es.pfsgroup.plugin.rem.model.dd.DDUsosActivo;


/**
 * Modelo que gestiona la informacion de un cliente Ursus
 *  
 * @author Guillem Rey
 *
 */
@Entity
@Table(name = "CLU_CLIENTE_URSUS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Inheritance(strategy=InheritanceType.JOINED)
public class ClienteUrsus implements Serializable, Auditable {
		
    /**
	 * 
	 */
	private static final long serialVersionUID = -1900278147793511971L;

	@Id
	@Column(name = "CLU_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ClienteUrsusGenerator")
    @SequenceGenerator(name = "ClienteUrsusGenerator", sequenceName = "S_CLU_CLIENTE_URSUS")
	private Long id;

	@Column(name = "CLU_CLASE_DOC_IDENTIFICADOR", nullable = false)
	private String ClaseDeDocumentoIdentificador;
	
	@Column(name = "CLU_DOCUMENTO_CLIENTE", nullable = false)
	private String DniNifDelTitularDeLaOferta;
	
	@Column(name = "CLU_NUMERO_CLIENTE_URSUS")
	private String numeroClienteUrsus;
	
	@Column(name = "CLU_NUMERO_CLIENTE_URSUS_BH")
	private String numeroClienteUrsusBh;
	
	@Column(name = "CLU_NOMBRE_APELLIDOS_TITULAR")
	private String NombreYApellidosTitularDeOferta;
	
	@Column(name = "CLU_NOMBRE_CLIENTE")
	private String NombreDelCliente;
	
	@Column(name = "CLU_APELLIDO1_CLIENTE")
	private String PrimerApellido;
	
	@Column(name = "CLU_APELLIDO2_CLIENTE")
	private String SegundoApellido;
	
	@Column(name = "CLU_CODIGO_TIPO_VIA")
	private String CodigoTipoDeVia;
	
	@Column(name = "CLU_TIPO_VIA_TRABAJO")
	private String DenominacionTipoDeViaTrabajo;
	
	@Column(name = "CLU_NOMBRE_VIA")
	private String NombreDeLaVia;
	
	@Column(name = "CLU_PORTAL")
	private String PORTAL;
	
	@Column(name = "CLU_ESCALERA")
	private String ESCALERA;
	
	@Column(name = "CLU_PISO")
	private String PISO;
	
	@Column(name = "CLU_NUM_PUERTA")
	private String NumeroDePuerta;
	
	@Column(name = "CLU_CODIGO_POSTAL")
	private String CodigoPostal;
	
	@Column(name = "CLU_NOMBRE_MUNICIPIO")
	private String NombreDelMunicipio;
	
	@Column(name = "CLU_NOMBRE_PROVINCIA")
	private String NombreDeLaProvincia;
	
	@Column(name = "CLU_CODIGO_PROVINCIA")
	private String CodigoDeProvincia;
	
	@Column(name = "CLU_NOMBRE_PAIS")
	private String NombreDePaisDelDomicilio;
	
	@Column(name = "CLU_DATOS_COMPL_DOMICILIO")
	private String DatosComplementariosDelDomicilio;
	
	@Column(name = "CLU_NOMBRE_BARRIO")
	private String BarrioColoniaOApartado;
	
	@Column(name = "CLU_EDAD")
	private String EdadDelCliente;
	
	@Column(name = "CLU_CODIGO_ESTADO_CIVIL")
	private char CodigoEstadoCivil;
	
	@Column(name = "CLU_ESTADO_CIVIL_ACTUAL")
	private String EstadoCivilActual;
	
	@Column(name = "CLU_NUMERO_HIJOS")
	private String NumeroDeHijos;
	
	@Column(name = "CLU_SEXO")
	private String SEXO;
	
	@Column(name = "CLU_NOMBRE_EMPRESA")
	private String NombreComercialDeLaEmpresa;
	
	@Column(name = "CLU_DELEGACION")
	private String DELEGACION;
	
	@Column(name = "CLU_TIPO_SOCIEDAD")
	private String TipoDeSociedad;
	
	@Column(name = "CLU_CODIGO_SITUACION_CLIENTE")
	private String CodigoDeSituacionDelCliente;
	
	@Column(name = "CLU_NOMBRE_SITUACION_CLIENTE")
	private String NombreDeLaSituacionDelCliente;
	
	@Column(name = "CLU_FECHA_NACIMIENTO")
	private String FechaDeNacimientoOConstitucion;
	
	@Column(name = "CLU_NOMBRE_PAIS_NACIMIENTO")
	private String NombreDelPaisDeNacimiento;
	
	@Column(name = "CLU_NOMBRE_PROVINCIA_NACIMIENTO")
	private String NombreDeLaProvinciaNacimiento;
	
	@Column(name = "CLU_NOMBRE_POBLACION_NACIMIENTO")
	private String NombreDePoblacionDeNacimiento;
	
	@Column(name = "CLU_NOMBRE_PAIS_NACIONALIDAD")
	private String NombreDePaisNacionalidad;
	
	@Column(name = "CLU_NOMBRE_PAIS_RESIDENCIA")
	private String NombreDePaisResidencia;
	
	@Column(name = "CLU_SUBSECTOR_ACTIVIDAD_ECONOMICA")
	private String SubsectorDeActividadEconomica;
	
	@Column(name = "CLU_HAY_OCURRENCIAS")
	private Boolean hayOcurrencias;
	
	@Column(name = "CLU_NUM_CLIENTE_URSUS_CONYUGE")
	private String numeroClienteUrsusConyuge;
	
	@Column(name = "CLU_NOMBRE_APELLIDOS_CONYUGE")
	private String nombreYApellidosConyuge;
	
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

	public String getClaseDeDocumentoIdentificador() {
		return ClaseDeDocumentoIdentificador;
	}

	public void setClaseDeDocumentoIdentificador(String claseDeDocumentoIdentificador) {
		ClaseDeDocumentoIdentificador = claseDeDocumentoIdentificador;
	}

	public String getDniNifDelTitularDeLaOferta() {
		return DniNifDelTitularDeLaOferta;
	}

	public void setDniNifDelTitularDeLaOferta(String dniNifDelTitularDeLaOferta) {
		DniNifDelTitularDeLaOferta = dniNifDelTitularDeLaOferta;
	}

	public String getNumeroClienteUrsus() {
		return numeroClienteUrsus;
	}

	public void setNumeroClienteUrsus(String numeroClienteUrsus) {
		this.numeroClienteUrsus = numeroClienteUrsus;
	}

	public String getNumeroClienteUrsusBh() {
		return numeroClienteUrsusBh;
	}

	public void setNumeroClienteUrsusBh(String numeroClienteUrsusBh) {
		this.numeroClienteUrsusBh = numeroClienteUrsusBh;
	}
	
	public String getNombreYApellidosTitularDeOferta() {
		return NombreYApellidosTitularDeOferta;
	}

	public void setNombreYApellidosTitularDeOferta(String nombreYApellidosTitularDeOferta) {
		NombreYApellidosTitularDeOferta = nombreYApellidosTitularDeOferta;
	}

	public String getNombreDelCliente() {
		return NombreDelCliente;
	}

	public void setNombreDelCliente(String nombreDelCliente) {
		NombreDelCliente = nombreDelCliente;
	}

	public String getPrimerApellido() {
		return PrimerApellido;
	}

	public void setPrimerApellido(String primerApellido) {
		PrimerApellido = primerApellido;
	}

	public String getSegundoApellido() {
		return SegundoApellido;
	}

	public void setSegundoApellido(String segundoApellido) {
		SegundoApellido = segundoApellido;
	}

	public String getCodigoTipoDeVia() {
		return CodigoTipoDeVia;
	}

	public void setCodigoTipoDeVia(String codigoTipoDeVia) {
		CodigoTipoDeVia = codigoTipoDeVia;
	}

	public String getDenominacionTipoDeViaTrabajo() {
		return DenominacionTipoDeViaTrabajo;
	}

	public void setDenominacionTipoDeViaTrabajo(String denominacionTipoDeViaTrabajo) {
		DenominacionTipoDeViaTrabajo = denominacionTipoDeViaTrabajo;
	}

	public String getNombreDeLaVia() {
		return NombreDeLaVia;
	}

	public void setNombreDeLaVia(String nombreDeLaVia) {
		NombreDeLaVia = nombreDeLaVia;
	}

	public String getPORTAL() {
		return PORTAL;
	}

	public void setPORTAL(String pORTAL) {
		PORTAL = pORTAL;
	}

	public String getESCALERA() {
		return ESCALERA;
	}

	public void setESCALERA(String eSCALERA) {
		ESCALERA = eSCALERA;
	}

	public String getPISO() {
		return PISO;
	}

	public void setPISO(String pISO) {
		PISO = pISO;
	}

	public String getNumeroDePuerta() {
		return NumeroDePuerta;
	}

	public void setNumeroDePuerta(String numeroDePuerta) {
		NumeroDePuerta = numeroDePuerta;
	}

	public String getCodigoPostal() {
		return CodigoPostal;
	}

	public void setCodigoPostal(String codigoPostal) {
		CodigoPostal = codigoPostal;
	}

	public String getNombreDelMunicipio() {
		return NombreDelMunicipio;
	}

	public void setNombreDelMunicipio(String nombreDelMunicipio) {
		NombreDelMunicipio = nombreDelMunicipio;
	}

	public String getNombreDeLaProvincia() {
		return NombreDeLaProvincia;
	}

	public void setNombreDeLaProvincia(String nombreDeLaProvincia) {
		NombreDeLaProvincia = nombreDeLaProvincia;
	}

	public String getCodigoDeProvincia() {
		return CodigoDeProvincia;
	}

	public void setCodigoDeProvincia(String codigoDeProvincia) {
		CodigoDeProvincia = codigoDeProvincia;
	}

	public String getNombreDePaisDelDomicilio() {
		return NombreDePaisDelDomicilio;
	}

	public void setNombreDePaisDelDomicilio(String nombreDePaisDelDomicilio) {
		NombreDePaisDelDomicilio = nombreDePaisDelDomicilio;
	}

	public String getDatosComplementariosDelDomicilio() {
		return DatosComplementariosDelDomicilio;
	}

	public void setDatosComplementariosDelDomicilio(String datosComplementariosDelDomicilio) {
		DatosComplementariosDelDomicilio = datosComplementariosDelDomicilio;
	}

	public String getBarrioColoniaOApartado() {
		return BarrioColoniaOApartado;
	}

	public void setBarrioColoniaOApartado(String barrioColoniaOApartado) {
		BarrioColoniaOApartado = barrioColoniaOApartado;
	}

	public String getEdadDelCliente() {
		return EdadDelCliente;
	}

	public void setEdadDelCliente(String edadDelCliente) {
		EdadDelCliente = edadDelCliente;
	}

	public char getCodigoEstadoCivil() {
		return CodigoEstadoCivil;
	}

	public void setCodigoEstadoCivil(char codigoEstadoCivil) {
		CodigoEstadoCivil = codigoEstadoCivil;
	}

	public String getEstadoCivilActual() {
		return EstadoCivilActual;
	}

	public void setEstadoCivilActual(String estadoCivilActual) {
		EstadoCivilActual = estadoCivilActual;
	}

	public String getNumeroDeHijos() {
		return NumeroDeHijos;
	}

	public void setNumeroDeHijos(String numeroDeHijos) {
		NumeroDeHijos = numeroDeHijos;
	}

	public String getSEXO() {
		return SEXO;
	}

	public void setSEXO(String sEXO) {
		SEXO = sEXO;
	}

	public String getNombreComercialDeLaEmpresa() {
		return NombreComercialDeLaEmpresa;
	}

	public void setNombreComercialDeLaEmpresa(String nombreComercialDeLaEmpresa) {
		NombreComercialDeLaEmpresa = nombreComercialDeLaEmpresa;
	}

	public String getDELEGACION() {
		return DELEGACION;
	}

	public void setDELEGACION(String dELEGACION) {
		DELEGACION = dELEGACION;
	}

	public String getTipoDeSociedad() {
		return TipoDeSociedad;
	}

	public void setTipoDeSociedad(String tipoDeSociedad) {
		TipoDeSociedad = tipoDeSociedad;
	}

	public String getCodigoDeSituacionDelCliente() {
		return CodigoDeSituacionDelCliente;
	}

	public void setCodigoDeSituacionDelCliente(String codigoDeSituacionDelCliente) {
		CodigoDeSituacionDelCliente = codigoDeSituacionDelCliente;
	}

	public String getNombreDeLaSituacionDelCliente() {
		return NombreDeLaSituacionDelCliente;
	}

	public void setNombreDeLaSituacionDelCliente(String nombreDeLaSituacionDelCliente) {
		NombreDeLaSituacionDelCliente = nombreDeLaSituacionDelCliente;
	}

	public String getFechaDeNacimientoOConstitucion() {
		return FechaDeNacimientoOConstitucion;
	}

	public void setFechaDeNacimientoOConstitucion(String fechaDeNacimientoOConstitucion) {
		FechaDeNacimientoOConstitucion = fechaDeNacimientoOConstitucion;
	}

	public String getNombreDelPaisDeNacimiento() {
		return NombreDelPaisDeNacimiento;
	}

	public void setNombreDelPaisDeNacimiento(String nombreDelPaisDeNacimiento) {
		NombreDelPaisDeNacimiento = nombreDelPaisDeNacimiento;
	}

	public String getNombreDeLaProvinciaNacimiento() {
		return NombreDeLaProvinciaNacimiento;
	}

	public void setNombreDeLaProvinciaNacimiento(String nombreDeLaProvinciaNacimiento) {
		NombreDeLaProvinciaNacimiento = nombreDeLaProvinciaNacimiento;
	}

	public String getNombreDePoblacionDeNacimiento() {
		return NombreDePoblacionDeNacimiento;
	}

	public void setNombreDePoblacionDeNacimiento(String nombreDePoblacionDeNacimiento) {
		NombreDePoblacionDeNacimiento = nombreDePoblacionDeNacimiento;
	}

	public String getNombreDePaisNacionalidad() {
		return NombreDePaisNacionalidad;
	}

	public void setNombreDePaisNacionalidad(String nombreDePaisNacionalidad) {
		NombreDePaisNacionalidad = nombreDePaisNacionalidad;
	}

	public String getNombreDePaisResidencia() {
		return NombreDePaisResidencia;
	}

	public void setNombreDePaisResidencia(String nombreDePaisResidencia) {
		NombreDePaisResidencia = nombreDePaisResidencia;
	}

	public String getSubsectorDeActividadEconomica() {
		return SubsectorDeActividadEconomica;
	}

	public void setSubsectorDeActividadEconomica(String subsectorDeActividadEconomica) {
		SubsectorDeActividadEconomica = subsectorDeActividadEconomica;
	}

	public Boolean getHayOcurrencias() {
		return hayOcurrencias;
	}

	public void setHayOcurrencias(Boolean hayOcurrencias) {
		this.hayOcurrencias = hayOcurrencias;
	}

	public String getNumeroClienteUrsusConyuge() {
		return numeroClienteUrsusConyuge;
	}

	public void setNumeroClienteUrsusConyuge(String numeroClienteUrsusConyuge) {
		this.numeroClienteUrsusConyuge = numeroClienteUrsusConyuge;
	}

	public String getNombreYApellidosConyuge() {
		return nombreYApellidosConyuge;
	}

	public void setNombreYApellidosConyuge(String nombreYApellidosConyuge) {
		this.nombreYApellidosConyuge = nombreYApellidosConyuge;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	@Override
	public Auditoria getAuditoria() {
		return this.auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
		
	}

}
