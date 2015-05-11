package es.pfsgroup.recovery.bpmframework.test;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import org.apache.commons.lang.RandomStringUtils;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkDDTipoAccion;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkInputDatos;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkTipoProcInput;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDDTipoInput;
import es.pfsgroup.recovery.geninformes.model.GENINFInforme;

/**
 * Clase abstracta para todos los tests del plugin, con el código reaprovechable
 * entre todos
 * 
 * @author bruno
 * 
 */
public abstract class AbstractRecoveryBPMFwkTests {

    /**
     * Datos que introduciría el usuario para crear un input
     * 
     * @author bruno
     * 
     */
    public static class DatosEntradaInput {
        private FileItem adjuntoInput;
        private String codigoTipoInput;
        private Map<String, Object> datosInput;
        private Long idProcedimiento;

        /**
         * Inicializa la entrada de datos usando el generador de valores random
         * 
         * @param random
         */
        public DatosEntradaInput(Random random) {
            this.idProcedimiento = random.nextLong();
            this.adjuntoInput = new FileItem();
            this.datosInput = generaDatosRandom(Math.abs(random.nextInt(1000)), random);
            this.codigoTipoInput = "Tipo-Input-" + random.nextLong();
        }

        /**
         * Genera una cantidad de datos aleatoria
         * 
         * @param n
         *            Cantidad de datos
         * @param random 
         * @return
         */
        private Map<String, Object> generaDatosRandom(int n, Random random) {
            HashMap<String, Object> datos = new HashMap<String, Object>();

            if (n > 0) {
                for (int i = 0; i < n; i++) {
                    String key = "dato" + i;
                    switch (i % 5) {
                    case 0:
                        datos.put(key, random.nextBoolean());
                        break;
                    case 1:
                        datos.put(key, random.nextDouble());
                        break;
                    case 2:
                        datos.put(key, random.nextFloat());
                        break;
                    case 3:
                        datos.put(key, "abcde" + random.nextLong());
                        break;
                    case 4:
                        datos.put(key, random.nextLong());
                        break;
                    default:
                    	datos.put(key, "abcde" + random.nextLong());
                    	break;
                    }
                }
            }

            return datos;
        }

        public FileItem getAdjuntoInput() {
            return adjuntoInput;
        }

        public String getCodigoTipoInput() {
            return codigoTipoInput;
        }

        public Map<String, Object> getDatosInput() {
            return datosInput;
        }

        public Long getIdProcedimiento() {
            return idProcedimiento;
        }

    }

    /*
     * Métodos para inicializar cada test
     */
    public abstract void childBefore();

    public abstract void childAfter();

    protected Random random;

    /**
     * Genera un objeto de tipo DTO INPUT para usarlo en los tests
     * 
     * @param entradaInput
     * @return
     */
    protected RecoveryBPMfwkInputDto generaDTOInput(DatosEntradaInput entradaInput) {
        RecoveryBPMfwkInputDto dto = new RecoveryBPMfwkInputDto();
        dto.setIdProcedimiento(entradaInput.getIdProcedimiento());
        dto.setCodigoTipoInput(entradaInput.getCodigoTipoInput());
        dto.setAdjunto(entradaInput.getAdjuntoInput());
        dto.setDatos(entradaInput.getDatosInput());
        return dto;

    }
    
    /**
     * Creamos un objeto de pruebas de tipo RecoveryBPMfwkTipoProcInput para probar la configuración.
     * @param codigoTipoInput
     * @param codigoTipoProcedimiento
     * @return
     */
    protected RecoveryBPMfwkTipoProcInput generaTipoProcInput(String codigoTipoInput, String codigoTipoProcedimiento){
    	
    	RecoveryBPMfwkTipoProcInput tipoProcInput = new RecoveryBPMfwkTipoProcInput();
    	
    	RecoveryBPMfwkDDTipoAccion tipoAccion = new RecoveryBPMfwkDDTipoAccion();
    	tipoAccion.setCodigo(RandomStringUtils.randomAlphanumeric(15));
    	
    	tipoProcInput.setTipoAccion(tipoAccion);
    	
    	TipoProcedimiento tipoProcedimiento = new TipoProcedimiento();
    	tipoProcedimiento.setCodigo(codigoTipoProcedimiento);
    	
    	RecoveryBPMfwkDDTipoInput tipoInput = new RecoveryBPMfwkDDTipoInput();
    	tipoInput.setCodigo(codigoTipoInput);
    	
    	tipoProcInput.setNombreTransicion(RandomStringUtils.randomAlphanumeric(15));
    	
    	GENINFInforme plantilla = new GENINFInforme();
    	plantilla.setId(random.nextLong());
    	plantilla.setCodigo(RandomStringUtils.randomAlphanumeric(15));
		tipoProcInput.setPlantilla(plantilla);
    	
    	RecoveryBPMfwkInputDatos dato1  = new RecoveryBPMfwkInputDatos();
    	dato1.setId(random.nextLong());
    	dato1.setNombre(RandomStringUtils.randomAlphanumeric(10));
    	dato1.setDato(RandomStringUtils.randomAlphanumeric(10));
    	dato1.setGrupo(RandomStringUtils.randomAlphanumeric(10));
    	
    	RecoveryBPMfwkInputDatos dato2  = new RecoveryBPMfwkInputDatos();
    	dato2.setId(random.nextLong());
    	dato2.setNombre(RandomStringUtils.randomAlphanumeric(10));
    	dato2.setDato(RandomStringUtils.randomAlphanumeric(10));
    	dato2.setGrupo(RandomStringUtils.randomAlphanumeric(10));
    	
    	Set<RecoveryBPMfwkInputDatos> set = new HashSet<RecoveryBPMfwkInputDatos>();
    	set.add(dato1);
    	set.add(dato2);
    	
    	tipoProcInput.setId(random.nextLong());
    	tipoProcInput.setTipoProcedimiento(tipoProcedimiento);
    	tipoProcInput.setTipoInput(tipoInput);
    	tipoProcInput.setNodesExcluded(RecoveryBPMfwkTipoProcInput.NONE_EXCLUDED);
    	tipoProcInput.setNodesIncluded(RecoveryBPMfwkTipoProcInput.ALL_INCLUDED);
    	tipoProcInput.setInputDatos(set);
    	
    	return tipoProcInput;
    	
    }



}
