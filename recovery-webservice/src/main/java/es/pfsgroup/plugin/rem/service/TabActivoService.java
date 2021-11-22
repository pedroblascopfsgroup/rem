package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.genericService.api.GenericService;
import es.pfsgroup.plugin.rem.model.Activo;

public interface TabActivoService extends GenericService{
	
	public static final String DEFAULT_SERVICE_BEAN_KEY = "DEFAULT"; 			// Antiguo codigo de Pestana
	public static final String TAB_DATOS_BASICOS = "datosbasicos"; 					// Pestana 1
	public static final String TAB_DATOS_REGISTRALES = "datosregistrales"; 			// Pestana 2
	public static final String TAB_INFO_ADMINISTRATIVA = "infoadministrativa"; 		// Pestana 3
	public static final String TAB_CARGAS_ACTIVO = "cargasactivo"; 					// Pestana 4
	public static final String TAB_SIT_POSESORIA_LLAVES = "sitposesoriallaves"; 	// Pestana 5
	public static final String TAB_VALORACIONES_PRECIOS = "valoracionesprecios";	// Pestana 6
	public static final String TAB_INFORMACION_COMERCIAL = "informacioncomercial"; 	// Pestana 7
	public static final String TAB_INFORME_COMERCIAL = "informecomercial";
	public static final String TAB_ADMINISTRACION = "administracion";
	public static final String TAB_COMUNIDAD_PROPIETARIOS = "datosComunidad";
	public static final String TAB_DATOS_PUBLICACION = "datospublicacion";
    public static final String TAB_ACTIVO_HISTORICO_ESTADO_PUBLICACION = "activohistoricoestadopublicacion";
    public static final String TAB_ACTIVO_CONDICIONANTES_DISPONIBILIDAD = "activocondicionantesdisponibilidad";
	public static final String TAB_COMERCIAL = "comercial";
	public static final String TAB_PATRIMONIO = "patrimonio";
	public static final String TAB_PATRIMONIO_CONTRATO = "contratospatrimonio";
	public static final String TAB_PLUSVALIA = "plusvalia";
	public static final String TAB_FASE_PUBLICACION = "fasepublicacionactivo";
	public static final String TAB_SANEAMIENTO = "saneamiento";
	public static final String TAB_INFORME_FISCAL = "informefiscal";
	
    BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();
	

	/**
	 * C�digo de tipo de operaci�n para el que aplica este servicio.
	 * @return
	 */
	public String[] getCodigoTab();
	
	/**
	 * Devuelve un dto con el conjunto de datos a cargar del activo
	 * @param activo
	 * @return
	 * @throws InvocationTargetException 
	 * @throws IllegalAccessException 
	 */
	public WebDto getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException;
	
	/**
	 * Guarda un conjunto de datos del activo.
	 * @param activo
	 * @param dto
	 * @return Activo
	 */
	public Activo saveTabActivo(Activo activo, WebDto dto);
}
