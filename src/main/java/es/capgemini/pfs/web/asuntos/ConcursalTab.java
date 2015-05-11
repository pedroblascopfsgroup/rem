package es.capgemini.pfs.web.asuntos;

import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.webflow.bo.WebExecutor;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.web.menu.ElementoDinamicoPorFuncion;

public class ConcursalTab extends ElementoDinamicoPorFuncion {

    private static final long serialVersionUID = 2286034672321701006L;

    @Resource
    private Properties appProperties;

    @Autowired
    UsuarioManager usuarioManager;

    @Autowired
    WebExecutor executor;

    private final Log logger = LogFactory.getLog(getClass());

    @Override
    public boolean valid(Object param) {
        return puedeMostrarSolapaConcursal(param) && super.valid(param);
    }

    private boolean puedeMostrarSolapaConcursal(Object id) {

        String bo = appProperties.getProperty("BO_CONCURSOMANAGER.DAME_NUM_DE_PROCS_FASE_COMUN");

        Integer num = 0;

        try {
            num = (Integer) executor.execute(bo, id);
        } catch (Exception e) {
            logger.error("Error al consultar la BO concursoManager.dameNumProcsFaseComun", e);
        }

        return num > 0;
    }
}
