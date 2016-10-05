package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoNoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;

@Component
public class MSVActualizadorPerimetroActivo implements MSVLiberator {

    protected final Log logger = LogFactory.getLog(getClass());
    
    private static final Integer CHECK_VALOR_SI = 1;
    private static final Integer CHECK_VALOR_NO = 0;
    private static final Integer CHECK_NO_CAMBIAR = -1;
    
	@Autowired
	private ApiProxyFactory proxyFactory;
		
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
    @Autowired
    private GenericAdapter adapter;
	
	
	@Override
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {
		if (!Checks.esNulo(tipoOperacion)){
			if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PERIMETRO_ACTIVO.equals(tipoOperacion.getCodigo())){
				return true;
			}else {
				return false;
			}
		}else{
			return false;
		}
	}
	
	/**
	 * Método que evalua el valor de un check en funcion de las columnas S/N/<nulo>
	 * @param cellValue
	 * @return
	 */
	private Integer getCheckValue(String cellValue){
		if(!Checks.esNulo(cellValue)){
			if("S".equalsIgnoreCase(cellValue))
				return CHECK_VALOR_SI;
			else
				return CHECK_VALOR_NO;					
		}
		
		return CHECK_NO_CAMBIAR;
		
	}

	@Override
	public Boolean liberaFichero(MSVDocumentoMasivo file) throws IllegalArgumentException, IOException {
			
		processAdapter.setStateProcessing(file.getProcesoMasivo().getId());
		MSVHojaExcel exc = proxyFactory.proxy(ExcelManagerApi.class).getHojaExcel(file);
		
		try{
			// Recorre y procesa todas las filas del fichero excel
			for (int fila = 1; fila < exc.getNumeroFilas(); fila++) {
				
				Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
				
				//Evalua si ha encontrado un registro de perimetro para el activo dado. 
				//En caso de que no exista, crea uno nuevo relacionado sin datos
				PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activo.getId());
	
				//Variables temporales para asignar valores de filas excel
				Integer tmpIncluidoEnPerimetro = getCheckValue(exc.dameCelda(fila, 1));
				Integer tmpAplicaGestion = getCheckValue(exc.dameCelda(fila, 2));
				String  tmpMotivoAplicaGestion = exc.dameCelda(fila, 3);
				Integer tmpAplicaComercializar = getCheckValue(exc.dameCelda(fila, 4));
				String  tmpMotivoComercializacion = exc.dameCelda(fila, 5);
				String  tmpMotivoNoComercializacion = exc.dameCelda(fila, 6);
				String  tmpTipoComercializacion = exc.dameCelda(fila, 7);
				
	
				perimetroActivo.setActivo(activo);
				//Incluido en perimetro
				if(!CHECK_NO_CAMBIAR.equals(tmpIncluidoEnPerimetro)) perimetroActivo.setIncluidoEnPerimetro(tmpIncluidoEnPerimetro);
				
				//Aplica gestion
				if(!CHECK_NO_CAMBIAR.equals(tmpAplicaGestion)){
					perimetroActivo.setAplicaGestion(tmpAplicaGestion);
					perimetroActivo.setFechaAplicaGestion(new Date());					
				}
				if(!Checks.esNulo(tmpMotivoAplicaGestion)) perimetroActivo.setMotivoAplicaGestion(tmpMotivoAplicaGestion);
				
				//Aplica comercializacion
				if(!CHECK_NO_CAMBIAR.equals(tmpAplicaComercializar)){
					perimetroActivo.setAplicaComercializar(tmpAplicaComercializar);
					perimetroActivo.setFechaAplicaComercializar(new Date());
				}
				//Motivo para Si comercializar
				if(!Checks.esNulo(tmpMotivoComercializacion))
					perimetroActivo.setMotivoAplicaComercializar((DDMotivoComercializacion)
						utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoComercializacion.class, tmpMotivoComercializacion));
				
				//Motivo para No comercializar
				if(!Checks.esNulo(tmpMotivoNoComercializacion))
					perimetroActivo.setMotivoNoAplicaComercializar((DDMotivoNoComercializacion)
						utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoNoComercializacion.class, tmpMotivoNoComercializacion));
				
				//Tipo de comercializacion en el activo
				if(!Checks.esNulo(tmpTipoComercializacion))
				activo.setTipoComercializacion((DDTipoComercializacion)
						utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class, tmpTipoComercializacion));
				
				//Persiste los datos, creando el registro de perimetro
				// Todos los datos son de PerimetroActivo, a excepcion del tipo comercializacion que es del Activo
				if(!Checks.esNulo(tmpTipoComercializacion)) activoApi.saveOrUpdate(activo);
				activoApi.saveOrUpdatePerimetroActivo(perimetroActivo);
	
			} //Fin for
			
			return true;
			
		} catch (Exception e){
			
			logger.error(e.getMessage());
			e.printStackTrace();
			return false;
			
		}

	}

}
