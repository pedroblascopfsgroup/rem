package es.pfsgroup.recovery.bpmframework;

import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkConfigApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkCallback;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;

/**
 * Clase para testear online la petición de procesado batch de un input
 * 
 * @author bruno
 * 
 */
@Controller
public class EltitiController {

    @Autowired
    private transient ApiProxyFactory proxyFactory;

    private transient Random random = new Random();

    @RequestMapping
    public String procesadobatch() {
        final RecoveryBPMfwkInputDto input = creaDToInput();
        final Long idProcess = random.nextLong();
        final RecoveryBPMfwkCallback callback = creaCallback();
        try {
            proxyFactory.proxy(RecoveryBPMfwkBatchApi.class).programaProcesadoInput(idProcess, input, callback);
        } catch (RecoveryBPMfwkError e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        return "default";
    }
    
    /**
     * Recupera la configuración de un tipo de input en función de los parámetros de entrada.
     * @param codigoTipoInput
     * @param codigoTipoProcedimiento
     * @return
     */
    @RequestMapping
    public String recuperaConfiguracion(String codigoTipoInput, String codigoTipoProcedimiento, String codigoNodo) {
    	
    	try {
            proxyFactory.proxy(RecoveryBPMfwkConfigApi.class).getInputConfigNodo(codigoTipoInput, codigoTipoProcedimiento, codigoNodo);
        } catch (RecoveryBPMfwkError e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    	
    	return "default";
    }
    
    /**
     * Ejecuta las peticiones batch pendientes en base de datos.
     * @return
     */
    @RequestMapping
    public String ejecutaPeticionesBatchPendientes() {
    	
    	try {
            proxyFactory.proxy(RecoveryBPMfwkBatchApi.class).ejecutaPeticionesBatchPendientes();
        } catch (RecoveryBPMfwkError e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    	
    	return "default";
    }

    /**
     * Crea un objeto Caalback de pruebas.
     * @return
     */
    private RecoveryBPMfwkCallback creaCallback() {
        return new RecoveryBPMfwkCallback() {

            @Override
            public String onSuccess() {
                return "ONSUCCESS";
            }

            @Override
            public String onProcessStart() {
                return "ON PROCESSS STATRFGAGAD";
            }

            @Override
            public String onProcessEnd() {
                return "PROCESS END";
            }

            @Override
            public String onError() {
                return "ON ERROR oyohoyoyoyoy";
            }
        };
    }

    /**
     * Crea un objeto InputDto de pruebas.
     * @return
     */
    private RecoveryBPMfwkInputDto creaDToInput() {
        final Map<String, Object> datos = new ConcurrentHashMap<String, Object>();

        datos.put("dato1", random.nextBoolean());
        datos.put("dato2", random.nextDouble());
        datos.put("dato3", random.nextLong());

        final RecoveryBPMfwkInputDto dto = new RecoveryBPMfwkInputDto();
        dto.setAdjunto(null);
        dto.setCodigoTipoInput("TEST");
        dto.setDatos(datos);
        dto.setIdProcedimiento(10000000111286L);
        return dto;
    }

}
