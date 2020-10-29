package es.pfsgroup.plugin.rem.model;

import java.math.BigDecimal;

import es.capgemini.devon.dto.WebDto;

public class DtoCalidadDatoPublicacionActivo extends WebDto{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	//FASE 0 A 2
	private String drIdufirFase1;
	private String dqIdufirFase1;
	private String correctoIdufirFase1;
	private String drFincaRegistralFase1;
	private String dqFincaRegistralFase1;
	private String correctoFincaRegistralFase1;
	private String drTomoFase1;
	private String dqTomoFase1;
	private String correctoTomoFase1;
	private String drLibroFase1;
	private String dqLibroFase1;
	private String correctoLibroFase1;
	private String drFolioFase1;
	private String dqFolioFase1;
	private String correctoFolioFase1;
	private String drUsoDominanteFase1;
	private String dqUsoDominanteFase1;
	private String correctoUsoDominanteFase1;
	private String drMunicipioDelRegistroFase1;
	private String dqMunicipioDelRegistroFase1;
	private String correctoMunicipioDelRegistroFase1;
	private String drProvinciaDelRegistroFase1;
	private String dqProvinciaDelRegistroFase1;
	private String correctoProvinciaDelRegistroFase1;
	private String drNumeroDelRegistroFase1;
	private String dqNumeroDelRegistroFase1;
	private String correctoNumeroDelRegistroFase1;
	private String drVpoFase1;
	private String dqVpoFase1;
	private String correctoVpoFase1;
	private String drAnyoConstruccionFase1;
	private String dqAnyoConstruccionFase1;
	private String correctoAnyoConstruccionFase1;
	private String drTipologianFase1;
	private String dqTipologiaFase1;
	private String correctoTipologiaFase1;
	private String drSubtipologianFase1;
	private String dqSubtipologiaFase1;
	private String correctoSubtipologiaFase1;
	private String drInformacionCargasFase1;
	private String dqInformacionCargasFase1;
	private String correctoInformacionCargasFase1;
	private String descripcionCargasInformacionCargasFase1;
	private String drInscripcionCorrectaFase1;
	private String dqInscripcionCorrectaFase1;
	private String correctoInscripcionCorrectaFase1;
	private String drPor100PropiedadFase1;
	private String dqPor100PropiedadFase1;
	private String correctoPor100PropiedadFase1;
	private Boolean desplegable0Collapsed;
	private Boolean desplegable1Collapsed;
	private Boolean desplegable2Collapsed;
	

	public Boolean getDesplegable0Collapsed() {
		return desplegable0Collapsed;
	}

	public void setDesplegable0Collapsed(Boolean desplegable0Collapsed) {
		this.desplegable0Collapsed = desplegable0Collapsed;
	}

	public Boolean getDesplegable1Collapsed() {
		return desplegable1Collapsed;
	}

	public void setDesplegable1Collapsed(Boolean desplegable1Collapsed) {
		this.desplegable1Collapsed = desplegable1Collapsed;
	}

	public Boolean getDesplegable2Collapsed() {
		return desplegable2Collapsed;
	}

	public void setDesplegable2Collapsed(Boolean desplegable2Collapsed) {
		this.desplegable2Collapsed = desplegable2Collapsed;
	}

	
	private String correctoDatosRegistralesFase1;
	
	public String getDrIdufirFase1() {
		return drIdufirFase1;
	}

	public void setDrIdufirFase1(String drIdufirFase1) {
		this.drIdufirFase1 = drIdufirFase1;
	}

	public String getDqIdufirFase1() {
		return dqIdufirFase1;
	}

	public void setDqIdufirFase1(String dqIdufirFase1) {
		this.dqIdufirFase1 = dqIdufirFase1;
	}

	public String getCorrectoIdufirFase1() {
		return correctoIdufirFase1;
	}

	public void setCorrectoIdufirFase1(String correctoIdufirFase1) {
		this.correctoIdufirFase1 = correctoIdufirFase1;
	}

	public String getDrFincaRegistralFase1() {
		return drFincaRegistralFase1;
	}

	public void setDrFincaRegistralFase1(String drFincaRegistralFase1) {
		this.drFincaRegistralFase1 = drFincaRegistralFase1;
	}

	public String getDqFincaRegistralFase1() {
		return dqFincaRegistralFase1;
	}

	public void setDqFincaRegistralFase1(String dqFincaRegistralFase1) {
		this.dqFincaRegistralFase1 = dqFincaRegistralFase1;
	}

	public String getCorrectoFincaRegistralFase1() {
		return correctoFincaRegistralFase1;
	}

	public void setCorrectoFincaRegistralFase1(String correctoFincaRegistralFase1) {
		this.correctoFincaRegistralFase1 = correctoFincaRegistralFase1;
	}

	public String getDrTomoFase1() {
		return drTomoFase1;
	}

	public void setDrTomoFase1(String drTomoFase1) {
		this.drTomoFase1 = drTomoFase1;
	}

	public String getDqTomoFase1() {
		return dqTomoFase1;
	}

	public void setDqTomoFase1(String dqTomoFase1) {
		this.dqTomoFase1 = dqTomoFase1;
	}

	public String getCorrectoTomoFase1() {
		return correctoTomoFase1;
	}

	public void setCorrectoTomoFase1(String correctoTomoFase1) {
		this.correctoTomoFase1 = correctoTomoFase1;
	}

	public String getDrLibroFase1() {
		return drLibroFase1;
	}

	public void setDrLibroFase1(String drLibroFase1) {
		this.drLibroFase1 = drLibroFase1;
	}

	public String getDqLibroFase1() {
		return dqLibroFase1;
	}

	public void setDqLibroFase1(String dqLibroFase1) {
		this.dqLibroFase1 = dqLibroFase1;
	}

	public String getCorrectoLibroFase1() {
		return correctoLibroFase1;
	}

	public void setCorrectoLibroFase1(String correctoLibroFase1) {
		this.correctoLibroFase1 = correctoLibroFase1;
	}

	public String getDrFolioFase1() {
		return drFolioFase1;
	}

	public void setDrFolioFase1(String drFolioFase1) {
		this.drFolioFase1 = drFolioFase1;
	}

	public String getDqFolioFase1() {
		return dqFolioFase1;
	}

	public void setDqFolioFase1(String dqFolioFase1) {
		this.dqFolioFase1 = dqFolioFase1;
	}

	public String getCorrectoFolioFase1() {
		return correctoFolioFase1;
	}

	public void setCorrectoFolioFase1(String correctoFolioFase1) {
		this.correctoFolioFase1 = correctoFolioFase1;
	}

	public String getDrUsoDominanteFase1() {
		return drUsoDominanteFase1;
	}

	public void setDrUsoDominanteFase1(String drUsoDominanteFase1) {
		this.drUsoDominanteFase1 = drUsoDominanteFase1;
	}

	public String getDqUsoDominanteFase1() {
		return dqUsoDominanteFase1;
	}

	public void setDqUsoDominanteFase1(String dqUsoDominanteFase1) {
		this.dqUsoDominanteFase1 = dqUsoDominanteFase1;
	}

	public String getCorrectoUsoDominanteFase1() {
		return correctoUsoDominanteFase1;
	}

	public void setCorrectoUsoDominanteFase1(String correctoUsoDominanteFase1) {
		this.correctoUsoDominanteFase1 = correctoUsoDominanteFase1;
	}

	public String getDrMunicipioDelRegistroFase1() {
		return drMunicipioDelRegistroFase1;
	}

	public void setDrMunicipioDelRegistroFase1(String drMunicipioDelRegistroFase1) {
		this.drMunicipioDelRegistroFase1 = drMunicipioDelRegistroFase1;
	}

	public String getDqMunicipioDelRegistroFase1() {
		return dqMunicipioDelRegistroFase1;
	}

	public void setDqMunicipioDelRegistroFase1(String dqMunicipioDelRegistroFase1) {
		this.dqMunicipioDelRegistroFase1 = dqMunicipioDelRegistroFase1;
	}

	public String getCorrectoMunicipioDelRegistroFase1() {
		return correctoMunicipioDelRegistroFase1;
	}

	public void setCorrectoMunicipioDelRegistroFase1(String correctoMunicipioDelRegistroFase1) {
		this.correctoMunicipioDelRegistroFase1 = correctoMunicipioDelRegistroFase1;
	}

	public String getDrProvinciaDelRegistroFase1() {
		return drProvinciaDelRegistroFase1;
	}

	public void setDrProvinciaDelRegistroFase1(String drProvinciaDelRegistroFase1) {
		this.drProvinciaDelRegistroFase1 = drProvinciaDelRegistroFase1;
	}

	public String getDqProvinciaDelRegistroFase1() {
		return dqProvinciaDelRegistroFase1;
	}

	public void setDqProvinciaDelRegistroFase1(String dqProvinciaDelRegistroFase1) {
		this.dqProvinciaDelRegistroFase1 = dqProvinciaDelRegistroFase1;
	}

	public String getCorrectoProvinciaDelRegistroFase1() {
		return correctoProvinciaDelRegistroFase1;
	}

	public void setCorrectoProvinciaDelRegistroFase1(String correctoProvinciaDelRegistroFase1) {
		this.correctoProvinciaDelRegistroFase1 = correctoProvinciaDelRegistroFase1;
	}

	public String getDrNumeroDelRegistroFase1() {
		return drNumeroDelRegistroFase1;
	}

	public void setDrNumeroDelRegistroFase1(String drNumeroDelRegistroFase1) {
		this.drNumeroDelRegistroFase1 = drNumeroDelRegistroFase1;
	}

	public String getDqNumeroDelRegistroFase1() {
		return dqNumeroDelRegistroFase1;
	}

	public void setDqNumeroDelRegistroFase1(String dqNumeroDelRegistroFase1) {
		this.dqNumeroDelRegistroFase1 = dqNumeroDelRegistroFase1;
	}

	public String getCorrectoNumeroDelRegistroFase1() {
		return correctoNumeroDelRegistroFase1;
	}

	public void setCorrectoNumeroDelRegistroFase1(String correctoNumeroDelRegistroFase1) {
		this.correctoNumeroDelRegistroFase1 = correctoNumeroDelRegistroFase1;
	}

	public String getDrVpoFase1() {
		return drVpoFase1;
	}

	public void setDrVpoFase1(String drVpoFase1) {
		this.drVpoFase1 = drVpoFase1;
	}

	public String getDqVpoFase1() {
		return dqVpoFase1;
	}

	public void setDqVpoFase1(String dqVpoFase1) {
		this.dqVpoFase1 = dqVpoFase1;
	}

	public String getCorrectoVpoFase1() {
		return correctoVpoFase1;
	}

	public void setCorrectoVpoFase1(String correctoVpoFase1) {
		this.correctoVpoFase1 = correctoVpoFase1;
	}

	public String getDrAnyoConstruccionFase1() {
		return drAnyoConstruccionFase1;
	}

	public void setDrAnyoConstruccionFase1(String drAnyoConstruccionFase1) {
		this.drAnyoConstruccionFase1 = drAnyoConstruccionFase1;
	}

	public String getDqAnyoConstruccionFase1() {
		return dqAnyoConstruccionFase1;
	}

	public void setDqAnyoConstruccionFase1(String dqAnyoConstruccionFase1) {
		this.dqAnyoConstruccionFase1 = dqAnyoConstruccionFase1;
	}

	public String getCorrectoAnyoConstruccionFase1() {
		return correctoAnyoConstruccionFase1;
	}

	public void setCorrectoAnyoConstruccionFase1(String correctoAnyoConstruccionFase1) {
		this.correctoAnyoConstruccionFase1 = correctoAnyoConstruccionFase1;
	}

	public String getDrTipologianFase1() {
		return drTipologianFase1;
	}

	public void setDrTipologianFase1(String drTipologianFase1) {
		this.drTipologianFase1 = drTipologianFase1;
	}

	public String getDqTipologiaFase1() {
		return dqTipologiaFase1;
	}

	public void setDqTipologiaFase1(String dqTipologiaFase1) {
		this.dqTipologiaFase1 = dqTipologiaFase1;
	}

	public String getCorrectoTipologiaFase1() {
		return correctoTipologiaFase1;
	}

	public void setCorrectoTipologiaFase1(String correctoTipologiaFase1) {
		this.correctoTipologiaFase1 = correctoTipologiaFase1;
	}

	public String getDrSubtipologianFase1() {
		return drSubtipologianFase1;
	}

	public void setDrSubtipologianFase1(String drSubtipologianFase1) {
		this.drSubtipologianFase1 = drSubtipologianFase1;
	}

	public String getDqSubtipologiaFase1() {
		return dqSubtipologiaFase1;
	}

	public void setDqSubtipologiaFase1(String dqSubtipologiaFase1) {
		this.dqSubtipologiaFase1 = dqSubtipologiaFase1;
	}

	public String getCorrectoSubtipologiaFase1() {
		return correctoSubtipologiaFase1;
	}

	public void setCorrectoSubtipologiaFase1(String correctoSubtipologiaFase1) {
		this.correctoSubtipologiaFase1 = correctoSubtipologiaFase1;
	}

	public String getDrInformacionCargasFase1() {
		return drInformacionCargasFase1;
	}

	public void setDrInformacionCargasFase1(String drInformacionCargasFase1) {
		this.drInformacionCargasFase1 = drInformacionCargasFase1;
	}

	public String getDqInformacionCargasFase1() {
		return dqInformacionCargasFase1;
	}

	public void setDqInformacionCargasFase1(String dqInformacionCargasFase1) {
		this.dqInformacionCargasFase1 = dqInformacionCargasFase1;
	}

	public String getCorrectoInformacionCargasFase1() {
		return correctoInformacionCargasFase1;
	}

	public void setCorrectoInformacionCargasFase1(String correctoInformacionCargasFase1) {
		this.correctoInformacionCargasFase1 = correctoInformacionCargasFase1;
	}

	public String getDescripcionCargasInformacionCargasFase1() {
		return descripcionCargasInformacionCargasFase1;
	}

	public void setDescripcionCargasInformacionCargasFase1(String descripcionCargasInformacionCargasFase1) {
		this.descripcionCargasInformacionCargasFase1 = descripcionCargasInformacionCargasFase1;
	}

	public String getDrInscripcionCorrectaFase1() {
		return drInscripcionCorrectaFase1;
	}

	public void setDrInscripcionCorrectaFase1(String drInscripcionCorrectaFase1) {
		this.drInscripcionCorrectaFase1 = drInscripcionCorrectaFase1;
	}

	public String getDqInscripcionCorrectaFase1() {
		return dqInscripcionCorrectaFase1;
	}

	public void setDqInscripcionCorrectaFase1(String dqInscripcionCorrectaFase1) {
		this.dqInscripcionCorrectaFase1 = dqInscripcionCorrectaFase1;
	}

	public String getCorrectoInscripcionCorrectaFase1() {
		return correctoInscripcionCorrectaFase1;
	}

	public void setCorrectoInscripcionCorrectaFase1(String correctoInscripcionCorrectaFase1) {
		this.correctoInscripcionCorrectaFase1 = correctoInscripcionCorrectaFase1;
	}

	public String getDrPor100PropiedadFase1() {
		return drPor100PropiedadFase1;
	}

	public void setDrPor100PropiedadFase1(String drPor100PropiedadFase1) {
		this.drPor100PropiedadFase1 = drPor100PropiedadFase1;
	}

	public String getDqPor100PropiedadFase1() {
		return dqPor100PropiedadFase1;
	}

	public void setDqPor100PropiedadFase1(String dqPor100PropiedadFase1) {
		this.dqPor100PropiedadFase1 = dqPor100PropiedadFase1;
	}

	public String getCorrectoPor100PropiedadFase1() {
		return correctoPor100PropiedadFase1;
	}

	public void setCorrectoPor100PropiedadFase1(String correctoPor100PropiedadFase1) {
		this.correctoPor100PropiedadFase1 = correctoPor100PropiedadFase1;
	}

		private String drF3ReferenciaCatastral;
	
		private String dqF3ReferenciaCatastral;
	
		private String correctoF3ReferenciaCatastral;
	
		private BigDecimal drF3SuperficieConstruida;
	
		private BigDecimal dqF3SuperficieConstruida;
	
		private String correctoF3SuperficieConstruida;
	
		private BigDecimal drF3SuperficieUtil;
	
		private BigDecimal dqF3SuperficieUtil;
		
		private String correctoF3SuperficieUtil;
	
		private Long drF3AnyoConstruccion;
	
		private Long dqF3AnyoConstruccion;
	
		private String correctoF3AnyoConstruccion;
	
		private String drF3TipoVia;
	
		private String dqF3TipoVia;
	
		private String correctoF3TipoVia;
	
		private String drF3NomCalle;
	
		private String dqF3NomCalle;
	
		private String correctoF3NomCalle;
	
		private String probabilidadCalleCorrecta;
	
		private String drF3CP;
	
		private String dqF3CP;
	
		private String correctoF3CP;
		
		private String drF3Municipio;
	
		private String dqF3Municipio;

		private String correctoF3Municipio;
	
		private String drF3Provincia;
	
		private String dqF3Provincia;
		
		private String correctoF3Provincia;
		
		private String correctoF3BloqueFase3;
	
	//Fotos
	
	private String numFotos;
	
	private String numFotosExterior;
	
	private String numFotosInterior;
	
	private String numFotosObra;
	
	private String numFotosMinimaResolucion;
	
	private String numFotosMinimaResolucionY;
	
	private String numFotosMinimaResolucionX;
	
	private String mensajeDQFotos;
	
	// Descripcion
	
	private String drFase4Descripcion;
	
	private String dqFase4Descripcion;
	
	// Localizacion
	
	private String drf4LocalizacionLatitud;
	
	private String dqF4Localizacionlatitud;
	
	private String drf4LocalizacionLongitud;
	
	private String dqf4LocalizacionLongitud;
	
	private String geodistanciaDQ;
	
	//CEE
	
	private String etiquetaCEERem;
	
	private String numEtiquetaA;
	
	private String numEtiquetaB;
	
	private String numEtiquetaC;
	
	private String numEtiquetaD;
	
	private String numEtiquetaE;
	
	private String numEtiquetaF;
	
	private String numEtiquetaG;
	
	private String mensajeDQCEE;
	
	public String getNumFotos() {
		return numFotos;
	}

	public void setNumFotos(String numFotos) {
		this.numFotos = numFotos;
	}

	public String getNumFotosExterior() {
		return numFotosExterior;
	}

	public void setNumFotosExterior(String numFotosExterior) {
		this.numFotosExterior = numFotosExterior;
	}

	public String getNumFotosInterior() {
		return numFotosInterior;
	}

	public void setNumFotosInterior(String numFotosInterior) {
		this.numFotosInterior = numFotosInterior;
	}

	public String getNumFotosObra() {
		return numFotosObra;
	}

	public void setNumFotosObra(String numFotosObra) {
		this.numFotosObra = numFotosObra;
	}

	public String getNumFotosMinimaResolucion() {
		return numFotosMinimaResolucion;
	}

	public void setNumFotosMinimaResolucion(String numFotosMinimaResolucion) {
		this.numFotosMinimaResolucion = numFotosMinimaResolucion;
	}

	public String getNumFotosMinimaResolucionY() {
		return numFotosMinimaResolucionY;
	}

	public void setNumFotosMinimaResolucionY(String numFotosMinimaResolucionY) {
		this.numFotosMinimaResolucionY = numFotosMinimaResolucionY;
	}

	public String getNumFotosMinimaResolucionX() {
		return numFotosMinimaResolucionX;
	}

	public void setNumFotosMinimaResolucionX(String numFotosMinimaResolucionX) {
		this.numFotosMinimaResolucionX = numFotosMinimaResolucionX;
	}

	public String getMensajeDQFotos() {
		return mensajeDQFotos;
	}

	public void setMensajeDQFotos(String mensajeDQFotos) {
		this.mensajeDQFotos = mensajeDQFotos;
	}


	public String getGeodistanciaDQ() {
		return geodistanciaDQ;
	}

	public void setGeodistanciaDQ(String geodistanciaDQ) {
		this.geodistanciaDQ = geodistanciaDQ;
	}

	public String getEtiquetaCEERem() {
		return etiquetaCEERem;
	}

	public void setEtiquetaCEERem(String etiquetaCEERem) {
		this.etiquetaCEERem = etiquetaCEERem;
	}

	public String getDrFase4Descripcion() {
		return drFase4Descripcion;
	}

	public void setDrFase4Descripcion(String drFase4Descripcion) {
		this.drFase4Descripcion = drFase4Descripcion;
	}

	public String getDqFase4Descripcion() {
		return dqFase4Descripcion;
	}

	public void setDqFase4Descripcion(String dqFase4Descripcion) {
		this.dqFase4Descripcion = dqFase4Descripcion;
	}

	public String getDrf4LocalizacionLatitud() {
		return drf4LocalizacionLatitud;
	}

	public void setDrf4LocalizacionLatitud(String drf4LocalizacionLatitud) {
		this.drf4LocalizacionLatitud = drf4LocalizacionLatitud;
	}

	public String getDqF4Localizacionlatitud() {
		return dqF4Localizacionlatitud;
	}

	public void setDqF4Localizacionlatitud(String dqF4Localizacionlatitud) {
		this.dqF4Localizacionlatitud = dqF4Localizacionlatitud;
	}

	public String getDrf4LocalizacionLongitud() {
		return drf4LocalizacionLongitud;
	}

	public void setDrf4LocalizacionLongitud(String drf4LocalizacionLongitud) {
		this.drf4LocalizacionLongitud = drf4LocalizacionLongitud;
	}

	public String getDqf4LocalizacionLongitud() {
		return dqf4LocalizacionLongitud;
	}

	public void setDqf4LocalizacionLongitud(String dqf4LocalizacionLongitud) {
		this.dqf4LocalizacionLongitud = dqf4LocalizacionLongitud;
	}

	public String getNumEtiquetaA() {
		return numEtiquetaA;
	}

	public void setNumEtiquetaA(String numEtiquetaA) {
		this.numEtiquetaA = numEtiquetaA;
	}

	public String getNumEtiquetaB() {
		return numEtiquetaB;
	}

	public void setNumEtiquetaB(String numEtiquetaB) {
		this.numEtiquetaB = numEtiquetaB;
	}

	public String getNumEtiquetaC() {
		return numEtiquetaC;
	}

	public void setNumEtiquetaC(String numEtiquetaC) {
		this.numEtiquetaC = numEtiquetaC;
	}

	public String getNumEtiquetaD() {
		return numEtiquetaD;
	}

	public void setNumEtiquetaD(String numEtiquetaD) {
		this.numEtiquetaD = numEtiquetaD;
	}

	public String getNumEtiquetaE() {
		return numEtiquetaE;
	}

	public void setNumEtiquetaE(String numEtiquetaE) {
		this.numEtiquetaE = numEtiquetaE;
	}

	public String getNumEtiquetaF() {
		return numEtiquetaF;
	}

	public void setNumEtiquetaF(String numEtiquetaF) {
		this.numEtiquetaF = numEtiquetaF;
	}

	public String getNumEtiquetaG() {
		return numEtiquetaG;
	}

	public void setNumEtiquetaG(String numEtiquetaG) {
		this.numEtiquetaG = numEtiquetaG;
	}

	public String getMensajeDQCEE() {
		return mensajeDQCEE;
	}

	public void setMensajeDQCEE(String mensajeDQCEE) {
		this.mensajeDQCEE = mensajeDQCEE;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getDrF3ReferenciaCatastral() {
		return drF3ReferenciaCatastral;
	}

	public void setDrF3ReferenciaCatastral(String drF3ReferenciaCatastral) {
		this.drF3ReferenciaCatastral = drF3ReferenciaCatastral;
	}

	public String getDqF3ReferenciaCatastral() {
		return dqF3ReferenciaCatastral;
	}

	public void setDqF3ReferenciaCatastral(String dqF3ReferenciaCatastral) {
		this.dqF3ReferenciaCatastral = dqF3ReferenciaCatastral;
	}

	public String getCorrectoF3ReferenciaCatastral() {
		return correctoF3ReferenciaCatastral;
	}

	public void setCorrectoF3ReferenciaCatastral(String correctoF3ReferenciaCatastral) {
		this.correctoF3ReferenciaCatastral = correctoF3ReferenciaCatastral;
	}

	public BigDecimal getDrF3SuperficieConstruida() {
		return drF3SuperficieConstruida;
	}

	public void setDrF3SuperficieConstruida(BigDecimal drF3SuperficieConstruida) {
		this.drF3SuperficieConstruida = drF3SuperficieConstruida;
	}

	public BigDecimal getDqF3SuperficieConstruida() {
		return dqF3SuperficieConstruida;
	}

	public void setDqF3SuperficieConstruida(BigDecimal dqF3SuperficieConstruida) {
		this.dqF3SuperficieConstruida = dqF3SuperficieConstruida;
	}

	public String getCorrectoF3SuperficieConstruida() {
		return correctoF3SuperficieConstruida;
	}

	public void setCorrectoF3SuperficieConstruida(String correctoF3SuperficieConstruida) {
		this.correctoF3SuperficieConstruida = correctoF3SuperficieConstruida;
	}

	public BigDecimal getDrF3SuperficieUtil() {
		return drF3SuperficieUtil;
	}

	public void setDrF3SuperficieUtil(BigDecimal drF3SuperficieUtil) {
		this.drF3SuperficieUtil = drF3SuperficieUtil;
	}

	public BigDecimal getDqF3SuperficieUtil() {
		return dqF3SuperficieUtil;
	}

	public void setDqF3SuperficieUtil(BigDecimal dqF3SuperficieUtil) {
		this.dqF3SuperficieUtil = dqF3SuperficieUtil;
	}

	public Long getDrF3AnyoConstruccion() {
		return drF3AnyoConstruccion;
	}

	public void setDrF3AnyoConstruccion(Long drF3AnyoConstruccion) {
		this.drF3AnyoConstruccion = drF3AnyoConstruccion;
	}

	public Long getDqF3AnyoConstruccion() {
		return dqF3AnyoConstruccion;
	}

	public void setDqF3AnyoConstruccion(Long dqF3AnyoConstruccion) {
		this.dqF3AnyoConstruccion = dqF3AnyoConstruccion;
	}

	public String getDrF3TipoVia() {
		return drF3TipoVia;
	}

	public void setDrF3TipoVia(String drF3TipoVia) {
		this.drF3TipoVia = drF3TipoVia;
	}

	public String getDqF3TipoVia() {
		return dqF3TipoVia;
	}

	public void setDqF3TipoVia(String dqF3TipoVia) {
		this.dqF3TipoVia = dqF3TipoVia;
	}

	public String getDrF3NomCalle() {
		return drF3NomCalle;
	}

	public void setDrF3NomCalle(String drF3NomCalle) {
		this.drF3NomCalle = drF3NomCalle;
	}

	public String getDqF3NomCalle() {
		return dqF3NomCalle;
	}

	public void setDqF3NomCalle(String dqF3NomCalle) {
		this.dqF3NomCalle = dqF3NomCalle;
	}

	public String getProbabilidadCalleCorrecta() {
		return probabilidadCalleCorrecta;
	}

	public void setProbabilidadCalleCorrecta(String probabilidadCalleCorrecta) {
		this.probabilidadCalleCorrecta = probabilidadCalleCorrecta;
	}

	public String getDrF3CP() {
		return drF3CP;
	}

	public void setDrF3CP(String drF3CP) {
		this.drF3CP = drF3CP;
	}

	public String getDqF3CP() {
		return dqF3CP;
	}

	public void setDqF3CP(String dqF3CP) {
		this.dqF3CP = dqF3CP;
	}

	public String getDrF3Municipio() {
		return drF3Municipio;
	}

	public void setDrF3Municipio(String drF3Municipio) {
		this.drF3Municipio = drF3Municipio;
	}

	public String getDqF3Municipio() {
		return dqF3Municipio;
	}

	public void setDqF3Municipio(String dqF3Municipio) {
		this.dqF3Municipio = dqF3Municipio;
	}

	public String getDrF3Provincia() {
		return drF3Provincia;
	}

	public void setDrF3Provincia(String drF3Provincia) {
		this.drF3Provincia = drF3Provincia;
	}

	public String getDqF3Provincia() {
		return dqF3Provincia;
	}

	public void setDqF3Provincia(String dqF3Provincia) {
		this.dqF3Provincia = dqF3Provincia;
	}

	public String getCorrectoF3SuperficieUtil() {
		return correctoF3SuperficieUtil;
	}

	public void setCorrectoF3SuperficieUtil(String correctoF3SuperficieUtil) {
		this.correctoF3SuperficieUtil = correctoF3SuperficieUtil;
	}

	public String getCorrectoF3AnyoConstruccion() {
		return correctoF3AnyoConstruccion;
	}

	public void setCorrectoF3AnyoConstruccion(String correctoF3AnyoConstruccion) {
		this.correctoF3AnyoConstruccion = correctoF3AnyoConstruccion;
	}

	public String getCorrectoF3TipoVia() {
		return correctoF3TipoVia;
	}

	public void setCorrectoF3TipoVia(String correctoF3TipoVia) {
		this.correctoF3TipoVia = correctoF3TipoVia;
	}

	public String getCorrectoF3NomCalle() {
		return correctoF3NomCalle;
	}

	public void setCorrectoF3NomCalle(String correctoF3NomCalle) {
		this.correctoF3NomCalle = correctoF3NomCalle;
	}

	public String getCorrectoF3CP() {
		return correctoF3CP;
	}

	public void setCorrectoF3CP(String correctoF3CP) {
		this.correctoF3CP = correctoF3CP;
	}

	public String getCorrectoF3Municipio() {
		return correctoF3Municipio;
	}

	public void setCorrectoF3Municipio(String correctoF3Municipio) {
		this.correctoF3Municipio = correctoF3Municipio;
	}

	public String getCorrectoF3Provincia() {
		return correctoF3Provincia;
	}

	public void setCorrectoF3Provincia(String correctoF3Provincia) {
		this.correctoF3Provincia = correctoF3Provincia;
	}

	public String getCorrectoF3BloqueFase3() {
		return correctoF3BloqueFase3;
	}

	public void setCorrectoF3BloqueFase3(String correctoF3BloqueFase3) {
		this.correctoF3BloqueFase3 = correctoF3BloqueFase3;
	}
	
	public String getCorrectoDatosRegistralesFase1() {
		return correctoDatosRegistralesFase1;
	}

	public void setCorrectoDatosRegistralesFase1(String correctoDatosRegistralesFase1) {
		this.correctoDatosRegistralesFase1 = correctoDatosRegistralesFase1;
	}
	
}
