package es.pfsgroup.plugin.rem.adapter;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.capgemini.pfs.users.UsuarioManager;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.jbpm.JBPMProcessManagerApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoComunidadPropietarios;
import es.pfsgroup.plugin.rem.model.ActivoGestion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoLocalizacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubestadoGestion;

@Service
public class ComunidadesPropietariosAdapter {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	protected JBPMProcessManagerApi jbpmProcessManagerApi;

	@Autowired
	protected TipoProcedimientoManager tipoProcedimiento;

	@Resource
	private MessageService messageServices;
	
	@Autowired
	private UsuarioManager usuarioApi;

	private final Log logger = LogFactory.getLog(getClass());


	@Transactional(readOnly = false)
	public void updateComunidad(Long idActivo, String idComunidadPropietarios, String fechaEnvioCarta, String codEstadoLocalizacion, String codSubestadoGestion) {

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "numActivo", idActivo);
		Activo activo = genericDao.get(Activo.class, filter);

		try {			
			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			Filter filtroFechaFin = genericDao.createFilter(FilterType.NULL, "fechaFin");

			ActivoGestion gestionAnterior = genericDao.get(ActivoGestion.class, filtroActivo, filtroFechaFin);

			if(gestionAnterior != null) {
				gestionAnterior.setFechaFin(new Date());
				gestionAnterior.getAuditoria().setUsuarioModificar(usuarioApi.getUsuarioLogado().getUsername());
				gestionAnterior.getAuditoria().setFechaModificar(new Date());
				genericDao.save(ActivoGestion.class, gestionAnterior);
			}			
	
			ActivoGestion nuevaGestion = new ActivoGestion();

			nuevaGestion.setActivo(activo);

			if(codEstadoLocalizacion != null) {
				DDEstadoLocalizacion estadoLocalizacion = genericDao.get(DDEstadoLocalizacion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codEstadoLocalizacion));
				if(estadoLocalizacion != null)
					nuevaGestion.setEstadoLocalizacion(estadoLocalizacion);
			}

			if(codSubestadoGestion != null) {
				DDSubestadoGestion subestadoGestion = genericDao.get(DDSubestadoGestion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codSubestadoGestion));
				if(subestadoGestion != null)
					nuevaGestion.setSubestadoGestion(subestadoGestion);
			}			
 
			nuevaGestion.setFechaInicio(new Date());
			nuevaGestion.setUsuario(usuarioApi.getUsuarioLogado());

			Auditoria auditoria = new Auditoria();
			auditoria.setFechaCrear(new Date());
			auditoria.setUsuarioCrear(usuarioApi.getUsuarioLogado().getUsername());
			auditoria.setBorrado(false);

			nuevaGestion.setAuditoria(auditoria);
			 
			genericDao.save(ActivoGestion.class, nuevaGestion);

			ActivoComunidadPropietarios activoComunidadPropietarios = genericDao.get(ActivoComunidadPropietarios.class, genericDao.createFilter(FilterType.EQUALS, "id", activo.getComunidadPropietarios().getId()),
					genericDao.createFilter(FilterType.EQUALS,"codigoComPropUvem", idComunidadPropietarios));

			if (activoComunidadPropietarios != null && !Checks.isFechaNula(fechaEnvioCarta)) {
				 Date dateEnvioCarta = new SimpleDateFormat("dd/MM/yyyy").parse(fechaEnvioCarta);  
				 activoComunidadPropietarios.setFechaEnvioCarta(dateEnvioCarta);
				 genericDao.save(ActivoComunidadPropietarios.class, activoComunidadPropietarios);
			}

		} catch (Exception e) {
			logger.error(e);
			e.printStackTrace();
		}
	}
}