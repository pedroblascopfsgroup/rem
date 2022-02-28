package es.pfsgroup.plugin.rem.activo.catastro;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import edu.emory.mathcs.backport.java.util.Arrays;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBLocalizacionesBien;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.CatastroApi;
import es.pfsgroup.plugin.rem.controller.CatastroController;
import es.pfsgroup.plugin.rem.logTrust.LogTrustWebService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoCatastro;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;
import es.pfsgroup.plugin.rem.model.ActivoLocalizacion;
import es.pfsgroup.plugin.rem.model.Catastro;
import es.pfsgroup.plugin.rem.model.DtoActivoCatastro;
import es.pfsgroup.plugin.rem.model.DtoCatastroCorrecto;
import es.pfsgroup.plugin.rem.model.DtoDatosCatastro;
import es.pfsgroup.plugin.rem.model.DtoDatosCatastroGrid;
import es.pfsgroup.plugin.rem.model.UpdateReferenciaCatastroDto;
import es.pfsgroup.plugin.rem.model.VActivoCatastro;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientException;
import es.pfsgroup.plugin.rem.restclient.httpclient.HttpClientFacade;
import es.pfsgroup.plugin.rem.restclient.registro.dao.RestLlamadaDao;
import es.pfsgroup.plugin.rem.restclient.registro.model.RestLlamada;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

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
	
	private static final String REM3_URL = "rem3.base.url";
	private static final String URL_CONSULTA_CATASTRO = "rem3.consulta.catastro";
	private static final int TIMEOUT_1_MINUTO =60;
    private static final String GET_METHOD = "GET";
    
    @Resource
    private Properties appProperties;
    
    @Autowired
    private HttpClientFacade httpClientFacade;

    @Autowired
    private RestLlamadaDao llamadaDao;

    @Autowired
    private LogTrustWebService trustMe;
    
    @Autowired
    private ActivoApi activoApi;
    
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
	
	@Transactional(readOnly = false)
	public List<DtoDatosCatastro> getDatosCatastroWs(Long idActivo, String refCatastral) {
		List<DtoDatosCatastro> listDto = new ArrayList<DtoDatosCatastro>();
		boolean referenciaValida =  this.isReferenciaValida(refCatastral);
		List<DtoDatosCatastro> lista = new ArrayList<DtoDatosCatastro>();
			
		 lista = consultaCatastroRem3(idActivo, refCatastral);
		
		if (!lista.isEmpty()) {
			existeCatastro(lista);
			listDto.addAll(lista);
		}
		
		if(!referenciaValida || lista.isEmpty()) {
			DtoDatosCatastro dto = new DtoDatosCatastro();
			dto.setCatastroCorrecto(false);
			dto.setRefCatastral(refCatastral);
			listDto.add(dto);
		}
		

		
		return listDto;
	}

	@Override
	public List<DtoDatosCatastroGrid> validarCatastro (DtoDatosCatastro dtoCatastroRem, DtoDatosCatastro dtoCatastro){
		List<DtoDatosCatastroGrid> listDto = new ArrayList<DtoDatosCatastroGrid>();
		List<DtoDatosCatastroGrid> listDtoGenerales = this.validarCatastroDatosBásicos(dtoCatastroRem, dtoCatastro);
		List<DtoDatosCatastroGrid> listDtoDireccion = this.validarCatastroDireccion(dtoCatastroRem, dtoCatastro);
		
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
			
			dto.setNombre(GEODISTANCIA);

			dto.setDatoRem("");
			dto.setDatoCatastro("");
			if(dtoCatastroRem.getLatitud() != null && dtoCatastroRem.getLongitud() != null && dtoCatastro.getLatitud() != null && dtoCatastro.getLongitud() != null) {
				Double geodistancia = calculoGeodistancia(
					(dtoCatastroRem.getLatitud() != null ? dtoCatastroRem.getLatitud().doubleValue() : 0.0),
					(dtoCatastroRem.getLongitud() != null ? dtoCatastroRem.getLongitud().doubleValue() : 0.0),
					(dtoCatastro.getLatitud() != null ? dtoCatastro.getLatitud().doubleValue() : 0.0),
					(dtoCatastro.getLongitud() != null ? dtoCatastro.getLongitud().doubleValue() : 0.0)
				);
				dto.setCoincidencia(geodistancia < 1);
				dto.setProbabilidad("Diferencia de distancia: " + String.format("%.2f", geodistancia));
			}

			
			listDto.add(dto);
			
			dto = new DtoDatosCatastroGrid();
			
			dto.setNombre(LATITUD);
			if(dtoCatastroRem.getLatitud() != null && dtoCatastro.getLatitud() != null) {
				dto.setDatoRem(dtoCatastroRem.getLatitud().toString());
				dto.setDatoCatastro(dtoCatastro.getLatitud().toString());
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
		
		return calculoSimililtud(nombreCalleDatoRem.toUpperCase(),nombreCalleCatastro.toUpperCase());
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
			if(activoCatastro.getCatastro() != null) {
				dto.setDescripcion(activoCatastro.getCatastro().getRefCatastral());
				dto.setCodigo(activoCatastro.getRefCatastral());
			}
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
			if(activoCatastro.getCatastro() != null) {
				dto.setRefCatastral(activoCatastro.getCatastro().getRefCatastral());
			}
			dto.setCorrecto(activoCatastro.getCatastroCorrecto() != null ? activoCatastro.getCatastroCorrecto().toString() : null);
			
			listDto.add(dto);
		}
		
		return listDto;
	}


	@Override
	public List<DtoDatosCatastroGrid> getGridReferenciaCatastralByRefCatastral(String refCatastral, Long idActivo) {
		
		List<DtoDatosCatastroGrid> listDto = new ArrayList<DtoDatosCatastroGrid>();
		try {
			
			DtoDatosCatastro dtoRem = getDatosCatastroRem(idActivo); 
			
			DtoDatosCatastro dtoCatastro = getDatosCatastro(refCatastral,idActivo);
			
			listDto = validarCatastro(dtoRem,dtoCatastro);
				
		} catch (Exception e) {
			logger.error("error en CatastroManager metodo getGridReferenciaCatastralByRefCatastral - ", e);
		}
		return listDto;
	}

	public DtoDatosCatastro getDatosCatastro(String refCatastral, Long idActivo) {
		Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS,"activo.id",idActivo);
		List<ActivoCatastro> actCatastro = genericDao.getList(ActivoCatastro.class, filtroActivo);
		String referencia;
		Catastro catastro = null;
		DtoDatosCatastro dtoCatastro = new DtoDatosCatastro();
		if(!Checks.esNulo(refCatastral)) {
			referencia = refCatastral;
		}else if(!Checks.estaVacio(actCatastro)) {
			if(actCatastro.get(0).getCatastro() != null) {
				referencia = actCatastro.get(0).getCatastro().getRefCatastral();
			}else {
				referencia = actCatastro.get(0).getRefCatastral();
			}
		}else {
			return dtoCatastro;
		}
		if((actCatastro.size() > 1 && refCatastral == null) || referencia == null) {
			return dtoCatastro;
		}
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS,"refCatastral",referencia);

		
		catastro = genericDao.get(Catastro.class, filtro);
		
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
				DtoCatastroCorrecto dto = this.devolverReferenciaAndCorrecto(refCatastral);
				Catastro catastro  = this.getCatastroByActivoAndRef(idActivo, dto.getRefCatastral());
				ActivoCatastro activoCatastro = getActivoCatastroByActivoAndReferencia(idActivo,dto.getRefCatastral());
			
				if(activoCatastro == null) {				
					activoCatastro = new ActivoCatastro();
					activoCatastro.setAuditoria(Auditoria.getNewInstance());
					activoCatastro.setActivo(activo);
					if(catastro != null) {
						activoCatastro.setCatastro(catastro);
						activoCatastro.setRefCatastral(dto.getRefCatastral());
					}else {
						activoCatastro.setRefCatastral(dto.getRefCatastral());
					}
					activoCatastro.setCatastroCorrecto(dto.getCorrecto());
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
				DtoDatosCatastro datosCatastro = getDatosCatastro(refCatastral,idActivo);
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
		ActivoCatastro ac = genericDao.get(ActivoCatastro.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo), genericDao.createFilter(FilterType.EQUALS, "catastro.refCatastral", refCatastral));
		if(ac == null) {
			ac = genericDao.get(ActivoCatastro.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo), genericDao.createFilter(FilterType.EQUALS, "refCatastral", refCatastral));
		}
		return ac;
	}
	
	@Override
	@Transactional(readOnly = false)
	public void updateCatastro(Long idActivo, String referenciaAnterior, String nuevaReferencia) {
		DtoCatastroCorrecto dto = this.devolverReferenciaAndCorrecto(nuevaReferencia);
		ActivoCatastro acn = getActivoCatastroByActivoAndReferencia(idActivo, dto.getRefCatastral());
		ActivoCatastro ac = getActivoCatastroByActivoAndReferencia(idActivo, referenciaAnterior);
		Catastro catastro  = this.getCatastroByActivoAndRef(idActivo, dto.getRefCatastral());
		if(ac != null && acn == null) {
			if(catastro != null) {
				ac.setCatastro(catastro);
				ac.setRefCatastral(dto.getRefCatastral());
			}else {
				ac.setRefCatastral(dto.getRefCatastral());
				ac.setCatastro(null);
			}
			ac.setCatastroCorrecto(dto.getCorrecto());
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
	
	private DtoCatastroCorrecto devolverReferenciaAndCorrecto(String refCatastral) {
		DtoCatastroCorrecto dto = new DtoCatastroCorrecto();
		String[] parts = refCatastral.split("-");
		dto.setRefCatastral(parts[0]); 
		if(parts.length > 1) {
			dto.setCorrecto(Boolean.parseBoolean(parts[1]));
		}
		
		return dto;
	}
	
	private List<DtoDatosCatastro> consultaCatastroRem3(Long idActivo, String refCatastral){
		Activo activo = activoDao.getActivoById(idActivo);
		List<DtoDatosCatastro> lista = new ArrayList<DtoDatosCatastro>();
		
		if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getBien()) && !Checks.esNulo(activo.getBien().getLocalizaciones().get(0))
				&& !Checks.esNulo(activo.getBien().getLocalizaciones().get(0).getLocalidad()) && !Checks.esNulo(activo.getBien().getLocalizaciones().get(0).getProvincia())) {
			
			Map<String, String> headers = new HashMap<String, String>();
	        headers.put("Content-Type", "application/json");
				
			String urlBase = !Checks.esNulo(appProperties.getProperty(REM3_URL))
			        ? appProperties.getProperty(REM3_URL) : "";
			String urlEndpoint = !Checks.esNulo(appProperties.getProperty(URL_CONSULTA_CATASTRO))
			        ? appProperties.getProperty(URL_CONSULTA_CATASTRO) : "";
			
			StringBuilder urlConsultaCatastro = new StringBuilder();
			urlConsultaCatastro.append(urlBase);
			urlConsultaCatastro.append(urlEndpoint);
			urlConsultaCatastro.append("/"+refCatastral);
			urlConsultaCatastro.append("/"+activo.getBien().getLocalizaciones().get(0).getProvincia().getCodigo());
			urlConsultaCatastro.append("/"+activo.getBien().getLocalizaciones().get(0).getLocalidad().getCodigo());
			
			JSONObject respuesta = null;
			String ex = null;		
	    	String mensaje = null;
	    	boolean resultadoOK = false;

			logger.error("[CONSULTA CATASTRO] URL: "+urlConsultaCatastro);
	        
	        try{			
				respuesta = procesarPeticion(this.httpClientFacade, urlConsultaCatastro.toString(), GET_METHOD, headers, "{}", TIMEOUT_1_MINUTO, "UTF-8");					
				logger.debug("[PETICION] RESPUESTA: "+ respuesta);
				
				JSONObject menuItems = (JSONObject) respuesta.get("data");
				
				Boolean success = (Boolean) menuItems.get("success");	
				
				if (success) {
					JSONArray catastro = (JSONArray)menuItems.get("catastro");		

					for (Object item : catastro) {
						JSONObject cat = (JSONObject) item;
						
						DtoDatosCatastro dtoCatastro = new DtoDatosCatastro();
						
						dtoCatastro.setRefCatastral(cat.getString("referenciaCatastral"));
						
						
						String superficieString = cat.getString("superficieConstruida");
						if(superficieString != null) {
							String superficie = checkObjectByType(superficieString, "double");
							dtoCatastro.setSuperficieConstruida(superficie != null ? Double.parseDouble(superficie) : null);
						}
						
						String anyoConstruccionString = cat.getString("anyoConstruccion");
						if(anyoConstruccionString != null) {
							String anyoConstruccion = checkObjectByType(anyoConstruccionString, "int");
							dtoCatastro.setAnyoConstruccion(anyoConstruccion != null ? Integer.parseInt(anyoConstruccion) : null);
						}
						
						dtoCatastro.setCodigoPostal(cat.getString("codPostal"));
						
				
						dtoCatastro.setTipoViaCod(cat.getString("codTipoVia"));
						if(dtoCatastro.getTipoViaCod() != null) {
							Filter tpvFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoCatastro.getTipoViaCod());
							DDTipoVia via = genericDao.get(DDTipoVia.class, tpvFilter);
							if (!Checks.esNulo(via)) {
								dtoCatastro.setTipoVia(via.getDescripcion());
							}
						}
						
						
						dtoCatastro.setNumeroVia((String) cat.getString("numVia"));
						dtoCatastro.setDomicilio((String) cat.getString("numVia"));
						dtoCatastro.setPlanta(cat.getString("planta"));
						dtoCatastro.setPuerta((String) cat.getString("puerta"));
						dtoCatastro.setEscalera(cat.getString("escalera"));
						
						dtoCatastro.setProvinciaCod(cat.getString("codProvincia"));
						if(dtoCatastro.getProvinciaCod() != null) {
							Filter provFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoCatastro.getProvinciaCod());
							DDProvincia provincia = genericDao.get(DDProvincia.class, provFilter);
							if (!Checks.esNulo(provincia)) {
								dtoCatastro.setProvincia(provincia.getDescripcion());
							}
						}
						
						dtoCatastro.setMunicipioCod(cat.getString("codMunicipio"));
						if(dtoCatastro.getMunicipioCod()!= null) {
							Filter munFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoCatastro.getMunicipioCod());
							Localidad municipio = genericDao.get(Localidad.class, munFilter);
							if (!Checks.esNulo(municipio)) {
								dtoCatastro.setMunicipio(municipio.getDescripcion());
							}
						}
						if (!Checks.esNulo(cat.getString("lat"))) {
							String lat = checkObjectByType(cat.getString("lat"), "bigdecimal");
							dtoCatastro.setLatitud(lat != null ? new BigDecimal(lat) : null);
						}
						if (!Checks.esNulo(cat.getString("lon"))) {
							String lon = checkObjectByType(cat.getString("lon"), "bigdecimal");
							dtoCatastro.setLongitud(lon != null ? new BigDecimal(lon) : null);
						}
						if (!Checks.esNulo(cat.getString("correcto"))) {
							dtoCatastro.setCatastroCorrecto((Boolean) cat.get("correcto"));
						}
						
						dtoCatastro.setNombreVia(cat.getString("nombreVia"));
						dtoCatastro.setUso(cat.getString("uso"));
						
						lista.add(dtoCatastro);
					}
					
					resultadoOK = true;
				}
			}catch (HttpClientException e1) {
				e1.printStackTrace();
				ex = e1.getMessage();
			}catch (Exception e) {
				logger.error("Error al procesar petición para consultar catastro", e);
				logger.error(e.getMessage());
			}
			
			if (resultadoOK == true) {
				logger.debug("[CONSULTA CATASTRO] MENSAJE: "+ mensaje);
				logger.debug("[CONSULTA CATASTRO] RESULTADO: "+ resultadoOK);
			} else {
				logger.error("[CONSULTA CATASTRO] URL: "+urlConsultaCatastro);
				logger.error("[CONSULTA CATASTRO] MENSAJE: "+ mensaje);
				logger.error("[CONSULTA CATASTRO] RESULTADO: "+ resultadoOK);
			}
					
			registrarLlamada(urlConsultaCatastro.toString(),null, respuesta != null ? respuesta.toString() : null, ex);
			
		}
		
		return lista;
		
	}
	
	private JSONObject procesarPeticion(HttpClientFacade httpClientFacade, String serviceUrl, String sendMethod, Map<String, String> headers, String jsonString, int responseTimeOut, String charSet) throws HttpClientException {
        return httpClientFacade.processRequest(serviceUrl, sendMethod, headers, jsonString, responseTimeOut, charSet);
    }
	
	private void registrarLlamada(String endPoint, String request, String result,String exception) {
        RestLlamada registro = new RestLlamada();
        registro.setMetodo("WEBSERVICE");
        registro.setEndpoint(endPoint);
        registro.setRequest(request);
        logger.debug(request);
        logger.debug("-------------------");
        logger.debug(result);
        registro.setException(exception);    
        try {
            registro.setResponse(result);
            llamadaDao.guardaRegistro(registro);
            trustMe.registrarLlamadaServicioWeb(registro);
        } catch (Exception e) {
            logger.error("Error al trazar la llamada al WS", e);
        }
    }
	
	private String checkObjectByType(String object, String type) {
		try {
			if (type == "double") {
				Double.parseDouble(object);
			} else if (type == "int") {
				Integer.parseInt(object);
			} else if (type == "bigdecimal") {
				new BigDecimal(object);
			}
			
		} catch (Exception e) {
			return null;
		}
		return object;
	}

	private void existeCatastro(List<DtoDatosCatastro> listadoCatastro) {

		for(DtoDatosCatastro datosCatastro : listadoCatastro) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS,"refCatastral",datosCatastro.getRefCatastral());
			Filter filtroMun = genericDao.createFilter(FilterType.EQUALS,"localidad.codigo",datosCatastro.getMunicipioCod());
			Filter filtroPrv = genericDao.createFilter(FilterType.EQUALS,"provincia.codigo",datosCatastro.getProvinciaCod());
			
			Catastro catastro = genericDao.get(Catastro.class, filtro,filtroMun,filtroPrv);
			
			if (Checks.esNulo(catastro)) {
				catastro = new Catastro();
				catastro.setRefCatastral(datosCatastro.getRefCatastral());
				catastro.setSuperficieConstruida(datosCatastro.getSuperficieConstruida());
				catastro.setAnyoConstrucción(datosCatastro.getAnyoConstruccion());
				catastro.setCodPostal(datosCatastro.getCodigoPostal());
				if (!Checks.esNulo(datosCatastro.getTipoViaCod())) {
					Filter tpvFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",datosCatastro.getTipoViaCod());
					DDTipoVia via = genericDao.get(DDTipoVia.class, tpvFilter);
					if (!Checks.esNulo(via))catastro.setTipoVia(via);
				}
				catastro.setNumeroVia(datosCatastro.getNumeroVia());
				catastro.setPlanta(datosCatastro.getPlanta());
				catastro.setPuerta(datosCatastro.getPuerta());
				if (!Checks.esNulo(datosCatastro.getProvinciaCod())) {
					Filter provFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",datosCatastro.getProvinciaCod());
					DDProvincia provincia = genericDao.get(DDProvincia.class, provFilter);
					if (!Checks.esNulo(provincia)) catastro.setProvincia(provincia);
				}
				if (!Checks.esNulo(datosCatastro.getMunicipioCod())) {
					Filter munFilter = genericDao.createFilter(FilterType.EQUALS, "codigo",datosCatastro.getMunicipioCod());
					Localidad municipio = genericDao.get(Localidad.class, munFilter);
					if (!Checks.esNulo(municipio)) catastro.setLocalidad(municipio);
				}
				catastro.setLatitud(datosCatastro.getLatitud());
				catastro.setLongitud(datosCatastro.getLongitud());
				catastro.setEscalera(datosCatastro.getEscalera());
				catastro.setUsoPrincipal(datosCatastro.getUso());
				catastro.setDescripcionVia(datosCatastro.getNombreVia());
				
				genericDao.save(Catastro.class, catastro);
			}
		}
		
	}
	
	
	private Double calculoGeodistancia(double lon1, double lat1,
			double lon2, double lat2) {

		double earthRadius = 6371; // km

		lat1 = Math.toRadians(lat1);
		lon1 = Math.toRadians(lon1);
		lat2 = Math.toRadians(lat2);
		lon2 = Math.toRadians(lon2);

		double dlon = (lon2 - lon1);
		double dlat = (lat2 - lat1);

		double sinlat = Math.sin(dlat / 2);
		double sinlon = Math.sin(dlon / 2);

		double a = (sinlat * sinlat) + Math.cos(lat1)*Math.cos(lat2)*(sinlon*sinlon);
		double c = 2 * Math.asin (Math.min(1.0, Math.sqrt(a)));

		double distanceInMeters = earthRadius * c * 1000;

		return distanceInMeters;

		}
	
	@Override
	public boolean isReferenciaValida(String refCatastral) {
		
		String letraDc= "MQWERTYUIOPASDFGHJKLBZX";
		String dcCalculado = "";
		int[] pesoPosicion = new int[]{13,15,12,5,4,17,9,21,3,7,1};
		
		if(Checks.esNulo(refCatastral) || refCatastral.length() != 20) {
			return false;
		}
		
		refCatastral = refCatastral.toUpperCase();
		
		
		String cadenaPrimerDC=(refCatastral.substring(0,7) + refCatastral.substring(14,18)); 
	    String cadenaSegundoDC=(refCatastral.substring(7,14) + refCatastral.substring(14,18));
	    List<String> cadenas = new ArrayList<String>();
	    cadenas.add(cadenaPrimerDC);
	    cadenas.add(cadenaSegundoDC); cadenaSegundoDC.split("");
	    int posicion = 0;
	    Integer valorCaracter  = null;
	    for (String cadena : cadenas) {
	    	int sumaDigitos=0;
	    	
	    	String[] caracteres = cadena.split("");

	    	
	    	LinkedList<String> caracteresList = new LinkedList<String>();
	    	caracteresList.addAll(Arrays.asList(caracteres));
	    	caracteresList.removeFirst();

	    	posicion = 0;
	    	for (String caracter : caracteresList) {
	    		valorCaracter = null;
	    		if(caracter.matches("[0-9]")) {
	    			valorCaracter = Integer.parseInt(caracter);
	    		}else if(caracter.matches("[A-N]")){
	                valorCaracter=Character.codePointAt(caracter, 0)-64;
	            }else if(caracter.matches("[Ñ]")){
	                valorCaracter=15;
	            }else if(caracter.matches("[N-Z]")){
	                valorCaracter=Character.codePointAt(caracter, 0)-63;
	            }
	    		
	            if(valorCaracter != null && posicion < 11) {
	            	sumaDigitos=(sumaDigitos+(valorCaracter*pesoPosicion[posicion]))%23;
	            }
	            posicion++;
			}
	    	 dcCalculado+=letraDc.charAt(sumaDigitos);
		}
	    
	    if(!dcCalculado.equalsIgnoreCase(refCatastral.substring(18,20))){
	        return false;
	    }
	    return true;

	}
	
	@Override
	public List<VActivoCatastro> getListActivoCatastroByIdActivo(Long id) {
		
		Activo activo = activoApi.getActivoMatrizIfIsUA(id);
		return genericDao.getList(VActivoCatastro.class, genericDao.createFilter(FilterType.EQUALS,  "idActivo", activo.getId()));
	}
	
	@Override
	@Transactional(readOnly = false)
	public void updateReferenciaCatastro(UpdateReferenciaCatastroDto data) {
		ActivoCatastro activoCatastro = genericDao.get(ActivoCatastro.class, genericDao.createFilter(FilterType.EQUALS, "id", data.getIdActivoCatastro()));
		
		if(activoCatastro != null) {
			if(data.getValorCatastralConst() != null) activoCatastro.setValorCatastralConst(data.getValorCatastralConst());
			if(data.getValorCatastralSuelo() != null) activoCatastro.setValorCatastralSuelo(data.getValorCatastralSuelo());
			if(!Checks.isFechaNula(data.getFechaRevValorCatastral())) activoCatastro.setFechaRevValorCatastral(data.getFechaRevValorCatastral());
			genericDao.save(ActivoCatastro.class, activoCatastro);
		}
		
	}
}