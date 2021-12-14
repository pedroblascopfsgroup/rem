package es.pfsgroup.plugin.rem.activo.catastro;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.CatastroApi;
import es.pfsgroup.plugin.rem.controller.ActivoController;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoCatastro;
import es.pfsgroup.plugin.rem.model.ActivoInfoComercial;
import es.pfsgroup.plugin.rem.model.ActivoInfoRegistral;
import es.pfsgroup.plugin.rem.model.Catastro;
import es.pfsgroup.plugin.rem.model.DtoDatosCatastro;
import es.pfsgroup.plugin.rem.model.DtoDatosCatastroGrid;
import es.pfsgroup.plugin.rem.thread.ValidarCatastroAsincrono;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;

@Service("catastroManager")
public class CatastroManager implements CatastroApi {
	
    @Autowired
	private ActivoDao activoDao;
    
    protected static final Log logger = LogFactory.getLog(ActivoController.class);
    
	private static final String PROB_MUY_BAJA = "Muy baja";
	private static final String PROB_BAJA = "Baja";
	private static final String PROB_MEDIA = "Media";
	private static final String PROB_ALTA = "Alta";
	private static final String PROB_MUY_ALTA = "Muy alta";
	
	private static final String COINCIDENCIA_OK = "OK";
	private static final String COINCIDENCIA_KO = "KO";
	
	private static final String SUPERFICIE_CONSTRUIDA= "Superficie construida";
	private static final String SUPERFICIE_PARCELA= "Superficie Parcela";
	private static final String GEODISTANCIA= "Geodistancia";
	private static final String ANYO_CONSTRUCCION= "Año construcción";
	private static final String TIPO_VIA= "Tipo vía";
	private static final String CODIGO_POSTAL= "Código postal";
	private static final String MUNICIPIO= "Superficie construida";
	private static final String PROVINCIA= "Provincia";
	private static final String NOMBRE_CALLE= "Nombre calle";
	
	
    @Autowired
	private GenericABMDao genericDao;
    @Autowired
	private GenericAdapter genericAdapter;
    
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
			dto.setTipoVia(activo.getTipoVia().getCodigo());
			dto.setNombreVia(activo.getNombreVia());
			dto.setNumeroVia(activo.getNumeroDomicilio());
			
			if(infoR != null) {
				dto.setSuperficieParcela((double) infoR.getSuperficieParcela());
			}
			if(infoC != null) {
				dto.setAnyoConstruccion(infoC.getAnyoConstruccion());
			}
		}
		return dto;
	}
	
	public List<DtoDatosCatastro> getDatosCatastroWs(Long idActivo) {
		List<DtoDatosCatastro> listDto = new ArrayList<DtoDatosCatastro>();
		
		DtoDatosCatastro dto = this.getDatosCatastroRem(idActivo);
		DtoDatosCatastro dto2 = this.getDatosCatastroRem(idActivo);
		dto.setRefCatastral("Prueba");
		dto2.setRefCatastral("Prueba2");
		
		listDto.add(dto);
		listDto.add(dto2);
		
		return listDto;
	}



	@Override
	public List<DtoDatosCatastroGrid> validarCatastro(DtoDatosCatastro dtoCatastroRem, DtoDatosCatastro dtoCatastro) {
		
		List<DtoDatosCatastroGrid> listDto = new ArrayList<DtoDatosCatastroGrid>();
		try {
			
			DtoDatosCatastroGrid dtoSP = new DtoDatosCatastroGrid();
			
			if(dtoCatastroRem.getSuperficieParcela() != null && dtoCatastro.getSuperficieParcela() != null) {
				dtoSP.setNombre(SUPERFICIE_PARCELA);
				dtoSP.setDatoRem(dtoCatastroRem.getSuperficieParcela().toString());
				dtoSP.setDatoCatastro(dtoCatastro.getSuperficieParcela().toString());
				dtoSP.setCoincidencia(calculoCoincidencia(calculoValor(dtoCatastroRem.getSuperficieParcela(),dtoCatastro.getSuperficieParcela())));
				dtoSP.setProbabilidad("");
			}else {
				dtoSP.setNombre(SUPERFICIE_PARCELA);
				dtoSP.setDatoRem(dtoCatastroRem.getSuperficieParcela() == null ? "" : dtoCatastroRem.getSuperficieParcela().toString());
				dtoSP.setDatoCatastro(dtoCatastro.getSuperficieParcela() == null ? "" : dtoCatastro.getSuperficieParcela().toString());
				dtoSP.setProbabilidad("");
			}
			listDto.add(dtoSP);
			
			DtoDatosCatastroGrid dtoSC = new DtoDatosCatastroGrid();
			if(dtoCatastroRem.getSuperficieConstruida() != null && dtoCatastro.getSuperficieConstruida() != null) {
				dtoSC.setNombre(SUPERFICIE_CONSTRUIDA);
				dtoSC.setDatoRem(dtoCatastroRem.getSuperficieConstruida().toString());
				dtoSC.setDatoCatastro(dtoCatastro.getSuperficieConstruida().toString());
				dtoSC.setCoincidencia(calculoCoincidencia(calculoValor(dtoCatastroRem.getSuperficieConstruida(),dtoCatastro.getSuperficieConstruida())));
				dtoSC.setProbabilidad("");
			}else {
				dtoSC.setNombre(SUPERFICIE_CONSTRUIDA);
				dtoSC.setDatoRem(dtoCatastroRem.getSuperficieConstruida() == null ? "" : dtoCatastroRem.getSuperficieConstruida().toString());
				dtoSC.setDatoCatastro(dtoCatastro.getSuperficieConstruida() == null ? "" : dtoCatastro.getSuperficieConstruida().toString());
				dtoSC.setProbabilidad("");
			}
			listDto.add(dtoSC);
			
			DtoDatosCatastroGrid dtoGeo = new DtoDatosCatastroGrid();
			if(dtoCatastroRem.getGeodistancia() != null && dtoCatastro.getGeodistancia() != null) {
				dtoGeo.setNombre(GEODISTANCIA);
				dtoGeo.setDatoRem(dtoCatastroRem.getGeodistancia().toString());
				dtoGeo.setDatoCatastro(dtoCatastro.getGeodistancia().toString());
				dtoGeo.setCoincidencia(calculoCoincidencia(calculoValor(dtoCatastroRem.getGeodistancia(),dtoCatastro.getGeodistancia())));
				dtoGeo.setProbabilidad("");
			}else {
				dtoGeo.setNombre(GEODISTANCIA);
				dtoGeo.setDatoRem(dtoCatastroRem.getGeodistancia() == null ? "" : dtoCatastroRem.getGeodistancia().toString());
				dtoGeo.setDatoCatastro(dtoCatastro.getGeodistancia() == null ? "" : dtoCatastro.getGeodistancia().toString());
				dtoGeo.setProbabilidad("");
			}
			listDto.add(dtoGeo);
			
			DtoDatosCatastroGrid dtoAC = new DtoDatosCatastroGrid();
			if(dtoCatastroRem.getAnyoConstruccion() != null && dtoCatastro.getAnyoConstruccion() != null) {
				dtoAC.setNombre(ANYO_CONSTRUCCION);
				dtoAC.setDatoRem(dtoCatastroRem.getAnyoConstruccion().toString());
				dtoAC.setDatoCatastro(dtoCatastro.getAnyoConstruccion().toString());
				dtoAC.setCoincidencia(calculoIgual(dtoCatastroRem.getAnyoConstruccion().toString(),dtoCatastro.getAnyoConstruccion().toString()));
				dtoAC.setProbabilidad("");
			}else {
				dtoAC.setNombre(ANYO_CONSTRUCCION);
				dtoAC.setDatoRem(dtoCatastroRem.getAnyoConstruccion() == null ? "" : dtoCatastroRem.getAnyoConstruccion().toString());
				dtoAC.setDatoCatastro(dtoCatastro.getAnyoConstruccion() == null ? "" : dtoCatastro.getAnyoConstruccion().toString());
				dtoAC.setProbabilidad("");
			}
			
			listDto.add(dtoAC); 
			
			DtoDatosCatastroGrid dtoTP = new DtoDatosCatastroGrid();
			if((dtoCatastroRem.getTipoVia() != null && !dtoCatastroRem.getTipoVia().isEmpty()) 
					&& (dtoCatastro.getTipoVia() != null && !dtoCatastro.getTipoVia().isEmpty())) {
				dtoTP.setNombre(TIPO_VIA);
				dtoTP.setDatoRem(dtoCatastroRem.getTipoVia());
				dtoTP.setDatoCatastro(dtoCatastro.getTipoVia());
				dtoTP.setCoincidencia(calculoIgual(dtoCatastroRem.getTipoVia(),dtoCatastro.getTipoVia()));
				dtoTP.setProbabilidad("");
			}else {
				dtoTP.setNombre(TIPO_VIA);
				dtoTP.setDatoRem(dtoCatastroRem.getTipoVia() == null ? "" : dtoCatastroRem.getTipoVia());
				dtoTP.setDatoCatastro(dtoCatastro.getTipoVia() == null ? "" : dtoCatastro.getTipoVia());
				dtoTP.setProbabilidad("");
			}
	
			listDto.add(dtoTP);
			
			DtoDatosCatastroGrid dtoCP = new DtoDatosCatastroGrid();
			if((dtoCatastroRem.getCodigoPostal() != null && dtoCatastroRem.getCodigoPostal().isEmpty())  
					&& (dtoCatastro.getCodigoPostal() != null && !dtoCatastro.getCodigoPostal().isEmpty())) {
				dtoCP.setNombre(CODIGO_POSTAL);
				dtoCP.setDatoRem(dtoCatastroRem.getCodigoPostal());
				dtoCP.setDatoCatastro(dtoCatastro.getCodigoPostal());
				dtoCP.setCoincidencia(calculoIgual(dtoCatastroRem.getCodigoPostal(),dtoCatastro.getCodigoPostal()));
				dtoCP.setProbabilidad("");
					
			}else {
				dtoCP.setNombre(CODIGO_POSTAL);
				dtoCP.setDatoRem(dtoCatastroRem.getCodigoPostal() == null ? "" : dtoCatastroRem.getCodigoPostal());
				dtoCP.setDatoCatastro(dtoCatastro.getCodigoPostal() == null ? "" : dtoCatastro.getCodigoPostal());
				dtoCP.setProbabilidad("");
			}
			
			listDto.add(dtoCP);
			
			DtoDatosCatastroGrid dtoMu = new DtoDatosCatastroGrid();
			if((dtoCatastroRem.getMunicipio() != null && !dtoCatastroRem.getMunicipio().isEmpty()) 
					&& (dtoCatastro.getMunicipio() != null && !dtoCatastro.getMunicipio().isEmpty())) {
				dtoMu.setNombre(MUNICIPIO);
				dtoMu.setDatoRem(dtoCatastroRem.getMunicipio());
				dtoMu.setDatoCatastro(dtoCatastro.getMunicipio());
				dtoMu.setCoincidencia(calculoIgual(dtoCatastroRem.getMunicipio(),dtoCatastro.getMunicipio()));
				dtoMu.setProbabilidad("");
			}else {
				dtoMu.setNombre(MUNICIPIO);
				dtoMu.setDatoRem(dtoCatastroRem.getMunicipio() == null ? "" : dtoCatastroRem.getMunicipio());
				dtoMu.setDatoCatastro(dtoCatastro.getMunicipio() == null ? "" : dtoCatastro.getMunicipio());
				dtoMu.setProbabilidad("");
			}
			
			listDto.add(dtoMu);
			
			DtoDatosCatastroGrid dtoPR = new DtoDatosCatastroGrid();
			if((dtoCatastroRem.getProvincia() != null && dtoCatastroRem.getProvincia().isEmpty()) 
					&& (dtoCatastro.getProvincia() != null && !dtoCatastro.getProvincia().isEmpty())){
				dtoPR.setNombre(PROVINCIA);
				dtoPR.setDatoRem(dtoCatastroRem.getProvincia());
				dtoPR.setDatoCatastro(dtoCatastro.getProvincia());
				dtoPR.setCoincidencia(calculoIgual(dtoCatastroRem.getProvincia(),dtoCatastro.getProvincia()));
				dtoPR.setProbabilidad("");
			}else {
				dtoPR.setNombre(PROVINCIA);
				dtoPR.setDatoRem(dtoCatastroRem.getProvincia());
				dtoPR.setDatoCatastro(dtoCatastro.getProvincia());
				dtoPR.setProbabilidad("");
			}
			
			listDto.add(dtoPR);
			
			DtoDatosCatastroGrid dtoNC = new DtoDatosCatastroGrid();
			//Nombre calle
			if((dtoCatastroRem.getNombreCalle() != null && !dtoCatastroRem.getNombreCalle().isEmpty()) 
					&& (dtoCatastro.getNombreCalle() != null && !dtoCatastro.getNombreCalle().isEmpty())) {
				Double probabilidad = calculoSimilaridad(dtoCatastroRem.getNombreCalle(),dtoCatastro.getNombreCalle());
				dtoNC.setNombre(NOMBRE_CALLE);
				dtoNC.setDatoRem(dtoCatastroRem.getNombreCalle());
				dtoNC.setDatoCatastro(dtoCatastro.getNombreCalle());
				dtoNC.setCoincidencia(calculoCoincidencia(probabilidad));
				dtoNC.setProbabilidad(calculoProbabilidad(probabilidad));
			}else {
				dtoNC.setNombre(NOMBRE_CALLE);
				dtoNC.setDatoRem(dtoCatastroRem.getNombreCalle() == null ? "" : dtoCatastroRem.getNombreCalle());
				dtoNC.setDatoCatastro(dtoCatastro.getNombreCalle() == null ? "" : dtoCatastro.getNombreCalle());
				dtoNC.setProbabilidad("");
			}
			
			listDto.add(dtoNC);
		} catch (Exception e) {
			logger.error("error en CatastroManager método validarCatastro - ", e);
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
	
	private boolean calculoCoincidencia(Double valor) {
		
		boolean resultado = false;
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
	@Transactional(readOnly = false)
	public void eliminarCatastro(Long id) {
		ActivoCatastro activoCatastro = genericDao.get(ActivoCatastro.class, genericDao.createFilter(FilterType.EQUALS, "id", id));
		Auditoria.delete(activoCatastro);
		
		genericDao.save(ActivoCatastro.class, activoCatastro);
	}
	
	@Override
	@Transactional(readOnly = false)
	public void saveCatastro(Long idActivo, List<String> arrayReferencias) {
		ArrayList<String> listReferencias = new ArrayList<String>();
		Activo activo = activoDao.get(idActivo);
		for (String refCatastral : arrayReferencias) {
			Catastro catastro = genericDao.get(Catastro.class, genericDao.createFilter(FilterType.EQUALS,  "refCatastral", refCatastral));
			ActivoCatastro activoCatastro = getActivoCatastroByActivoAndReferencia(idActivo,refCatastral);
			if(catastro != null && activo != null && activoCatastro == null) {				
				activoCatastro = new ActivoCatastro();
				activoCatastro.setAuditoria(Auditoria.getNewInstance());
				activoCatastro.setActivo(activo);
				activoCatastro.setRefCatastral(refCatastral);
				genericDao.save(ActivoCatastro.class, activoCatastro);
				listReferencias.add(refCatastral);	
			}
		}
		Thread hilo = new Thread(new ValidarCatastroAsincrono(genericAdapter.getUsuarioLogado().getUsername(), listReferencias, idActivo));
		hilo.start();
	}
	
	@Override
	@Transactional
	public void validaAsincrono(ArrayList<String> refCatastralList, Long idActivo) {
		DtoDatosCatastro datosRem = getDatosCatastroRem(idActivo);
		
		for (String refCatastral : refCatastralList) {
			ActivoCatastro activoCatastro = getActivoCatastroByActivoAndReferencia(idActivo,refCatastral);
			if(activoCatastro != null) {
				DtoDatosCatastro datosCatastro = getDatosCatastroRem(idActivo);
				//GetDatosCatastroFromCatastro(refCatastral);
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
	
}