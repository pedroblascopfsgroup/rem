package es.pfsgroup.plugin.rem.activo.catastro;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.CatastroApi;
import es.pfsgroup.plugin.rem.controller.CatastroController;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoCatastro;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;
import es.pfsgroup.plugin.rem.model.ActivoLocalizacion;
import es.pfsgroup.plugin.rem.model.Catastro;
import es.pfsgroup.plugin.rem.model.DtoActivoCatastro;
import es.pfsgroup.plugin.rem.model.DtoDatosCatastro;
import es.pfsgroup.plugin.rem.model.DtoDatosCatastroGrid;

@Service("catastroManager")
public class CatastroManager implements CatastroApi {
	
    @Autowired
	private ActivoDao activoDao;
    
    @Autowired
	private GenericABMDao genericDao;
    
    
    protected static final Log logger = LogFactory.getLog(CatastroController.class);
    
	private static final String PROB_MUY_BAJA = "Muy baja";
	private static final String PROB_BAJA = "Baja";
	private static final String PROB_MEDIA = "Media";
	private static final String PROB_ALTA = "Alta";
	private static final String PROB_MUY_ALTA = "Muy alta";
	
	private static final String SUPERFICIE_CONSTRUIDA= "Superficie construida";
	private static final String SUPERFICIE_PARCELA= "Superficie Parcela";
	private static final String GEODISTANCIA= "Geodistancia";
	private static final String ANYO_CONSTRUCCION= "Año construcción";
	private static final String TIPO_VIA= "Tipo vía";
	private static final String CODIGO_POSTAL= "Código postal";
	private static final String MUNICIPIO= "Municipio";
	private static final String PROVINCIA= "Provincia";
	private static final String NOMBRE_CALLE= "Nombre calle";
	private static final String LATITUD= "Latitud";
	private static final String LONGITUD= "Longitud";
    
	public DtoDatosCatastro getDatosCatastroRem(Long idActivo) {
		DtoDatosCatastro dto = new DtoDatosCatastro();
		Activo activo = activoDao.getActivoById(idActivo);
	
		if(activo != null) {
			ActivoInfoRegistral infoR = activo.getInfoRegistral();
			ActivoInfoComercial infoC = activo.getInfoComercial();
				
			dto.setIdActivo(idActivo);
			dto.setDireccion(activo.getDireccionCompleta());
			dto.setSuperficieConstruida((double)activo.getTotalSuperficieConstruida());			
			//dto.setSuperficieReperComun(superficieReperComun); ¿De donde sale esto?
			dto.setCodigoPostal(activo.getCodPostal());
			dto.setNombreVia(activo.getNombreVia());
			dto.setNumeroVia(activo.getNumeroDomicilio());
			dto.setTipoVia(activo.getTipoVia().getDescripcion());
			dto.setProvincia(activo.getProvinciaDescripcion());
			dto.setMunicipio(activo.getMunicipioDescripcion());
			dto.setPuerta(activo.getPuerta());
			dto.setPlanta(activo.getPiso());
			dto.setDomicilio(activo.getNumeroDomicilio());
			
			if(infoR != null && infoR.getSuperficieParcela() != null) {
				dto.setSuperficieParcela((double) infoR.getSuperficieParcela());
			}
			if(infoC != null) {
				dto.setAnyoConstruccion(infoC.getAnyoConstruccion());
			}
			
			ActivoLocalizacion activoLocalizacion = activo.getLocalizacion();
			if(activoLocalizacion != null) {
				NMBLocalizacionesBien localizacionesBien = activo.getLocalizacion().getLocalizacionBien();
				dto.setLatitud(activoLocalizacion.getLatitud());
				dto.setLongitud(activoLocalizacion.getLongitud());
				if(localizacionesBien != null) {
					if(localizacionesBien.getLocalidad() != null) {
						dto.setMunicipioCod(localizacionesBien.getLocalidad().getCodigo());
						dto.setMunicipio(localizacionesBien.getLocalidad().getDescripcion());
					}
					if(localizacionesBien.getProvincia() != null) {
						dto.setProvinciaCod(localizacionesBien.getProvincia().getCodigo());
						dto.setProvincia(localizacionesBien.getProvincia().getDescripcion());
					}
				}
				if(activo.getTipoVia() != null) {
					dto.setTipoViaCod(activo.getTipoVia().getCodigo());
					dto.setTipoVia(activo.getTipoVia().getDescripcion());
				}
			}
		}
		return dto;
	}
	
	public List<DtoDatosCatastro> getDatosCatastroWs(Long idActivo) {
		List<DtoDatosCatastro> listDto = new ArrayList<DtoDatosCatastro>();
		
		DtoDatosCatastro dto = this.getDatosCatastroRem(idActivo);
		DtoDatosCatastro dto2 = this.getDatosCatastroRem(idActivo);
		DtoDatosCatastro dto3 = this.getDatosCatastroRem(idActivo);
		dto.setRefCatastral("PRUEBA1VJ9395S0058HL");
		dto2.setRefCatastral("PRUEBA2VJ9395S0058HL");
		dto3.setRefCatastral("PRUEBA3VJ9395S0058HL");
		
		dto.setCatastroCorrecto(true);
		dto2.setCatastroCorrecto(false);


		
		listDto.add(dto);
		listDto.add(dto2);
		listDto.add(dto3);
		
		return listDto;
	}

	@Override
	public List<DtoDatosCatastroGrid> validarCatastro (DtoDatosCatastro dtoCatastroRem, DtoDatosCatastro dtoCatastro){
		List<DtoDatosCatastroGrid> listDto = new ArrayList<DtoDatosCatastroGrid>();
		List<DtoDatosCatastroGrid> listDtoGenerales = this. validarCatastroDatosBásicos(dtoCatastroRem, dtoCatastro);
		List<DtoDatosCatastroGrid> listDtoDireccion = this. validarCatastroDireccion(dtoCatastroRem, dtoCatastro);
		
		listDto.addAll(listDtoDireccion);
		listDto.addAll(listDtoGenerales);
		
		return listDto;
	}

	@Override
	public List<DtoDatosCatastroGrid> validarCatastroDatosBásicos(DtoDatosCatastro dtoCatastroRem, DtoDatosCatastro dtoCatastro) {
		
		List<DtoDatosCatastroGrid> listDto = new ArrayList<DtoDatosCatastroGrid>();
		try {
			
			DtoDatosCatastroGrid dto = new DtoDatosCatastroGrid();
			
			if(dtoCatastroRem.getSuperficieParcela() != null && dtoCatastro.getSuperficieParcela() != null) {
				dto.setNombre(SUPERFICIE_PARCELA);
				dto.setDatoRem(dtoCatastroRem.getSuperficieParcela().toString());
				dto.setDatoCatastro(dtoCatastro.getSuperficieParcela().toString());
				dto.setCoincidencia(calculoCoincidencia(calculoValor(dtoCatastroRem.getSuperficieParcela(),dtoCatastro.getSuperficieParcela())));
			}else {
				dto.setNombre(SUPERFICIE_PARCELA);
				dto.setDatoRem(dtoCatastroRem.getSuperficieParcela() == null ? "" : dtoCatastroRem.getSuperficieParcela().toString());
				dto.setDatoCatastro(dtoCatastro.getSuperficieParcela() == null ? "" : dtoCatastro.getSuperficieParcela().toString());
			}
			listDto.add(dto);
			
			 dto = new DtoDatosCatastroGrid();
			if(dtoCatastroRem.getSuperficieConstruida() != null && dtoCatastro.getSuperficieConstruida() != null) {
				dto.setNombre(SUPERFICIE_CONSTRUIDA);
				dto.setDatoRem(dtoCatastroRem.getSuperficieConstruida().toString());
				dto.setDatoCatastro(dtoCatastro.getSuperficieConstruida().toString());
				dto.setCoincidencia(calculoCoincidencia(calculoValor(dtoCatastroRem.getSuperficieConstruida(),dtoCatastro.getSuperficieConstruida())));
			}else {
				dto.setNombre(SUPERFICIE_CONSTRUIDA);
				dto.setDatoRem(dtoCatastroRem.getSuperficieConstruida() == null ? "" : dtoCatastroRem.getSuperficieConstruida().toString());
				dto.setDatoCatastro(dtoCatastro.getSuperficieConstruida() == null ? "" : dtoCatastro.getSuperficieConstruida().toString());
			}
			
			listDto.add(dto);
			
			dto = new DtoDatosCatastroGrid();
			if(dtoCatastroRem.getGeodistancia() != null && dtoCatastro.getGeodistancia() != null) {
				dto.setNombre(GEODISTANCIA);
				dto.setDatoRem(dtoCatastroRem.getGeodistancia().toString());
				dto.setDatoCatastro(dtoCatastro.getGeodistancia().toString());
				dto.setCoincidencia(calculoCoincidencia(calculoValor(dtoCatastroRem.getGeodistancia(),dtoCatastro.getGeodistancia())));
			}else {
				dto.setNombre(GEODISTANCIA);
				dto.setDatoRem(dtoCatastroRem.getGeodistancia() == null ? "" : dtoCatastroRem.getGeodistancia().toString());
				dto.setDatoCatastro(dtoCatastro.getGeodistancia() == null ? "" : dtoCatastro.getGeodistancia().toString());
			}
			listDto.add(dto);
			
			dto = new DtoDatosCatastroGrid();
			if(dtoCatastroRem.getAnyoConstruccion() != null && dtoCatastro.getAnyoConstruccion() != null) {
				dto.setNombre(ANYO_CONSTRUCCION);
				dto.setDatoRem(dtoCatastroRem.getAnyoConstruccion().toString());
				dto.setDatoCatastro(dtoCatastro.getAnyoConstruccion().toString());
				dto.setCoincidencia(calculoIgual(dtoCatastroRem.getAnyoConstruccion().toString(),dtoCatastro.getAnyoConstruccion().toString()));
			}else {
				dto.setNombre(ANYO_CONSTRUCCION);
				dto.setDatoRem(dtoCatastroRem.getAnyoConstruccion() == null ? "" : dtoCatastroRem.getAnyoConstruccion().toString());
				dto.setDatoCatastro(dtoCatastro.getAnyoConstruccion() == null ? "" : dtoCatastro.getAnyoConstruccion().toString());
			}
			
			listDto.add(dto); 
			
			dto = new DtoDatosCatastroGrid();
			
			dto.setNombre(LATITUD);
			if(dtoCatastroRem.getLatitud() != null && dtoCatastro.getLatitud() != null) {
				dto.setDatoRem(dtoCatastroRem.getLatitud().toString());
				dto.setDatoCatastro(dtoCatastro.getLatitud().toString());
				dto.setCoincidencia(calculoIgual(dtoCatastroRem.getLatitud().toString(),dtoCatastro.getLatitud().toString()));
			}else {
				dto.setDatoRem(dtoCatastroRem.getLatitud() == null ? "" : dtoCatastroRem.getLatitud().toString());
				dto.setDatoCatastro(dtoCatastro.getLatitud() == null ? "" : dtoCatastro.getLatitud().toString());
			}
			listDto.add(dto);
			
			dto = new DtoDatosCatastroGrid();
			dto.setNombre(LONGITUD);
			if(dtoCatastroRem.getLongitud() != null && dtoCatastro.getLongitud() != null) {
				dto.setDatoRem(dtoCatastroRem.getLongitud().toString());
				dto.setDatoCatastro(dtoCatastro.getLongitud().toString());
				dto.setCoincidencia(calculoIgual(dtoCatastroRem.getLongitud().toString(),dtoCatastro.getLongitud().toString()));
			}else {
				dto.setDatoRem(dtoCatastroRem.getLongitud() == null ? "" : dtoCatastroRem.getLongitud().toString());
				dto.setDatoCatastro(dtoCatastro.getLongitud() == null ? "" : dtoCatastro.getLongitud().toString());
			}
			listDto.add(dto);
			

		} catch (Exception e) {
			logger.error("error en CatastroManager metodo validarCatastro - ", e);
		}
		return listDto;
	}
	
	@Override
	public List<DtoDatosCatastroGrid> validarCatastroDireccion(DtoDatosCatastro dtoCatastroRem, DtoDatosCatastro dtoCatastro) {
		
		List<DtoDatosCatastroGrid> listDto = new ArrayList<DtoDatosCatastroGrid>();
		try {
			
			DtoDatosCatastroGrid dto = new DtoDatosCatastroGrid();
			
			dto = new DtoDatosCatastroGrid();
			if(!Checks.esNulo(dtoCatastroRem.getTipoVia()) && !Checks.esNulo(dtoCatastroRem.getTipoViaCod()) && !Checks.esNulo(dtoCatastro.getTipoVia()) && !Checks.esNulo(dtoCatastro.getTipoViaCod())){
				dto.setNombre(TIPO_VIA);
				dto.setDatoRem(dtoCatastroRem.getTipoVia());
				dto.setDatoCatastro(dtoCatastro.getTipoVia());
				dto.setCoincidencia(calculoIgual(dtoCatastroRem.getTipoViaCod(),dtoCatastro.getTipoViaCod()));
			}else {
				dto.setNombre(TIPO_VIA);
				dto.setDatoRem(dtoCatastroRem.getTipoVia());
				dto.setDatoCatastro(dtoCatastro.getTipoVia());
			}
	
			listDto.add(dto);
			
			dto = new DtoDatosCatastroGrid();
			if((dtoCatastroRem.getCodigoPostal() != null && !dtoCatastroRem.getCodigoPostal().isEmpty())  
					&& (dtoCatastro.getCodigoPostal() != null && !dtoCatastro.getCodigoPostal().isEmpty())) {
				dto.setNombre(CODIGO_POSTAL);
				dto.setDatoRem(dtoCatastroRem.getCodigoPostal());
				dto.setDatoCatastro(dtoCatastro.getCodigoPostal());
				dto.setCoincidencia(calculoIgual(dtoCatastroRem.getCodigoPostal(),dtoCatastro.getCodigoPostal()));
					
			}else {
				dto.setNombre(CODIGO_POSTAL);
				dto.setDatoRem(dtoCatastroRem.getCodigoPostal());
				dto.setDatoCatastro(dtoCatastro.getCodigoPostal());
			}
			
			listDto.add(dto);
			
			dto = new DtoDatosCatastroGrid();
			if((dtoCatastroRem.getMunicipio() != null && !dtoCatastroRem.getMunicipio().isEmpty()) 
					&& (dtoCatastro.getMunicipio() != null && !dtoCatastro.getMunicipio().isEmpty())) {
				dto.setNombre(MUNICIPIO);
				dto.setDatoRem(dtoCatastroRem.getMunicipio());
				dto.setDatoCatastro(dtoCatastro.getMunicipio());
				dto.setCoincidencia(calculoIgual(dtoCatastroRem.getMunicipioCod(),dtoCatastro.getMunicipioCod()));
			}else {
				dto.setNombre(MUNICIPIO);
				dto.setDatoRem(dtoCatastroRem.getMunicipio());
				dto.setDatoCatastro(dtoCatastro.getMunicipio());
			}
			
			listDto.add(dto);
			
			dto = new DtoDatosCatastroGrid();
			if((dtoCatastroRem.getProvincia() != null && !dtoCatastroRem.getProvincia().isEmpty()) 
					&& (dtoCatastro.getProvincia() != null && !dtoCatastro.getProvincia().isEmpty())){
				dto.setNombre(PROVINCIA);
				dto.setDatoRem(dtoCatastroRem.getProvincia());
				dto.setDatoCatastro(dtoCatastro.getProvincia());
				dto.setCoincidencia(calculoIgual(dtoCatastroRem.getProvinciaCod(),dtoCatastro.getProvinciaCod()));
			}else {
				dto.setNombre(PROVINCIA);
				dto.setDatoRem(dtoCatastroRem.getProvincia());
				dto.setDatoCatastro(dtoCatastro.getProvincia());
			}
			
			listDto.add(dto);
			
			dto = new DtoDatosCatastroGrid();
			if(!Checks.esNulo(dtoCatastroRem.getNombreVia()) && !Checks.esNulo(dtoCatastro.getNombreVia())) {
				Double probabilidad = calculoSimilaridad(dtoCatastroRem.getNombreVia(),dtoCatastro.getNombreVia());
				dto.setNombre(NOMBRE_CALLE);
				dto.setDatoRem(dtoCatastroRem.getNombreVia());
				dto.setDatoCatastro(dtoCatastro.getNombreVia());
				dto.setCoincidencia(calculoCoincidencia(probabilidad));
				dto.setProbabilidad(calculoProbabilidad(probabilidad));
			}else {
				dto.setNombre(NOMBRE_CALLE);
				dto.setDatoRem(dtoCatastroRem.getNombreVia());
				dto.setDatoCatastro(dtoCatastro.getNombreVia());
			}
			
			listDto.add(dto);
			
		} catch (Exception e) {
			logger.error("error en CatastroManager metodo validarCatastro - ", e);
		}
		return listDto;
	
	}
	
	private String calculoProbabilidad(Double resultado) {
		String respuesta = PROB_MUY_BAJA;
		
		if(resultado >= 0 && resultado <= 0.2) {
			respuesta= PROB_MUY_BAJA;
		}else if(resultado > 0.2 && resultado <= 0.4) {
			respuesta= PROB_BAJA;
		}else if(resultado > 0.4 && resultado <= 0.6) {
			respuesta= PROB_MEDIA;
		}else if(resultado > 0.6 && resultado <= 0.8) {
			respuesta= PROB_ALTA;
		}else if(resultado > 0.8 && resultado <= 1) {
			respuesta= PROB_MUY_ALTA;
		}
		return respuesta;
	}
	
	private Double calculoValor(Double valor1, Double valor2) {
		Double resultado = 0D;
		
		try {
			resultado=valor1/valor2;	
		} catch (Exception e) {
			resultado = 0D;
		}
		
		return resultado;
	}
	
	private boolean calculoIgual(String valorDatoRem, String valorCatastro) {
		return valorDatoRem.equals(valorCatastro);
	}
	
	private Boolean calculoCoincidencia(Double valor) {
		
		Boolean resultado = false;
		try {
			if(valor >= 0.8 && valor <= 1.2) {
				resultado= true;
			}else if(valor < 0.8 || valor > 1.2) {
				resultado= false;
			}	
		} catch (Exception e) {
			resultado = false;
		}
		
		return resultado;		
	}
		
	private Double calculoSimilaridad(String nombreCalleDatoRem, String nombreCalleCatastro) {
		
		return calculoSimililtud(nombreCalleDatoRem,nombreCalleCatastro);
	}

	private Double calculoSimililtud(String nombreCalleDatoRem, String nombreCalleCatastro) {
	   
		int[][]matriz = new int[nombreCalleDatoRem.length() + 1][nombreCalleCatastro.length() + 1];
		for (int i = 0; i <= nombreCalleDatoRem.length(); i++) {
			matriz[i][0] = i;
		}
		for (int j = 0; j <= nombreCalleCatastro.length(); j++) {
			matriz[0][j] = j;
		}
		for (int i = 1; i < matriz.length; i++) {
			for (int j = 1; j < matriz[i].length; j++) {
				if (nombreCalleDatoRem.charAt(i - 1) == nombreCalleCatastro.charAt(j - 1)) {
					matriz[i][j] = matriz[i - 1][j - 1];
				} else {
		           int min = Integer.MAX_VALUE;
		           if ((matriz[i - 1][j]) + 1 < min) {
		        	   min = (matriz[i - 1][j]) + 1;
		           }
		           if ((matriz[i][j - 1]) + 1 < min) {
		        	   min = (matriz[i][j - 1]) + 1;
		           }
		           if ((matriz[i - 1][j - 1]) + 1 < min) {
		        	   min = (matriz[i - 1][j - 1]) + 1;
		           }
		           matriz[i][j] = min;
				}
	     }
	  }
	  int distancia = matriz[nombreCalleDatoRem.length()][nombreCalleCatastro.length()];
	  
	  Double longitud = (double) (nombreCalleDatoRem.length() > nombreCalleCatastro.length() ? nombreCalleDatoRem.length() : nombreCalleCatastro.length());
	  return 1 - (distancia / longitud);
   }


	@Override
	public List<DtoActivoCatastro> getComboReferenciaCatastralByidActivo(Long idActivo) {
		List<DtoActivoCatastro> listDto = new ArrayList<DtoActivoCatastro>();
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS,"activo.id",idActivo);
		List<ActivoCatastro> listActCatastro = genericDao.getList(ActivoCatastro.class, filtro);
		
		for (ActivoCatastro activoCatastro : listActCatastro) {
			DtoActivoCatastro dto = new DtoActivoCatastro();
			dto.setDescripcion(activoCatastro.getRefCatastral());
			dto.setCodigo(activoCatastro.getRefCatastral());
			dto.setId(activoCatastro.getId().toString());
			listDto.add(dto);
		}
		
		return listDto;
	}


	@Override
	public List<DtoActivoCatastro> getGridReferenciaCatastralByidActivo(Long idActivo) {
		List<DtoActivoCatastro> listDto = new ArrayList<DtoActivoCatastro>();
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS,"activo.id",idActivo);
		List<ActivoCatastro> listActCatastro = genericDao.getList(ActivoCatastro.class, filtro);
		
		for (ActivoCatastro activoCatastro : listActCatastro) {
			DtoActivoCatastro dto = new DtoActivoCatastro();
			dto.setRefCatastral(activoCatastro.getRefCatastral());
			dto.setCorrecto(activoCatastro.getCatastroCorrecto() != null ? activoCatastro.getCatastroCorrecto().toString() : null);
			
			listDto.add(dto);
		}
		
		return listDto;
	}


	@Override
	public List<DtoDatosCatastroGrid> getGridReferenciaCatastralByRefCatastral(String refCatastral, Long idActivo) {
		
		List<DtoDatosCatastroGrid> listDto = new ArrayList<DtoDatosCatastroGrid>();
		try {
			if(refCatastral != null) {
				DtoDatosCatastro dtoRem = getDatosCatastroRem(idActivo); 
				
				DtoDatosCatastro dtoCatastro = getDatosCatastro(refCatastral);
				
				listDto = validarCatastro(dtoRem,dtoCatastro);
			}	
		} catch (Exception e) {
			logger.error("error en CatastroManager metodo getGridReferenciaCatastralByRefCatastral - ", e);
		}
		return listDto;
	}

	public DtoDatosCatastro getDatosCatastro(String refCatastral) {
		Filter filtro = genericDao.createFilter(FilterType.EQUALS,"refCatastral",refCatastral);
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS,"auditoria.borrado",false);
		Catastro catastro = genericDao.get(Catastro.class, filtro,filtroBorrado);
		DtoDatosCatastro dtoCatastro = new DtoDatosCatastro();

		if(catastro != null) {
			dtoCatastro.setRefCatastral(catastro.getRefCatastral());
			dtoCatastro.setSuperficieParcela(catastro.getSuperficieParcela());
			dtoCatastro.setSuperficieConstruida(catastro.getSuperficieConstruida());
			dtoCatastro.setSuperficieReperComun(catastro.getSuperficieZonasComunes());
			dtoCatastro.setAnyoConstruccion(catastro.getAnyoConstrucción());
			dtoCatastro.setCodigoPostal(catastro.getCodPostal());
			dtoCatastro.setTipoVia(catastro.getTipoVia() != null ? catastro.getTipoVia().getDescripcion() : null);
			dtoCatastro.setTipoViaCod(catastro.getTipoVia() != null ? catastro.getTipoVia().getCodigo() : null);
			dtoCatastro.setNombreVia(catastro.getDescripcionVia());
			dtoCatastro.setNumeroVia(catastro.getNumeroVia());
			dtoCatastro.setDireccion(catastro.getDescripcionVia());
			dtoCatastro.setGeodistancia(catastro.getGeodistancia() != null ? Double.parseDouble(catastro.getGeodistancia().toString()) : null);
			dtoCatastro.setMunicipio(catastro.getLocalidad() != null ? catastro.getLocalidad().getDescripcion() : null);
			dtoCatastro.setProvincia(catastro.getProvincia() != null ? catastro.getProvincia().getDescripcion() : null);
			dtoCatastro.setMunicipioCod(catastro.getLocalidad() != null ? catastro.getLocalidad().getCodigo() : null);
			dtoCatastro.setProvinciaCod(catastro.getProvincia() != null ? catastro.getProvincia().getCodigo() : null);
			dtoCatastro.setNombreVia(catastro.getDescripcionVia());
			dtoCatastro.setLatitud(catastro.getLatitud());
			dtoCatastro.setLongitud(catastro.getLongitud());
		}
		return dtoCatastro;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void eliminarCatastro(Long id) {
		ActivoCatastro activoCatastro = genericDao.get(ActivoCatastro.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
		Auditoria.delete(activoCatastro);
		
		genericDao.save(ActivoCatastro.class, activoCatastro);
	}
	
	@Override
	@Transactional(readOnly = false)
	public void saveCatastro(Long idActivo, List<String> arrayReferencias) {
		Activo activo = activoDao.get(idActivo);
		
		
		if(activo != null) {	
			
			
			for (String refCatastral : arrayReferencias) {
				Catastro catastro  = this.getCatastroByActivoAndRef(idActivo, refCatastral);
				ActivoCatastro activoCatastro = getActivoCatastroByActivoAndReferencia(idActivo,refCatastral);
				if(catastro != null && activoCatastro == null) {				
					activoCatastro = new ActivoCatastro();
					activoCatastro.setAuditoria(Auditoria.getNewInstance());
					activoCatastro.setActivo(activo);
					activoCatastro.setCatastro(catastro);
					//ac.setCatastroCorrecto(formatoCatastro);
					genericDao.save(ActivoCatastro.class, activoCatastro);
				}
			}
		}
	}
	
	@Override
	@Transactional
	public void validaAsincrono(ArrayList<String> refCatastralList, Long idActivo) {
		DtoDatosCatastro datosRem = getDatosCatastroRem(idActivo);
		
		for (String refCatastral : refCatastralList) {
			ActivoCatastro activoCatastro = getActivoCatastroByActivoAndReferencia(idActivo,refCatastral);
			if(activoCatastro != null) {
				DtoDatosCatastro datosCatastro = getDatosCatastro(refCatastral);
				List<DtoDatosCatastroGrid> datosCatastroList = validarCatastro(datosRem, datosCatastro);
				boolean coincidencia = checkCoindicenciaCatastro(datosCatastroList);
				activoCatastro.setCatastroCorrecto(coincidencia);
				genericDao.save(ActivoCatastro.class, activoCatastro);
			}
		}
	}
	
	private boolean checkCoindicenciaCatastro(List<DtoDatosCatastroGrid> datosCatastroList) {
		boolean coincidencia = true;
		for (DtoDatosCatastroGrid dtoDatosCatastro : datosCatastroList) {
			if(dtoDatosCatastro.getCoincidencia() == null || !dtoDatosCatastro.getCoincidencia()) {
				coincidencia = false;
				break;
			}
		}
		return coincidencia;
	}
	
	private ActivoCatastro getActivoCatastroByActivoAndReferencia(Long idActivo, String refCatastral) {
		return genericDao.get(ActivoCatastro.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo), genericDao.createFilter(FilterType.EQUALS, "refCatastral", refCatastral));
	}
	
	@Override
	@Transactional(readOnly = false)
	public void updateCatastro(Long idActivo, String referenciaAnterior, String nuevaReferencia, Boolean formatoCatastro) {
		ActivoCatastro acn = getActivoCatastroByActivoAndReferencia(idActivo,nuevaReferencia);
		ActivoCatastro ac = getActivoCatastroByActivoAndReferencia(idActivo, referenciaAnterior);
		Catastro catastro  = this.getCatastroByActivoAndRef(idActivo, nuevaReferencia);
		if(ac != null && catastro != null && acn == null) {
			ac.setCatastro(catastro);
			ac.setCatastroCorrecto(formatoCatastro);
			genericDao.save(ActivoCatastro.class, ac);
		}
	}
	
	private Catastro getCatastroByActivoAndRef(Long idActivo, String refCatastral) {
		Catastro catastro = null;
		
		Activo activo = activoDao.getActivoById(idActivo);
		if(activo != null) {
			Filter filtroProvincia = genericDao.createFilter(FilterType.EQUALS,  "provincia.codigo", activo.getProvincia());
			Filter filtroMunicipio =genericDao.createFilter(FilterType.EQUALS,  "localidad.codigo", activo.getMunicipio());
			Filter filtroRefCatastral  =genericDao.createFilter(FilterType.EQUALS,  "refCatastral", refCatastral);
			catastro = genericDao.get(Catastro.class, filtroRefCatastral,filtroProvincia, filtroMunicipio);	
		}
		return catastro;
	}
}