package es.pfsgroup.plugin.rem.activo;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoAvisadorApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoAviso;


@Service("activoAvisadorManager")
public class ActivoAvisadorManager implements ActivoAvisadorApi {

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	
	protected static final Log logger = LogFactory.getLog(ActivoAvisadorManager.class);
	
	@Autowired
	private Executor executor;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoDao activoDao;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired 
    private ActivoApi activoApi;

	@Autowired
	private FuncionManager funcionManager;

	@Override
	@BusinessOperation(overrides = "activoAvisadorManager.get")
	public String get(Long id) {
		return "";
		//return activoDao.get(id);
	}
	
	

	@Override
	@BusinessOperation(overrides = "activoAvisadorManager.getListActivoAvisador")
	public List<DtoAviso> getListActivoAvisador(Long id, Usuario usuarioLogado) {
		
		List<DtoAviso> listaAvisos = new ArrayList<DtoAviso>();
		Activo activo = activoApi.get(id);
		List<Perfil> perfilesUsuario = usuarioLogado.getPerfiles();
		boolean esGestorActivo = false;
		for (int i=0;i<perfilesUsuario.size();i++) {
			
			if (perfilesUsuario.get(i).getCodigo().equals("HAYAGESACT")) {
				esGestorActivo = true;
			}
			
		}
		
		boolean restringida = false;
		boolean obraNueva = false;
		
		try {
		//Avisos 1 y 2: Integrado en agrupación restringida / Integrado en obra nueva
			restringida = activoApi.isIntegradoAgrupacionRestringida(id, usuarioLogado);
			obraNueva = activoApi.isIntegradoAgrupacionObraNueva(id, usuarioLogado);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		if (restringida) {
			DtoAviso dtoAviso = new DtoAviso();
			dtoAviso.setDescripcion("Incluido en agrupación restringida");
			dtoAviso.setId(String.valueOf(id));
			listaAvisos.add(dtoAviso);
		}
		
		if (obraNueva) {
			DtoAviso dtoAviso = new DtoAviso();
			dtoAviso.setDescripcion("Incluido en agrupación de obra nueva");
			dtoAviso.setId(String.valueOf(id));
			listaAvisos.add(dtoAviso);
		}
		
		//Aviso 3 / 4: Situación posesoria OCUPADO + Con o sín título
		if (esGestorActivo && activo.getSituacionPosesoria().getOcupado() == 1) {
			
			if (activo.getSituacionPosesoria().getConTitulo() == 1) {
				DtoAviso dtoAviso = new DtoAviso();
				dtoAviso.setDescripcion("Situación posesoria ocupado con título");
				dtoAviso.setId(String.valueOf(id));
				listaAvisos.add(dtoAviso);
			} else {
				DtoAviso dtoAviso = new DtoAviso();
				dtoAviso.setDescripcion("Situación posesoria ocupado sin título");
				dtoAviso.setId(String.valueOf(id));
				listaAvisos.add(dtoAviso);
			}
			
		}
		
		//Aviso 5: Tapiado 
		if (esGestorActivo && BooleanUtils.toBoolean(activo.getSituacionPosesoria().getAccesoTapiado())) {
			DtoAviso dtoAviso = new DtoAviso();
			dtoAviso.setDescripcion("Situación de acceso tapiado");
			dtoAviso.setId(String.valueOf(id));
			listaAvisos.add(dtoAviso);
			
		}
		
		// Aviso 6: Acceso antiocupa
		if (esGestorActivo && BooleanUtils.toBoolean(activo.getSituacionPosesoria().getAccesoAntiocupa())) {
			DtoAviso dtoAviso = new DtoAviso();
			dtoAviso.setDescripcion("Situación de acceso con puerta antiocupa");
			dtoAviso.setId(String.valueOf(id));
			listaAvisos.add(dtoAviso);
			
		}
		
		// Aviso 7: Pendiente toma posesión
		if (esGestorActivo && activo.getAdjJudicial() != null && activo.getAdjJudicial().getAdjudicacionBien() != null 
				&&  activo.getSituacionPosesoria() != null && activo.getSituacionPosesoria().getFechaTomaPosesion() == null) {
			
			DtoAviso dtoAviso = new DtoAviso();
			dtoAviso.setDescripcion("Pendiente toma de posesión");
			dtoAviso.setId(String.valueOf(id));
			listaAvisos.add(dtoAviso);
			
		}
		
		// Aviso 8: Sin gestión
		// Si no es judicial...
		if (activo.getTitulo() != null && activo.getTitulo().getId() != 1) {
			if (activo.getGestionHre() == 0) {
				DtoAviso dtoAviso = new DtoAviso();
				dtoAviso.setDescripcion("Activo sin gestión");
				dtoAviso.setId(String.valueOf(id));
				listaAvisos.add(dtoAviso);
			}
			
		}
		
		// Aviso 9: Estado Comercial		
		if(!Checks.esNulo(activo.getSituacionComercial())) {
			DtoAviso dtoAviso = new DtoAviso();
			dtoAviso.setDescripcion(activo.getSituacionComercial().getDescripcion());
			dtoAviso.setId(String.valueOf(id));
			listaAvisos.add(dtoAviso);			
		}
		
		// Aviso 10: Perímetro Haya
		if(!activoApi.isActivoDentroPerimetro(id)) {
			DtoAviso dtoAviso = new DtoAviso();
			dtoAviso.setDescripcion("Fuera del perímetro Haya");
			dtoAviso.setId(String.valueOf(id));
			listaAvisos.add(dtoAviso);	
		}
		
		return listaAvisos;
		//activoDao.getListActivos(id, usuarioLogado);
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}