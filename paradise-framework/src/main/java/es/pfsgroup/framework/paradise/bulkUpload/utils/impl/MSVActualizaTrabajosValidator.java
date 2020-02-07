package es.pfsgroup.framework.paradise.bulkUpload.utils.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
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
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
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
public class MSVActualizaTrabajosValidator extends MSVExcelValidatorAbstract {
    
    public static final String PERFIL_GESTOR = "HAYAGESACT";
    public static final String PERFIL_SUPERVISOR = "HAYASUPACT";
    
    public static final String GESTOR_MANTENIMIENTO = "GACT";
    public static final String SUPERVISOR_MANTENIMIENTO = "SUPACT";
    
    public static final String ESTADO_TAREA = "Resultado actuaci%n t%cnica % tarificada";
			
	public static final String TRABAJO_NO_EXISTE = "El trabajo no existe.";
	public static final String PROVEEDOR_NO_EXISTE = "El código del proveedor no existe.";
	public static final String USUARIO_CONTACTO_VACIO = "Si el campo código proveedor está relleno, el usuario de contacto también debe estarlo.";
	public static final String USUARIO_NO_PERTENECE = "El usuario no pertenece al proveedor indicado.";
	public static final String USERNAME_NO_EXISTE = "El usuario no existe.";
	public static final String USERNAME_CONTACTO_NO_EXISTE = "El usuario de contacto no existe.";
	public static final String USERNAME_RESPONSABLE_NO_EXISTE= "El usuario responsable del trabajo no existe.";
	public static final String GESTOR_NO_EXISTE = "El gestor del activo no existe.";
	public static final String SUPERVISOR_NO_EXISTE = "El supervisor no existe.";
	public static final String PERFIL_GESTOR_ERRONEO = "El gestor del activo debe tener el perfil " + PERFIL_GESTOR + ".";
	public static final String PERFIL_SUPERVISOR_ERRONEO = "El supervisor del activo debe tener el perfil " + PERFIL_SUPERVISOR + ".";
	public static final String TIPOLOGIA_ERRONEA = "La tipología del proveedor no coincide con una de las indicadas.";
	public static final String RESPONSABLE_ERRONEO = "El tipo del responsable del trabajo no está entre los permitidos.";
	public static final String ERROR_TAREA = "El proveedor no se puede modificar, tareas resultado de la actuación completadas.";
	
	public static final Integer COL_NUM_TRABAJO = 0;
	public static final Integer COL_CODIGO_PROVEEDOR = 1;
	public static final Integer COL_USUARIO_CONTACTO = 2;
	public static final Integer COL_RESPONSABLE_TRABAJO = 3;
	public static final Integer COL_GESTOR_ACTIVO = 4;
	public static final Integer COL_SUPERVISOR_ACTIVO = 5;
	/*              
	 *              Mantenimiento técnico 05
	 *              Certificadora 06
	 *              Aseguradora 03
	 *              Gestoría 01
    */
	public static final String[] TIPOLOGIAS = new String[]{ "05","06","03","01" }; 
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
			// if (!isActiveExists(exc)){
			Map<String, List<Integer>> mapaErrores = new HashMap<String, List<Integer>>();
			mapaErrores.put(TRABAJO_NO_EXISTE, isTrabajoNotExistsRows(exc));
			mapaErrores.put(PROVEEDOR_NO_EXISTE, isProveedorNotExistRows(exc));
			mapaErrores.put(USUARIO_CONTACTO_VACIO, isProveedorAndNotContacto(exc));
			mapaErrores.put(USUARIO_NO_PERTENECE, perteneceContactoAProveedor(exc));
			mapaErrores.put(USERNAME_CONTACTO_NO_EXISTE, isUsuarioNotExistsRows(exc, COL_USUARIO_CONTACTO));
			mapaErrores.put(USERNAME_RESPONSABLE_NO_EXISTE, isUsuarioNotExistsRows(exc, COL_RESPONSABLE_TRABAJO));
			mapaErrores.put(GESTOR_NO_EXISTE, isUsuarioNotExistsRows(exc, COL_GESTOR_ACTIVO));
			mapaErrores.put(SUPERVISOR_NO_EXISTE, isUsuarioNotExistsRows(exc, COL_SUPERVISOR_ACTIVO));
			mapaErrores.put(PERFIL_GESTOR_ERRONEO, isUserNotInPerfil(exc, COL_GESTOR_ACTIVO, PERFIL_GESTOR));
			mapaErrores.put(PERFIL_SUPERVISOR_ERRONEO, isUserNotInPerfil(exc, COL_SUPERVISOR_ACTIVO, PERFIL_SUPERVISOR));
			mapaErrores.put(TIPOLOGIA_ERRONEA, isUserInTipologia(exc));
			mapaErrores.put(RESPONSABLE_ERRONEO, isUserGestorOrSupervisorMantenimiento(exc));
			mapaErrores.put(ERROR_TAREA, esTareaCompletada(exc));

			if (!mapaErrores.get(TRABAJO_NO_EXISTE).isEmpty() 
			        || !mapaErrores.get(PROVEEDOR_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(USUARIO_CONTACTO_VACIO).isEmpty()
					|| !mapaErrores.get(USUARIO_NO_PERTENECE).isEmpty()
					|| !mapaErrores.get(USERNAME_CONTACTO_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(USERNAME_RESPONSABLE_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(GESTOR_NO_EXISTE).isEmpty()
					|| !mapaErrores.get(SUPERVISOR_NO_EXISTE).isEmpty()
			        || !mapaErrores.get(PERFIL_GESTOR_ERRONEO).isEmpty()
                    || !mapaErrores.get(PERFIL_SUPERVISOR_ERRONEO).isEmpty()
                    || !mapaErrores.get(TIPOLOGIA_ERRONEA).isEmpty()
                    || !mapaErrores.get(RESPONSABLE_ERRONEO).isEmpty()
                    || !mapaErrores.get(ERROR_TAREA).isEmpty()){
			    
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
		
	   private List<Integer> isUsuarioNotExistsRows(MSVHojaExcel exc, Integer nCol){
	        List<Integer> listaFilas = new ArrayList<Integer>();
	        
	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    String username = exc.dameCelda(i, nCol);
	                    if(!Checks.esNulo(username) 
	                            && Boolean.FALSE.equals(particularValidator.existeUsuario(username)))
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
	
	   private List<Integer> isTrabajoNotExistsRows(MSVHojaExcel exc){
	       List<Integer> listaFilas = new ArrayList<Integer>();

	        try{
	            for(int i=1; i<this.numFilasHoja;i++){
	                try {
	                    if(!Checks.esNulo(exc.dameCelda(i, COL_NUM_TRABAJO)) 
	                            && Boolean.FALSE.equals(particularValidator.existeTrabajo(exc.dameCelda(i, COL_NUM_TRABAJO))))
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
	   
	   private List<Integer> isProveedorNotExistRows(MSVHojaExcel exc){
           List<Integer> listaFilas = new ArrayList<Integer>();

            try{
                for(int i=1; i<this.numFilasHoja;i++){
                    try {
                        if(!Checks.esNulo(exc.dameCelda(i, COL_CODIGO_PROVEEDOR)) 
                                && Boolean.FALSE.equals(particularValidator.existeProveedorByCodRem(exc.dameCelda(i, COL_CODIGO_PROVEEDOR))))
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
	
       private List<Integer> isProveedorAndNotContacto(MSVHojaExcel exc){
           List<Integer> listaFilas = new ArrayList<Integer>();

            try{
                for(int i=1; i<this.numFilasHoja;i++){
                    try {
                        
                        if(Checks.esNulo(exc.dameCelda(i, COL_USUARIO_CONTACTO)) 
                                && !Checks.esNulo(exc.dameCelda(i, COL_CODIGO_PROVEEDOR)))
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
	   
       private List<Integer> perteneceContactoAProveedor(MSVHojaExcel exc){
           List<Integer> listaFilas = new ArrayList<Integer>();

            try{
                for(int i=1; i<this.numFilasHoja;i++){
                    try {
                        String usrContacto = exc.dameCelda(i, COL_USUARIO_CONTACTO);
                        String codProveedor = exc.dameCelda(i, COL_USUARIO_CONTACTO);
                        if(Checks.esNulo(usrContacto) && !Checks.esNulo(codProveedor)) 
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
	
       private List<Integer> isUserNotInPerfil(MSVHojaExcel exc, Integer col, String perfil){
           List<Integer> listaFilas = new ArrayList<Integer>();

            try{
                for(int i=1; i<this.numFilasHoja;i++){
                    try {
                        String usrContacto = exc.dameCelda(i, col);
                        if(!Checks.esNulo(usrContacto) && Boolean.TRUE.equals(particularValidator.esPerfilErroneo(perfil, usrContacto)))
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
	
       private List<Integer> isUserInTipologia(MSVHojaExcel exc){
           List<Integer> listaFilas = new ArrayList<Integer>();

            try{
                for(int i=1; i<this.numFilasHoja;i++){
                    try {
                        String proveedor = exc.dameCelda(i, COL_CODIGO_PROVEEDOR);
                        if(!Checks.esNulo(proveedor) 
                                && Boolean.TRUE.equals(particularValidator.isProveedorInTipologias(proveedor, TIPOLOGIAS)))
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
       
       private List<Integer> isUserGestorOrSupervisorMantenimiento(MSVHojaExcel exc){
           List<Integer> listaFilas = new ArrayList<Integer>();
           
           try{
               for(int i=1; i<this.numFilasHoja;i++){
                   try {
                       String username= exc.dameCelda(i, COL_RESPONSABLE_TRABAJO);
                       
                       if(!Checks.esNulo(username) && 
                          (!particularValidator.isUserGestorType(username, GESTOR_MANTENIMIENTO)
                          || !particularValidator.isUserGestorType(username, SUPERVISOR_MANTENIMIENTO))
                          )
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
   
       private List<Integer> esTareaCompletada(MSVHojaExcel exc) {
           List<Integer> listaFilas = new ArrayList<Integer>();
           
           try{
               for(int i=1; i<this.numFilasHoja;i++){
                   try {
                       String numTrabajo= exc.dameCelda(i, COL_NUM_TRABAJO);
                       
                       if(!Checks.esNulo(numTrabajo) && 
                          Boolean.TRUE.equals(particularValidator.esTareaCompletada(numTrabajo, ESTADO_TAREA))
                          )
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

}
