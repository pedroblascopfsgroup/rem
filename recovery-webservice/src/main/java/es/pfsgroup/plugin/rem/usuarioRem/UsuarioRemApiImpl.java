package es.pfsgroup.plugin.rem.usuarioRem;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.model.GestorSustituto;

@Service("usuarioRemApiImpl")
public class UsuarioRemApiImpl implements UsuarioRemApi{

	@Autowired
	private GenericABMDao genericDao;
	
	public List<String> getGestorSustitutoUsuario(Usuario usuario) {

		List<String> mailsPara = new ArrayList<String>();

		List<GestorSustituto> sustitutos = genericDao.getList(GestorSustituto.class,
				genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id", usuario.getId()));
		if (!Checks.estaVacio(sustitutos)) {
			if (!Checks.esNulo(sustitutos)) {
				for (GestorSustituto gestorSustituto : sustitutos) {
					if (!Checks.esNulo(gestorSustituto)) {
						if ((gestorSustituto.getFechaFin() == null || gestorSustituto.getFechaFin().after(new Date()) || gestorSustituto.getFechaFin().equals(new Date()))
								&& (gestorSustituto.getFechaInicio().before(new Date()) || gestorSustituto.getFechaInicio().equals(new Date()))
								&& !gestorSustituto.getAuditoria().isBorrado()) {

							if (!Checks.esNulo(gestorSustituto.getUsuarioGestorSustituto()) || !Checks.esNulo(gestorSustituto.getUsuarioGestorSustituto().getEmail())) {
								mailsPara.add(gestorSustituto.getUsuarioGestorSustituto().getEmail());
							}
						}
					}
				}
			}
		}

		return mailsPara;
	}
	
	public List<String> getApellidoNombreSustituto(Usuario usuario) {
		
		List<String> apellidoNombreSus = new ArrayList<String>();

		List<GestorSustituto> sustitutos = genericDao.getList(GestorSustituto.class,
				genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id", usuario.getId()));
		if (!Checks.estaVacio(sustitutos)) {
			if (!Checks.esNulo(sustitutos)) {
				for (GestorSustituto gestorSustituto : sustitutos) {
					if (!Checks.esNulo(gestorSustituto)) {
						if ((gestorSustituto.getFechaFin() == null || gestorSustituto.getFechaFin().after(new Date()) || gestorSustituto.getFechaFin().equals(new Date()))
								&& (gestorSustituto.getFechaInicio().before(new Date()) || gestorSustituto.getFechaInicio().equals(new Date()))
								&& !gestorSustituto.getAuditoria().isBorrado()) {

							if (!Checks.esNulo(gestorSustituto.getUsuarioGestorSustituto()) || !Checks.esNulo(gestorSustituto.getUsuarioGestorSustituto().getEmail())) {
								apellidoNombreSus.add(gestorSustituto.getUsuarioGestorSustituto().getApellidoNombre());
							}
						}
					}
				}
			}
		}
		
		return apellidoNombreSus;
		
	}

}