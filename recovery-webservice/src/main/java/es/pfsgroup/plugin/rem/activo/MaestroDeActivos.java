package es.pfsgroup.plugin.rem.activo;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalMaestroApi;
import es.pfsgroup.plugin.gestorDocumental.dto.ActivoInputDto;
import es.pfsgroup.plugin.gestorDocumental.dto.ActivoOutputDto;

public class MaestroDeActivos {
	@Autowired
	private GestorDocumentalMaestroApi gestorDocumentalMaestroManager;
	
	@Autowired
	private MSVRawSQLDao rawDao;
	private final Log logger = LogFactory.getLog(getClass());
	private static final String UNIDAD_ALQUILABLE =	"UNIDAD ALQUILABLE";
	private static final String ORIGEN ="REM";
	private static final String FLAGMULTIPLICIDAD ="1";
	private static final String MOTIVO_OPERACION ="14";
	private static final String SIMULACRO ="simulacion";
	private Long idActivoAM = null;
	private Long numREMActivoAM = null;
	private Long idUnidadAlquilable = null;
	private String cartera = null;
	
	public MaestroDeActivos(Long idUnidadAlquilable, Long idActivoAM, Long numREMActivoAM, String cartera) {
		logger.error("Ejecucion del constructor de maestro de activos");
		logger.error("[ID UNIDAD ALQUILABLE] => "+ idUnidadAlquilable);
		logger.error("[ID ACTIVO MATRIZ] => "+ idActivoAM);
		logger.error("[NUMERO REM ACTIVO MATRIZ] => "+ numREMActivoAM);
		logger.error("[CARTERA] => "+ cartera);
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.idActivoAM = idActivoAM;
		this.numREMActivoAM = numREMActivoAM;
		this.idUnidadAlquilable = idUnidadAlquilable;
		this.cartera = cartera;
	}
	
	@Transactional
	public ActivoOutputDto altaActivo() {
		
		String idUnidadAlquilable = Long.toString(this.idUnidadAlquilable);
		String idActivoAM = Long.toString(this.idActivoAM);
		String numREMActivoAM = Long.toString(this.numREMActivoAM);
		
		try {
			if (!Checks.esNulo(idActivoAM) && !Checks.esNulo(numREMActivoAM) && !Checks.esNulo(idUnidadAlquilable)) {
				
				ActivoInputDto dto = new ActivoInputDto();
				dto.setIdActivoMatriz(idActivoAM);
				dto.setNumRemActivoMatriz(numREMActivoAM);
				dto.setIdUnidadAlquilable(idUnidadAlquilable);
				SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd-MM-yyyy HH:MM:ss");
				dto.setFechaOperacion(DATE_FORMAT.format(new Date()));
				dto.setTipoActivo(UNIDAD_ALQUILABLE);
				dto.setOrigen(ORIGEN);
				dto.setFlagMultiplicidad(FLAGMULTIPLICIDAD);
				dto.setMotivoOperacion(MOTIVO_OPERACION);
				dto.setIdCliente(cartera);
			
				dto.setEvent(dto.EVENTO_ALTA_ACTIVOS);
				

				ActivoOutputDto activoOutput =  new ActivoOutputDto();
				logger.error("[SE EJECUTA EL MAESTRO DE ACTIVOS]");
				logger.error(dto.toString());
				BeanUtils.copyProperties(gestorDocumentalMaestroManager
						.ejecutar(dto), activoOutput);
				
				if (!Checks.esNulo(activoOutput) && SIMULACRO.equals(activoOutput.getResultDescription())) {
					logger.error("[MAESTRO DE ACTIVOS] SIMULACION DE VALORES DE PRUEBA");
					activoOutput = new ActivoOutputDto();
					activoOutput.setResultCode("simulacion");
					activoOutput.setNumActivoUnidadAlquilable(String.valueOf(getNewNumActivo()));
					return activoOutput;
				}else if (!Checks.esNulo(activoOutput) && !SIMULACRO.equals(activoOutput.getResultDescription())){
					logger.error("[RESPUESTA MAESTRO DE ACTIVOS ]: \n "+ activoOutput.getNumActivoUnidadAlquilable() );
					return activoOutput;
				}else {
					return null;
				}
			}
		}catch( Exception e) {
			logger.error("Error maestro de activos", e);
		}
		return null;
	}
	
	@Transactional
	public Long getNewNumActivo() {
		return Long.valueOf(rawDao.getExecuteSQL("SELECT MAX(ACT_NUM_ACTIVO) + 1 FROM ACT_ACTIVO"));
	}
	

}
