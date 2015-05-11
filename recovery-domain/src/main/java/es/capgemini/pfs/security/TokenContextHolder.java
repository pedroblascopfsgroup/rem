package es.capgemini.pfs.security;

/**
 * @author amarinso
 * introducimos el par�metro "token" de la request en el thread local para utilizarlo al entrar 
 * a la aplicaci�n con una URL directa.
 * 
 */
public class TokenContextHolder {

    private static final ThreadLocal<String> token = new ThreadLocal<String>() {
        @Override
        protected String initialValue() {
            return null;
        }
    };

    public static String getToken() {
        return token.get();
    }

    public static void setToken(String data) {
        token.set(data);
    }

}
