package es.capgemini.pfs.users;

import java.util.List;

import org.springframework.stereotype.Service;

import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;

@Service
public class FuncionManager {

    public boolean tieneFuncion(Usuario usuario, String codigo) {
        List<Perfil> perfiles = usuario.getPerfiles();
        for (Perfil per : perfiles) {
            for (Funcion fun : per.getFunciones()) {
                if (fun.getDescripcion().equals(codigo)) { return true; }
            }
        }

        return false;
    }
}
