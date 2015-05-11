package es.pfsgroup.plugin.recovery.agendaMultifuncion.test.impl.manager.RecoveryAnotacionManager.bo;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.RandomStringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.AgendaMultifuncionCustomTemplate;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dto.DtoCrearAnotacionInfo;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.test.impl.manager.RecoveryAnotacionManager.AbstractRecoveryAnotacionManagerTests;

@RunWith(MockitoJUnitRunner.class)
public class CreateAnotacionTest extends AbstractRecoveryAnotacionManagerTests{

    private DtoCrearAnotacionBuilder dtoBuilder;
    private Long idUnidadGestion;
    private List<Long> usuarios;
    private List<String> direcccionesEmailPara;
    private List<String> direcccionesEmailCC;
    private InputStream streamPlantilla;
    private String nombrePlantilla;
    
    @Override
    public void childBefore() throws IOException {
        idUnidadGestion = random.nextLong();
        usuarios = initArrayWithRandomData(Long.class, Math.abs(random.nextInt(20)));
        direcccionesEmailPara = initArrayWithRandomData(String.class, 0);
        direcccionesEmailCC = initArrayWithRandomData(String.class, 0);
        dtoBuilder = new DtoCrearAnotacionBuilder(idUnidadGestion, usuarios, direcccionesEmailPara, direcccionesEmailCC);
        nombrePlantilla = RandomStringUtils.randomAlphanumeric(100);
        streamPlantilla = IOUtils.toInputStream(RandomStringUtils.randomAscii(1000), "ASCII");
        
        HashMap<String, String> parametros = new HashMap<String, String>();
        //FIXME Encontrar un modo mejor de decir cual debe ser la plantilla.
        parametros.put(AgendaMultifuncionCustomTemplate.LOCATION_TEMPLATE_KEY, nombrePlantilla);
        
        simular().seObtienenLosUsuarios(usuarios);
        simular().seObtieneConfiguracionPersonalizada(parametros);
        simular().seObtieneRecursoDelClassPath(nombrePlantilla, streamPlantilla);
    }


    @Override
    public void childAfter() {
        dtoBuilder = null;
        idUnidadGestion = null;
        usuarios = null;
        direcccionesEmailPara = null;
        direcccionesEmailCC = null;
        nombrePlantilla = null;
        streamPlantilla = null;
    }
    
    @Test
    public void testCreateAnotacion(){
        DtoCrearAnotacionInfo dto = dtoBuilder.nuevoDtoCrearAnotacionConUsuarios(true);
        spyManager.createAnotacion(dto);
        
        verificar().seHanEnviadoEmails(1, nombrePlantilla);
    }


    private <T> List<T> initArrayWithRandomData(Class<T> clazz, int count) {
        ArrayList data = new ArrayList();
       for (int i=0; i<count;i++){
           if (clazz == String.class){
               data.add(RandomStringUtils.randomAlphabetic(100));
           }else if (clazz == Long.class){
               data.add(random.nextLong());
           }else{
               throw new IllegalArgumentException(clazz.getName() + " es un tipo no soportado por el método");
           }
       }
       return data;
    }

}
