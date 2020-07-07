package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelRepoApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVProcesoApi;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessCompositeValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidationFactory;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidationRunner;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidators;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVValidationResult;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVMultiColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVExcelFileItemDto;
import es.pfsgroup.framework.paradise.bulkUpload.dto.ResultadoValidacion;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.MSVExcelParser;

@Component
public class MSVMasivaSuministrosValidator extends MSVExcelValidatorAbstract {
		
	public static final String NUM_ACTIVO_NO_EXISTE = "El número del activo no existe.";
	
	//Mensajes de errores de los diccionarios
	public static final String TIPO_SUMINISTRO_ERROR = "El tipo de suministro no es correcto.";
	public static final String SUBTIPO_SUMINISTRO_ERROR = "El subtipo de suministro no es correcto.";
	public static final String PERIODICIDAD_ERROR = "La periocidad no es correcto.";
	public static final String MOT_ALTA_SUMINISTRO_ERROR = "El motivo alta suministro no es correcto.";
	public static final String MOT_BAJA_SUMINISTRO_ERROR = "El motivo baja suministro no es correcto.";
	
	//Mensajes de errores de los campos de fechas
	public static final String FECHA_ALTA_SUMINISTRO_ERROR = "El formato de la fecha del campo 'Fecha Alta suministro' debe de ser: dd/mm/yyyy";
	public static final String FECHA_BAJA_SUMINISTRO_ERROR = "El formato de la fecha del campo 'Fecha Baja suministro' debe de ser: dd/mm/yyyy";
	
	//Mensajes de errores de los campos booleanos

	public static final String DOMICILIADO_ERROR = "El campo 'Domiciliado' solo puede estar rellenado con 'SI' para sí y 'NO' para no.";
	public static final String C_VALIDACION_SUMINISTRO_ERROR = "El campo 'Check Validación suministro' solo puede estar rellenado con 'SI' para sí y 'NO' para no.";
	
	public static final String MOT_BAJA_SUMINISTRO_NO_RELLENADO = "El campo 'Fecha Baja suministro' solo puede estar rellenado si el campo 'Motivo Baja suministro' está rellenado.";
	public static final String FECHA_BAJA_SUMINISTRO_NO_RELLENADO = "El campo 'Motivo Baja suministro' solo puede estar rellenado si el campo 'Fecha Baja suministro' está rellenado.";
	public static final String COMP_SUMINISTRADORA_ERROR = "La compañía suministradora no existe.";
	
	public static final String C_VAL_SUM_RELLENO_ES_USU_GEST_SUPER = "El campo 'Check Validación suministro' solo puede estar rellenado si el usuario que está realizando la carga masiva es un gestor o supervisor de administración.";
	public static final String GESTORIA_ADMINISTRACION_ACTIVO_ERROR = "Al ser un usuario con perfil de 'Gestoría de administración' solo puedes modificar activos que su gestoría sea 'Gestoría de administración'";
	
	
	private static final int FILA_DATOS = 1;

	private static final int NUM_COLS = 13;

	private static final int COL_NUM_ACTIVO = 0;
	private static final int COL_TIPO_SUMINISTRO = 1;
	private static final int COL_SUBTIPO_SUMINISTRO = 2;
	private static final int COL_COMP_SUMINISTRADORA = 3;
	private static final int COL_DOMICILIADO = 4;
	private static final int COL_N_CONTRATO = 5;
	private static final int COL_N_CUPS = 6;
	private static final int COL_PERIOCIDAD = 7;
	private static final int COL_F_ALTA_SUMINISTRO = 8;
	private static final int COL_MOTIVO_ALTA_SUMINISTRO = 9;
	private static final int COL_F_BAJA_SUMINISTRO = 10;
	private static final int COL_MOTIVO_BAJA_SUMINISTRO = 11;
	private static final int COL_C_VALIDACION_SUMINISTRO = 12;
	private static final String[] listaValidos = { "S", "N", "SI", "NO" };
	private static final String[] listaValidosPositivos = { "S", "SI" };
	private static final String[] listaValidosNegativos = { "N", "NO" };
	
	public static final String GESTORIAADMINISTRACION = "GIAADMT";
	public static final String PEFGESTORIAADMINISTRACION = "HAYAGESTADMT";
	public static final String TIPOGESTGESTADM = "GADMT";
	public static final String TIPOGESTSUPERADM = "SADM";
	public static final String PEFGESTADM = "HAYAADM";
	public static final String PEFSUPERADM = "HAYASADM";
	
	
	
	
	@Autowired
	private MSVExcelParser excelParser;
	
	@Autowired
	private MSVBusinessValidationFactory validationFactory;
	
	@Autowired
	private MSVBusinessValidationRunner validationRunner;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private ParticularValidatorApi particularValidator;
	
	@Autowired
	private MSVProcesoApi msvProcesoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Resource
    MessageService messageServices;
	
	private Integer numFilasHoja;
	
	protected final Log logger = LogFactory.getLog(getClass());

	@Override
	public MSVDtoValidacion validarContenidoFichero(MSVExcelFileItemDto dtoFile) throws Exception {
		if (dtoFile.getIdTipoOperacion() == null){
			throw new IllegalArgumentException("idTipoOperacion no puede ser null");
		}
		List<String> lista = recuperarFormato(dtoFile.getIdTipoOperacion());
		MSVHojaExcel exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		MSVHojaExcel excPlantilla = excelParser.getExcel(recuperarPlantilla(dtoFile.getIdTipoOperacion()));
		MSVBusinessValidators validators = validationFactory.getValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVBusinessCompositeValidators compositeValidators = validationFactory.getCompositeValidators(getTipoOperacion(dtoFile.getIdTipoOperacion()));
		MSVDtoValidacion dtoValidacionContenido = recorrerFichero(exc, excPlantilla, lista, validators, compositeValidators, true);
		MSVDDOperacionMasiva operacionMasiva = msvProcesoApi.getOperacionMasiva(dtoFile.getIdTipoOperacion());
		
		//Validaciones especificas no contenidas en el fichero Excel de validacion
		exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
		//Obtenemos el numero de filas reales que tiene la hoja excel a examinar
		try {
			this.numFilasHoja = exc.getNumeroFilasByHoja(0, operacionMasiva);
		} catch (Exception e) {
			logger.error(e.getMessage());
			e.printStackTrace();
		}
		
		if (!dtoValidacionContenido.getFicheroTieneErrores()) {
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			mapaErrores.put(NUM_ACTIVO_NO_EXISTE, isNumActivoNotExistsRows(exc));
			
			mapaErrores.put(TIPO_SUMINISTRO_ERROR, isTipoSuministroNotExistRows(exc));
			mapaErrores.put(SUBTIPO_SUMINISTRO_ERROR, isSubtipoSuministroNotExistRows(exc));
			mapaErrores.put(PERIODICIDAD_ERROR, isPeriodicidadNotExistRows(exc));
			mapaErrores.put(MOT_ALTA_SUMINISTRO_ERROR, isMotivoAltaSuministroNotExistRows(exc));
			mapaErrores.put(MOT_BAJA_SUMINISTRO_ERROR, isMotivoBajaSuministroNotExistRows(exc));
			mapaErrores.put(COMP_SUMINISTRADORA_ERROR, isCompSuministradoraNotExistRows(exc));
			
			mapaErrores.put(FECHA_ALTA_SUMINISTRO_ERROR, isFechaValidator(exc, COL_F_ALTA_SUMINISTRO));
			mapaErrores.put(FECHA_BAJA_SUMINISTRO_ERROR, isFechaValidator(exc, COL_F_BAJA_SUMINISTRO));
			
			mapaErrores.put(FECHA_BAJA_SUMINISTRO_NO_RELLENADO, fBajaSumNoRellenado(exc));
			mapaErrores.put(MOT_BAJA_SUMINISTRO_NO_RELLENADO, motBajaSumNoRellenado(exc));
			
			mapaErrores.put(DOMICILIADO_ERROR, isBooleanValidator(exc, COL_DOMICILIADO));
			mapaErrores.put(C_VALIDACION_SUMINISTRO_ERROR, isBooleanValidator(exc, COL_C_VALIDACION_SUMINISTRO));
			
			
			mapaErrores.put(C_VAL_SUM_RELLENO_ES_USU_GEST_SUPER, checkValSumRellenoEsUsuGestOSuperAdministracion(exc));
			mapaErrores.put(GESTORIA_ADMINISTRACION_ACTIVO_ERROR, esGestActivoYUsuGestAdm(exc));

			if (!mapaErrores.get(NUM_ACTIVO_NO_EXISTE).isEmpty() 
					|| !mapaErrores.get(TIPO_SUMINISTRO_ERROR).isEmpty()
					|| !mapaErrores.get(SUBTIPO_SUMINISTRO_ERROR).isEmpty()
					|| !mapaErrores.get(PERIODICIDAD_ERROR).isEmpty()
					|| !mapaErrores.get(MOT_ALTA_SUMINISTRO_ERROR).isEmpty()
					|| !mapaErrores.get(MOT_BAJA_SUMINISTRO_ERROR).isEmpty()
					|| !mapaErrores.get(COMP_SUMINISTRADORA_ERROR).isEmpty()
					|| !mapaErrores.get(FECHA_ALTA_SUMINISTRO_ERROR).isEmpty()
					|| !mapaErrores.get(FECHA_BAJA_SUMINISTRO_ERROR).isEmpty()
					|| !mapaErrores.get(FECHA_BAJA_SUMINISTRO_NO_RELLENADO).isEmpty()
					|| !mapaErrores.get(MOT_BAJA_SUMINISTRO_NO_RELLENADO).isEmpty()
					|| !mapaErrores.get(DOMICILIADO_ERROR).isEmpty()
					|| !mapaErrores.get(C_VALIDACION_SUMINISTRO_ERROR).isEmpty()
					|| !mapaErrores.get(C_VAL_SUM_RELLENO_ES_USU_GEST_SUPER).isEmpty()
					|| !mapaErrores.get(GESTORIA_ADMINISTRACION_ACTIVO_ERROR).isEmpty()

					){
				dtoValidacionContenido.setFicheroTieneErrores(true);
				exc = excelParser.getExcel(dtoFile.getExcelFile().getFileItem().getFile());
				String nomFicheroErrores = exc.crearExcelErroresMejorado(mapaErrores);
				FileItem fileItemErrores = new FileItem(new File(nomFicheroErrores));
				dtoValidacionContenido.setExcelErroresFormato(fileItemErrores);
			}
		}
		exc.cerrar();
		
		return dtoValidacionContenido;
	}

	protected ResultadoValidacion validaContenidoCelda(String nombreColumna, String contenidoCelda, MSVBusinessValidators contentValidators) {
		ResultadoValidacion resultado = new ResultadoValidacion();
		resultado.setValido(true);
		
		if ((contentValidators != null) && (contentValidators.getValidatorForColumn(nombreColumna.trim()) != null)){
			MSVColumnValidator v = contentValidators.getValidatorForColumn(nombreColumna.trim());
			MSVValidationResult result = validationRunner.runValidation(v,contenidoCelda);
			resultado.setValido(result.isValid());
			resultado.setErroresFila(result.getErrorMessage());
		}
		return resultado;
	}

	/**
	 * Realiza validaciones multivalor con diferentes valores de la fila
	 * @param mapaDatos
	 * @param compositeValidators
	 * @return
	 */
	protected ResultadoValidacion validaContenidoFila(
			Map<String, String> mapaDatos,
			List<String> listaCabeceras,
			MSVBusinessCompositeValidators compositeValidators) {
		ResultadoValidacion resultado = new ResultadoValidacion();
		resultado.setValido(true);
		
		if (compositeValidators != null) {
			List<MSVMultiColumnValidator> listaValidadores = compositeValidators.getValidatorForColumns(listaCabeceras);
			if (listaValidadores != null) {
				MSVValidationResult result = validationRunner.runCompositeValidation(listaValidadores, mapaDatos);
				resultado.setValido(result.isValid());
				resultado.setErroresFila(result.getErrorMessage());
			}
		}
		return resultado;
	}
	
	public File recuperarPlantilla(Long idTipoOperacion)  {
		try {
			FileItem fileItem = proxyFactory.proxy(ExcelRepoApi.class).dameExcelByTipoOperacion(idTipoOperacion);
			return fileItem.getFile();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	private boolean esBorrar(String cadena) {
		return cadena.toUpperCase().trim().equals("X");
	}
	
	private List<Integer> isNumActivoNotExistsRows(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, COL_NUM_ACTIVO)) && Boolean.FALSE.equals(particularValidator.existeActivo(exc.dameCelda(i, COL_NUM_ACTIVO))))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e) {
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private List<Integer> isTipoSuministroNotExistRows(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                     if(!Checks.esNulo(exc.dameCelda(i, COL_TIPO_SUMINISTRO)) 
                             && Boolean.FALSE.equals(particularValidator.existeTipoSuministroByCod(exc.dameCelda(i, COL_TIPO_SUMINISTRO))))
                         listaFilas.add(i);
                 } catch (ParseException e) {
                     listaFilas.add(i);
                 }
             }
             } catch (IllegalArgumentException e) {
                 listaFilas.add(0);
                 e.printStackTrace();
             } catch (IOException e) {
                 listaFilas.add(0);
                 e.printStackTrace();
             }
         return listaFilas;   
    }
	
	private List<Integer> isSubtipoSuministroNotExistRows(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                     if(!Checks.esNulo(exc.dameCelda(i, COL_SUBTIPO_SUMINISTRO)) 
                             && Boolean.FALSE.equals(particularValidator.existeSubtipoSuministroByCod(exc.dameCelda(i, COL_SUBTIPO_SUMINISTRO))))
                         listaFilas.add(i);
                 } catch (ParseException e) {
                     listaFilas.add(i);
                 }
             }
             } catch (IllegalArgumentException e) {
                 listaFilas.add(0);
                 e.printStackTrace();
             } catch (IOException e) {
                 listaFilas.add(0);
                 e.printStackTrace();
             }
         return listaFilas;   
    }
	
	private List<Integer> isPeriodicidadNotExistRows(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                     if(!Checks.esNulo(exc.dameCelda(i, COL_PERIOCIDAD)) 
                             && Boolean.FALSE.equals(particularValidator.existePeriodicidadByCod(exc.dameCelda(i, COL_PERIOCIDAD))))
                         listaFilas.add(i);
                 } catch (ParseException e) {
                     listaFilas.add(i);
                 }
             }
             } catch (IllegalArgumentException e) {
                 listaFilas.add(0);
                 e.printStackTrace();
             } catch (IOException e) {
                 listaFilas.add(0);
                 e.printStackTrace();
             }
         return listaFilas;   
    }
	
	private List<Integer> isMotivoAltaSuministroNotExistRows(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                     if(!Checks.esNulo(exc.dameCelda(i, COL_MOTIVO_ALTA_SUMINISTRO)) 
                             && Boolean.FALSE.equals(particularValidator.existeMotivoAltaSuministroByCod(exc.dameCelda(i, COL_MOTIVO_ALTA_SUMINISTRO))))
                         listaFilas.add(i);
                 } catch (ParseException e) {
                     listaFilas.add(i);
                 }
             }
             } catch (IllegalArgumentException e) {
                 listaFilas.add(0);
                 e.printStackTrace();
             } catch (IOException e) {
                 listaFilas.add(0);
                 e.printStackTrace();
             }
         return listaFilas;   
    }
	
	private List<Integer> isMotivoBajaSuministroNotExistRows(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                     if(!Checks.esNulo(exc.dameCelda(i, COL_MOTIVO_BAJA_SUMINISTRO)) 
                             && Boolean.FALSE.equals(particularValidator.existeMotivoBajaSuministroByCod(exc.dameCelda(i, COL_MOTIVO_BAJA_SUMINISTRO))))
                         listaFilas.add(i);
                 } catch (ParseException e) {
                     listaFilas.add(i);
                 }
             }
             } catch (IllegalArgumentException e) {
                 listaFilas.add(0);
                 e.printStackTrace();
             } catch (IOException e) {
                 listaFilas.add(0);
                 e.printStackTrace();
             }
         return listaFilas;   
    }
	
	private List<Integer> isCompSuministradoraNotExistRows(MSVHojaExcel exc){
        List<Integer> listaFilas = new ArrayList<Integer>();

         try{
             for(int i=1; i<this.numFilasHoja;i++){
                 try {
                     if(!Checks.esNulo(exc.dameCelda(i, COL_COMP_SUMINISTRADORA)) 
                             && Boolean.FALSE.equals(particularValidator.existeCodigoPrescriptor(exc.dameCelda(i, COL_COMP_SUMINISTRADORA))))
                         listaFilas.add(i);
                 } catch (ParseException e) {
                     listaFilas.add(i);
                 }
             }
             } catch (IllegalArgumentException e) {
                 listaFilas.add(0);
                 e.printStackTrace();
             } catch (IOException e) {
                 listaFilas.add(0);
                 e.printStackTrace();
             }
         return listaFilas;   
    }

	private List<Integer> isFechaValidator(MSVHojaExcel exc, Integer col){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					if(!Checks.esNulo(exc.dameCelda(i, col)) && !esFechaValida(exc.dameCelda(i, col)))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e) {
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}

	private List<Integer> isBooleanValidator(MSVHojaExcel exc, Integer col){
		List<Integer> listaFilas = new ArrayList<Integer>();
		
		
		try{
			for(int i=1; i<this.numFilasHoja;i++){
				try {
					String celda = exc.dameCelda(i, col);
					if(!Checks.esNulo(celda) && !Arrays.asList(listaValidos).contains(celda.toUpperCase()))
						listaFilas.add(i);
				} catch (ParseException e) {
					listaFilas.add(i);
				}
			}
		} catch (IllegalArgumentException e) {
			listaFilas.add(0);
			e.printStackTrace();
		} catch (IOException e) {
			listaFilas.add(0);
			e.printStackTrace();
		}
		
		return listaFilas;
	}
	
	private boolean esFechaValida(String fecha) {
		if(fecha == null || fecha.isEmpty()) {
			return false;
		}
		if(esBorrar(fecha))
			return true;
		try {
			String[] fechaArray = fecha.split("/");
			if(fechaArray.length != 3 || 
					(fechaArray[0].length() != 2 || fechaArray[1].length() != 2 || fechaArray[2].length() != 4)) {
				return false;
			}
			if(Integer.parseInt(fechaArray[0]) > 31 || Integer.parseInt(fechaArray[1]) > 12) {
				return false;
			}
			SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
			ft.parse(fecha);
		}catch (IllegalArgumentException e) {
			logger.error(e.getMessage());
	         return false;
		} catch (ParseException e) {
			logger.error(e.getMessage());
			return false;
		}
		return true;
	}
	
	private List<Integer> fBajaSumNoRellenado(MSVHojaExcel exc){
 	   List<Integer> listaFilas = new ArrayList<Integer>();
        
        try{
            for(int i=1; i<this.numFilasHoja;i++){
                try {
                    String fBajaSum= exc.dameCelda(i, COL_F_BAJA_SUMINISTRO);
                    String motBajaSum = exc.dameCelda(i, COL_MOTIVO_BAJA_SUMINISTRO);
                    
                    if( (fBajaSum == null || fBajaSum.isEmpty()) && (motBajaSum != null && !motBajaSum.isEmpty()))
                        listaFilas.add(i);
                        
                } catch (ParseException e) {
                    listaFilas.add(i);
                }
            }
        }catch (IllegalArgumentException e) {
            listaFilas.add(0);
            e.printStackTrace();
        } catch (IOException e) {
            listaFilas.add(0);
            e.printStackTrace();
        }
        
        return listaFilas;
    }
	
	private List<Integer> motBajaSumNoRellenado(MSVHojaExcel exc){
	 	   List<Integer> listaFilas = new ArrayList<Integer>();
	        
	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    String fBajaSum= exc.dameCelda(i, COL_F_BAJA_SUMINISTRO);
	                    String motBajaSum = exc.dameCelda(i, COL_MOTIVO_BAJA_SUMINISTRO);
	                    
	                    if( (motBajaSum == null || motBajaSum.isEmpty()) && (fBajaSum != null && !fBajaSum.isEmpty()))
	                        listaFilas.add(i);
	                        
	                } catch (ParseException e) {
	                    listaFilas.add(i);
	                }
	            }
	        }catch (IllegalArgumentException e) {
	            listaFilas.add(0);
	            e.printStackTrace();
	        } catch (IOException e) {
	            listaFilas.add(0);
	            e.printStackTrace();
	        }
	        
	        return listaFilas;
	    }
	
	//Caso pef perfiles
	private List<Integer> checkValSumRellenoEsUsuGestOSuperAdministracion(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		//String usernameLogado = msvProcesoApi.getUsername();	
		Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

		try{
            for(int i=1; i<this.numFilasHoja;i++){
				try{
					String cValidacionSum = exc.dameCelda(i, COL_C_VALIDACION_SUMINISTRO);
					if(cValidacionSum != null && !cValidacionSum.isEmpty() 
							&& Arrays.asList(listaValidos).contains(cValidacionSum.toUpperCase())){
		
						List<Perfil> perfiles = usu.getPerfiles();
						if(perfiles != null && !perfiles.isEmpty()) {
							Perfil perfilGestAdm = genericDao.get(Perfil.class, genericDao.createFilter(FilterType.EQUALS, "codigo", PEFGESTADM));
							Perfil perfilSuperAdm = genericDao.get(Perfil.class, genericDao.createFilter(FilterType.EQUALS, "codigo", PEFSUPERADM));
							if(!perfiles.contains(perfilGestAdm) || !perfiles.contains(perfilSuperAdm)) {
								 listaFilas.add(i);
							}
						}
					}
				}catch(ParseException e){
					listaFilas.add(i);
				}
            }
        }catch (IllegalArgumentException e) {
            listaFilas.add(0);
            e.printStackTrace();
        } catch (IOException e) {
            listaFilas.add(0);
            e.printStackTrace();
        }
		
		return listaFilas;
	}
		
	private List<Integer> esGestActivoYUsuGestAdm(MSVHojaExcel exc){
		List<Integer> listaFilas = new ArrayList<Integer>();
		Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

		try{
            for(int i=1; i<this.numFilasHoja;i++){
				try{
					String numActivo = exc.dameCelda(i, COL_NUM_ACTIVO);
					List<Perfil> perfiles = usu.getPerfiles();
					Perfil perfilGestAdm = genericDao.get(Perfil.class, genericDao.createFilter(FilterType.EQUALS, "codigo", PEFGESTORIAADMINISTRACION));
					
					
					if(numActivo != null && !numActivo.isEmpty() 
						&& perfiles != null && !perfiles.isEmpty()
						&& perfiles.contains(perfilGestAdm)
						&& Boolean.FALSE.equals(particularValidator.esMismoTipoGestorActivo(GESTORIAADMINISTRACION, numActivo))){
							listaFilas.add(i);
					}
				}catch(ParseException e){
					listaFilas.add(i);
				}
            }
        }catch (IllegalArgumentException e) {
            listaFilas.add(0);
            e.printStackTrace();
        } catch (IOException e) {
            listaFilas.add(0);
            e.printStackTrace();
        }
		
		return listaFilas;
	}
}
