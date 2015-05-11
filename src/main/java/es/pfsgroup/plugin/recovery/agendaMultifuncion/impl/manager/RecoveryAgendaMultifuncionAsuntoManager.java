package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.manager;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.dao.RecoveryAgendaMultifuncionAsuntoDao;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.api.manager.RecoveryAgendaMultifuncionAsuntoEXTAsuntoApi;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.dto.RecoveryAgendaMultifuncionDtoBusquedaAsunto;

@Service
@Transactional(readOnly = true)
public class RecoveryAgendaMultifuncionAsuntoManager implements RecoveryAgendaMultifuncionAsuntoEXTAsuntoApi {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private RecoveryAgendaMultifuncionAsuntoDao asuntoDao;

    @Autowired
    private ApiProxyFactory proxyFactory;

    /**
     * Busca asuntos paginados teniendo en cuenta las anotaciones (plugin multiagenda).
     * 
     * @param dto
     *            los par�metros para la Búsqueda.
     * @return Asuntos paginados
     */
    @Override
    @BusinessOperation(AMF_ASUNTO_FIND_ASUNTOS_PAGINATED)
    public Page findAsuntosPaginated(RecoveryAgendaMultifuncionDtoBusquedaAsunto dto) {
        dto.setCodigoZonas(getCodigosDeZona(dto));
        dto.setTiposProcedimiento(getTiposProcedimiento(dto));
        return asuntoDao.buscarAsuntosPaginated(proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado(), dto);
    }

    private Set<String> getCodigosDeZona(DtoBusquedaAsunto dtoBusquedaAsuntos) {
        Set<String> zonas;
        if (dtoBusquedaAsuntos.getCodigoZona() != null && dtoBusquedaAsuntos.getCodigoZona().trim().length() > 0) {
            List<String> list = Arrays.asList((dtoBusquedaAsuntos.getCodigoZona().split(",")));
            zonas = new HashSet<String>(list);
        } else {
            // Usuario usuario = (Usuario) executor
            // .execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
            // zonas = usuario.getCodigoZonas();
            zonas = new HashSet<String>();
        }
        return zonas;
    }

    private Set<String> getTiposProcedimiento(DtoBusquedaAsunto dtoBusquedaAsuntos) {
        Set<String> tiposProcedimiento = null;
        if (dtoBusquedaAsuntos.getTipoProcedimiento() != null && dtoBusquedaAsuntos.getTipoProcedimiento().trim().length() > 0) {
            tiposProcedimiento = new HashSet<String>(Arrays.asList((dtoBusquedaAsuntos.getTipoProcedimiento().split(","))));
        }
        return tiposProcedimiento;
    }

}
