package es.pfsgroup.plugin.recovery.mejoras.comite;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.pfsgroup.plugin.recovery.mejoras.comite.dao.MEJComiteDao;

@Controller
public class MEJComiteController {

	@Autowired
	private MEJComiteDao mejComiteDao;
	
	
	@RequestMapping
	public String eliminaSesion(ModelMap map){
		
		mejComiteDao.flush();
		mejComiteDao.clear();
		
		return "default";
	}
}
