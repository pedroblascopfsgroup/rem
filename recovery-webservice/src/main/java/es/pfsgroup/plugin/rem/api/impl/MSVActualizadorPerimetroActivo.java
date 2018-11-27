package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;

import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;

import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;

@Component
public class MSVActualizadorPerimetroActivo extends AbstractMSVActualizador implements MSVLiberator {

    protected final Log logger = LogFactory.getLog(getClass());
    
    private static final Integer CHECK_VALOR_SI = 1;
    private static final Integer CHECK_VALOR_NO = 0;
    private static final Integer CHECK_NO_CAMBIAR = -1;

    @Autowired
    private ActivoAdapter activoAdapter;
	
	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private UpdaterStateApi updaterState;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_PERIMETRO_ACTIVO;
	}
	

	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws JsonViewerException, IOException, ParseException, SQLException, Exception {
		return procesaFila(exc, fila, prmToken, new Object[0]);
	}

	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken, Object[] extraArgs) throws IOException, ParseException, JsonViewerException, SQLException {
		
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
		String 	tmpDestinoComercial = exc.dameCelda(fila, 8);
		String	tmpTipoAlquiler = exc.dameCelda(fila, 9);
		Integer tmpAplicaFormalizar = getCheckValue(exc.dameCelda(fila, 10));
		String  tmpMotivoAplicaFormalizar = exc.dameCelda(fila,11);
		Integer tmpAplicaPublicar = getCheckValue(exc.dameCelda(fila, 12));
		String  tmpMotivoAplicaPublicar = exc.dameCelda(fila,13);

		perimetroActivo.setActivo(activo);
		//Incluido en perimetro		---------------------------
		if(!CHECK_NO_CAMBIAR.equals(tmpIncluidoEnPerimetro)) perimetroActivo.setIncluidoEnPerimetro(tmpIncluidoEnPerimetro);
		
		
		//Aplica gestion 			---------------------------
		if(!CHECK_NO_CAMBIAR.equals(tmpAplicaGestion)){
			perimetroActivo.setAplicaGestion(tmpAplicaGestion);
			perimetroActivo.setFechaAplicaGestion(new Date());					
		}
		if(!Checks.esNulo(tmpMotivoAplicaGestion)) perimetroActivo.setMotivoAplicaGestion(tmpMotivoAplicaGestion);
		
		
		//Aplica comercializacion	---------------------------
		// Si se quita del perimetro, forzamos el quitado de comercializacion y actualizar la situación comercial del activo a No Comercializable
		if(CHECK_VALOR_NO.equals(tmpIncluidoEnPerimetro) && !CHECK_VALOR_NO.equals(perimetroActivo.getAplicaComercializar())) tmpAplicaComercializar=0;
		
		if(!CHECK_NO_CAMBIAR.equals(tmpAplicaComercializar)){
			perimetroActivo.setAplicaComercializar(tmpAplicaComercializar);
			perimetroActivo.setFechaAplicaComercializar(new Date());
		}
		
		//Motivo para Si comercializar
		if(!Checks.esNulo(tmpMotivoComercializacion))
			perimetroActivo.setMotivoAplicaComercializar((DDMotivoComercializacion)
				utilDiccionarioApi.dameValorDiccionarioByCod(DDMotivoComercializacion.class, tmpMotivoComercializacion.substring(0, 2)));
		
		//Motivo para No comercializar
		if(!Checks.esNulo(tmpMotivoNoComercializacion))
			perimetroActivo.setMotivoNoAplicaComercializar(tmpMotivoNoComercializacion);
		
		//Tipo de comercializacion en el activo
		if(!Checks.esNulo(tmpTipoComercializacion))
			activo.setTipoComercializar((DDTipoComercializar)
				utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializar.class, tmpTipoComercializacion.substring(0, 2)));
		
		//Tipo de Destino comercial en el activo
		if(!Checks.esNulo(tmpDestinoComercial) && !Checks.esNulo(activo.getActivoPublicacion()))
			activo.getActivoPublicacion().setTipoComercializacion((DDTipoComercializacion)
					utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializacion.class, tmpDestinoComercial.substring(0, 2)));
		
		//Tipo de alquiler del activo
		if(!Checks.esNulo(tmpTipoAlquiler))
			activo.setTipoAlquiler((DDTipoAlquiler)
					utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoAlquiler.class, tmpTipoAlquiler.substring(0, 2)));
		
		
		if(CHECK_VALOR_NO.equals(tmpAplicaComercializar)) {
			//Si Comercializar es NO, forzamos también a NO => Formalizar (por si no venía informado)
			tmpAplicaFormalizar = CHECK_VALOR_NO;
			
			// Comprobamos si es necesario actualizar el estado de publicación del activo.
			activoAdapter.actualizarEstadoPublicacionActivo(activo.getId());
		}
		
		//Aplica Formalizar			---------------------------
		if(!CHECK_NO_CAMBIAR.equals(tmpAplicaFormalizar)){
			perimetroActivo.setAplicaFormalizar(tmpAplicaFormalizar);
			perimetroActivo.setFechaAplicaFormalizar(new Date());					
		} 

		if(!Checks.esNulo(tmpMotivoAplicaFormalizar)) perimetroActivo.setMotivoAplicaFormalizar(tmpMotivoAplicaFormalizar);
		
		//Aplica Publicar 		---------------------------
		if(!CHECK_NO_CAMBIAR.equals(tmpAplicaPublicar)){
			perimetroActivo.setAplicaPublicar(BooleanUtils.toBooleanObject(tmpAplicaPublicar));
			perimetroActivo.setFechaAplicaPublicar(new Date());
		}

		if(!Checks.esNulo(tmpMotivoAplicaPublicar)) perimetroActivo.setMotivoAplicaPublicar(tmpMotivoAplicaPublicar);


		// ---------------------------
		//Persiste los datos, creando el registro de perimetro
		// Todos los datos son de PerimetroActivo, a excepcion del tipo comercializacion que es del Activo
		if(!Checks.esNulo(tmpTipoComercializacion) || !Checks.esNulo(tmpDestinoComercial) || !Checks.esNulo(tmpTipoAlquiler)) 
			activoApi.saveOrUpdate(activo);
		//Si en la excel se ha indicado que NO esta en perimetro, desmarcamos sus checks
		if(CHECK_VALOR_NO.equals(perimetroActivo.getIncluidoEnPerimetro())) this.desmarcarChecksFromPerimetro(perimetroActivo);
		
		activoApi.saveOrUpdatePerimetroActivo(perimetroActivo);
		
		//Actualizar disponibilidad comercial del activo
		updaterState.updaterStateDisponibilidadComercial(activo);

		//Actualizar registro historico destino comercial del activo
		activoApi.updateHistoricoDestinoComercial(activo, extraArgs);

		activoApi.saveOrUpdate(activo);

		// Actualizar estado publicación activo a través del procedure.
		activoDao.publicarActivoConHistorico(activo.getId(), "masivo - perímetro");

		return new ResultadoProcesarFila();
	}
	
	/**
	 * Método que evalua el valor de un check en funcion de las columnas S/N/<nulo>
	 * @param cellValue
	 * @return
	 */
	private Integer getCheckValue(String cellValue){
		if(!Checks.esNulo(cellValue)){
			if("S".equalsIgnoreCase(cellValue) || String.valueOf(CHECK_VALOR_SI).equalsIgnoreCase(cellValue))
				return CHECK_VALOR_SI;
			else
				return CHECK_VALOR_NO;
		}
		
		return CHECK_NO_CAMBIAR;
		
	}
	
	/**
	 * Si se indica que esta fuera del perímetro, se desmarcan todos los checks
	 * @param perimetro
	 */
	private void desmarcarChecksFromPerimetro(PerimetroActivo perimetro) {
		
		if(!CHECK_VALOR_NO.equals(perimetro.getAplicaAsignarMediador())) {
			perimetro.setAplicaAsignarMediador(CHECK_VALOR_NO);
			perimetro.setFechaAplicaAsignarMediador(new Date());
		}
		if(!CHECK_VALOR_NO.equals(perimetro.getAplicaComercializar())) {
			perimetro.setAplicaComercializar(CHECK_VALOR_NO);
			perimetro.setFechaAplicaComercializar(new Date());
		}
		if(!CHECK_VALOR_NO.equals(perimetro.getAplicaFormalizar())) {
			perimetro.setAplicaFormalizar(CHECK_VALOR_NO);
			perimetro.setFechaAplicaFormalizar(new Date());
		}
		if(!CHECK_VALOR_NO.equals(perimetro.getAplicaGestion())) {
			perimetro.setAplicaGestion(CHECK_VALOR_NO);
			perimetro.setFechaAplicaGestion(new Date());
		}
		if(!CHECK_VALOR_NO.equals(perimetro.getAplicaTramiteAdmision())) {
			perimetro.setAplicaTramiteAdmision(CHECK_VALOR_NO);
			perimetro.setFechaAplicaTramiteAdmision(new Date());
		}
		if(perimetro.getAplicaPublicar()) {
			perimetro.setAplicaPublicar(BooleanUtils.toBooleanObject(CHECK_VALOR_NO));
			perimetro.setFechaAplicaTramiteAdmision(new Date());
		}
	}


}
