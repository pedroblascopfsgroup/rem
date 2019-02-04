package es.pfsgroup.plugin.rem.restclient.salesforce.clients;

import javax.net.ssl.*;
import java.lang.instrument.Instrumentation;

public class LenientHostnameVerifierAgent {
    public static void premain(String args, Instrumentation inst) {
        HttpsURLConnection.setDefaultHostnameVerifier(new HostnameVerifier() {
            public boolean verify(String s, SSLSession sslSession) {
                return true;
            }
        });
    }
}
