package es.pfsgroup.plugin.rem.activo;

import java.util.Date;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
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
	private Long numActivoAM = null;
	private Long idUnidadAlquilable = null;
	
	public MaestroDeActivos(Long idUnidadAlquilable, Long idActivoAM, Long numActivoAM) {
		logger.info("Ejecucion del constructor de maestro de activos");
		// imprescindible para poder inyectar componentes
		SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
		this.idActivoAM = idActivoAM;
		this.numActivoAM = numActivoAM;
		this.idUnidadAlquilable = idUnidadAlquilable;
	}
	
	@Transactional
	public ActivoOutputDto altaActivo() {
		
		String idUnidadAlquilable = Long.toString(this.idUnidadAlquilable);
		String idActivoAM = Long.toString(this.idActivoAM);
		String numActivoAM = Long.toString(this.numActivoAM);
		
		try {
			if (!Checks.esNulo(idActivoAM) && !Checks.esNulo(numActivoAM) && !Checks.esNulo(idUnidadAlquilable)) {
				
				ActivoInputDto dto = new ActivoInputDto();
				dto.setIdActivoMatriz(idActivoAM);
				dto.setNumRemActivoMatriz(numActivoAM);
				dto.setIdUnidadAlquilable(idUnidadAlquilable);
				dto.setFechaOperacion(new Date().toString());
				dto.setTipoActivo(UNIDAD_ALQUILABLE);
				dto.setOrigen(ORIGEN);
				dto.setFlagMultiplicidad(FLAGMULTIPLICIDAD);
				dto.setMotivoOperacion(MOTIVO_OPERACION);
			
				dto.setEvent(dto.EVENTO_ALTA_ACTIVOS);
				
				logger.info("[MAESTRO_ACTIVOS] VARIABLES DE ENTRADA = \n idActivoAM ->" +idActivoAM+"\n numActivoAM _->" + numActivoAM + "\n idUnidadAlquilable ->" + idUnidadAlquilable);
				ActivoOutputDto activoOutput =  new ActivoOutputDto();
				BeanUtils.copyProperties(gestorDocumentalMaestroManager
						.ejecutar(dto), activoOutput);
			
				if (!Checks.esNulo(activoOutput) && SIMULACRO.equals(activoOutput.getResultDescription())) {
					activoOutput = new ActivoOutputDto();
					activoOutput.setResultCode("simulacion");
					activoOutput.setNumActivoUnidadAlquilable(String.valueOf(getNewNumActivo()));
					return activoOutput;
				}else if (!Checks.esNulo(activoOutput) && !SIMULACRO.equals(activoOutput.getResultDescription())){
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
