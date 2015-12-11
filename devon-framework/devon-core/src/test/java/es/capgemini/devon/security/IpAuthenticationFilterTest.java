package es.capgemini.devon.security;

import static org.junit.Assert.fail;

import java.util.Arrays;
import java.util.Collection;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.GrantedAuthorityImpl;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;
import org.springframework.security.ui.WebAuthenticationDetails;
import org.springframework.security.userdetails.User;
import org.springframework.security.userdetails.UserDetails;

import es.capgemini.devon.mocks.MockedHttpServletRequest;

@RunWith(Parameterized.class)
public class IpAuthenticationFilterTest {

    @Parameters
    public static Collection<Object[]> data() {
        return Arrays.asList(new Object[][] { { true, new String[][] { { "*", "*.*.*.*" } } }, // ----- todo a todo
                { true, new String[][] { { "user", "10.68.8.28" } } }, // ------------------------------ mismo usuario, misma IP
                { true, new String[][] { { "user", "10.68.8.28" } } }, // ------------------------------ mismo usuario, misma IP
                { true, new String[][] { { "user", "10.68.8.27,10.68.8.28" } } }, // ------------------- mismo usuario, misma IP entre varias
                { true, new String[][] { { "us*", "10.68.8.28" } } }, // ------------------------------- usuario con *, misma IP
                { true, new String[][] { { "user", "10.68.8.*" } } }, // ------------------------------- mismo usuario, IP con *
                { true, new String[][] { { "us*", "10.68.8.*" } } }, // -------------------------------- usuario con *, IP con *
                { false, new String[][] { { "user", "!*.*.*.*" } } }, // ------------------------------- mismo usuario, todas las IPs denegadas
                { false, new String[][] { { "user", "!10.68.8.28" } } }, // ---------------------------- mismo usuario, IP denegada
                { false, new String[][] { { "user", "!10.68.8.27,!10.68.8.28" } } }, // ---------------- mismo usuario, IP denegada entre varias
                { false, new String[][] { { "us*", "!10.68.8.28" } } }, // ----------------------------- usuario con *, IP denegada
                { false, new String[][] { { "user", "!10.68.8.*" } } }, // ----------------------------- mismo usuario, IP denegada con *
                { false, new String[][] { { "us*", "!10.68.8.*" } } }, // ------------------------------ usuario con *, IP denegada con *
                { false, new String[][] { { "user", "10.68.8.27" } } }, // ----------------------------- mismo usuario, otra IP permitida
                { false, new String[][] { { "us*", "10.68.8.27" } } }, // ------------------------------ usuario con *, otra IP permitida
                { true, new String[][] { { "[ROLE_TEST]", "10.68.8.28" } } }, // ----------------------- mismo rol, misma IP
                { true, new String[][] { { "[ROLE_TE*]", "10.68.8.28" } } }, // ------------------------ rol con *, misma IP
                { true, new String[][] { { "[ROLE_TE*]", "10.68.8.*" } } }, // ------------------------- rol con *, IP con *
                { false, new String[][] { { "[ROLE_TEST]", "!10.68.8.28" } } }, // --------------------- mismo rol, IP denegada
                { false, new String[][] { { "[ROLE_TEST]", "!10.68.8.*" } } }, // ---------------------- mismo rol, IP denegada con *
                { false, new String[][] { { "[ROLE_TE*]", "!10.68.8.28" } } }, // ---------------------- rol con *, IP denegada
                { false, new String[][] { { "[ROLE_TE*]", "!10.68.8.*" } } }, // ----------------------- rol con *, IP denegada con *
                { false, new String[][] { { "user", "10.68.8.28" }, { "[ROLE_TEST]", "!10.68.8.28" } } }, // -- usuario permitido, rol denegado
                { false, new String[][] { { "user", "!10.68.8.28" }, { "[ROLE_TEST]", "10.68.8.28" } } }, // -- usuario denegado, rol permitido
        });
    }

    private boolean shouldPass;
    private String[][] filters;

    private String username = "user";
    private String password = "";
    private String[] authorities = new String[] { "ROLE_TEST", "ROLE_ADMIN" };
    private String ip = "10.68.8.28";

    public IpAuthenticationFilterTest(boolean shouldPass, String[][] filters) {
        this.shouldPass = shouldPass;
        this.filters = filters;
    }

    @Test
    public void filter() {
        IpAuthenticationFilter filter = getFilter(filters);
        Object[] loginData = getLoginData(username, password, authorities, ip);

        if (shouldPass) {
            try {
                filter.check((UserDetails) loginData[0], (UsernamePasswordAuthenticationToken) loginData[1]);
            } catch (IpNotAllowedException e) {
                fail("Debería dejar pasar al usuario [" + username + "] desde la ip [" + ip + "] con authorities [" + toString(authorities)
                        + "] según los filtros [" + toString(filters) + "]");
            }
        } else {
            try {
                filter.check((UserDetails) loginData[0], (UsernamePasswordAuthenticationToken) loginData[1]);
                fail("No debería dejar pasar al usuario [" + username + "] desde la ip [" + ip + "] con authorities [" + toString(authorities)
                        + "] según los filtros [" + toString(filters) + "]");
            } catch (IpNotAllowedException e) {
            }
        }

    }

    private String toString(String[] array) {
        String result = "";
        for (String row : array) {
            result = result + row + ",";
        }
        return result.length() == 0 ? "" : result.substring(0, result.length() - 1);
    }

    private String toString(String[][] array) {
        String result = "";
        for (String[] row : array) {
            result = result + "[";
            for (String col : row) {
                result = result + col + ",";
            }
            result = result.length() == 1 ? result : result.substring(0, result.length() - 1);
            result = result + "]";
        }
        result = result + "]";
        return result;
    }

    private IpAuthenticationFilter getFilter(String[][] filters) {
        IpAuthenticationFilter filter = new IpAuthenticationFilter();
        Properties props = new Properties();
        for (String[] row : filters) {
            props.put(row[0], row[1]);
        }
        filter.setFilterIps(props);
        return filter;

    }

    private HttpServletRequest getRequest(String ip) {
        MockedHttpServletRequest request = new MockedHttpServletRequest();
        request.setRemoteAddr(ip);
        return request;
    }

    private Object[] getLoginData(String username, String password, String[] authorities, String ip) {
        GrantedAuthority[] grantedAuthorities = new GrantedAuthorityImpl[authorities.length];
        for (int i = 0; i < authorities.length; i++) {
            grantedAuthorities[i] = new GrantedAuthorityImpl(authorities[i]);
        }

        UsernamePasswordAuthenticationToken token = new UsernamePasswordAuthenticationToken(username, password);
        token.setDetails(new WebAuthenticationDetails(getRequest(ip)));

        UserDetails userDetails = new User(username, password, true, true, true, true, grantedAuthorities);

        return new Object[] { userDetails, token };
    }

}
