package es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tc.backport175.proxy.ProxyFactory;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.hibernate.pagination.PageHibernate;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.dao.NMBBienDao;

@Controller
public class NMBBienController {

	@Autowired
    private Executor executor;	
	
	@Autowired
	private NMBBienDao nmbBienDao;	
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String exportacionBienesCount(NMBDtoBuscarBienes dto, String paramas, ModelMap model) {
		Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
		Parametrizacion parametroLimite = (Parametrizacion)executor.execute(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
				Parametrizacion.LIMITE_EXPORT_EXCEL_BUSCADOR_BIENES);
		int limite = Integer.parseInt(parametroLimite.getValor());
		model.put("limit", limite);

		int count = ((PageHibernate)nmbBienDao.buscarBienesExport(dto, usuarioLogado)).getTotalCount();
		model.put("count", count);
	
		
		return "plugin/coreextension/exportacionGenericoCountJSON";
	}
}
