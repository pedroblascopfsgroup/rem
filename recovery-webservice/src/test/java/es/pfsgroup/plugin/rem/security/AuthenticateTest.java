package es.pfsgroup.plugin.rem.security;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;

import java.io.IOException;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.mockito.internal.configuration.injection.MockInjection;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.security.Authentication;
import org.springframework.security.GrantedAuthority;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;
import org.springframework.security.userdetails.UserDetails;
import org.springframework.security.userdetails.UserDetailsService;
import org.springframework.ui.ModelMap;

import es.capgemini.devon.security.SecurityUser;
import es.capgemini.devon.security.SecurityUserInfo;


@RunWith(MockitoJUnitRunner.class)
public class AuthenticateTest {

//	@InjectMocks RecoveryAgendaMultifuncionAnotacionController recoveryAgendaMultifuncionAnotacionController;
//	
//	@Mock ApiProxyFactory mockProxyFactory;
//	@Mock AsuntoApi mockAsuntoApi;
//	
//	@Test
//	public void testGetAdjuntosEntidad(){
//		ModelMap map =new ModelMap();
//		Long idAsunto = 1L;
//		
//		Asunto asunto=new Asunto();
//		
//		when(mockProxyFactory.proxy(AsuntoApi.class)).thenReturn(mockAsuntoApi);
//		when(mockAsuntoApi.get(idAsunto)).thenReturn(asunto);
//		
//		String resultado=recoveryAgendaMultifuncionAnotacionController.getAdjuntosEntidad(idAsunto, "3", map);
//		
//		assertEquals(RecoveryAgendaMultifuncionAnotacionController.ADJUNTOS_ASUNTO, resultado);
//	}
	
	private static final String AUTH2_SERVER_URL = "haya.auth2.server.url";
	private static final String AUTH2_SERVER_URL_METHOD = "haya.auth2.server.url.method";
	private static final String AUTH2_SERVER_URL_TIMEOUT = "haya.auth2.server.url.timeout";
	private static final String AUTH2_SERVER_URL_CHARSET = "haya.auth2.server.url.charset";
	private static final String AUTH2_SERVER_CLIENT_ID = "haya.auth2.server.param.client_id";
	private static final String AUTH2_SERVER_REDIRECT_URI = "haya.auth2.server.param.redirect_uri";
	private static final String AUTH2_SERVER_RESOURCE = "haya.auth2.server.param.resource";
	private static final String AUTH2_SERVER_GRANT_TYPE = "haya.auth2.server.param.grant_type";
	private static final String AUTH2_SERVER_CLIENT_SECRET = "haya.auth2.server.param.client_secret";
	private static final String AUTH2_SERVER_SCOPE = "haya.auth2.server.param.scope";
	
	@Mock
	private Properties appProperties;
	
	@Mock
	private UserDetailsService userDetailsService;
	
	@Mock
	private UsernamePasswordAuthenticationToken auth;

	@Mock
	private HttpClient httpClient;

	@InjectMocks 
	private HayaAuthenticationProvider authProvider;
	
	@Mock
	private HttpServletRequest httpServletRequest;
	
	@Mock
	private HayaWebAuthenticationDetails hayaWebAuth;
	
	@Mock
	private PostMethod method;
		
	private final String USER_TEST = "pfs.dgutierrez";
	private final String MOCK_RESULT = "mock-test";
	private final String RESPONSE_TEST = "{\"access_token\": \"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IlNBZ2g3elFIQ2JNWVc0dl9ocmJKbHUxeDViQSJ9.eyJhdWQiOiJodHRwczovL2hheWEuZXMvUmVtIiwiaXNzIjoiaHR0cDovL2FkZnMuaGF5YS5lcy9hZGZzL3NlcnZpY2VzL3RydXN0IiwiaWF0IjoxNTE4NDM2ODczLCJleHAiOjE1MTg0NDA0NzMsImFwcHR5cGUiOiJDb25maWRlbnRpYWwiLCJhcHBpZCI6IjcxZjgzOTk4LWY1YzUtNDliNC1hYjczLTE4NzI5ZWI1M2JhZSIsImF1dGhtZXRob2QiOiJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6YWM6Y2xhc3NlczpQYXNzd29yZFByb3RlY3RlZFRyYW5zcG9ydCIsImF1dGhfdGltZSI6IjIwMTgtMDItMTJUMTI6MDE6MTMuNjYwWiIsInZlciI6IjEuMCJ9.jcmTomnP0HacxBDCnTqsFGfIuKkMBBcIHgnLTohYi7PKgzw74xl4DOSWadQfyuiatI1qdzP_E2wn2SrKUikpvKcuMJi1sFuOaHQxfntkrad0R_WTB6tJFiEQ8QtsD9hIJ-VFvfUbeM7f3lFK7jvr-6nV2hDgqLeYlJlL5_30u7l8-7dYnsIMrJHlz4OsHSc_b3bwdHDit6cSFkvae7tZG5fRWzIVGx3XF75y9RqEzDncuZHETD-I0QAqIy7YHMhznnE2rXC4Tgjf2Q_bLIUYyn6x-0mnE-BCJCvXcq7_8QHStf1xWru-ZD3uWSkMy9oywr-ZBkq5t-dCud0Vy0-Hhw\",\"token_type\": \"bearer\",\"expires_in\": 3600,\"resource\": \"https://haya.es/Rem\",\"refresh_token\": \"faQ7M5gilZTiVAnFBEruTyFi0vOo_Ik1a_OMnqrqy7IAAQAAGomVM7aeqAkmFehk4doaTZ1IDDd7Lv_vsFIdTujHBCJSl1lxCx6B-1aVsDWBaTtiwHkVtDAmNV0hLhmjSecs3_TdN8TT8vqN3TL22Sq4EoHGW11bugMVpQpwgbeWk6CkutA7mUvM82SwHNc1oiKOdjvsfmO6E7_eFw_A8vha2KBoR-Pq3ImY04ryMmJlRyBXkk0HbZjlv_DSNjlXImfqwZCCJNev1WT7PW3BSrQ8b0NlMjpDWAW0usU0C6b7NSMGOlI7xiMtEG2LxHyvEH8JGaGteL5pZlUZkwddFtHW9VS9KvLJq1LeSylYrXgC-5xMDDLJNMUJMPrKo2fLTvuE25AFAAD38VbqRFSa5sQRcYbiZJI-lGIaAYe6uXQCYvxSRW4J8Kc4S_txSKhBTfz6Q3Vj7iXrr69kMkSKKx54bSncD0Q4PvKGN1UplmJm1wkz2d0iVHzTguva2IkR8ci-HuoQZqCwIJn7UMWySgQGBG0be3IUvAQX1YdKKPacRzMmqdg-j8xm2Ii6_poerMIERfFsfql1qX7HMpSwkLMSZLOOK0DIIdCHfREjYusZPsW-bOL1u-eCYsPHpZDFfbQMVcOqZc8CpwkYXb2C1IAvFcjMBmyYl_9OaoUXzjfUVtU0886sqKd_DZl6v4-0hk1sDWGMaEu70GERvVhF9rEPDNvOGHtNSS5fI0V5NjvupmtAmy9rNRXKpyOAdFs2BgR-oJzidXGX4QY0Fjv3Xk7zQMnUlflVE9noGqm77nU3dsIf0nyLuBd0NqhhjWjw53ktr0yHfp73wsjt6R6RgFBt4cKjnddm7zYVe5NMOLkFnSYXrHDzft0GbygIxk5h2ryoj8W_v5MMFIKqg9V0Du2KOFmJRN8S9qAOuZLwDWElFIlERpCuotxQtqXTgI0_OoD_w8PsB0xF-AgOQZ5DiZb2adsrXLkWrZPRYvVMkm3e56dOiCijEH88BLQkbSjYxl8NZ73EwkuMlDV5UW8MRNHEU8jYsPYnTcYYaWnN69BYFp_tS4C_BRbBY9aI53U-ZCgWEmh6gDcHTl9_1ise4Qw9rIlkch5_1eAuWog-8px0YEog6GQxjHzGM2zVNUeRe4XKrIRY4diB2MEtK2qkEHVIHlalsY3GWkn6mqFam9bu1U19uB1gTsSTmT1fuGhh52xQdRvnz2xlYWjC2njYhyOkG7JGmB2DCpB5wFlQ3fZtnzAoPw1rc-PMsLa5cpE9Gl7Fx-GKmV6EERshWD5I-LfllmbgZXyMCr3y6G2vdBgyWyK2j9CKyErXDTc2fEvdPzRoUAKHHlvGHzU1_uRF2vhKVSk3qJ8WkiVR1ifY5NflLNNbU3lFeHH1U9mjZDw3Beyq8npgKa2SABFh1e_Mse-BLVzLH46EnS2r46WqI69OWdyxFkbpFyWFDE_nHsdFulTJ0AbUOyO2St8qz7MoTAT8PmZ52De0BMQ7_wAnEH2i3awFnng4pWZHybTmylpyjQkmlAfYAeUiFMRfbmL2nMd2VnRLwq4FlVcGqfMzTEvDUUalXVhqpX4Lqu2yxTInrWlHZzcL3XU3nBiqh9sCEItcgTAXE7T_nAOFJTf3HZh63VCsiQtrorCcPl8GgMKLkB0inuv_zyFlzUjpKcAwN6PrHj7KQAfcOjb34Jk7tHGdJbJIDLZV8PKmnFkQMaSGIBYr5pRWfCQ2nkS1mN0GYfJrKZHINeYUqboA9Dr0gPw0ywqajmZsO0Qhm1bkckK9b3rjpOkWlPu34lfSkXV6tEH1Y_1bhBQUpN-8A5YrGo0laGSfvZY13EyYcdPv-BvZ5Eh5kGV4XRtbwRtOr3e7zS7YOBq8PxA6XJrix0xYTR7GLiWrXARcyXzH4VBklLGUjLFSMaNd1bDDejx_ZA6o6QjfZfL-rljo39uPNdQ_GQqwWGavwrCZ_hCgGyMu3ZxxEW0sVzAU5JuSR-HYq41AcckzFecy-pJGA6yI2WCAg5YH1Y6HO8RBh3i5j-ZTVM9jllLeh2KmqQbhbJPAnI7shq-lFrf79sbpI7hdfUQsasXJJevcWd69mfRiXE-akNFL-XSUHEqS2-rfTM53SFlOeBRduK984mehrEjskvuWGMm3oETOD-yJc9PuL1WRbVuMuSAPhhpHEBWthtQFZmvLFOBbrz4Ee3reOD5jdU5Hb1uRWLokEjNrmQEb2XDicpK_sPoOCIQpt7ygwQ6ojhhv-gXq2SsBn6ThrqNU8QGe_lUw06J9oLPtJA.sWhJXWJnVwwNMwdZ9KIcH4VZBV9BSCQ_aWbEEl4ZE5lZs1abZ6NHLYOgr-Gac2L_FXFb_yx_dtnovmTgvjtKEXgv0q55sfTrDiyuCbUgM-JD-AgnPthvXuwUBqC7CKdEQz-RDEMKK2Nw9WUVT_HfZx7xyib6fwtQfwJcirzNVn1MtrV5p8l9W3dkdP5CCgygfYuMoPpwSP9BTU82m6FA8P18dAMaPh1qkRS5DFux8zvTRrJCixyxNUQZvpGn2sbWd3qsO8vU7nXUPERXDIQSZVFOjWzL3n6GnxDa1-nYxbHwU9LREiOJ-SZ5wf8VGNTZ2g_rj416GKEQyNtFcogjUg\",\"refresh_token_expires_in\": 43199,\"id_token\": \"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IlNBZ2g3elFIQ2JNWVc0dl9ocmJKbHUxeDViQSIsImtpZCI6IlNBZ2g3elFIQ2JNWVc0dl9ocmJKbHUxeDViQSJ9.eyJhdWQiOiI3MWY4Mzk5OC1mNWM1LTQ5YjQtYWI3My0xODcyOWViNTNiYWUiLCJpc3MiOiJodHRwczovL2FkZnMuaGF5YS5lcy9hZGZzIiwiaWF0IjoxNTE4NDM2ODczLCJleHAiOjE1MTg0NDA0NzMsImF1dGhfdGltZSI6MTUxODQzNjg3Mywic3ViIjoidVRpRHRlbWxEdVdjUElmTTZBWTVDaFMxMCtGek1oTHEwdzh2aFhSRFF0dz0iLCJ1cG4iOiJwZnMuZGd1dGllcnJlekBoYXlhLmVzIiwidW5pcXVlX25hbWUiOiJDSVNBLjBcXHBmcy5kZ3V0aWVycmV6IiwicHdkX3VybCI6Imh0dHBzOi8vYWRmcy5oYXlhLmVzL2FkZnMvcG9ydGFsL3VwZGF0ZXBhc3N3b3JkLyIsInB3ZF9leHAiOiI3MTg2ODQzIn0.KM37BrefkihnAspO9F2I6n6xlLx34yu0lFybxCWeghIw-0sKpILLX3g6om7B66-VibhzMPLCCxLU30aZWaX1VYw4qe62nrIYrYyrVO_mZ8qzx_s5eQapCS15i8qqZcwXPQeTKvuUkA2otf9f88iRqHvi2rFZlJAG_kPyxsdBJ8GtcSMinp0g-DHvmXGVMNLASnNW4knwbZgGK9iaVmHuhmuXorrReLBvsqcaH1Zg43Qz85rPyXDkmcZoFRMBWM3HOqUIPR-ETshw6rmmkPRAC6MZIM4Wo6-LtxAdjRvFDKqLC0fEA8VWXv1pSUyd73YF5BaSRMoBUb_6sFVKYo4JzA\"}";

	private void initialize () throws IOException  {

		when(auth.getDetails()).thenReturn(hayaWebAuth);
		when(hayaWebAuth.getCode()).thenReturn(MOCK_RESULT);
		
		when(appProperties.getProperty(AUTH2_SERVER_URL)).thenReturn(MOCK_RESULT);
		when(appProperties.getProperty(AUTH2_SERVER_CLIENT_ID)).thenReturn(MOCK_RESULT);
		when(appProperties.getProperty(AUTH2_SERVER_REDIRECT_URI)).thenReturn(MOCK_RESULT);
		when(appProperties.getProperty(AUTH2_SERVER_RESOURCE)).thenReturn(MOCK_RESULT);
		when(appProperties.getProperty(AUTH2_SERVER_RESOURCE)).thenReturn(MOCK_RESULT);
		when(appProperties.getProperty(AUTH2_SERVER_GRANT_TYPE)).thenReturn(MOCK_RESULT);
		when(appProperties.getProperty(AUTH2_SERVER_CLIENT_SECRET)).thenReturn(MOCK_RESULT);
		when(appProperties.getProperty(AUTH2_SERVER_SCOPE)).thenReturn(MOCK_RESULT);
		when(httpClient.executeMethod((HttpMethod)Mockito.any())).thenReturn(200);

		
		byte[] bytesRespuesta = RESPONSE_TEST.getBytes();
		when(method.getResponseBody()).thenReturn(bytesRespuesta);
		when(method.getParams()).thenReturn(new HttpMethodParams());
	
		GrantedAuthority[] auth = new GrantedAuthority[0];
		UserDetails secInfo = new SecurityUser(1L, USER_TEST, MOCK_RESULT, true, true, true, true, auth);
		when(userDetailsService.loadUserByUsername(USER_TEST)).thenReturn(secInfo);
		authProvider.setUserDetailsService(userDetailsService);

	}

	@Test
	public void testResponseBody() throws IOException {
		
		//initialize();
		//Authentication authResponse = authProvider.authenticate(auth);

		//Mockito.verify(method, Mockito.times(1)).getResponseBody();
		///assertEquals(USER_TEST, authResponse.getName());
		
	}
	
}
